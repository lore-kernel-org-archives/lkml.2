Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1EPMnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:43:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1EPMnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q9RNMpScWBnd95w6mdGdiidaVPbRn5LdG60nIi0KyLmRhFwO1PmutygbN3q4VhOq7s
         KiZvuoRnoGlgIWA4WsaWJ4Tn8P8wspTTwd1rKQ+zDSOlOBWcUTzxyhJ89Ajw8Tq7c/1a
         DYPg9pi0V6zhbu1Jq5aYe490sclZJrcnSdrxU=
Date: Mon, 16 May 2011 14:42:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516124259.GU23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516122642.GD10469@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516122642.GD10469@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 02:26:42PM +0200, Jan Kratochvil wrote:
> > I can't understand the above sentence.  A thread can't deliver signal
> > without going through tracer while ptraced.  Can you elaborate a bit
> > more?
> 
> I tried to explain why GDB will see SIGUSR1 twice.  Despite it is not
> a realtime signal and therefore the signal is "flag", it does not queue/count.
> You know better than me why GDB sees SIGUSR1 twice.

Ah, okay.  Well, there are five threads sending USR1 and five USR2,
right?  The main thread would enter signal delivery path when the
first signal (be it USR1 or USR2) wakes it up and on dequeueing the
first signal (USR1 here), it would trap for signal delivery.
Depending on timing, this may happen after all signals are generated
but more likely to happen before some of them haven't finished sending
yet.

So, while the first USR1 is being delivered through ptrace and
whatnot, the remaining signals are sent, some of them are USR1, thus
making USR1 pending again.

Once you finish delivering USR1, signal delivery path is restarted and
the new pending USR1 is delivered and then USR2.

> > There's no distinction between main or sub threads in terms of signal
> > delivery unless signal itself is specifically directed to a thread.
> 
> This sample code uses only tkill to avoid any mess with which TID will get
> which signal.

Yeap.  Missed that.

> > Isn't that the signal pending mask?
> 
> Yes but how do you query siginfo_t (GDB $_siginfo) of a pending signal to make
> it accessible to the user?

You can't, at least not yet, but wouldn't presenting list of pending
signals be helpful enough?

> You also need to mask out blocked signals

I thought we export this through /proc.  Maybe not.  I'll check.

> and properly order them like kernel does - which is not guaranteed
> by POSIX.  You need to reimplement part of the kernel functionality
> and if you implement it a bit differently it will break transparency
> of the debugging.

I don't get why the delivery ordering matters.

> > * If there are signals to deliver,
> 
> This is the question if the debugger can reliably detect.  Maybe it can.

This shouldn't be too hard.  You just need to know all the masks.

> >   CONT it and it will take the signal
> >   trap (eventually).  During signal trap, do PTRACE_INTERRUPT and then
> >   let the tracee deliver the signal.  Tracee will deliver the signal
> >   and take STOP trap.
> > 
> > Is the above enough for your use case?
> 
> If there is enough documentation - or one reads the soures - one can
> reimplement the signal delivery login in userland to expect what will kernel
> do.  TBH I do not think it is the right API but you are right it is
> workaroundable in userland.

Oh, I would strongly recomment something like that.  Don't depend on
implementation details.  I still don't understand why you need to know
the order beforehand.  Wouldn't pending list be enough?  What are you
trying to achieve?

Thanks.

-- 
tejun
