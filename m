Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HQLqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:46:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34644 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab1HQLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:46:52 -0400
Subject: Re: [PATCH 8/9] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <m2k4ajn7kw.fsf@firstfloor.org>
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
	 <1313060386-4858-9-git-send-email-matt@console-pimps.org>
	 <m2k4ajn7kw.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 12:46:39 +0100
Message-ID: <1313581599.2311.4.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 11:09 -0700, Andi Kleen wrote: 
> Matt Fleming <matt@console-pimps.org> writes:
> > +
> > +	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > +				EFI_LOADER_DATA, sizeof(*idt),
> > +				(void **)&idt);
> > +	if (status != EFI_SUCCESS)
> > +		goto fail;
> > +
> > +	idt->size = 0;
> > +	idt->address = 0;
> > +
> > +	status = make_boot_params(boot_params, image, handle);
> > +	if (status != EFI_SUCCESS)
> > +		goto fail;
> > +
> > +	memset((char *)gdt->address, 0x0, gdt->size);
> > +	desc = (u64 *)gdt->address;
> > +
> > +	/*
> > +	 * 4Gb - (0x100000*0x1000 = 4Gb)
> > +	 * base address=0
> > +	 * code read/exec
> > +	 * granularity=4096, 386 (+5th nibble of limit)
> > +	 */
> > +	desc[2] = 0x00cf9a000000ffff;
> > +
> > +	/*
> > +	 * 4Gb - (0x100000*0x1000 = 4Gb)
> > +	 * base address=0
> > +	 * data read/write
> > +	 * granularity=4096, 386 (+5th nibble of limit)
> > +	 */
> > +	desc[3] = 0x00cf92000000ffff;
> > +
> > +	/* Task segment value */
> > +	desc[4] = 0x0080890000000000;
> 
> The code would benefit from more variables/defines and less magic numbers.

Yeah, good point. I'll update that.

> I assume this is all virtual, otherwise it would be really scary.

What do you mean by virtual?

> > +	asm volatile ("lidt %0" :: "m" (*idt));
> > +	asm volatile ("lgdt %0" :: "m" (*gdt));
> > +
> > +	asm volatile("cli");
> 
> ::: "memory" to avoid moving

What do you mean? What will be moved?

> > +
> > +	return boot_params;
> > +fail:
> > +	return NULL;
> 
> Does the caller actually something useful here for NULL? Better to have
> messages when any of this fails.

Yes, the caller uses the return value to figure out whether it should
fall back to the usual non-EFI bzImage boot procedure.

> > +int memcmp(const void *s1, const void *s2, size_t len)
> > +{
> > +	u8 diff;
> > +	asm("repe; cmpsb; setnz %0"
> > +	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
> 
> This doesn't describe to gcc that the inline assembler 
> reads s1 and s2. At the minimum add a memory clobber.

Confused. The "+" constraint indicates that the register will be both
read from and written to. Why is the memory clobber required? We're not
modifying memory.

> > +
> > +/**
> > + * strlen - Find the length of a string
> > + * @s: The string to be sized
> > + */
> > +size_t strlen(const char *s)
> > +{
> > +	const char *sc;
> > +
> > +	for (sc = s; *sc != '\0'; ++sc)
> > +		/* nothing */;
> > +	return sc - s;
> > +}
> 
> Why not just link in/#include lib/string.c ? 

I did try to #include it originally but there was various compiler
errors that sent me running in the other direction, e.g.

In file included from arch/x86/boot/compressed/../string.c:83:0,
                 from arch/x86/boot/compressed/string.c:12:
arch/x86/boot/compressed/../../../../lib/string.c: In function ‘strlcat’:
arch/x86/boot/compressed/../../../../lib/string.c:223:2: warning: asm operand 0 probably doesn’t match constraints
arch/x86/boot/compressed/../../../../lib/string.c:223:2: error: impossible constraint in ‘asm’
make[2]: *** [arch/x86/boot/compressed/string.o] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2

This is with CONFIG_DEBUG_BUGVERBOSE=y.

Thanks for the review!

-- 
Matt Fleming, Intel Open Source Technology Center


