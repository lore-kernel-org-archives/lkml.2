Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1IMOdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:33:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55154 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1IMOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:33:10 -0400
Message-ID: <4E6F69A1.9030406@gmail.com>
Date: Tue, 13 Sep 2011 16:33:05 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org> <1315838094-2307-11-git-send-email-matt@console-pimps.org>
In-Reply-To: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 09/12/2011 04:34 PM, Matt Fleming wrote:
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
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>
> v2:
>  - File alignment was too large, was 8192 should be 512. Reported by
>    Maarten Lankhorst.
>  - Added UGA support for graphics
>  - Use VIDEO_TYPE_EFI instead of hard-coded number.
>  - Move linelength assignment until after we've assigned depth
>  - Dynamically fill out AddressOfEntryPoint in tools/build.c
>  - Don't use magic number for GDT/TSS stuff. Requested by Andi Kleen
>  - The bzImage may need to be relocated as it may have been loaded at
>    a high address address by the firmware. This was required to get my
>    macbook booting because the firmware loaded it at 0x7cxxxxxx, which
>    triggers this error in decompress_kernel(),
>
> 	if (heap > ((-__PAGE_OFFSET-(128<<20)-1) & 0x7fffffff))
> 		error("Destination address too large");
>
This version seems to boot for me. Is it useful to add 32-bits support though?
It seems that only some older versions of OSX use it. I could see if I can
revive my mac mini, iirc it has 32-bits efi, or at least used to have.

Do I need to pass anything to add it to efibootmgr?

I tried something like this:
echo "args" | efibootmgr -c -l '\vmlinuz.efi' -L 'Native EFI linux boot' -@ - -u -d /dev/sdb

And it boots vmlinuz.efi, but the arguments I passed do not appear to have any effect.

~Maarten

