Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1F0Og3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:36:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34751 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1F0OgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m77d10vTW5Wl+24uq1ZZLhAgbS8qHf6uRge2AHYUfiirJTHBkZp0KK1LIvqsxk8828
         Tn63QaHMEfhttll2SigtxicKR/+jOPspfa74RzP3HmnGAkN89mkkL7+7rmb1hWFTs5Lx
         tz1IT+F1ST+JqC0NW5KQD7n5gWPgIE1eHrfgE=
Date: Mon, 27 Jun 2011 16:36:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110627143617.GC30101@htj.dyndns.org>
References: <20110622210834.GC20549@redhat.com>
 <20110623122253.GM30101@htj.dyndns.org>
 <20110623132126.GA10410@redhat.com>
 <20110623132754.GO30101@htj.dyndns.org>
 <20110623132831.GA11453@redhat.com>
 <20110623170650.GA14601@redhat.com>
 <20110625141553.GX30101@htj.dyndns.org>
 <20110626205157.GB16293@redhat.com>
 <20110627082443.GA30101@htj.dyndns.org>
 <20110627142136.GA5812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627142136.GA5812@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 27, 2011 at 04:21:36PM +0200, Oleg Nesterov wrote:
> Yes, but at the same time even __fatal_signal_pending() is too strong!
> What if the tracee exits on its own, and its sys_exit() races with
> exit_group() from another thread? In this case I think it should stop,
> but __fatal_signal_pending() is true.
>
> And worse. What if the tracee stops in PTRACE_EVENT_EXIT, and _then_
> another thread does sys_exit_group()? The tracee will be "killed".
> I do not think this is right. I think the "implicit" SIGKILL in this
> case should _not_ wake up the tracee. Only the real SIGKILL (or any
> fatal signal which mutates to SIGKILL). Otherwise we simply can't
> guarantee PTRACE_EVENT_EXIT works "reliably" in this case.

Indeed, for PTRACE_EVENT_EXIT to work properly, we would need to
discern between actual KILLs and the implicit ones.

> We have signal_group_exit()/SIGNAL_GROUP_EXIT. I think we also need
> SIGNAL_THE_REAL_SIGKILL_WAS_SENT flag. Note also we have the similar
> problems with the coredump. SIGKILL should abort it. Also, we should
> define what TIF_SIGPENDIND and interruptible wait mean after exit_signals()
> and/or exit_notify(). Some drivers (tty? I do not remember) expect that
> the exiting task can do wait_event_interruptible() and react to ^C.

Eh... that sounds very shady.  Maybe we should try to remove that
weird requirement instead?

> > I don't have
> > any major problem with the original.  Please go ahead.
> 
> Thanks. Can I add your reviewed-by/acked-by ?

Sure, please feel free to add reviewed-by.  Thanks.

-- 
tejun
