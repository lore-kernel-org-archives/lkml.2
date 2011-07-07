Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1GGSA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:00:58 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48330 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1GGSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:00:52 -0400
Message-ID: <4E15F451.5070701@candelatech.com>
Date: Thu, 07 Jul 2011 11:00:49 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] slub:  Add method to verify memory is not freed.
References: <1309308462-20124-1-git-send-email-greearb@candelatech.com> <1309308462-20124-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1107010909060.2458@router.home>
In-Reply-To: <alpine.DEB.2.00.1107010909060.2458@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 07:11 AM, Christoph Lameter wrote:

>> +#ifdef CONFIG_SLUB_DEBUG
>> +bool verify_mem_not_deleted(const void *x)
>> +{
>> +	struct page *page;
>> +	void *object = (void *)x;
>> +	unsigned long flags;
>> +	bool rv;
>> +
>> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
>> +		return false;
>> +
>> +	local_irq_save(flags);
>> +
>> +	page = virt_to_head_page(x);
>> +	if (unlikely(!PageSlab(page))) {
>> +		/* maybe it was from stack? */
>> +		rv = true;
>> +		goto out_unlock;
>> +	}
>
> The above check is problematic for slabs that have SLAB_DESTROY_BY_RCU
> set. PageSlab(page) may be true to the next rcu interval.

I do not see the problem here.  If PageSlab(page) is true, we fall
through and do the check for on-free-list, under the slab_lock().

We only return error if it is on the free list.  Would these pages
waiting on the RCU interval show up as in the free list?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

