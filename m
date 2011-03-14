Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1CNXt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:49:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40709 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1CNXt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:49:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Mar 2011 08:42:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] thp+memcg-numa: fix BUG at include/linux/mm.h:370!
Message-Id: <20110315084257.f6116c70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110314195823.GC2140@redhat.com>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
	<20110314155232.GB10696@random.random>
	<alpine.LSU.2.00.1103140910570.2601@sister.anvils>
	<AANLkTikvt+o+UaksmvM5C7FWt7hTMJyaPiUGhQ+6OKBg@mail.gmail.com>
	<20110314171730.GF10696@random.random>
	<20110314195823.GC2140@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 20:58:23 +0100
Johannes Weiner <jweiner@redhat.com> wrote:

> On Mon, Mar 14, 2011 at 06:17:31PM +0100, Andrea Arcangeli wrote:
> > On Mon, Mar 14, 2011 at 09:56:10AM -0700, Linus Torvalds wrote:
> > > Does mem_cgroup_newpage_charge() even _need_ the mmap_sem at all? And
> > > if not, why not release the read-lock early? And even if it _does_
> > > need it, why not do
> 
> [...]
> 
> > About mem_cgroup_newpage_charge I think you're right it won't need the
> > mmap_sem. Running it under it is sure safe. But if it's not needed we
> > can move the up_read before the mem_cgroup_newpage_charge like you
> > suggested. Johannes/Minchan could you confirm the mmap_sem isn't
> > needed around mem_cgroup_newpage_charge? The mm and new_page are
> > stable without the mmap_sem, only the vma goes away but the memcg
> > shouldn't care.
> 
> We don't care about the vma.  It's all about assigning the physical
> page to the memcg that mm->owner belongs to.
> 
> It would be the first callsite not holding the mmap_sem, but that is
> only because all existing sites are fault handlers that don't drop the
> lock for other reasons.
> 
> I am not aware of anything that would rely on the lock in there, or
> would not deserve to break if it did.
> 

mmap_sem is not required to held if uncharge() operation is done
if vma turns out to be a stale pointer.

Thanks,
-Kame

