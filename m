Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1DMUuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:50:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31543 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1DMUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:50:24 -0400
Message-ID: <4DA60C30.4060606@kernel.org>
Date: Wed, 13 Apr 2011 13:48:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org>
In-Reply-To: <20110413193459.GL19819@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DA60C75.0065,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 12:34 PM, Joerg Roedel wrote:
> On Wed, Apr 13, 2011 at 12:14:55PM -0700, Yinghai Lu wrote:
>> thanks for the bisecting...
>>
>> so those two patches uncover some problems.
>>
>> [    0.000000] Checking aperture...
>> [    0.000000] No AGP bridge found
>> [    0.000000] Node 0: aperture @ a0000000 size 32 MB
>> [    0.000000] Aperture pointing to e820 RAM. Ignoring.
>> [    0.000000] Your BIOS doesn't leave a aperture memory hole
>> [    0.000000] Please enable the IOMMU option in the BIOS setup
>> [    0.000000] This costs you 64 MB of RAM
>> [    0.000000]     memblock_x86_reserve_range: [0xa0000000-0xa3ffffff]       aperture64
>> [    0.000000] Mapping aperture over 65536 KB of RAM @ a0000000
>>
>> so kernel try to reallocate apperture. because BIOS allocated is pointed to RAM or size is too small.
> 
> It is actually beyond 4GB on that machine, this value read here is from
> the previous kernel-boot. The BIOS does not reset these values on a
> reboot.
> 
>> but your radeon does use [0xa0000000, 0xbfffffff)
> 
> Yes, I suspected that too (and spent a few hours reading radeon code),
> but then I talked the Alex Deucher and he explained that these addresses
> which the driver prints for GTT and VRAM are in the GPU address space
> and do not refer to system ram. So this shouldn't be the problem.


can you try following change ? it will push gart to 0x80000000

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 86d1ad4..3b6a9d5 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -83,7 +83,7 @@ static u32 __init allocate_aperture(void)
 	 * so don't use 512M below as gart iommu, leave the space for kernel
 	 * code for safe
 	 */
-	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
+	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
 	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
