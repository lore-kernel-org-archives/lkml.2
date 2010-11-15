Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0KOS5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:57:46 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2820 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab0KOS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:57:44 -0500
Message-ID: <4CE182A2.1020606@caviumnetworks.com>
Date: Mon, 15 Nov 2010 10:57:38 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, benh@kernel.crashing.org,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        heiko.carstens@de.ibm.com, hpa@zytor.com, jejb@parisc-linux.org,
        kyle@mcmartin.ca, mingo@elte.hu, roland@redhat.com,
        schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com
Subject: Re: +	exec_domain-establish-a-linux32-domain-on-config_compat-systems.patc
 h added to -mm tree
References: <201011122022.oACKM6HH029696@imap1.linux-foundation.org> <20101113171722.GA2956@redhat.com>
In-Reply-To: <20101113171722.GA2956@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 18:58:25.0666 (UTC) FILETIME=[1523FE20:01CB84F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 09:17 AM, Oleg Nesterov wrote:
> On 11/12, Andrew Morton wrote:
>>
>> From: David Daney<ddaney@caviumnetworks.com>
>>
>> If PER_LINUX32 is set calling sys_personality, we will try to find the
>> corresponding exec_domain.  This causes us to try to load a module for
>> personality-8.  After running the userspace module loader and failing to
>> find the module, we fall back to the default.
>
> Cough. It is not easy to me comment this patch ;)
>
> Personally, I think this change is fine. But, despite the fact
> the code in exec_domain.c is very trivial, I was never able to really
> understand its rationality. And the usage of ->personality has some
> oddities.
>
> In particular, I can't parse default_exec_domain() at all. And,
> what exec_domain->handler() actually does? I do not see anything
> in arch/ which uses EXEC_DOMAIN offsets.
>
> Perhaps someone from CC can explain this?
>
>
>> We can avoid the failed module loading overhead by building-in the
>> linux32_exec_domain for systems that have CONFIG_COMPAT.
>
> Indeed. But at the same time this means it is not possible to use
> personality-8.ko if the system has it.

Well in the same way it is not possible to use personality-0.ko 
(PER_LINUX) because it is just as built-in.

>
> Don't get me wrong, I have no idea why anyone could want this module,
> just I am a bit worried.

If the personality is built-in, then I don't see how it makes any sense 
to attempt to override it with an externally supplied version.  If you 
want set a domain for PER_LINUX32, don't configure you system to supply 
a default version.

>
>> +#ifdef CONFIG_COMPAT
>> +static struct exec_domain linux32_exec_domain = {
>> +	.name		= "Linux32",		/* name */
>> +	.handler	= default_handler,	/* lcall7 causes a seg fault. */
>> +	.pers_low	= PER_LINUX32,
>> +	.pers_high	= PER_LINUX32,
>> +	.signal_map	= ident_map,		/* Identity map signals. */
>> +	.signal_invmap	= ident_map,		/*  - both ways. */
>> +};
>> +#endif
>> +
>>   struct exec_domain default_exec_domain = {
>>   	.name		= "Linux",		/* name */
>>   	.handler	= default_handler,	/* lcall7 causes a seg fault. */
>> @@ -41,6 +52,9 @@ struct exec_domain default_exec_domain =
>>   	.pers_high	= 0,			/* PER_LINUX personality. */
>>   	.signal_map	= ident_map,		/* Identity map signals. */
>>   	.signal_invmap	= ident_map,		/*  - both ways. */
>> +#ifdef CONFIG_COMPAT
>> +	.next		=&linux32_exec_domain,
>> +#endif
>>   };
>
> OK, but please look at arch/s390/kernel/compat_exec_domain.c and
> arch/ia64/mm/init.c, they also register PER_LINUX32 domain, not
> good. And note that register_exec_domain() doesn't check
> pers_low/high, this means linux32_exec_domain can silently supress
> s390_exec_domain/ia32_exec_domain.
>

Ah, I had not known about this.  The comments in arch/ia64/mm/init.c 
mirror my reason for creating the patch.

I think the s390 and ia64 definitions will conflict with the #ifdef 
CONFIG_COMPAT in my patch.  I will attempt to correct this in a new 
version of the patch.

Thanks for looking at this,
David Daney


