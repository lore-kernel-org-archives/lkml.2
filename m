Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2EKSLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKSLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:11:34 -0400
Date: Fri, 11 May 2012 18:28:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/7] x86/tlb: fall back to flush all when meet a THP
 large page
Message-ID: <20120511162855.GB19697@redhat.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-5-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336626013-28413-5-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 10, 2012 at 01:00:10PM +0800, Alex Shi wrote:
> +	for (addr = start; addr <= end; addr += HPAGE_SIZE) {
> +		pgd = pgd_offset(mm, addr);
> +		if (likely(!pgd_none(*pgd))) {
> +			pud = pud_offset(pgd, addr);
> +			if (likely(!pud_none(*pud))) {
> +				pmd = pmd_offset(pud, addr);
> +				if (likely(!pmd_none(*pmd)))
> +					if (pmd_large(*pmd))
> +						return 1;

Note with THP we've to set the pmd temporarily not present during
split_huge_page just before it returns a regular pmd (to avoid erratas
and mixing 4k and 2m tlb on the same physical page). So pmd_large
would fail in that small time window and we would do the invlpg loop
(which should still work safe so no big deal). But I believe you could
use pmd_trans_huge above, maybe gcc can drop the whole block with
CONFIG_TRANSPARENT_HUGEPAGE=n.
