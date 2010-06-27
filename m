Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0F0XOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 19:14:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53061 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0F0XOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 19:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p8WyLEoO5kpd6ff/n0LBOzRHCZc6Z5k459HL55Cue/r7cCBe7Wh4rZ8mvVIXWjFSQr
         S6++uLbrtsONJFJUb25rrGnTT5ngvy8MflKt+nBvC91CRnF8XP5nzP4fTOAvWVtBpGdE
         uBQPAm4BpseRKH+h0gdHFHuu3NU7/Lwh1Iw1c=
MIME-Version: 1.0
In-Reply-To: <4C272C1C.9000802@orcon.net.nz>
References: <20100622145805R.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTilMfDfy7BPiuAh9u-tR3kw1Vt_SebMziLUtLM6S@mail.gmail.com>
	<4C232AAC.2010200@orcon.net.nz>
	<20100627131836T.fujita.tomonori@lab.ntt.co.jp>
	<4C272C1C.9000802@orcon.net.nz>
Date: Mon, 28 Jun 2010 09:14:29 +1000
Message-ID: <AANLkTinrscp_Vqh69dbH5t5yqNiR4Mgl7T2JRrmWwI4a@mail.gmail.com>
Subject: Re: Problems with alpha/pci + radeon/ttm
From: Dave Airlie <airlied@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mattst88@gmail.com,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       rth@twiddle.net, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       alexdeucher@gmail.com, jglisse@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 8:46 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> On 27/06/10 16:20, FUJITA Tomonori wrote:
>>
>> On Thu, 24 Jun 2010 21:51:40 +1200
>> Michael Cree<mcree@orcon.net.nz>  wrote:
>>
>>>>> Is this a regression (what kernel version worked)?
>>>>>
>>>>> Seems that the IOMMU can't find 128 pages. It's likely due to:
>>>>>
>>>>> - out of the IOMMU space (possibly someone doesn't free the IOMMU
>>>>>   space).
>>>>>
>>>>> or
>>>>>
>>>>> - the mapping parameters (such as align) aren't appropriate so the
>>>>>   IOMMU can't find space.
>>>>
>>>> I don't think KMS drivers have ever worked on alpha so its not a
>>>> regression, they are working fine on x86 + powerpc and sparc has been
>>>> run at least once.
>>>
>>> KMS on the console boot up has worked since about 2.6.32, but starting
>>> up the X server has always failed and, in my case, the system becomes
>>> unstable and eventually OOPs.
>>>
>>>> I suspect we are simply hitting the limits of the iommu, how big an
>>>> address space does it handle? since generally graphics drivers try to
>>>> bind a lot of things to the GART.
>>>
>>> No idea on the address space limit.  I applied the patch of Fujita that
>>> logs all IOMMU allocations, and also inserted some extra printks in the
>>> ttm kernel code so that I could see which routines failed and the error
>>> code returned.  Running the radeon test on boot exhibits the following:
>>>
>>> [  238.712768] [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset
>>> 0x1a312000
>>> [  239.281127] [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset
>>> 0x1a412000
>>> [  239.281127] ttm_tt_bind belched -12
>>> [  239.282104] ttm_bo_handle_move_mem belched -12
>>> [  239.282104] ttm_bo_move_buffer belched -12
>>> [  239.282104] ttm_bo_validate belched -12
>>> [  239.282104] radeon 0000:01:00.0: object_init failed for (1048576,
>>> 0x00000002) err=-12
>>> [  239.282104] [drm:radeon_test_moves] *ERROR* Failed to create GTT
>>> object 419
>>> [  239.399291] Error while testing BO move.
>>>
>>> Note that no IOMMU allocations are printed while radeon_test_moves is
>>> running so iommu_arena_alloc doesn't appear to be called.  Also the
>>> error code returned up to radeon_test_moves is -12 which is ENOMEM.  So
>>> does appear to be some memory limit.
>>
>> Hmm, not related with IOMMU? looks like ttm_tt_populate could return
>> ENOMEM too. Can we locate where we hit ENOMEM first?
>
> Yeah, in ttm_mem_global_reserve while it is walking glob->zones:
>
> [  239.303588] [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset
> 0x1a412000
> [  239.304564] ttm_mem_global_reserve zone used_mem (0x1a5f0000) exceeds
> limit (0x1a5ef000)
> [  239.304564] ttm_mem_global_reserve zone used_mem (0x1a5f0000) exceeds
> limit (0x1a5ef000)
> [  239.304564] ttm_mem_global_reserve zone used_mem (0x1a5f0000) exceeds
> limit (0x1a5ef000)
> [  239.304564] ttm_mem_global_reserve zone used_mem (0x1a5f0000) exceeds
> limit (0x1a5ef000)
> [  239.304564] ttm_mem_global_reserve zone used_mem (0x1a5f0000) exceeds
> limit (0x1a5ef000)
> [  239.304564] ttm_mem_global_reserve return non-zero count decs to zero
> [  239.304564] ttm_mem_global_alloc_page belched -12
> [  239.304564] __ttm_tt_get_page coughed NULL
> [  239.304564] ttm_tt_populate belched -12
> [  239.304564] ttm_tt_bind belched -12
> [  239.304564] ttm_bo_handle_move_mem belched -12
> [  239.304564] ttm_bo_move_buffer belched -12
> [  239.304564] ttm_bo_validate belched -12
>
> On a hunch that we are chasing a red herring I installed another 256MB of
> memory into the machine (was 576MB for the test reported above) for a total
> of 832MB.
>
> Now radeon_test_moves runs to completion without error.
>
> OK, now a test of starting up the X server - ah, a bus error again but now
> it looks like it's in the radeon driver:
>
> [  1435.014] (II) EXA(0): Driver allocated offscreen pixmaps
> [  1435.014] (II) EXA(0): Driver registered support for the following
> operations:
> [  1435.014] (II)         Solid
> [  1435.014] (II)         Copy
> [  1435.014] (II)         Composite (RENDER acceleration)
> [  1435.014] (II)         UploadToScreen
> [  1435.014] (II)         DownloadFromScreen
> [  1435.030]
> Backtrace:
> [  1435.032] 0: /opt/xorg-ev56/bin/X (xorg_backtrace+0x54) [0x120070884]
> [  1435.032] 1: /opt/xorg-ev56/bin/X (0x120000000+0x65608) [0x120065608]
> [  1435.033] 2: /lib/libc.so.6.1 (0x20000310000+0x3d610) [0x2000034d610]
> [  1435.034] 3: /opt/xorg-ev56/lib/xorg/modules/drivers/radeon_drv.so
> (0x20000758000+0x15b890) [0x200008b3890]
> [  1435.034] 4: /opt/xorg-ev56/lib/xorg/modules/drivers/radeon_drv.so
> (0x20000758000+0x1392a0) [0x200008912a0]
> [  1435.034] 5: /opt/xorg-ev56/lib/xorg/modules/drivers/radeon_drv.so
> (0x20000758000+0x139bec) [0x20000891bec]
> [  1435.034] 6: /opt/xorg-ev56/lib/xorg/modules/drivers/radeon_drv.so
> (0x20000758000+0x4f088) [0x200007a7088]
> [  1435.035] 7: /opt/xorg-ev56/lib/xorg/modules/drivers/radeon_drv.so
> (0x20000758000+0x16f0f8) [0x200008c70f8]
> [  1435.035] 8: /opt/xorg-ev56/bin/X (AddScreen+0x1c0) [0x1200532b0]
> [  1435.036] 9: /opt/xorg-ev56/bin/X (InitOutput+0x29c) [0x12008c6ec]
> [  1435.036] 10: /opt/xorg-ev56/bin/X (0x120000000+0x24b48) [0x120024b48]
> [  1435.037] 11: /lib/libc.so.6.1 (__libc_start_main+0xec) [0x2000033267c]
> [  1435.037] 12: /opt/xorg-ev56/bin/X (__start+0x38) [0x120024788]
> [  1435.038] Bus error at address 0x20000030000
>
> And nothing in dmesg.  Now I'm not triggering the nasty page alloc errors.

The bus error is caused by the kernel, its something alpha specific
with how mmap works,
I'm not sure if alpha needs some special mmap flags or something,

Dave.
