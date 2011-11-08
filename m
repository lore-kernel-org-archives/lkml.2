Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1KHQsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:48:51 -0500
Received: from server88-208-211-118.live-servers.net ([88.208.211.118]:12023
	"EHLO mail.redrat.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab1KHQst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:48:49 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 11:48:49 EST
From: Andrew Vincer <Andrew.Vincer@redrat.co.uk>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
        "jarod@redhat.com" <jarod@redhat.com>,
        "error27@gmail.com" <error27@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] rc: Fix input deadlock and transmit error in redrat3
 driver
Thread-Topic: [PATCH 1/1] rc: Fix input deadlock and transmit error in
 redrat3 driver
Thread-Index: AcyeNUn9TE6FU/UfSOO9Ye7Pt3kBHQ==
Date: Tue, 8 Nov 2011 16:43:45 +0000
Message-ID: <DA69C24DC634074E9591C2B60BFDBC1C730E13@CP5-3512.fh.redrat.co.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [86.163.49.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed submit urb logic so hardware doesn't hang trying to transmit
signal data

Removed unneeded enable/disable detector commands in
redrat3_transmit_ir (the hardware does this anyway) and converted
arguments to unsigned as per 5588dc2

Signed-off-by: Andrew Vincer <andrew@redrat.co.uk>
---
 drivers/media/rc/redrat3.c |   52 +++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 61287fc..9bff23c 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -286,12 +286,6 @@ static void redrat3_issue_async(struct redrat3_dev *rr3)
 
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
-	if (!rr3->det_enabled) {
-		dev_warn(rr3->dev, "not issuing async read, "
-			 "detector not enabled\n");
-		return;
-	}
-
 	memset(rr3->bulk_in_buf, 0, rr3->ep_in->wMaxPacketSize);
 	res = usb_submit_urb(rr3->read_urb, GFP_ATOMIC);
 	if (res)
@@ -827,6 +821,7 @@ out:
 static void redrat3_handle_async(struct urb *urb, struct pt_regs *regs)
 {
 	struct redrat3_dev *rr3;
+	int ret;
 
 	if (!urb)
 		return;
@@ -840,15 +835,13 @@ static void redrat3_handle_async(struct urb *urb, struct pt_regs *regs)
 
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
-	if (!rr3->det_enabled) {
-		rr3_dbg(rr3->dev, "received a read callback but detector "
-			"disabled - ignoring\n");
-		return;
-	}
-
 	switch (urb->status) {
 	case 0:
-		redrat3_get_ir_data(rr3, urb->actual_length);
+		ret = redrat3_get_ir_data(rr3, urb->actual_length);
+		if (!ret) {
+			/* no error, prepare to read more */
+			redrat3_issue_async(rr3);
+		}
 		break;
 
 	case -ECONNRESET:
@@ -865,11 +858,6 @@ static void redrat3_handle_async(struct urb *urb, struct pt_regs *regs)
 		rr3->pkttype = 0;
 		break;
 	}
-
-	if (!rr3->transmitting)
-		redrat3_issue_async(rr3);
-	else
-		rr3_dbg(rr3->dev, "IR transmit in progress\n");
 }
 
 static void redrat3_write_bulk_callback(struct urb *urb, struct pt_regs *regs)
@@ -896,21 +884,24 @@ static u16 mod_freq_to_val(unsigned int mod_freq)
 	return (u16)(65536 - (mult / mod_freq));
 }
 
-static int redrat3_set_tx_carrier(struct rc_dev *dev, u32 carrier)
+static int redrat3_set_tx_carrier(struct rc_dev *rcdev, u32 carrier)
 {
-	struct redrat3_dev *rr3 = dev->priv;
+	struct redrat3_dev *rr3 = rcdev->priv;
+	struct device *dev = rr3->dev;
 
+	rr3_dbg(dev, "Setting modulation frequency to %u", carrier);
 	rr3->carrier = carrier;
 
 	return carrier;
 }
 
-static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
+static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
+				unsigned count)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
 	struct redrat3_signal_header header;
-	int i, j, count, ret, ret_len, offset;
+	int i, j, ret, ret_len, offset;
 	int lencheck, cur_sample_len, pipe;
 	char *buffer = NULL, *sigdata = NULL;
 	int *sample_lens = NULL;
@@ -928,20 +919,13 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
 		return -EAGAIN;
 	}
 
-	count = n / sizeof(int);
 	if (count > (RR3_DRIVER_MAXLENS * 2))
 		return -EINVAL;
 
+	/* rr3 will disable rc detector on transmit */
+	rr3->det_enabled = false;
 	rr3->transmitting = true;
 
-	redrat3_disable_detector(rr3);
-
-	if (rr3->det_enabled) {
-		dev_err(dev, "%s: cannot tx while rx is enabled\n", __func__);
-		ret = -EIO;
-		goto out;
-	}
-
 	sample_lens = kzalloc(sizeof(int) * RR3_DRIVER_MAXLENS, GFP_KERNEL);
 	if (!sample_lens) {
 		ret = -ENOMEM;
@@ -1055,7 +1039,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
 	else
-		ret = n;
+		ret = count;
 
 out:
 	kfree(sample_lens);
@@ -1063,8 +1047,8 @@ out:
 	kfree(sigdata);
 
 	rr3->transmitting = false;
-
-	redrat3_enable_detector(rr3);
+	/* rr3 re-enables rc detector because it was enabled before */
+	rr3->det_enabled = true;
 
 	return ret;
 }
-- 
1.7.1
