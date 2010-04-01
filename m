Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0DAQMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:12:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0DAQMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:12:38 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100401154249.GQ5825@random.random>
References: <1270117906.1653.139.camel@laptop>
	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
	 <4BB47FC3.1020606@redhat.com> <4BB480CC.2060503@redhat.com>
	 <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop>
	 <20100401154249.GQ5825@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 18:12:34 +0200
Message-ID: <1270138354.1598.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 17:42 +0200, Andrea Arcangeli wrote:
> The ugliest part of it (that I think you missed below) is the breakage
> of the RCU locking in the anon-vma which requires adding refcounting
> to it. That was the worst part of the conversion as far as I can tell.
> 
One thing we can do there is to mutex_trylock() if we get the lock, see
if we've got the right object, if the trylock fails we can do the
refcount thing and sleep. That would allow the fast-path to remain a
single atomic.

The only thing is growing that anon_vma struct, but KSM seems to already
do that for the most common .configs.



