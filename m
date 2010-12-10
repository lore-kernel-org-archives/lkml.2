Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0LJQle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:41:34 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:41842 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0LJQld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:41:33 -0500
MIME-Version: 1.0
X-Originating-IP: [89.139.39.216]
In-Reply-To: <20101207161054.d502fae8.akpm@linux-foundation.org>
References: <1291543563-5655-1-git-send-email-ohad@wizery.com> <20101207161054.d502fae8.akpm@linux-foundation.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 10 Dec 2010 18:26:36 +0200
Message-ID: <AANLkTi=zhjT1fw5_8hWufDDM4QkOcb=kBhhyiZ1PcDMo@mail.gmail.com>
Subject: Re: [RFC] add BUG_ON_MAPPABLE_NULL macro
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Greg KH <greg@kroah.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 2:10 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> Every time someone sends me a patch with text after the "---", I decide
> it was good changelog material and I promote it to above the "---".
> How's about you save us the effort :)

sure :)

>> +/**
>> + * BUG_ON_MAPPABLE_NULL() - BUG_ON(condition) only if address 0 is mappable
>> + * @condition:       condition to check, should contain a NULL check
>> + *
>> + * In general, NULL dereference Oopses are not desirable, since they take down
>> + * the system with them and make the user extremely unhappy. So as a general
>> + * rule drivers should avoid dereferencing NULL pointers by doing a simple
>
> s/drivers/code/

definitely.

>> + * check (when appropriate), and just return an error rather than crash.
>> + * This way the system, despite having reduced functionality, will just keep
>> + * running rather than immediately reboot.
>> + *
>> + * _Critical_ kernel code, OTOH, that should not (/cannot) keep running when
>> + * given an unexpected NULL pointer, should just crash. On some architectures,
>> + * a NULL dereference will always reliably produce an Oops. On others, where
>> + * the zero address can be mmapped, an Oops is not guaranteed. Relying on
>> + * NULL dereference Oopses to happen on these architectures might lead to
>> + * data corruptions (system will keep running despite a critical bug and
>> + * the results will be horribly undefined). In addition, these situations
>> + * can also have security implications - we have seen several privilege
>> + * escalation exploits with which an attacker gained full control over the
>> + * system due to NULL dereference bugs.
>
> yup.
>
>> + * This macro will BUG_ON if @condition is true on architectures where the zero
>> + * address can be mapped. On other architectures, where the zero address
>> + * can never be mapped, this macro is compiled out. It only makes sense to
>> + * use this macro if @condition contains a NULL check, in order to optimize that
>> + * check out on architectures where the zero address can never be mapped.
>> + * On such architectures, those checks are not necessary, since the code
>> + * itself will reliably reproduce an Oops as soon as the NULL address will
>> + * be dereferenced.
>> + *
>> + * As with BUG_ON, use this macro only if @condition cannot be tolerated.
>> + * If proceeding with degraded functionality is an option, it's much
>> + * better to just simply check for @condition and return some error code rather
>> + * than crash the system.
>> + */
>> +#define BUG_ON_MAPPABLE_NULL(cond) do { \
>> +     if (arch_mmap_check(0, 1, MAP_FIXED) == 0) \
>> +             BUG_ON(cond); \
>> +} while (0)
>
> - arch_mmap_check() didn't have any documentation.  Please fix?

Sure.

>
> - arch_mmap_check() is a pretty poor identifier (identifiers which
>  include the word "check" are usually poor ones).  Maybe
>  arch_address_accessible()?

Maybe arch_address_mappable() might be more accurate (an address might
be accessible but not mappable due to some other arch-specific usage)
?

But, do you think it makes sense to rename arch_mmap_check() without
adding any functional benefit to it ?

arch_mmap_check is already defined today for ARM, IA64, MN10300, S390
and SPARC, and used by get_unmapped_area() [mmap.c], and this patch
adds a second usage of it.

To rename it, the patch will have to touch all of those architectures,
and usually, patches that carry stylistic changes in areas which they
don't add any functional benefit to, are considered pretty annoying...

> - I worry about arch_mmap_check().  Is it expected that it will
>  perform a runtime check, like probe_kernel_address()?  Spell out the
>  expectations, please.

Yes, arch_mmap_check does perform a runtime check: get_unmapped_area()
calls it with its addr, len and flags parameters.

But, since BUG_ON_MAPPABLE_NULL() calls it with constant values, I
expect arch_mmap_check() to be compiled out (tested on ARM and
X86_64).

> - BUG_ON_MAPPABLE_NULL() will evaluate arch_mmap_check() even if
>  CONFIG_BUG=n.  Seems bad, depending on what those unspelled-out
>  expectations are!

Definitely. I'll add:

#define BUG_ON_MAPPABLE_NULL(condition)  do { if (condition) ; } while(0)

in case CONFIG_BUG=n.

>
> - BUG_ON_MAPPABLE_NULL() is a mouthful.  I can't immedaitely think of
>  anythinjg nicer :(

Heartily agree...

> - Is BUG_ON_MAPPABLE_NULL() really the interface you want?  Or do we
>  just want an interface which checks a pointer for nearly-nullness?

I guess we can start with BUG_ON_MAPPABLE_NULL(), since this is what
people commonly check today, and we will now be able to optimize those
checks out when they are unnecessary.

Thanks a lot,
Ohad.

>
>
>
