Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0INRgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:36:47 -0400
Received: from freeflow.nu ([178.79.134.28]:38764 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0INRgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:36:46 -0400
Message-ID: <4C8FB2AC.1030107@kernel.org>
Date: Tue, 14 Sep 2010 20:36:44 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: torvalds@linux-founation.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
References: <1284483964-2370-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141221310.31857@router.home>
In-Reply-To: <alpine.DEB.2.00.1009141221310.31857@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 14.9.2010 20.26, Christoph Lameter wrote:
> On Tue, 14 Sep 2010, Pekka Enberg wrote:
>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 59260e2..df201cf 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -76,6 +76,8 @@
>>   # define SLAB_FAILSLAB		0x00000000UL
>>   #endif
>>
>> +#define SLAB_DYNAMIC_NAME	0x04000000UL	/* s->name is kmalloc()'d */
>> +
> Put this into mm/slub.c as slub only flag? What is the difference from
> refcount == 1?
I can put it in mm/slub.c but I was worried about someone reusing the 
bit for something else.

Do you mean refcount == 2? You don't know during kmem cache release time 
if someone was merged to the cache or not.
>> @@ -3218,6 +3221,18 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>>   	down_write(&slub_lock);
>>   	s = find_mergeable(size, align, flags, name, ctor);
>>   	if (s) {
>> +		if (!(s->flags&  SLAB_DYNAMIC_NAME)) {
>> +			const char *new_name;
>> +
>> +			new_name = kstrdup(s->name, GFP_KERNEL);
> Ok. Keeping the original name. Why dont we do strdup by default and always
> do a kfree(s->name) on close?
>
I tried that. It gets very nasty during bootstrap.

