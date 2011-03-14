Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1CNT65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab1CNT64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:58:56 -0400
Date: Mon, 14 Mar 2011 20:58:23 +0100
From: Johannes Weiner <jweiner@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] thp+memcg-numa: fix BUG at include/linux/mm.h:370!
Message-ID: <20110314195823.GC2140@redhat.com>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
 <20110314155232.GB10696@random.random>
 <alpine.LSU.2.00.1103140910570.2601@sister.anvils>
 <AANLkTikvt+o+UaksmvM5C7FWt7hTMJyaPiUGhQ+6OKBg@mail.gmail.com>
 <20110314171730.GF10696@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314171730.GF10696@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 06:17:31PM +0100, Andrea Arcangeli wrote:
> On Mon, Mar 14, 2011 at 09:56:10AM -0700, Linus Torvalds wrote:
> > Does mem_cgroup_newpage_charge() even _need_ the mmap_sem at all? And
> > if not, why not release the read-lock early? And even if it _does_
> > need it, why not do

[...]

> About mem_cgroup_newpage_charge I think you're right it won't need the
> mmap_sem. Running it under it is sure safe. But if it's not needed we
> can move the up_read before the mem_cgroup_newpage_charge like you
> suggested. Johannes/Minchan could you confirm the mmap_sem isn't
> needed around mem_cgroup_newpage_charge? The mm and new_page are
> stable without the mmap_sem, only the vma goes away but the memcg
> shouldn't care.

We don't care about the vma.  It's all about assigning the physical
page to the memcg that mm->owner belongs to.

It would be the first callsite not holding the mmap_sem, but that is
only because all existing sites are fault handlers that don't drop the
lock for other reasons.

I am not aware of anything that would rely on the lock in there, or
would not deserve to break if it did.
