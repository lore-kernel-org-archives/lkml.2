Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1F0Xxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:53:51 -0400
Received: from mail.candelatech.com ([208.74.158.172]:59214 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1F0XxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:53:23 -0400
Message-ID: <4E091670.9040405@candelatech.com>
Date: Mon, 27 Jun 2011 16:46:56 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com> <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 04:28 PM, David Rientjes wrote:
> On Mon, 27 Jun 2011, greearb@candelatech.com wrote:
>
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This is for tracking down suspect memory usage.
>>
>
> Several things wrong with this:
>
>   - I have no idea where patch 1/2 is.

It was sent to lkml...should show up soon.

>   - the subject line is ambiguous, when you say memory is "deleted," I
>     thought at first you were talking about hot-removed, but it seems like
>     you're talking about "freed."

Ok, I can fix that.  I'm talking about memory that was freed.

>
>   - what "suspect memory usage" are you adding functionality to catch and
>     how are you doing it?

I saw a case where xprt was 0x6b6b6b6b.  I'm trying to figure out
what freed it.  I am not certain if this is a bug I introduced in
some nfs changes I am testing, or if it is in a standard kernel.
I am unable to reproduce it in standard kernel, but that is partly
because my test case depends on my nfs patches.

The code below contains my debugging hacks, definitely not
for kernel inclusion as is.

/*
  * Rpcbind child task calls this callback via tk_exit.
  */
static void rpcb_getport_done(struct rpc_task *child, void *data)
{
	struct rpcbind_args *map = data;
	struct rpc_xprt *xprt = map->r_xprt;
	int status = child->tk_status;

	verify_mem_not_deleted(map);
	verify_mem_not_deleted(xprt);

	BUG_ON((unsigned int)(map) == (unsigned int)(0x6b6b6b6b));
	if ((unsigned int)(xprt) == (unsigned int)(0x6b6b6b6b)) {
		printk("xprt: %p is invalid, which means map: %p is likely deleted already.\n",
		       xprt, map);
		printk("map: r_owner: %p  r_prog: %u r_status: %u\n",
		       map->r_owner, map->r_prog, map->r_status);
		printk("child: %p  status: %i\n", child, status);
		BUG_ON(1);
	}
	BUG_ON((unsigned int)(status) == (unsigned int)(0x6b6b6b6b));

>   - you didn't cc the slab maintainers, Pekka Enberg and Christoph Lameter
>     (I added them).

Thanks for that.

>> +/** Calling this on deleted objects will print some
>> + * SLUB debugging information.
>> + */
>
> Ambiguous as to what it will be printing and violation of the comment
> style used in the kernel (see Documentation/CodingStyle).
>
>> +#if defined(CONFIG_SLUB)&&  defined(CONFIG_SLUB_DEBUG)
>> +extern bool verify_mem_not_deleted(const void *x);
>> +#else
>> +#define verify_mem_not_deleted(x)
>
> This will surely break if anybody isn't using slub or CONFIG_SLUB_DEBUG
> and it testing verify_mem_not_deleted().  You probably want
>
> 	static inline bool verify_mem_not_deleted(const void *x)
> 	{
> 		return false;
> 	}

Ok.

>
>> +#endif
>> +
>>   /*
>>    * Shortcuts
>>    */
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 14d0135..b3d7680 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2953,6 +2953,40 @@ size_t ksize(const void *object)
>>   }
>>   EXPORT_SYMBOL(ksize);
>>
>> +#if defined(CONFIG_SLUB_DEBUG)
>
> #ifdef CONFIG_SLUB_DEBUG
>
>> +bool verify_mem_not_deleted(const void *x)
>> +{
>> +	struct page *page;
>> +	void *object = (void *)x;
>> +	struct kmem_cache *s;
>> +	unsigned long flags;
>> +	bool rv = false;
>> +
>> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
>> +		false;
>> +
>
> Did you even compile-test this?

Well yes, but obviously I'm having a bad day!

Aside from the lame mistakes in my patch..is the general approach
usable?

>> +	local_irq_save(flags);
>> +
>> +	page = virt_to_head_page(x);
>> +	if (unlikely(!PageSlab(page))) {
>> +		BUG_ON(!PageCompound(page));
>
> Why is there a BUG_ON() here if we didn't pass a pointer to a slab object?

Just copying the kfree code.  Just return 'true' in this case?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

