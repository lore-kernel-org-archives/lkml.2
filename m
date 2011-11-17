Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1KQCSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:18:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37218 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1KQCSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:18:50 -0500
Date: Wed, 16 Nov 2011 18:18:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "Adam M. Costello" <linux-kernel.amc+0+@nicemice.net>
cc: Ken Chen <kenchen@google.com>, David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org
Subject: Re: Could MADV_REMOVE work with hugetlbfs?
In-Reply-To: <20111109212737.35z~@nicemice.net>
Message-ID: <alpine.LSU.2.00.1111161757510.2092@sister.anvils>
References: <20111109212737.35z~@nicemice.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, Adam M. Costello wrote:

> madvise(MADV_REMOVE) punches a hole in a file (via truncate_range()).
> It's the only way (as far as I know) to return an arbitrary page of
> shared memory to the system.  It's supported by tmpfs, but not by
> hugetlbfs.
> 
> So a regular page of shared memory (from shmget() or from mmap() on
> a tmpfs file) can be returned, but huge page of shared memory (from
> shmget(SHM_HUGETLB) or from mmap() on a hugetlbfs file) cannot be
> returned.
> 
> Has anyone thought about adding support for truncate_range and
> MADV_REMOVE to hugetlbfs?  How hard would that be?

My guess it that it would be awkward.  It should be straightforward
if hugetlbfs were like other filesystems, but it involves peculiar
hugepage reservation code (needed for reliable operation, since the
units it deals in are huge and few), which might well defeat your
purpose completely - even if you free the punched pages, it may still
need to reserve them for your future use, and hence no advantage;
or else make it difficult to implement in a consistent unbuggy way.

(And regarding truncate_range: now that xfs and ext4 and others are
punching holes with fallocate(FALLOC_FL_PUNCH_HOLE), I do intend to
remove the truncate_range method in due course, wiring up
madvise(MADV_REMOVE) and tmpfs to use FALLOC_FL_PUNCH_HOLE instead.
The same functionality, but extended to other filesystems - so long
as it's simply done, not to complicate everybody's test matrix.)

Hugh
