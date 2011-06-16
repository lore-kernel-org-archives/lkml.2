Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab1FPNdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:33:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab1FPNcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:32:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="98075651"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RFC 3/5] usb:g_zero: bulk in/out unittest support
Date: Thu, 16 Jun 2011 16:31:05 +0300
Message-Id: <1308231068-24038-4-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a new vendor specific request to be handled by the
g_zero module in it's sourcesink configuration. The purpose if this
request is to update the length of the BULK transfer to a given value.
The bRequest value of the new control request is 0x5e.
It is used by the user-space Unit testing application for bulk in/out
tests.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/f_sourcesink.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index caf2f95..d417b8a 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -70,6 +70,7 @@ static unsigned pattern;
 module_param(pattern, uint, 0);
 MODULE_PARM_DESC(pattern, "0 = all zeroes, 1 = mod63 ");
 
+static struct f_sourcesink	*the_sourcesink;
 /*-------------------------------------------------------------------------*/
 
 static struct usb_interface_descriptor source_sink_intf = {
@@ -197,6 +198,7 @@ static void
 sourcesink_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	kfree(func_to_ss(f));
+	the_sourcesink = NULL;
 }
 
 /* optionally require specific source/sink data patterns  */
@@ -425,6 +427,7 @@ static int __init sourcesink_bind_config(struct usb_configuration *c)
 	status = usb_add_function(c, &ss->function);
 	if (status)
 		kfree(ss);
+	the_sourcesink = ss;
 	return status;
 }
 
@@ -472,6 +475,15 @@ static int sourcesink_setup(struct usb_configuration *c,
 		value = w_length;
 		break;
 
+	case 0x5e:
+		/*
+		 * Change bulk ep buffer size. buflen is the length of
+		 * the BULK transfer (req->length=buflen). Defined in g_zero.h
+		 */
+		disable_source_sink(the_sourcesink);
+		buflen = w_value;
+		value = enable_source_sink(c->cdev, the_sourcesink);
+		break;
 	default:
 unknown:
 		VDBG(c->cdev,
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
