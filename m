Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2FTSfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:35:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2FTSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:51 -0400
Message-Id: <20120620173024.099461098@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 37/61] usb: musb_gadget: fix crash caused by dangling pointer
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit 08f75bf14fadaa81fe362d5acda9b77b113dd0a2 upstream.

usb_ep_ops.disable must clear external copy of the endpoint descriptor,
otherwise musb crashes after loading/unloading several gadget modules
in a row:

Unable to handle kernel paging request at virtual address bf013730
pgd = c0004000
[bf013730] *pgd=8f26d811, *pte=00000000, *ppte=00000000
Internal error: Oops: 7 [#1]
Modules linked in: g_cdc [last unloaded: g_file_storage]
CPU: 0    Not tainted  (3.2.17 #647)
PC is at musb_gadget_enable+0x4c/0x24c
LR is at _raw_spin_lock_irqsave+0x4c/0x58
[<c027c030>] (musb_gadget_enable+0x4c/0x24c) from [<bf01b760>] (gether_connect+0x3c/0x19c [g_cdc])
[<bf01b760>] (gether_connect+0x3c/0x19c [g_cdc]) from [<bf01ba1c>] (ecm_set_alt+0x15c/0x180 [g_cdc])
[<bf01ba1c>] (ecm_set_alt+0x15c/0x180 [g_cdc]) from [<bf01ecd4>] (composite_setup+0x85c/0xac4 [g_cdc])
[<bf01ecd4>] (composite_setup+0x85c/0xac4 [g_cdc]) from [<c027b744>] (musb_g_ep0_irq+0x844/0x924)
[<c027b744>] (musb_g_ep0_irq+0x844/0x924) from [<c027a97c>] (musb_interrupt+0x79c/0x864)
[<c027a97c>] (musb_interrupt+0x79c/0x864) from [<c027aaa8>] (generic_interrupt+0x64/0x7c)
[<c027aaa8>] (generic_interrupt+0x64/0x7c) from [<c00797cc>] (handle_irq_event_percpu+0x28/0x178)
...

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1232,6 +1232,7 @@ static int musb_gadget_disable(struct us
 	}
 
 	musb_ep->desc = NULL;
+	musb_ep->end_point.desc = NULL;
 
 	/* abort all pending DMA and requests */
 	nuke(musb_ep, -ESHUTDOWN);


