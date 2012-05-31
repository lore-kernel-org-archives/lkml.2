Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2EaLEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:04:30 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:11440 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab2EaLE3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:04:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz14ffIzz1202hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
X-FB-SS: 0,
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "agraf@suse.de" <agraf@suse.de>
Subject: memblock_end_of_DRAM()  return end address + 1
Thread-Topic: memblock_end_of_DRAM()  return end address + 1
Thread-Index: Ac0/HQWP16L7u7IaTN6gp93aPjbXWA==
Date: Thu, 31 May 2012 11:03:35 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D03D5AAE2@039-SN2MPN1-022.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

memblock_end_of_DRAM() defined in mm/memblock.c returns base_address + size;
So this is not returning the end_of_DRAM, it is basically returning the end_of_DRAM + 1. The name looks to suggest that this returns end address on DRAM.

IIUC, it looks like that some code assumes this returns the end address while some assumes this returns end address + 1.

Example:
1. arch/powerpc/platforms/85xx/mpc85xx_ds.c


<cut>

#ifdef CONFIG_SWIOTLB
        if (memblock_end_of_DRAM() > max) {
                ppc_swiotlb_enable = 1;
                set_pci_dma_ops(&swiotlb_dma_ops);
                ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
        }
#endif

<cut>
<cut>


Where  max = 0xffffffff; So we assumes that memblock_end_of_DRAM() actually returns end address.

------
2.

In arch/powerpc/kernel/dma.c


static int dma_direct_dma_supported(struct device *dev, u64 mask)
{
#ifdef CONFIG_PPC64
        /* Could be improved so platforms can set the limit in case
         * they have limited DMA windows
         */
        return mask >= get_dma_offset(dev) + (memblock_end_of_DRAM() - 1);


<cut>

It looks to that here we assume base + addr + 1;

-----------


Thanks
-Bharat


