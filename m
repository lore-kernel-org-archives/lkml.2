Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1EPP7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:59:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab1EPP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DacUoBtiKl1vOw0yYKgGUdGsyDRjGzBBiEi/fd8192VDa7p4CPGQYWMTYn4WXnlL5z
         VioE7kwiv3pBrW+MXIx+Nl4VVuhkJFyfYHDJv5XhfhwF1utyr0BriPzfDFt9UrOqSHhU
         PuVxizksyvuAKcrLztaYSWkixvmambLAqj5tY=
Date: Mon, 16 May 2011 17:59:35 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 4/9] ptrace: relocate set_current_state(TASK_TRACED) in
 ptrace_stop()
Message-ID: <20110516155935.GB20624@htj.dyndns.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
 <1305301580-9924-5-git-send-email-tj@kernel.org>
 <20110516115711.GB4898@redhat.com>
 <20110516131608.GX23665@htj.dyndns.org>
 <20110516155158.GA15918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516155158.GA15918@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 05:51:58PM +0200, Oleg Nesterov wrote:
> > The racy part was task_is_stopped_or_traced() in task_stopped_code()
> > and the value of exit_code doesn't matter at that point.
> 
> Why exit_code doesn't matter? task_stopped_code() needs
> task_is_stopped_or_traced() && exit_code != 0. Both changes should be
> visible.

Because the actual exit_code is checked only after grabbing siglock.
As long as task_is_stopped_or_traced() is true, ptracer will grab
siglock and then check exit_code, so TASK_* is the only thing which
matters.  Fragile, if you ask me - we don't have proper mechanism
around lockless do_wait() checks and synchronizations are just
scattered around the code.

> > All we need to update on the tracee is tracee->state and
> > ~JOBCTL_TRAPPING and __wake_up_sync_key() can be considered single
> > operation.
> 
> Yes! IOW, it safe to reorder the memory operations which change ->state,
> ->exit_code, and ->jobctl. This only important thing is that we should not
> wake up the tracer before we change them.
> 
> And if I remember correctly this was the problem, the early patches did
> something like
> 
> 	task_clear_jobctl_trapping();
> 	set_current_state(TASK_TRACED);

Right, try_to_wake_up() already contains smp_wmb().  We'll be fine
with __set_current_state().  Can we do it in a later patch?

Thanks.

-- 
tejun
