Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1AZSun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:50:43 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51983 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AZSum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:50:42 -0500
Date: Wed, 26 Jan 2011 12:50:12 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] zram/vmalloc: Correct tunings to enable use with
 64K pages
Message-ID: <20110126185012.GD17383@linux.vnet.ibm.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=gehk1_ogsb-A6uWyb0a1Y2GqwKVu4k1p0Z-D1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@kernel.org> wrote:
> On Wed, Jan 26, 2011 at 7:22 PM, Robert Jennings> <rcj@linux.vnet.ibm.com> wrote:
>> xvmalloc will not currently function with 64K pages.  Newly allocated
>> pages will be inserted at an offset beyond the end of the first-level
>> index.  This tuning is needed to properly size the allocator for 64K
>> pages.
>> 
>> The default 3 byte shift results in a second level list size which can not
>> be indexed using the 64 bits of the flbitmap in the xv_pool structure.
>> The shift must increase to 4 bytes between second level list entries to
>> fit the size of the first level bitmap.
>> 
>> Here are a few statistics for structure sizes on 32- and 64-bit CPUs
>> with 4KB and 64KB page sizes.
>> 
>> bits_per_long              32        64        64
>> page_size               4,096     4,096    65,535
>> xv_align                    4         8         8
>> fl_delta                    3         3         4
>> num_free_lists            508       508     4,094
>> xv_pool size            4,144b    8,216b   66,040b
>> per object overhead        32        64        64
>> zram struct 0.5GB disk    512KB    1024KB      64KB
>> 
>> This patch maintains the current tunings for 4K pages, adds an optimal
>> sizing for 64K pages and adds a safe tuning for any other page sizes.
>> 
>> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zram/xvmalloc_int.h |   18 ++++++++++++++++--
>>  1 files changed, 16 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
>> index e23ed5c..051a49b 100644
>> --- a/drivers/staging/zram/xvmalloc_int.h
>> +++ b/drivers/staging/zram/xvmalloc_int.h
<snip>
>> @@ -27,8 +31,18 @@
>>  #define XV_MIN_ALLOC_SIZE	32
>>  #define XV_MAX_ALLOC_SIZE	(PAGE_SIZE - XV_ALIGN)
>>  
>> -/* Free lists are separated by FL_DELTA bytes */
>> -#define FL_DELTA_SHIFT	3
>> +/*
>> + * Free lists are separated by FL_DELTA bytes
>> + * This value is 3 for 4k pages and 4 for 64k pages, for any
>> + * other page size, a conservative (PAGE_SHIFT - 9) is used.
>> + */
>> +#if PAGE_SHIFT == 12
>> +#define FL_DELTA_SHIFT 3
>
> This is handled by the else branch already, no?

Yes, it does not need to be there.  I will repost.
