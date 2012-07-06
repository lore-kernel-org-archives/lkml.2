Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab2GFVc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:32:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GFVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:32:57 -0400
Message-ID: <4FF75986.8010706@wwwdotorg.org>
Date: Fri, 06 Jul 2012 15:32:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 03:05 PM, Catalin Marinas wrote:
> The patch adds the kernel booting and the initial setup code.
> Documentation/aarch64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.

> diff --git a/Documentation/aarch64/booting.txt b/Documentation/aarch64/booting.txt

> +3. Decompress the kernel image
> +------------------------------
> +
> +Requirement: OPTIONAL
> +
> +The AArch64 kernel does not provide a decompressor and therefore
> +requires gzip decompression to be performed by the boot loader if the
> +default Image.gz target is used.  For bootloaders that do not implement
> +this requirement, the larger Image target is available instead.

I'm curious why a decompressor isn't provided.

The reason I ask is that this change will cause differences in the way
e.g. a U-Boot script boots the kernel; the filename would be different,
you'd need to use a uImage in order for U-Boot to decompress the kernel
instead of a raw zImage, etc. This makes things on AArch64 work just a
little bit different from existing systems, and differences between
systems make for more things for everyone to understand and remember;
more mistakes will be made. U-Boot has recently grown a "bootz" command
to simplify booting a zImage directly for example, and now it seems that
won't be useful moving forward.

Also, on Tegra at least and perhaps OMAP too, there are a few parts of
earlyprintk serial port setup (i.e. port selection) which happen as part
of the decompressor rather than the main kernel image, so we'd have to
re-jig that too.

> +4. Call the kernel image
> +------------------------
> +
> +Requirement: MANDATORY
> +
> +The decompressed kernel image contains a 32-byte header as follows:
> +
> +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> +  u32 res0	= 0;		/* reserved */
> +  u64 text_offset;		/* Image load offset */
> +  u64 res1	= 0;		/* reserved */
> +  u64 res2	= 0;		/* reserved */
> +
> +The image must be placed at the specified offset (currently 0x80000)
> +from the start of the system RAM (aligned to 2MB) and called there.

Is "0x80000" meant to have an extra "0"; 0x80000 isn't aligned to 2MB
unless I'm really missing too much sleep today.
