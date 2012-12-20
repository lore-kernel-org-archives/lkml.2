Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2LTA5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:57:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48077 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2LTA5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:57:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-mm@kvack.org
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
	<20121219161856.e6aa984f.akpm@linux-foundation.org>
Date: Wed, 19 Dec 2012 16:57:03 -0800
In-Reply-To: <20121219161856.e6aa984f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 19 Dec 2012 16:18:56 -0800")
Message-ID: <878v8ty200.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/cI2Nn1cGWIsa3inVCwSSeURdeomrZjcU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering free pages.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 10 Dec 2012 10:39:13 +0900
> Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp> wrote:
>
>> This patch adds the values related to buddy system to vmcoreinfo data
>> so that makedumpfile (dump filtering command) can filter out all free
>> pages with the new logic.
>> It's faster than the current logic because it can distinguish free page
>> by analyzing page structure at the same time as filtering for other
>> unnecessary pages (e.g. anonymous page).
>> OTOH, the current logic has to trace free_list to distinguish free 
>> pages while analyzing page structure to filter out other unnecessary
>> pages.
>> 
>> The new logic uses the fact that buddy page is marked by _mapcount == 
>> PAGE_BUDDY_MAPCOUNT_VALUE. But, _mapcount shares its memory with other
>> fields for SLAB/SLUB when PG_slab is set, so we need to check if PG_slab
>> is set or not before looking up _mapcount value.
>> And we can get the order of buddy system from private field.
>> To sum it up, the values below are required for this logic.
>> 
>> Required values:
>>   - OFFSET(page._mapcount)
>>   - OFFSET(page.private)
>>   - NUMBER(PG_slab)
>>   - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)
>> 
>> Changelog from v1 to v2:
>> 1. remove SIZE(pageflags)
>>   The new logic was changed after I sent v1 patch.  
>>   Accordingly, SIZE(pageflags) has been unnecessary for makedumpfile.
>> 
>> What's makedumpfile:
>>   makedumpfile creates a small dumpfile by excluding unnecessary pages
>>   for the analysis. To distinguish unnecessary pages, makedumpfile gets
>>   the vmcoreinfo data which has the minimum debugging information only
>>   for dump filtering.
>
> Gee, this info is getting highly dependent upon deep internal kernel
> behaviour.
>
>> index 5e4bd78..b27efe4 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -1490,6 +1490,8 @@ static int __init crash_save_vmcoreinfo_init(void)
>> 	VMCOREINFO_OFFSET(page, _count);
>> 	VMCOREINFO_OFFSET(page, mapping);
>> 	VMCOREINFO_OFFSET(page, lru);
>> +	VMCOREINFO_OFFSET(page, _mapcount);
>> +	VMCOREINFO_OFFSET(page, private);
>> 	VMCOREINFO_OFFSET(pglist_data, node_zones);
>> 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
>>  #ifdef CONFIG_FLAT_NODE_MEM_MAP
>> @@ -1512,6 +1514,8 @@ static int __init crash_save_vmcoreinfo_init(void)
>> 	VMCOREINFO_NUMBER(PG_lru);
>> 	VMCOREINFO_NUMBER(PG_private);
>> 	VMCOREINFO_NUMBER(PG_swapcache);
>> +	VMCOREINFO_NUMBER(PG_slab);
>> +	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>
> We might change the PageBuddy() implementation at any time, and
> makedumpfile will break.  Or in this case, become less efficient.
>
> Is there any way in which we can move some of this logic into the
> kernel?  In this case, add some kernel code which uses PageBuddy() on
> behalf of makedumpfile, rather than replicating the PageBuddy() logic
> in userspace?

All that exists when makedumpfile runs is a core file.  So it would have
to be something like a share library that builds with the kernel and
then makedumpfile loads.

Eric

