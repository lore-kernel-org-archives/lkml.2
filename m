Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2ELH6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 03:58:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:39991 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2ELH6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 03:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142173153"
Message-ID: <4FAE1808.1080504@intel.com>
Date: Sat, 12 May 2012 15:58:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
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
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-5-git-send-email-alex.shi@intel.com> <20120511162855.GB19697@redhat.com>
In-Reply-To: <20120511162855.GB19697@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 12:28 AM, Andrea Arcangeli wrote:

> Hi,
> 
> On Thu, May 10, 2012 at 01:00:10PM +0800, Alex Shi wrote:
>> +	for (addr = start; addr <= end; addr += HPAGE_SIZE) {
>> +		pgd = pgd_offset(mm, addr);
>> +		if (likely(!pgd_none(*pgd))) {
>> +			pud = pud_offset(pgd, addr);
>> +			if (likely(!pud_none(*pud))) {
>> +				pmd = pmd_offset(pud, addr);
>> +				if (likely(!pmd_none(*pmd)))
>> +					if (pmd_large(*pmd))
>> +						return 1;
> 
> Note with THP we've to set the pmd temporarily not present during
> split_huge_page just before it returns a regular pmd (to avoid erratas
> and mixing 4k and 2m tlb on the same physical page). So pmd_large
> would fail in that small time window and we would do the invlpg loop
> (which should still work safe so no big deal). But I believe you could
> use pmd_trans_huge above, maybe gcc can drop the whole block with
> CONFIG_TRANSPARENT_HUGEPAGE=n.


Thanks the explanation.
Sure, if THP was not enabled, we can return 0 directly. :)
