Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2EHXPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:15:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:47432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2EHXO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138405367"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        oleg@redhat.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        suresh@aristanetworks.com
Subject: Re: [PATCH 1/2] coredump: flush the fpu exit state for proper multi-threaded core dump
Date: Tue,  8 May 2012 16:18:02 -0700
Message-Id: <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 13:09 -0700, Suresh Siddha wrote:
On Mon, 2012-05-07 at 12:15 -0700, Linus Torvalds wrote:
> > Ugh, I hate this one.
> > 
> > We're making the exit path more expensive for almost no gain. The FPU
> > state is dead in 99.9% of all cases.
> > 
> > Why isn't this a core-dump-only case?
> > 
> 
> Today we do this unlazy_fpu() (which is what prepare_to_copy does)
> already as part of the first schedule() in the exit path. I am just
> making it explicit by calling prepare_to_copy() before exit_mm() which
> synchronizes all the threads before the first thread goes with the core
> dump.
> 
> I don't think I am adding any more cost to the existing path, unless I
> am missing something.

My quick test confirmed my understanding. For example, mainline is 
doing fpu_save_init() some 1770 times when a tsk is in the TASK_DEAD state,
during boot of a two socket system.

So based on your suggestion, made the first patch as core-dump only case and
added the third patch which clears the fpu state during exit.

thanks.

Suresh Siddha (3):
  coredump: flush the fpu exit state for proper multi-threaded core
    dump
  x86, xsave: remove thread_has_fpu() bug check in
    __sanitize_i387_state()
  x86, fpu: clear the fpu state during thread exit

 arch/x86/kernel/process.c |   19 +++++++++++++------
 arch/x86/kernel/xsave.c   |    2 --
 kernel/exit.c             |    5 +++++
 3 files changed, 18 insertions(+), 8 deletions(-)

-- 
1.7.6.5

