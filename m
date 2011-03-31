Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1CaFPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:15:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40536 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1CaFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:15:21 -0400
Message-ID: <4D940DD0.7000704@kernel.org>
Date: Wed, 30 Mar 2011 22:14:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Michael Leun <lkml20101129@newton.leun.net>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net>
In-Reply-To: <20110330203215.0a1a41a7@xenia.leun.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D940DE2.0102,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 11:32 AM, Michael Leun wrote:
> Hi,
>
> suspend to disk works with 2.6.38.1 but does not with 2.6.38.2 on my
> acer 1825ptz. Machine freezes after resume.
>
> git bisect yields:
>
> ml@jill:/usr/src/kernel/b/linux-2.6.38.y>  git bisect bad
> ff518ea26654e05d325d996f6e3a7f5f569cc2d5 is the first bad commit
> commit ff518ea26654e05d325d996f6e3a7f5f569cc2d5
> Author: Yinghai Lu<yinghai@kernel.org>
> Date:   Fri Feb 18 11:30:30 2011 +0000
>
>      x86: Cleanup highmap after brk is concluded
>
>      commit e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e upstream.
>
>      Now cleanup_highmap actually is in two steps: one is early in head64.c
>      and only clears above _end; a second one is in init_memory_mapping() and
>      tries to clean from _brk_end to _end.
>      It should check if those boundaries are PMD_SIZE aligned but currently
>      does not.
>      Also init_memory_mapping() is called several times for numa or memory
>      hotplug, so we really should not handle initial kernel mappings there.
>
>      This patch moves cleanup_highmap() down after _brk_end is settled so
>      we can do everything in one step.
>      Also we honor max_pfn_mapped in the implementation of cleanup_highmap.
>
>      Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>      Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
>      LKML-Reference:<alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
>      Signed-off-by: H. Peter Anvin<hpa@zytor.com>
>      Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> :040000 040000 b5ed0c2971ba1162c7cd289dd351d1700eb52fbc 8f830fdb43fa30ddebb485e6f6455d669300874b M      arch
>

can you please try following partial reverting patch?

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7942335..07688d1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -302,11 +302,11 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  void __init cleanup_highmap(void)
  {
  	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
  	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
  	pmd_t *pmd = level2_kernel_pgt;
+	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
  
-	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
+	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
  		if (pmd_none(*pmd))
  			continue;
  		if (vaddr < (unsigned long) _text || vaddr > end)
