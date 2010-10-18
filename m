Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0JRLfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:35:50 -0400
Received: from canuck.infradead.org ([134.117.69.58]:60278 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0JRLfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:35:45 -0400
Message-Id: <20101018112433.556591568@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 18 Oct 2010 13:24:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 00/20] mm: Preemptibility -v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes part of the mm a lot more preemptible. It converts
i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
preemptible.

The main motivation was making mm_take_all_locks() preemptible, since it
appears people are nesting hundreds of spinlocks there.

The side-effects are that can finally make mmu_gather preemptible,
something which lots of people have wanted to do for a long time.

It also gets us anon_vma refcounting, which seems to result in a nice
cleanup of the anon_vma lifetime rules wrt KSM and compaction.

This patch-set it build and boot-tested on x86_64 (a previous version was
also tested on Dave's Niagra2 machines, and I suppose s390 was too when
Martin provided the conversion patch for his arch).

There are no known architectures left unconverted.

Yanmin ran the -v3 posting through the comprehensive Intel test farm
and didn't find any regressions.

( Not included in this posting are the 4 Sparc64 patches that implement
  gup_fast, those can be applied separately after this series gets
  anywhere. )

The full series (including the Sparc64 gup_fast bits) also available in -git
form from (against Linus' tree as of about an hour ago):

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt

DaveM mentioned some sparc64 trouble with the -v4 posting, this turned out to
be a false positive as unpatched kernels also are having trouble on his
machines.

Linus, Andrew, Stephen, can we add this to -next for .37?


