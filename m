Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1IVLnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:43:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58808 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1IVLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:43:07 -0400
Message-ID: <4E7B1F46.9020706@gmail.com>
Date: Thu, 22 Sep 2011 13:43:02 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org> <1316607036-9235-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1316607036-9235-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 09/21/2011 02:10 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> There is currently a large divide between kernel development and the
> development of EFI boot loaders. The idea behind this patch is to give
> the kernel developers full control over the EFI boot process. As
> H. Peter Anvin put it,
>
> "The 'kernel carries its own stub' approach been very successful in
> dealing with BIOS, and would make a lot of sense to me for EFI as
> well."
>
> This patch introduces an EFI boot stub that allows an x86 bzImage to
> be loaded and executed by EFI firmware. The bzImage appears to the
> firmware as an EFI application. Luckily there are enough free bits
> within the bzImage header so that it can masquerade as an EFI
> application, thereby coercing the EFI firmware into loading it and
> jumping to its entry point. The beauty of this masquerading approach
> is that both BIOS and EFI boot loaders can still load and run the same
> bzImage, thereby allowing a single kernel image to work in any boot
> environment.
>
> The EFI boot stub supports multiple initrds, but they must exist on
> the same partition as the bzImage. Command-line arguments for the
> kernel can be appended after the bzImage name when run from the EFI
> shell, e.g.
>
> Shell> bzImage console=ttyS0 root=/dev/sdb initrd=initrd.img
>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Waychison <mikew@google.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>
> v3:
>  - Fix following warnings when compiling CONFIG_EFI_STUB=n
>
>    arch/x86/boot/tools/build.c: In function ‘main’:
>    arch/x86/boot/tools/build.c:138:24: warning: unused variable ‘pe_header’
>    arch/x86/boot/tools/build.c:138:15: warning: unused variable ‘file_sz’
>
>  - As reported by Matthew Garrett, some Apple machines have GOPs that
>    don't have hardware attached. We need to weed these out by
>    searching for ones that handle the PCIIO protocol.
>
>  - Don't allocate memory if no initrds are on cmdline
>  - Don't trust image->load_options_size
>
>  - Maarten Lankhorst suggested:
>    - Don't strip first argument when booted from efibootmgr
>    - Don't allocate too much memory for cmdline
>    - Don't update cmdline_size, the kernel considers it read-only
>    - Don't accept '\n' for initrd names
Even if load_options_size is not always completely reliable, could you at least prevent reading more than image->load_options_size? Code below doesn't seem to do that currently..

Thanks,
Maarten
