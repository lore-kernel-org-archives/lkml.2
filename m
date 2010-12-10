Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0LJLNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:13:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59247 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0LJLNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:13:15 -0500
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikXx4MgdPYWYNVj8cMOSHTHJEUHqKZ_q-P4jFYp@mail.gmail.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	 <1291335412-16231-2-git-send-email-walken@google.com>
	 <20101208152740.ac449c3d.akpm@linux-foundation.org>
	 <AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
	 <AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
	 <AANLkTikXx4MgdPYWYNVj8cMOSHTHJEUHqKZ_q-P4jFYp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 12:12:49 +0100
Message-ID: <1291979569.6803.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 22:39 -0800, Michel Lespinasse wrote:
> I think rwsem_is_contended() actually sounds better than fiddling with
> constants, but OTOH maybe the mlock use case is not significant enough
> to justify introducing that new API. 

Right, so I don't see the problem with _is_contended() either. In fact,
I introduce mutex_is_contended() in the mmu_preempt series to convert
existing (spin) lock break tests.

If you want to do lock-breaks like cond_resched_lock() all you really
have is *_is_contended(), sleeping locks will schedule unconditional.

int cond_break_mutex(struct mutex *mutex)
{
	int ret = 0;
	if (mutex_is_contended(mutex)) {
		mutex_unlock(mutex);
		ret = 1;
		mutex_lock(mutex);
	}
	return 1;
}

Or more exotic lock breaks, like the mmu-gather stuff, which falls out
of its nested page-table loops and restarts the whole affair.
