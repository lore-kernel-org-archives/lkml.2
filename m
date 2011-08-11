Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1HKSJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:09:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:51715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1HKSJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,357,1309762800"; 
   d="scan'208";a="37551607"
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 8/9] x86, efi: EFI boot stub support
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
	<1313060386-4858-9-git-send-email-matt@console-pimps.org>
Date: Thu, 11 Aug 2011 11:09:35 -0700
In-Reply-To: <1313060386-4858-9-git-send-email-matt@console-pimps.org> (Matt
	Fleming's message of "Thu, 11 Aug 2011 11:59:45 +0100")
Message-ID: <m2k4ajn7kw.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt@console-pimps.org> writes:
> +
> +	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +				EFI_LOADER_DATA, sizeof(*idt),
> +				(void **)&idt);
> +	if (status != EFI_SUCCESS)
> +		goto fail;
> +
> +	idt->size = 0;
> +	idt->address = 0;
> +
> +	status = make_boot_params(boot_params, image, handle);
> +	if (status != EFI_SUCCESS)
> +		goto fail;
> +
> +	memset((char *)gdt->address, 0x0, gdt->size);
> +	desc = (u64 *)gdt->address;
> +
> +	/*
> +	 * 4Gb - (0x100000*0x1000 = 4Gb)
> +	 * base address=0
> +	 * code read/exec
> +	 * granularity=4096, 386 (+5th nibble of limit)
> +	 */
> +	desc[2] = 0x00cf9a000000ffff;
> +
> +	/*
> +	 * 4Gb - (0x100000*0x1000 = 4Gb)
> +	 * base address=0
> +	 * data read/write
> +	 * granularity=4096, 386 (+5th nibble of limit)
> +	 */
> +	desc[3] = 0x00cf92000000ffff;
> +
> +	/* Task segment value */
> +	desc[4] = 0x0080890000000000;

The code would benefit from more variables/defines and less magic numbers.

I assume this is all virtual, otherwise it would be really scary.

> +	asm volatile ("lidt %0" :: "m" (*idt));
> +	asm volatile ("lgdt %0" :: "m" (*gdt));
> +
> +	asm volatile("cli");

::: "memory" to avoid moving

> +
> +	return boot_params;
> +fail:
> +	return NULL;

Does the caller actually something useful here for NULL? Better to have
messages when any of this fails.

> +int memcmp(const void *s1, const void *s2, size_t len)
> +{
> +	u8 diff;
> +	asm("repe; cmpsb; setnz %0"
> +	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));

This doesn't describe to gcc that the inline assembler 
reads s1 and s2. At the minimum add a memory clobber.

> +
> +/**
> + * strlen - Find the length of a string
> + * @s: The string to be sized
> + */
> +size_t strlen(const char *s)
> +{
> +	const char *sc;
> +
> +	for (sc = s; *sc != '\0'; ++sc)
> +		/* nothing */;
> +	return sc - s;
> +}

Why not just link in/#include lib/string.c ? 


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
