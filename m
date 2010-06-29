Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0F2ApG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:45:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:42513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0F2ApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,500,1272870000"; 
   d="scan'208";a="634444749"
Message-ID: <4C29420D.2010406@intel.com>
Date: Mon, 28 Jun 2010 17:45:01 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
In-Reply-To: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000609090107090901000308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000609090107090901000308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/2010 4:50 PM, Chris Li wrote:
> Hi Dan,
>
> My Mac Pro hit this BUG every time it try to load module ioatdma.
>
> This was first discover in FC 12&  13 kernel. See redhat bug 605845.
> https://bugzilla.redhat.com/show_bug.cgi?id=605845. I attach a picture
> of the kernel panic on the bug.
>
> The current git tree has it as well. The bug line number change a
> little bit though.
>
>
> 		/* when halted due to errors check for channel
> 		 * programming errors before advancing the completion state
> 		 */
> 		if (is_ioat_halted(status)) {
> 			u32 chanerr;
>
> 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
> 			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
> 				__func__, chanerr);
> 			BUG_ON(is_ioat_bug(chanerr));<---------------------------------
> 		}
>
> The machine is a Mac Pro. The bug is reproducible 100%. Black list the
> ioatdma module and the kernel boot just fine.
>
> Any suggestion? I am not afraid to try out patches.
>

Looks like that dev_err() did not make it to the console.  The attached 
patch should get us some more debug information.  This will stop the 
driver from making forward progress (applies to current -git).  I 
suspect this may be triggering from the driver self test, but to be safe 
you should set CONFIG_NET_DMA=n and CONFIG_ASYNC_TX_DMA=n.

--
Dan


--------------000609090107090901000308
Content-Type: text/plain;
 name="debug-ioat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debug-ioat.patch"

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 3c8b32a..89bff46 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -285,9 +285,9 @@ void ioat2_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
-			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
-				__func__, chanerr);
-			BUG_ON(is_ioat_bug(chanerr));
+			WARN_ONCE(is_ioat_bug(chanerr), "%s: %s: Channel halted (%x)\n",
+                             dev_name(to_dev(chan)), __func__, chanerr);
+			return;
 		}
 
 		/* if we haven't made progress and we have already

--------------000609090107090901000308--
