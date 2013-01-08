Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3AHNER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:04:17 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36696 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3AHNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
References: <20130105152208.GA3386@redhat.com>
	<CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
	<alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
	<CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
	<CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
Date: Tue, 8 Jan 2013 21:04:15 +0800
Message-ID: <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
From: Hillf Danton <dhillf@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 1:34 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 7, 2013 at 4:24 AM, Hillf Danton <dhillf@gmail.com> wrote:
>>
>> I take another try with waiting added, take a look please.
>
> Hmm. Is there some reason we never need to worry about it for the
> "pmd_numa()" case just above?
>
> A comment about this all might be a really good idea.
>
Yes Sir, added.
---
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: restore huge pmd splitting check

Hugh said, it's clear that 3.7 had an important pmd_trans_splitting(orig_pmd)
check there, which went AWOL in
d10e63f29488 "mm: numa: Create basic numa page hinting infrastructure".

It is restored for handling stable page fault, with wait_split_huge_page()
added, as suggested also by Hugh, to avoid reapted faults until the split
has completed.

This work is inspired by the oops reported by Dave Jones at
https://lkml.org/lkml/2013/1/5/115

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/memory.c	Sun Jan  6 19:49:50 2013
+++ b/mm/memory.c	Tue Jan  8 20:28:04 2013
@@ -3710,6 +3710,14 @@ retry:
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);

+			/*
+			 * Check if pmd is stable
+			 * (numa pmd is stable, see change_huge_pmd())
+			 */
+			if (pmd_trans_splitting(orig_pmd)) {
+				wait_split_huge_page(vma->anon_vma, pmd);
+				goto retry;
+			}
 			if (dirty && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
--
