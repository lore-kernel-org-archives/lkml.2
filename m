Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2EJXoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:44:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:64874 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876Ab2EJXo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141644660"
Subject: Re: [PATCH 1/3] coredump: flush the fpu exit state for proper
 multi-threaded core dump
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        chris@zankel.net
Date: Thu, 10 May 2012 16:48:04 -0700
In-Reply-To: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
	 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120509210551.GB334@redhat.com>
	 <1336599123.4634.42.camel@sbsiddha-desk.sc.intel.com>
	 <20120510165538.GA20931@redhat.com>
	 <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336693684.1153.30.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 10:04 -0700, Linus Torvalds wrote:
> On Thu, May 10, 2012 at 9:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > My point was, there is no any guarantee prepare_to_copy() does the flush.
> > An architecture can do this in copy_thread() or arch_dup_task_struct(),
> > for example. In fact I do not understand why x86 doesn't do this.
> 
> I agree that it would actually make more sense to do in
> arch_dup_task_struct(). I had trouble finding where the heck the
> fork() code did the FPU fixes back when I was fighting the FPU
> corruption thing.
> 
> The prepare_to_copy() thing is, I think, purely historical, and I
> think we should in fact get rid of it. Everybody else makes it a
> no-op, I think, with a *few* exceptions that seem to have copied the
> x86 model of flushing the FPU there.
> 
> So if somebody sends me a patch to remove that thing, and move the few
> existing users to arch_dup_task_struct(), I'd take it.

ok. Just sent the v2 version of the patchset which includes this. I
didn't compile, test all the architectures. I copied the relevant arch
maintainers who were using prepare_to_copy(). I will be glad if they can
review/test that patch and Ack.

> I think it would be a mistake to use it in the exit path. Make an
> explicit "drop_thread_state()" or similar macro, which can undo FPU
> state and possibly other architecture state.

In my previous/current patchset, I am using arch specific exit_thread()
to call drop_fpu() (changed the name to drop_fpu() from flush_fpu() in
the v2 patchset) during normal exit.

But in the case of coredump, all the other threads are waiting in
exit_mm() as part of the coredump_wait() and this is where we hit the
bug_on, when the main thread finds the other thread is still active on
the runqueue. So based on the discussion with Oleg, I added
wait_task_inactive() check in coredump_wait() to ensure all the other
threads are really off the rq, so that their most recent fpu state is
copied to the memory, which will be copied to the core file by the
dumping thread. Hope this is ok.

thanks,
suresh

