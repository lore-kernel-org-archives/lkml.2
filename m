Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3AGMYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:24:14 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37543 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3AGMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:24:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
References: <20130105152208.GA3386@redhat.com>
	<CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
	<alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
Date: Mon, 7 Jan 2013 20:24:12 +0800
Message-ID: <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hugh

On Mon, Jan 7, 2013 at 3:06 AM, Hugh Dickins <hughd@google.com> wrote:
> I don't entirely like your patch (or the original code): shouldn't
> there be a wait_split_huge_page(), rather than hammering back with
> repeated faults until the split has completed?
>
I take another try with waiting added, take a look please.

Hillf
---
--- a/mm/memory.c	Sun Jan  6 19:49:50 2013
+++ b/mm/memory.c	Mon Jan  7 20:16:14 2013
@@ -3710,6 +3710,11 @@ retry:
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);

+			/* Check if pmd is stable */
+			if (pmd_trans_splitting(orig_pmd)) {
+				wait_split_huge_page(vma->anon_vma, pmd);
+				goto retry;
+			}
 			if (dirty && !pmd_write(orig_pmd)) {
 				ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
 							  orig_pmd);
--
