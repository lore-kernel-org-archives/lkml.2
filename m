Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1F0IZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:25:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46741 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1F0IYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uHp74mXccNjzO7+w61FagK2mQU9JB6OuGQV+I5WSSsdOGjSUSI+DVprUv/3GrF0CzB
         akHXm3HAc54wH+oDL3hzTJWYIfTcSwbLkPNiyvX63vwo8OofU2fxqgxYRqmWOoOc2/ix
         3xtYydXJrTyQS2blV3apTxSzUnhxc7aIUIViE=
Date: Mon, 27 Jun 2011 10:24:43 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110627082443.GA30101@htj.dyndns.org>
References: <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210834.GC20549@redhat.com>
 <20110623122253.GM30101@htj.dyndns.org>
 <20110623132126.GA10410@redhat.com>
 <20110623132754.GO30101@htj.dyndns.org>
 <20110623132831.GA11453@redhat.com>
 <20110623170650.GA14601@redhat.com>
 <20110625141553.GX30101@htj.dyndns.org>
 <20110626205157.GB16293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626205157.GB16293@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sun, Jun 26, 2011 at 10:51:57PM +0200, Oleg Nesterov wrote:
> > Yeap, we've discussed this before and this indeed is odd.  However, is
> > there something ptracer can't do with PTRACE_EVENT_EXIT instead?
> 
> Firstly, I think PTRACE_EVENT_EXIT should not stop the tracee if it
> was SIGKILL'ed. Even if the tracee stops, it can be killed later.
> The tracer can't detach after that, it can't even wait() to detecte
> a zombie leader.

For SIGKILL, yes, it is different, but if PTRACE_EVENT_EXIT is enough
for all other cases, I think we're mostly set.  BTW, it seems like we
would actually stop at PTRACE_EVENT_EXIT even after SIGKILL.  This is
wrong & racy.  may_ptrace_stop() should be checking for
sigkill_pending(), right?

> > Heh, I think this needs to be prettier even at the cost of an inline
> > function.
> 
> May be, but the code is sooooo simple. In fact I thought about the helper,
> but can't find a good name.
> 
> Anyway, this is so minor, unless you strongly object I am going to push
> this patch as is. We can add a helper later although I don't think it is
> needed.
> 
> The same logic could be written as
> 
> 	if (thread_group_empty(tsk)) {
> 		int sig = ptrace_reparented(tsk) ?
> 			SIGCHLD : tsk->exit_signal;
> 		autoreap = do_notify_parent(tsk, sig);
> 	} else if (task->ptrace) {
> 		autoreap = do_notify_parent(tsk, SIGCHLD);
> 	} else {
> 		autoreap = !thread_group_leader();
> 	}
> 
> note that it certainly looks "prettier". However, personaly I strongly
> prefer the non-pretty code above, imho it is more straighforward and
> understandable. It is hardly possible to misread/misunderstand it.

Well, it's cosmetic after all and you're the maintainer.  I don't have
any major problem with the original.  Please go ahead.

Thanks.

-- 
tejun
