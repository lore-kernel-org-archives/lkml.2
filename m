Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0FRGsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab0FRGsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:48:03 -0400
Message-ID: <4C1B1691.6020809@redhat.com>
Date: Fri, 18 Jun 2010 14:47:45 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan>
In-Reply-To: <20100617161728.GA2741@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 12:17 AM, Marcin Slusarz wrote:
> On Thu, Jun 17, 2010 at 03:45:59PM +0200, Dan Carpenter wrote:
>> Commit 20413f27163 "x86, pat: Fix memory leak in free_memtype" added an
>> error message in free_memtype() if rbt_memtype_erase() returns NULL.
>> The problem is that if CONFIG_X86_PAT is enabled, we use a different
>> implimentation of rbt_memtype_erase() that always returns NULL.
>>
>> I've modified rbt_memtype_erase() to return an ERR_PTR() on errors and
>> made free_memtype() check for that instead.
>>
>> Addresses:  https://bugzilla.kernel.org/show_bug.cgi?id=16205
>>
>> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> This patch is probably ok, but it does not address my bug.
> I have CONFIG_X86_PAT=y, so rbt_memtype_erase does not always return NULL.

Could you please try boot with kernel parameter "debugpat", and
show me the output of reserve_memtype/free_memtype ?

>
>> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>> index acc15b2..81b7735 100644
>> --- a/arch/x86/mm/pat.c
>> +++ b/arch/x86/mm/pat.c
>> @@ -359,10 +359,10 @@ int free_memtype(u64 start, u64 end)
>>   	entry = rbt_memtype_erase(start, end);
>>   	spin_unlock(&memtype_lock);
>>
>> -	if (!entry) {
>> +	if (IS_ERR(entry)) {
>>   		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
>>   			current->comm, current->pid, start, end);
>> -		return -EINVAL;
>> +		return PTR_ERR(entry);
>>   	}
>>
>>   	kfree(entry);
>> diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
>> index f537087..90e5cbe 100644
>> --- a/arch/x86/mm/pat_rbtree.c
>> +++ b/arch/x86/mm/pat_rbtree.c
>> @@ -236,8 +236,10 @@ struct memtype *rbt_memtype_erase(u64 start, u64 end)
>>   	struct memtype *data;
>>
>>   	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
>> -	if (!data)
>> +	if (!data) {
>> +		data = ERR_PTR(-EINVAL);
>>   		goto out;
>> +	}
>>
>>   	rb_erase(&data->rb,&memtype_rbroot);
>>   out:
>>
>>
>

