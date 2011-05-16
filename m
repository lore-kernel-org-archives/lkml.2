Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1EPJNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:13:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1EPJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MT7dV8IKduNPjLECOZOVgOKpAYfZSX4uUjg9T4Bdgn6jIp/2dIiOEvWQIWFcU+tCGV
         yQTpWWsm3UCA6y6PAsP1xyGchYniBUY1i4rDx+23kQqgXQ+jmoVOSrqVS+bk83W7GNA4
         mBCKP9aIP3lz6SO4A15OrBWOXdCif0Ftz57oU=
Date: Mon, 16 May 2011 11:13:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110516091318.GQ23665@htj.dyndns.org>
References: <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
 <20110515174722.GA26361@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515174722.GA26361@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Sun, May 15, 2011 at 07:47:22PM +0200, Jan Kratochvil wrote:
> > But, the current WNOHANG wait is racy.  It's unlikely but definitely
> > possible for WNOHANG to fail when it's expected to succeed (not the
> > above case but more convoluted ones).
> 
> OK, so FYI it breaks current GDB.

That might be true but the race cases are very obscure.  Not sure
whether the race conditions could actually affect ptracer.  With
SEIZE, it won't, I think.

> > But, just out of curiosity, is there any reason the ptracer itself
> > should be doing something other than waitpid() while tracee is
> > running?  It's not like ptrace requests can be issued during that time
> > and sleeping waitpid() is way saner mechanism to wait for tracee
> > events than signal.
> 
> If the debugger wants to be single-threaded ("poll() model", not "threads
> model") and it wants to communicate with user and examine debuggee symbols and
> memory data it cannot use sleeping wait.  GDB is single-threaded and it
> supports `set target-async 1': info '(gdb)Background Execution'

I don't think target-async is necessarily related.  It doesn't really
matter whether the execution per-se is async or not.  The ptracer can
be a separate thread regardless and the interlocking can be added on
top (or not).

Anyways, I would recommend using sleeping wait(2)'s for ptrace event
tracking.  Well, signal notification would work but I think that would
be much more error-prone and has much higher chance of being fragile.

Thanks.

-- 
tejun
