Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab1L0U3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 15:29:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37786 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1L0U3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 15:29:34 -0500
Date: Tue, 27 Dec 2011 18:30:08 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andre Guedes <andre.guedes@openbossa.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [bluetooth] linux-3.x regression (bisected)
Message-ID: <20111227203008.GA13870@joana>
Mail-Followup-To: Rene Herman <rene.herman@gmail.com>,
	Andre Guedes <andre.guedes@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
References: <4EF3BACA.1080405@gmail.com>
 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
 <4EFA1EB8.9090005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFA1EB8.9090005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

* Rene Herman <rene.herman@gmail.com> [2011-12-27 20:38:32 +0100]:

> On 27-12-11 18:22, Andre Guedes wrote:
> 
> >Could you please send us the kernel log messages with Bluetooth debug
> >enabled? Here goes the instructions:
> >
> >1. Compile kernel with CONFIG_DYNAMIC_DEBUG=y.
> >2. Load Bluetooth module.
> >3. Run the following commands to turn debug on (remember to mount debugfs
> >first):
> >--
> >$ echo "file hci_core.c +pf">  /sys/kernel/debug/dynamic_debug/control
> >$ echo "file hci_event.c +pf">  /sys/kernel/debug/dynamic_debug/control
> >$ echo "file mgmt.c +pf">  /sys/kernel/debug/dynamic_debug/control
> >$ echo "file btusb.c +pf">  /sys/kernel/debug/dynamic_debug/control
> >--
> >4. Plug the Bluetooth adapter.
> 
> Thanks for the verbosity. Here's a -- full, just in case it's useful
> -- dmesg from vanilla 3.1.6 (i.e., when bluetooth does not work)
> generated per the above. The bluetooth bit is the last part.

snip

> 
> hci_le_init_req:hci0
> hci_send_cmd:hci0 opcode 0x2002 plen 0
> hci_send_cmd:skb len 3
> hci_cmd_task:hci0 cmd 1
> hci_send_frame:hci0 type 1 len 3
> btusb_send_frame:hci0
> btusb_tx_complete:hci0 urb e6900700 status 0 count 3
> Bluetooth: hci0 command tx timeout
> hci_cmd_task:hci0 cmd 1
> __hci_request:hci0 end: err -110

Seems your extfeatures is telling you something different from what it really
supports. Can you try with the following diff (use the dynamic debug that Andre
told you) 

Also the output of hcidump would nice.


diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 919e3c0..4c9f1aa 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -711,6 +711,8 @@ static void hci_cc_read_local_ext_features(struct hci_dev *hdev,
        if (rp->status)
                return;
 
+       BT_DBG("features 0x%2.2x", rp->features[0]);
+
        memcpy(hdev->extfeatures, rp->features, 8);
 
        hci_req_complete(hdev, HCI_OP_READ_LOCAL_EXT_FEATURES, rp->status);


	Gustavo
