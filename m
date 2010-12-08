Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0LHXzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:55:37 -0500
Received: from web31816.mail.mud.yahoo.com ([68.142.206.169]:33627 "HELO
	web31816.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754208Ab0LHXzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:55:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=rGQqT09P7dRWfD5x858howjc+G4LiNVOj/NoBZBGAzAUCpsBaIjriEVAvIMxRRPz38xmTn+pygG/7zAggtG5EwxOvE4ldcB1JPwkCEAYYVmiqMuWRUDQGHnCEkxiNuu2a5gNlqnderYJavzn4TRbxMmDE6bKy6SlDI5Lgy3Utr8=;
Message-ID: <531583.43961.qm@web31816.mail.mud.yahoo.com>
X-YMail-OSG: 88pUJ68VM1lx.sN9Fd63ykPhiZFOlj4WsQLR3_ppwPXiq4l
 6ftSAIvS6xZheDXSaWLrMuWgw00Nd.J_yTzPzmUuo08K6BkBPxxbRhAOUTlp
 pL2ujXw43whjekknVUD5NQHTC9iZLvjlC9xIus_G8nf.ZQzeHEstKUnh1Qzo
 UlL3phAlIA1vHgBSB1yI4Vp.vcWTmOY2JkPtR1IuRVZBK3B2Gh0rM6k77l_p
 SN.KrpF9.RkRJuwyRFUsMJBUuGnDTUkcoAHaEXyPPadHkSVezbgd76.EKKWI
 sZJ69oJvrl4UQjFyQzf1khYO8qUg9rQDhu9gYIMqrEu9YRuxIV1OO3JNfkMh
 N3_r1sbPlCg5pu6xx3g--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 15:55:27 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 The long story is that we see some host controllers misreport their
 PSA as they solved 2^v = streams, instead of 2^(v+1) = streams. Thus
 They report that they support 32 streams when in fact they support 16.
 When the device attempts to return status for stream > 15, the host
 says ACK(NumP=0), the device goes in flow control, blah, blah, this
 module parameter allows you to set a max cap on the number of streams
 the driver will ask XHCI HCD to allocate.
 drivers/usb/storage/uasp.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/uasp.c b/drivers/usb/storage/uasp.c
index 3b10efd..e5a26e9 100644
--- a/drivers/usb/storage/uasp.c
+++ b/drivers/usb/storage/uasp.c
@@ -30,6 +30,19 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
+int MaxNumStreams = -1;
+
+module_param(MaxNumStreams, int, 0444);
+MODULE_PARM_DESC(MaxNumStreams, "\n"
+	"\tSome host controllers and/or devices report a larger number of\n"
+	"\tstreams that they in fact support. This parameter allows you\n"
+	"\tto limit the number of streams this driver will request the XHCI\n"
+	"\tHCD to allocate. If set to -1, the default value, then this driver\n"
+	"\twill use the value reported by the attached device. Else the\n"
+	"\tnumber of streams will be limited to the minimum reported by the\n"
+	"\tattached device and this value. Valid values are -1, default,\n"
+	"\tand 1 to 0xFFEF.");
+
 /* Information unit types
  */
 #define IU_CMD   1
@@ -938,6 +951,8 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
 					 tpinfo->eps[3]->desc.bEndpointAddress);
 
 	if (udev->speed == USB_SPEED_SUPER) {
+		int max_streams;
+
 		for (i = 1; i < 4; i++) {
 			if (tpinfo->max_streams == 0)
 				tpinfo->max_streams = USB_SS_MAX_STREAMS(tpinfo->eps[i]->ss_ep_comp.bmAttributes);
@@ -952,9 +967,13 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
 		}
 		
 		tpinfo->use_streams = 1;
+		if (1 <= MaxNumStreams && MaxNumStreams <= 0xFFEF)
+			max_streams = min(MaxNumStreams, tpinfo->max_streams);
+		else
+			max_streams = tpinfo->max_streams;
 		tpinfo->num_streams = usb_alloc_streams(iface,
 							&tpinfo->eps[1], 3,
-							tpinfo->max_streams,
+							max_streams,
 							GFP_KERNEL);
 		if (tpinfo->num_streams <= 0) {
 			dev_err(&udev->dev,
-- 
1.7.0.1


