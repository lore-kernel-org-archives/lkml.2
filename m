Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1KRPXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:23:14 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63855 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1KRPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:23:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111118150742.GA23223@tiehlicka.suse.cz>
References: <CAJd=RBC+p8033bHNfP=WQ2SU1Y1zRpj+FEi9FdjuFKkjF_=_iA@mail.gmail.com>
	<20111118150742.GA23223@tiehlicka.suse.cz>
Date: Fri, 18 Nov 2011 23:23:12 +0800
Message-ID: <CAJd=RBCOK9tis-bF87Csn70miRDqLtCUiZmDH2hnc8i_9+KtNw@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: detect race if fail to COW
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:07 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 18-11-11 22:04:37, Hillf Danton wrote:
>> In the error path that we fail to allocate new huge page, before try again, we
>> have to check race since page_table_lock is re-acquired.
>
> I do not think we can race here because we are serialized by
> hugetlb_instantiation_mutex AFAIU. Without this lock, however, we could
> fall into avoidcopy and shortcut despite the fact that other thread has
> already did the job.
>
> The mutex usage is not obvious in hugetlb_cow so maybe we want to be
> explicit about it (either a comment or do the recheck).
>

Then the following check is unnecessary, no?

Thanks,
Hillf

	/*
	 * Retake the page_table_lock to check for racing updates
	 * before the page tables are altered
	 */
	spin_lock(&mm->page_table_lock);
	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
		/* Break COW */
