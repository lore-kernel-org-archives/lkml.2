Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0DAQUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab0DAQT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:19:58 -0400
Date: Thu, 1 Apr 2010 18:18:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401161840.GX5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <1270138354.1598.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270138354.1598.99.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 06:12:34PM +0200, Peter Zijlstra wrote:
> One thing we can do there is to mutex_trylock() if we get the lock, see
> if we've got the right object, if the trylock fails we can do the
> refcount thing and sleep. That would allow the fast-path to remain a
> single atomic.

But then how do you know which anon_vma_unlink has to decrease the
refcount and which not? That info should need to be stored in the
kernel stack, can't be stored in the vma. I guess it's feasible but
passing that info around sounds more tricky than the trylock itself
(adding params to those functions with int &refcount).

> The only thing is growing that anon_vma struct, but KSM seems to already
> do that for the most common .configs.

Ok, from my initial review of memory compaction I see that it already
adds its own recount and unifies it too with the ksm_refcount. So it's
worth stop calling it ksm_refcount and to remove the #ifdef (which
memory compaction didn't remove but added an defined(CONFIG_KSM) ||
defined(CONFIG_MIGRATION)).

If you do this change we can have your change applied first, and then
Mel can adapt memory compaction to it sharing the same unconditional
compiled-in refcount.
