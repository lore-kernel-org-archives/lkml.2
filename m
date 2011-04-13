Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1DMTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:49:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57172 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab1DMTs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JJzeoMgdWL9VUy+0hZDUIZa2l6o6LV3JsD1oK90H0jH+iWaBtnmf0OCQnk6kxNfZXz
         KhlGlf8jmF8QSS6ZrN2rlzqjXxQZAEQsCCA2L9M1aZNhx/GYuBvXb05j7pBW6eEv5ikf
         7AoEGDGkfsOIcMB4eAlmwD84Mzch7/+oQx0v8=
MIME-Version: 1.0
In-Reply-To: <4DA5F62F.3030504@kernel.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	<20110412090207.GE19819@8bytes.org>
	<BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	<20110412184433.GF19819@8bytes.org>
	<20110413064609.GA18777@elte.hu>
	<20110413172147.GI19819@8bytes.org>
	<4DA5F62F.3030504@kernel.org>
Date: Wed, 13 Apr 2011 15:48:57 -0400
Message-ID: <BANLkTikvKpHjz8RfJpNrejMrG3Mk0vpMmA@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Alex Deucher <alexdeucher@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 3:14 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 04/13/2011 10:21 AM, Joerg Roedel wrote:
>> On Wed, Apr 13, 2011 at 08:46:09AM +0200, Ingo Molnar wrote:
>> First of all, I bisected between v2.6.37-rc2..f005fe12b90c which where
>> only a couple of patches and merged v2.6.38-rc4 in at every step. There
>> was no failure found.
>> Then I tried this again, but this time I merged v2.6.38-rc5 at every
>> step and was successful. The bad commit in this branch turned out to be
>>
>>       1a4a678b12c84db9ae5dce424e0e97f0559bb57c
>>
>> which is related to memblock.
>>
>> Then I tried to find out which change between 2.6.38-rc4 and 2.6.38-rc5
>> is needed to trigger the failure, so I used f005fe12b90c as a base,
>> bisected between v2.6.38-rc4..v2.6.38-rc5 and merged every bisect step
>> into the base and tested. Here the bad commit turned out to be
>>
>>       e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20
>>
>> which is related to gart. It turned out that the gart aperture on that
>> box is on another position with these patches. Before it was as
>> 0xa4000000 and now it is at 0xa0000000. It seems like this has something
>> to do with the root-cause.
>>
>> Reverting commit 1a4a678b12c84db9ae5dce424e0e97f0559bb57c fixes the
>> problem btw. and booting with iommu=soft also works, but I have no idea
>> yet why the aperture at that address is a problem (with the patch
>> reverted the aperture lands at 0x80000000).
>>
>> I have put some debug-data online. There is my .config and two
>> dmesg-files for good (==2.6.39-rc3 + revert) and bad (==2.6.39-rc3)
>> I also created these dmesg-files again with memblock=debug, maybe that
>> helps to find the problem. The files are at
>>
>>       http://www.8bytes.org/~joro/debug/
>
> thanks for the bisecting...
>
> so those two patches uncover some problems.
>
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ a0000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000]     memblock_x86_reserve_range: [0xa0000000-0xa3ffffff]       aperture64
> [    0.000000] Mapping aperture over 65536 KB of RAM @ a0000000
>
> so kernel try to reallocate apperture. because BIOS allocated is pointed to RAM or size is too small.
>
> but your radeon does use [0xa0000000, 0xbfffffff)
>
> [    4.281993] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
> [    4.290672] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> [    4.298550] [drm] Detected VRAM RAM=320M, BAR=256M
> [    4.309857] [drm] RAM width 32bits DDR
> [    4.313748] [TTM] Zone  kernel: Available graphics memory: 1896524 kiB.
> [    4.320379] [TTM] Initializing pool allocator.
> [    4.324948] [drm] radeon: 320M of VRAM memory ready
> [    4.329832] [drm] radeon: 512M of GTT memory ready.
>
> and the one seems working:
>
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ a0000000 size 32 MB
> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000]     memblock_x86_reserve_range: [0x80000000-0x83ffffff]       aperture64
> [    0.000000] Mapping aperture over 65536 KB of RAM @ 80000000
> [    0.000000]     memblock_x86_reserve_range: [0xacb6bdc0-0xacb6bddf]          BOOTMEM
>
> will use different position...
>
> [    4.250159] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
> [    4.258830] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> [    4.266742] [drm] Detected VRAM RAM=320M, BAR=256M
> [    4.271549] [drm] RAM width 32bits DDR
> [    4.275435] [TTM] Zone  kernel: Available graphics memory: 1896526 kiB.
> [    4.282066] [TTM] Initializing pool allocator.
> [    4.282085] usb 7-2: new full speed USB device number 2 using ohci_hcd
> [    4.293076] [drm] radeon: 320M of VRAM memory ready
> [    4.298277] [drm] radeon: 512M of GTT memory ready.
> [    4.303218] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    4.309854] [drm] Driver supports precise vblank timestamp query.
> [    4.315970] [drm] radeon: irq initialized.
> [    4.320094] [drm] GART: num cpu pages 131072, num gpu pages 131072
>
> So question is why radeon is using the address [0xa0000000 - 0xc000000], and in E820 it is RAM ....

The VRAM and GTT addresses in the dmesg are internal GPU addresses not
system addresses.  The GPU has it's own internal address space for
on-chip memory clients (texture samplers, render buffers, display
controllers, etc.).  The GPU sets up two apertures in it's internal
address space and on-chip client requests are forwarded to the
appropriate place by the GPU's memory controller.  Addresses in the
GPU's VRAM aperture go to local vram on discrete cards, or to the
stolen memory at the top of system memory for IGP cards.  Addresses in
the GPU's GTT aperture hit a page table and get forwarded to the
appropriate dma pages.

Alex

>
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000acb8d000 (usable)
> [    0.000000]  BIOS-e820: 00000000acb8d000 - 00000000acb8f000 (reserved)
> [    0.000000]  BIOS-e820: 00000000acb8f000 - 00000000afce9000 (usable)
> [    0.000000]  BIOS-e820: 00000000afce9000 - 00000000afd21000 (reserved)
> [    0.000000]  BIOS-e820: 00000000afd21000 - 00000000afd4f000 (usable)
> [    0.000000]  BIOS-e820: 00000000afd4f000 - 00000000afdcf000 (reserved)
> [    0.000000]  BIOS-e820: 00000000afdcf000 - 00000000afecf000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000afecf000 - 00000000afeff000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000afeff000 - 00000000aff00000 (usable)
>
>
> so looks bios program wrong address to the radon card?
>
> Thanks
>
> Yinghai Lu
>
