Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2HONUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:20:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2HONUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:20:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Date: Wed, 15 Aug 2012 13:20:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151320.02313.arnd@arndb.de>
X-Provags-ID: V02:K0:mRcr1hQdI849CAm1qUDaWm2U+Ra3V5Q1yn6CvI5GfiO
 +rnem7okS5RRswjkWtSVatdfIk9TWREJ+5ydqlHKh0V9I0EH1y
 4CV67i08xexTi8K/Gz7QJzKBz0qWXj5u0d7me/M5pmXpiFG2bL
 5SSoVDXIXNuomSNeNHPNjZxDuuUhDx5ri8SQ7ica1X0p9yHwnC
 G2J/FoVVBkHTNCGbLC+3sbPckbpLmgsN9NnCBwJRy/22GK016h
 J1LP85hkycjZeYOzrCkOsPfNxY88IiDy/WHhDyFXLSdTdS11p4
 X6S81ZLImTNUBdoU+0K97dMCO+DS40/PgApX6n+OTjU9M9dTlQ
 cSEnr9LONmm8awN6+xJk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +The AArch64 exception model is made up of a number of exception levels
> +(EL0 - EL3), with EL0 and EL1 having a secure and a non-secure
> +counterpart.  EL2 is the hypervisor level and exists only in non-secure
> +mode. EL3 is the highest priority level and exists only in secure mode.

I'm always confused by a description like this. It sounds like you cannot
have a hypervisor if you have code running in secure mode in EL3. What
I instead understand is that you enter non-secure mode by going from
EL3 into EL2.

> +2. Setup the device tree
> +-------------------------
> +
> +Requirement: MANDATORY
> +
> +The device tree blob (dtb) must be no bigger than 2 megabytes in size
> +and placed at a 2-megabyte boundary within the first 512 megabytes from
> +the start of the kernel image. This is to allow the kernel to map the
> +blob using a single section mapping in the initial page tables.

I've seen people put firmware for some peripherals into the device tree,
so that a device driver can grab a blob from there and load it into the
device, rather than calling request_firmware() which would fail if the
OS running on the system does not contain the blob. If such firmware is
too large, you end up violating the 2 MB limit you impose here.

Should we keep that limit and declare those use cases as invalid, or
should we try to make the boot protocol more flexible?

> diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
> new file mode 100644
> index 0000000..d766493
> --- /dev/null
> +++ b/arch/arm64/include/asm/setup.h
> @@ -0,0 +1,26 @@
> +#ifndef __ASM_SETUP_H
> +#define __ASM_SETUP_H
> +
> +#include <linux/types.h>
> +
> +#define COMMAND_LINE_SIZE 1024
> +
> +#endif

Is this necessary? The asm-generic version of this file allows 512 bytes,
which seems plenty.

> +unsigned int processor_id;
> +EXPORT_SYMBOL(processor_id);
> +
> +unsigned int elf_hwcap __read_mostly;
> +EXPORT_SYMBOL(elf_hwcap);

EXPORT_SYMBOL_GPL?

Neither of these looks like they should be used in drivers.

	Arnd
