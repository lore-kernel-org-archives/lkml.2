Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0F0EVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 00:21:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:36942 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0F0EVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 00:21:22 -0400
Date: Sun, 27 Jun 2010 13:20:50 +0900
To: mcree@orcon.net.nz
Cc: airlied@gmail.com, fujita.tomonori@lab.ntt.co.jp, mattst88@gmail.com,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       rth@twiddle.net, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C232AAC.2010200@orcon.net.nz>
References: <20100622145805R.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTilMfDfy7BPiuAh9u-tR3kw1Vt_SebMziLUtLM6S@mail.gmail.com>
	<4C232AAC.2010200@orcon.net.nz>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100627131836T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 13:20:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 21:51:40 +1200
Michael Cree <mcree@orcon.net.nz> wrote:

> >> Is this a regression (what kernel version worked)?
> >>
> >> Seems that the IOMMU can't find 128 pages. It's likely due to:
> >>
> >> - out of the IOMMU space (possibly someone doesn't free the IOMMU
> >>   space).
> >>
> >> or
> >>
> >> - the mapping parameters (such as align) aren't appropriate so the
> >>   IOMMU can't find space.
> >
> > I don't think KMS drivers have ever worked on alpha so its not a
> > regression, they are working fine on x86 + powerpc and sparc has been
> > run at least once.
> 
> KMS on the console boot up has worked since about 2.6.32, but starting 
> up the X server has always failed and, in my case, the system becomes 
> unstable and eventually OOPs.
> 
> > I suspect we are simply hitting the limits of the iommu, how big an
> > address space does it handle? since generally graphics drivers try to
> > bind a lot of things to the GART.
> 
> No idea on the address space limit.  I applied the patch of Fujita that 
> logs all IOMMU allocations, and also inserted some extra printks in the 
> ttm kernel code so that I could see which routines failed and the error 
> code returned.  Running the radeon test on boot exhibits the following:
> 
> [  238.712768] [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 
> 0x1a312000
> [  239.281127] [drm] Tested GTT->VRAM and VRAM->GTT copy for GTT offset 
> 0x1a412000
> [  239.281127] ttm_tt_bind belched -12
> [  239.282104] ttm_bo_handle_move_mem belched -12
> [  239.282104] ttm_bo_move_buffer belched -12
> [  239.282104] ttm_bo_validate belched -12
> [  239.282104] radeon 0000:01:00.0: object_init failed for (1048576, 
> 0x00000002) err=-12
> [  239.282104] [drm:radeon_test_moves] *ERROR* Failed to create GTT 
> object 419
> [  239.399291] Error while testing BO move.
> 
> Note that no IOMMU allocations are printed while radeon_test_moves is 
> running so iommu_arena_alloc doesn't appear to be called.  Also the 
> error code returned up to radeon_test_moves is -12 which is ENOMEM.  So 
> does appear to be some memory limit.

Hmm, not related with IOMMU? looks like ttm_tt_populate could return
ENOMEM too. Can we locate where we hit ENOMEM first?
