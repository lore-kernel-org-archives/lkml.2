Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0DAQhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334Ab0DAQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:37:47 -0400
Date: Thu, 1 Apr 2010 17:42:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401154249.GQ5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270122194.1653.223.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:43:14PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-01 at 13:27 +0200, Peter Zijlstra wrote:
> > 
> > I've almost got a patch done that converts those two, still need to look
> > where that tasklist_lock muck happens.
> 
> OK, so the below builds and boots, only need to track down that
> tasklist_lock nesting, but I got to run an errand first.

You should have a look at my old patchset where Christoph already
implemented this (and not for decreasing latency but to allow
scheduling in mmu notifier handlers, only needed by XPMEM):

http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/

The ugliest part of it (that I think you missed below) is the breakage
of the RCU locking in the anon-vma which requires adding refcounting
to it. That was the worst part of the conversion as far as I can tell.

http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/anon-vma

I personally prefer read-write locks that Christoph used for both of
them, but I'm not against mutex either. Still the refcounting problem
should be the same as it's introduced by allowing the critical
sections under anon_vma->lock to schedule (no matter if it's mutex or
read-write sem).
