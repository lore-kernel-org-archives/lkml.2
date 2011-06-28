Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab1F1OxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:53:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:14312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab1F1OwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="21069757"
Message-ID: <4E09EA96.5080005@linux.intel.com>
Date: Tue, 28 Jun 2011 07:52:06 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Shawn Bohrer <sbohrer@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH v3] futex: Fix regression with read only mappings
References: <4E08F893.10103@linux.intel.com>	 <1309213375-31471-1-git-send-email-sbohrer@rgmadvisors.com> <1309258475.6701.200.camel@twins>
In-Reply-To: <1309258475.6701.200.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2011 03:54 AM, Peter Zijlstra wrote:
> On Mon, 2011-06-27 at 17:22 -0500, Shawn Bohrer wrote:
>> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
>> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
>> regression in that it additionally prevented futex operations on a
>> region within a read only memory mapped file.  For example this breaks
>> workloads that have one or more reader processes doing a FUTEX_WAIT on a
>> futex within a read only shared mapping, and a writer processes that has
>> a writable mapping issuing the FUTEX_WAKE.
>>
>> This fixes the regression for futex operations that should be valid on
>> RO mappings by trying a RO get_user_pages_fast() when the RW
>> get_user_pages_fast() fails so as not to slow down the common path of
>> writable anonymous maps and bailing when we used the RO path on
>> anonymous memory.
>>
>> While fixing the regression this patch opens up two possible bad
>> scenarios as identified by KOSAKI Motohiro:
>>
>> 1) This patch also allows FUTEX_WAIT on RO private mappings which have
>> the following corner case.
>>
>>   Thread-A: call futex(FUTEX_WAIT, memory-region-A).
>>             get_futex_key() return inode based key.
>>             sleep on the key
>>   Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
>>   Thread-B: write memory-region-A.
>>             COW happen. This process's memory-region-A become related
>>             to new COWed private (ie PageAnon=1) page.
>>   Thread-B: call futex(FUETX_WAKE, memory-region-A).
>>             get_futex_key() return mm based key.
>>             IOW, we fail to wake up Thread-A.
>>
>> 2) Current futex code doesn't handle zero page properly.
>>
>>   Read mode get_user_pages() can return zero page, but current futex
>>   code doesn't handle it at all. Then, zero page makes infinite loop
>>   internally.
>>
>> This Patch is based on Peter Zijlstra's initial patch with modifications to
>> only allow RO mappings for futex operations that need VERIFY_READ access.
>>
>> Reported-by: David Oliver <david@rgmadvisors.com>
>> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I think we need to address #2 above first.

1) Is the loop killable?
2) If not, and we try to catch zero_page scenario, we need to ensure RO
   sparse file mapping work. Peter notes that these are probably fine,
   filemap.c doesn't seem to use the zero page - but we need to test.

It's agreed, I believe, between myself, Peter, and Shawn that we will
document Private RW mappings as unsupported.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
