Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab1C1PWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:22:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1C1PWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qXRNPx2zRA9NrloBct1C/qws34iHDQhYJh3NQn8UeBKkDnjv6mD7oTRM87htSzPzbN
         QPt/g5mvRfOQrCUTJnk/ifc42SfAcFOpt+UdGq94PVy4ded9CE19a/L4AgeUk7NP26pC
         AKQbHkMWcXJrGaAoYSdpVq5xXRrqrORRw1lDg=
Date: Mon, 28 Mar 2011 17:21:58 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
 interaction
Message-ID: <20110328152158.GA6736@htj.dyndns.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
 <20110323183837.GA27680@redhat.com>
 <20110325142630.GD1409@htj.dyndns.org>
 <20110326182554.GA24315@redhat.com>
 <20110328085824.GE16530@htj.dyndns.org>
 <20110328121401.GA4099@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328121401.GA4099@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 28, 2011 at 02:14:01PM +0200, Oleg Nesterov wrote:
> > Hmmm... setting TIF_SIGPENDING and kicking the task to enter signal
> > delivery path doesn't have any side effect when it's running in
> > userland,
> 
> Yes. We should avoid the spurious TIF_SIGPENDING, if possible. But in
> this case we don't care.
> 
> But, unless the thread is ptraced, it can't be running in userland,
> why should we set TIF_SIGPENDING?

It goes both ways.  If we need it for ptrace path, the overhead for
!ptrace case is negligible && it makes the code less finicky, why not?

It's much cleaner to say "it sets notification condition and
guarantees that tasks travel signal delivery path" than "if !ptraced,
at least one task should already be in signal delivery path for such
and such reasons; however, while ptraced, because of the interaction
with PTRACE_CONT, there's a case we need to call in the task
explicitly."  The code becomes less prone to subtle bugs when the
surrounding code changes too.

> > We set SIGNAL_CLD_STOPPED if group_stop_count wasn't zero, ie. if
> > group stop has initiated, which will be delivered as soon as any task
> > enters signal delivery path.
> 
> Yes. And that task T has already called do_signal_stop() and it is
> TASK_STOPPED.

Ah, right, this is where I got confused.  signal_stop_count wouldn't
be set unless at least one task is already in signal delivery path.

> No?

You're right.  I was confused.  But if we're gonna call in a task,
let's do it regardless of ptrace.  It's not like splitting that
condition will buy us anything.

Thanks.

-- 
tejun
