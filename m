Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab1DNCIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab1DNCIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:08:35 -0400
Subject: Re: Linux 2.6.39-rc3
From: Dave Airlie <airlied@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4DA654D6.2060103@zytor.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	 <20110412090207.GE19819@8bytes.org>
	 <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	 <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>
	 <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>
	 <4DA654D6.2060103@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 12:07:33 +1000
Message-ID: <1302746853.4842.20.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 18:58 -0700, H. Peter Anvin wrote:
> On 04/13/2011 12:14 PM, Yinghai Lu wrote:
> > 
> > so those two patches uncover some problems.
> > 
> > [    0.000000] Checking aperture...
> > [    0.000000] No AGP bridge found
> > [    0.000000] Node 0: aperture @ a0000000 size 32 MB
> > [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> > [    0.000000] Your BIOS doesn't leave a aperture memory hole
> > [    0.000000] Please enable the IOMMU option in the BIOS setup
> > [    0.000000] This costs you 64 MB of RAM
> > [    0.000000]     memblock_x86_reserve_range: [0xa0000000-0xa3ffffff]       aperture64
> > [    0.000000] Mapping aperture over 65536 KB of RAM @ a0000000
> > 
> > so kernel try to reallocate apperture. because BIOS allocated is pointed to RAM or size is too small.
> > 
> > but your radeon does use [0xa0000000, 0xbfffffff)
> > 
> > [    4.281993] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
> > [    4.290672] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> > [    4.298550] [drm] Detected VRAM RAM=320M, BAR=256M
> > [    4.309857] [drm] RAM width 32bits DDR
> > [    4.313748] [TTM] Zone  kernel: Available graphics memory: 1896524 kiB.
> > [    4.320379] [TTM] Initializing pool allocator.
> > [    4.324948] [drm] radeon: 320M of VRAM memory ready
> > [    4.329832] [drm] radeon: 512M of GTT memory ready.
> > 
> > and the one seems working:
> > 
> > [    0.000000] Checking aperture...
> > [    0.000000] No AGP bridge found
> > [    0.000000] Node 0: aperture @ a0000000 size 32 MB
> > [    0.000000] Aperture pointing to e820 RAM. Ignoring.
> > [    0.000000] Your BIOS doesn't leave a aperture memory hole
> > [    0.000000] Please enable the IOMMU option in the BIOS setup
> > [    0.000000] This costs you 64 MB of RAM
> > [    0.000000]     memblock_x86_reserve_range: [0x80000000-0x83ffffff]       aperture64
> > [    0.000000] Mapping aperture over 65536 KB of RAM @ 80000000
> > [    0.000000]     memblock_x86_reserve_range: [0xacb6bdc0-0xacb6bddf]          BOOTMEM
> > 
> > will use different position...
> > 
> > [    4.250159] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
> > [    4.258830] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
> > [    4.266742] [drm] Detected VRAM RAM=320M, BAR=256M
> > [    4.271549] [drm] RAM width 32bits DDR
> > [    4.275435] [TTM] Zone  kernel: Available graphics memory: 1896526 kiB.
> > [    4.282066] [TTM] Initializing pool allocator.
> > [    4.282085] usb 7-2: new full speed USB device number 2 using ohci_hcd
> > [    4.293076] [drm] radeon: 320M of VRAM memory ready
> > [    4.298277] [drm] radeon: 512M of GTT memory ready.
> > [    4.303218] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> > [    4.309854] [drm] Driver supports precise vblank timestamp query.
> > [    4.315970] [drm] radeon: irq initialized.
> > [    4.320094] [drm] GART: num cpu pages 131072, num gpu pages 131072
> > 
> > So question is why radeon is using the address [0xa0000000 - 0xc000000], and in E820 it is RAM ....
> > 
> > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000acb8d000 (usable)
> > [    0.000000]  BIOS-e820: 00000000acb8d000 - 00000000acb8f000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000acb8f000 - 00000000afce9000 (usable)
> > [    0.000000]  BIOS-e820: 00000000afce9000 - 00000000afd21000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000afd21000 - 00000000afd4f000 (usable)
> > [    0.000000]  BIOS-e820: 00000000afd4f000 - 00000000afdcf000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000afdcf000 - 00000000afecf000 (ACPI NVS)
> > [    0.000000]  BIOS-e820: 00000000afecf000 - 00000000afeff000 (ACPI data)
> > [    0.000000]  BIOS-e820: 00000000afeff000 - 00000000aff00000 (usable)
> > 
> > so looks bios program wrong address to the radon card?
> > 
> 
> Okay, staring at this, it definitely seems toxic to overlay the GART
> over memory areas reserved by the BIOS.  If I were to guess, I would say
> that the problem here seems to be that the kernel thinks it is
> overlaying 64 MiB of memory, but the actual GART is in fact 512 MiB in
> size -- 131072 CPU pages -- which now overlaps the BIOS reserved areas.
> 
> Alex D., could you comment on the "num cpu pages" bit?

These are not CPU addresses. I think we've stated that already. Not the
droids.

the num cpu pages is how many CPU pages would be needed to fill the GPU
GTT, for those crazy cases where CPU pagesize != GPU pagesize.

Dave.


