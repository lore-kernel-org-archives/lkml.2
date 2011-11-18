Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1KRJ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:59:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:30371 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1KRJ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:59:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,532,1315206000"; 
   d="scan'208";a="92350658"
Date: Fri, 18 Nov 2011 11:58:58 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 17 (bluetooth)
Message-ID: <20111118095855.GB9034@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-bluetooth@vger.kernel.org
References: <20111117150733.a70faf2c9030d511d5367e1e@canb.auug.org.au>
 <4EC5496F.2080509@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC5496F.2080509@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Thu, Nov 17, 2011 at 09:50:39AM -0800, Randy Dunlap wrote:
> On 11/16/2011 08:07 PM, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> When CONFIG_BT_L2CAP is not enabled:
> 
> net/built-in.o: In function `hci_dev_open':
> (.text+0xdce9a): undefined reference to `enable_hs'

Despite not enabling L2CAP sounds strange we might find solution even for
this usage :-)
I am thinking about moving enable_hs to common part not depending on
CONFIG_BT_L2CAP option:

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cfd399f..ed0a656 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -54,6 +54,8 @@
 
 #define AUTO_OFF_TIMEOUT 2000
 
+int enable_hs;
+
 static void hci_cmd_task(unsigned long arg);
 static void hci_rx_task(unsigned long arg);
 static void hci_tx_task(unsigned long arg);
@@ -2691,3 +2693,6 @@ int hci_cancel_inquiry(struct hci_dev *hdev)
 
        return hci_send_cmd(hdev, HCI_OP_INQUIRY_CANCEL, 0, NULL);
 }
+
+module_param(enable_hs, bool, 0644);
+MODULE_PARM_DESC(enable_hs, "Enable High Speed");
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e49b6e5..f36bc3f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -58,7 +58,6 @@
 #include <net/bluetooth/a2mp.h>
 
 int disable_ertm;
-int enable_hs;
 
 static u32 l2cap_feat_mask = L2CAP_FEAT_FIXED_CHAN;
 static u8 l2cap_fixed_chan[8] = { L2CAP_FC_L2CAP, };
@@ -4811,6 +4810,3 @@ void l2cap_exit(void)
 
 module_param(disable_ertm, bool, 0644);
 MODULE_PARM_DESC(disable_ertm, "Disable enhanced retransmission mode");
-
-module_param(enable_hs, bool, 0644);
-MODULE_PARM_DESC(enable_hs, "Enable High Speed");


Best regards 
Andrei Emeltchenko 
