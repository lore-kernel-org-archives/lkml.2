Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0F0RAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 13:00:35 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:16710 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0F0RAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 13:00:34 -0400
Message-ID: <4C2783AD.3010403@tilera.com>
Date: Sun, 27 Jun 2010 13:00:29 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic
 network.
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006261316.12816.arnd@arndb.de>
In-Reply-To: <201006261316.12816.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2010 7:16 AM, Arnd Bergmann wrote:
> On Friday 25 June 2010, Chris Metcalf wrote:
>   
>> The original submission of this code to LKML had the driver
>> instantiated under /proc/tile/hardwall.  Now we just use a character
>> device for this, conventionally /dev/hardwall.  Some futures planning
>> for the TILE-Gx chip suggests that we may want to have other types of
>> devices that share the general model of "bind a task to a cpu, then
>> 'activate' a file descriptor on a pseudo-device that gives access to
>> some hardware resource".  As such, we are using a device rather
>> than, for example, a syscall, to set up and activate this code.
>>     
> The character device looks much better than the proc file. I still
> think a system call would be a more appropriate abstraction here,
> but the two are equivalent after all.
>   

I'm going to argue for a character device, though.  There are a few
reasons why I prefer it:

1. It allows a straightforward model for adding additional types of
"device" like this in the future.  It would be natural to support
multiple minor numbers, perhaps with different ones having different "is
the cpumask valid?" criteria.  Our next release will have two user
networks, and a notion of userspace IPIs, all of which fit the life
cycle of "create nonoverlapping cpumask, bind to cpu via affinity,
activate, deactivate".  You could imagine passing constants to the
syscall you propose, but it feels like it's just turning into a device
switch at that point.

2. You can easily imagine multiple classes of users, where different
classes are allowed to use different resources -- perhaps one user
network reserved for root, one for some privileged group, while the
userspace IPI network is available to anyone.  Or something different. 
We don't really know all the use cases yet, and having user/group
permissions built into the model seems like it may be helpful.

3. More subjectively -- the user dynamic networks have a "devicey" feel
to me.  Normal open-source code never has to deal with these things; you
only use them if your program is ready to open them up somehow, then
read and write data to them, which feels like a device kind of
abstraction (even though the reading and writing is via GPRs, not
iomem).  And the userspace IPI stuff will be done by mapping IOMEM into
process space and poking at it, once you've registered on the "userspace
IPI" device, so again it has a kind of devicey feel to it.

I don't think it would be strictly wrong to use a syscall, and you say
the two are interchangeable at a high level, but I think character
devices fit a bit better.

>> diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
>> index 96c50d2..95b54bc 100644
>> --- a/arch/tile/include/asm/processor.h
>> +++ b/arch/tile/include/asm/processor.h
>> @@ -74,6 +74,14 @@ struct async_tlb {
>>  	unsigned long address;   /* what address faulted? */
>>  };
>>  
>> +#ifdef CONFIG_HARDWALL
>> +struct hardwall_info;
>> +
>> +/* Can't use a normal list_head here due to header-file inclusion issues. */
>> +struct hardwall_list {
>> +	struct list_head *next, *prev;
>> +};
>> +#endif
>>     
> It seems strange that you need this. Why does linux/list.h
> depend on asm/processor.h?
>   

<linux/list.h> -> <linux/poison.h> -> <linux/prefetch.h> ->
<asm/processor.h>.  There doesn't seem to be any good way around this. 
I could, I suppose, use an opaque "struct list_head;" declaration in
<asm/processor.h>, then create one with kmalloc on demand, but that
seemed like overkill, so I embed the made-up version here, then validate
it as a BUILD_BUG_ON() to be the same size as a real list_head.  I never
actually use the "hardwall_list" structure directly.

> It certainly seems that the code would get simpler if this
> can be avoided.
>
>   
>> +/*
>> + * Guard changes to the hardwall data structures.
>> + * This could be finer grained (e.g. one lock for the list of hardwall
>> + * rectangles, then separate embedded locks for each one's list of tasks),
>> + * but there are subtle correctness issues when trying to start with
>> + * a task's "hardwall" pointer and lock the correct rectangle's embedded
>> + * lock in the presence of a simultaneous deactivation, so it seems
>> + * easier to have a single lock, given that none of these data
>> + * structures are touched very frequently during normal operation.
>> + */
>> +static DEFINE_SPINLOCK(hardwall_lock);
>>     
> I think instead of making the lock more fine-grained, a better optimization
> might be to use RCU to protect the updates. AFAICT, the updates to the
> structure are rare but you need to read it a lot.
>   

Actually, we neither read nor write the list very much.  We take the
lock when a new hardwall is created or a new process enables user
network access, but these are both "once per process lifetime" events
typically.  After that, the user process is just granted direct hardware
access when it is context switched in (based on a non-NULL hardwall_info
pointer) and that's it.  So the big spinlock approach is actually good
from a simplicity point of view.

>> +/*
>> + * Low-level primitives
>> + */
>> +
>> +/* Map a HARDWALL_FILE file to the matching hardwall info structure */
>> +#define _file_to_hardwall(file) ((file)->private_data)
>> +#define file_to_hardwall(file) \
>> +	((struct hardwall_info *)_file_to_hardwall(file))
>>     
> I wouldn't bother with these abstractions, you can simply write
> file->private_data in every place where they are used.
>   

Good point, fixed.  The abstractions were more useful when the file was
a seq_file and I had to work harder to get private data.

>> +#ifdef CONFIG_COMPAT
>> +static long hardwall_compat_ioctl(struct file *file,
>> +				  unsigned int a, unsigned long b)
>> +{
>> +	/* Sign-extend the argument so it can be used as a pointer. */
>> +	return hardwall_ioctl(file, a, (int)(long)b);
>> +}
>> +#endif
>>     
> Better use compat_ptr(b) instead of the manual cast.
>   

Yes, although hardwall_ioctl() wants an unsigned long, so it would have
to be "(unsigned long)compat_ptr(b)", so it's not obviously better
(certainly less succinct!).  But I concur that it's slightly less
obscure :-)

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

