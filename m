Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2F1Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:55:59 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:23997 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab2F1Qz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:55:58 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2012 12:55:58 EDT
X-Loopcount0: from 10.170.28.39
From: <Srinivas_G_Gowda@Dell.com>
To: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Thu, 28 Jun 2012 09:45:28 -0700
Subject: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Topic: [PATCH 1/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Index: Ac1VTXpsfWKE7MhDQvyYCZzyqN6iWw==
Message-ID: <4FEC8A28.4070806@dell.com>
References: <4FEC8931.5020001@dell.com>
In-Reply-To: <4FEC8931.5020001@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
x-forwarded-message-id: <4FEC8931.5020001@dell.com>
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


functions that will send the Set System Info command
and its corresponding handler

Signed-off-by: Srinivas Gowda G <Srinivas_G_Gowda@Dell.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |   73 +++++++++++++++++++++++++++++++++++
 include/linux/ipmi_msgdefs.h        |    1 +
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index d0abb3a..b1a98b5 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2709,6 +2709,79 @@ get_guid(ipmi_smi_t intf)
 	intf->null_user_handler = NULL;
 }
 
+static int 
+send_set_os_name_cmd(ipmi_smi_t intf)
+{
+	unsigned char param_select;
+	unsigned char set_selector;
+	unsigned char string_encode;
+	unsigned char str_len;
+	unsigned char data[9];
+
+	struct kernel_ipmi_msg            msg;
+	struct ipmi_system_interface_addr si;
+
+	si.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	si.channel = IPMI_BMC_CHANNEL;
+	si.lun = 0;
+	
+	param_select  = 4;	/* parameter number for volatile OS name */
+	set_selector  = 0;	/* set selector, block 0 */
+	string_encode = 0;	/* ASCII Encoding */
+	str_len = 5;		/* length of ASCII string - "Linux" */
+	
+	data[0] = param_select;
+	data[1] = set_selector;
+	data[2] = string_encode;
+	data[3] = str_len;
+	data[4] = 'L';
+	data[5] = 'i';
+	data[6] = 'n';
+	data[7] = 'u';
+	data[8] = 'x';
+
+	msg.netfn = IPMI_NETFN_APP_REQUEST;
+	msg.cmd = IPMI_SET_SYSTEM_INFO;
+	msg.data = data;
+	msg.data_len = 9;
+	return i_ipmi_request(NULL,
+			      intf,
+			      (struct ipmi_addr *) &si,
+			      0,
+			      &msg,
+			      intf,
+			      NULL,
+			      NULL,
+			      0,
+			      intf->channels[0].address,
+			      intf->channels[0].lun,
+			      -1, 0);
+}
+
+/*
+ * msg handler for Set_System_Info cmd - set OS name 
+ */
+static void
+set_os_name_handler(ipmi_smi_t intf, struct ipmi_recv_msg *msg)
+{
+	if ((msg->addr.addr_type != IPMI_SYSTEM_INTERFACE_ADDR_TYPE)
+	    || (msg->msg.netfn != IPMI_NETFN_APP_RESPONSE)
+	    || (msg->msg.cmd != IPMI_SET_SYSTEM_INFO))
+		/* Not for me */
+		return;
+
+	if (msg->msg.data[0] != 0) 
+		/* Error  setting OS name as Linux in BMC. */
+		printk(KERN_WARNING PFX 
+			"Failed to set OS name as Linux: 0x%X\n", msg->msg.data[0]);
+	else
+		printk(KERN_INFO PFX 
+			"OS Name successfully set as Linux\n");		
+
+	os_name_set = 1;
+	wake_up(&intf->waitq);
+}
+
 /*
  *   Set the Operating System Name as "Linux" in BMC 
  *   using "Set System Info" command.
diff --git a/include/linux/ipmi_msgdefs.h b/include/linux/ipmi_msgdefs.h
index df97e6e..b5ea664 100644
--- a/include/linux/ipmi_msgdefs.h
+++ b/include/linux/ipmi_msgdefs.h
@@ -57,6 +57,7 @@
 #define IPMI_GET_BMC_GLOBAL_ENABLES_CMD	0x2f
 #define IPMI_READ_EVENT_MSG_BUFFER_CMD	0x35
 #define IPMI_GET_CHANNEL_INFO_CMD	0x42
+#define IPMI_SET_SYSTEM_INFO		0x58
 
 /* Bit for BMC global enables. */
 #define IPMI_BMC_RCV_MSG_INTR     0x01
-- 
1.7.1


Thanks,
G