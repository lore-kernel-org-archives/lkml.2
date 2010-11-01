Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0KANwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:52:34 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:46331
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235Ab0KANwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:52:31 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2cK146fK1432N98dNzz1202hzz15d4Rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp02.amd.com;RD:ausb3extmailp02.amd.com;EFVD:NLI
X-WSS-ID: 0LB7L73-01-NJ0-02
X-M-MSG: 
Date: Mon, 1 Nov 2010 14:53:22 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Jan Kiszka <jan.kiszka@web.de>
CC: kvm <kvm@vger.kernel.org>, Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
Message-ID: <20101101135322.GG20959@amd.com>
References: <4CCEB7CF.8030207@web.de>
 <4CCEB946.7070103@web.de>
 <20101101132127.GF20959@amd.com>
 <4CCEBFAC.1000809@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CCEBFAC.1000809@web.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 09:25:00AM -0400, Jan Kiszka wrote:
> Am 01.11.2010 14:21, Roedel, Joerg wrote:
> > The registers rax and rbx contain non-canonical addresses (if
> > interpreted as pointers). The instruction where this happens is a mov so
> > I guess that the #GP is because of an non-canonical address.
> > Can you find out the code-line where this happens and the exact
> > assembler instruction? (haven't managed to decode the registers used).
> 
> In pfn_to_dma_pte, line 710:
> 
>                 if (!dma_pte_present(pte)) {
> ffffffff8121de8c:       f6 03 03                testb  $0x3,(%rbx)
> ffffffff8121de8f:       0f 85 d8 00 00 00       jne    ffffffff8121df6d <pfn_to_dma_pte+0x154>
> 
> The first instruction raises the fault.

Ok, so it seems that my understanding of the Code: field in the
crash-message was wrong :)
Anyway, the testb uses rbx as an address which has a non-canonical
value. This means the the address of 'pte' is invalid. Since rax also
contains a wrong address the 'parent' variable probably already contains
the wrong address. Does the attached patch help?

diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 5619f85..ca46f24 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -6,7 +6,7 @@
  */
 #define VTD_PAGE_SHIFT		(12)
 #define VTD_PAGE_SIZE		(1UL << VTD_PAGE_SHIFT)
-#define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
+#define VTD_PAGE_MASK		((((u64)-1) << VTD_PAGE_SHIFT) & ((1ULL << 52) - 1))
 #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_MASK)
 
 #define DMA_PTE_READ (1)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

