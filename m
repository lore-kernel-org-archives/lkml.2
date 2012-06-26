Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2FZN0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:26:08 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:57479 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab2FZN0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:26:07 -0400
X-Loopcount0: from 10.170.28.39
From: <Srinivas_G_Gowda@Dell.com>
To: <linux-kernel@vger.kernel.org>, <minyard@acm.org>, <openipmi@mvista.com>
Date: Tue, 26 Jun 2012 18:54:55 +0530
Subject: [PATCH] ipmi: setting OS name as Linux in BMC
Thread-Topic: [PATCH] ipmi: setting OS name as Linux in BMC
Thread-Index: Ac1Tnx8GNguCiax+RDOG7F/bRP8u7A==
Message-ID: <4FE9B827.80300@dell.com>
References: <4FE9A3EB.50505@dell.com>
In-Reply-To: <4FE9A3EB.50505@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
x-forwarded-message-id: <4FE9A3EB.50505@dell.com>
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an option in IPMI Spec using which BMC can be made aware
of the OS name that it is talking to.
IPMI_Spec-IPMI2_0E4_061209  -  ref - 22.14a ,  [Set System Info]

This patch will update the OS name as "Linux" in BMC during
IPMI Driver initialization. In the current patch, declaration of
the OS name is done only for the Volatile param.

Signed-off-by: Srinivas Gowda G <Srinivas_G_Gowda@dell.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   72 ++++++++++++++++++++++++++++++++++++++
 include/linux/ipmi_msgdefs.h     |    1 +
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 1e638ff..df995b4 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2709,6 +2709,71 @@ static int try_get_dev_id(struct smi_info *smi_info)
 	return rv;
 }
 
+/*
+ * Set the Operating System Name as "Linux" using "Set System Info" command.
+ * Only setting Volatile variable - Parameter 4 
+ */
+static int try_set_system_info_os_name(struct smi_info *smi_info)
+{
+	unsigned char         msg[11];
+	unsigned char         *resp;
+	unsigned char         param_select;
+	unsigned char	      set_selector;		
+	unsigned char         string_encode;
+	unsigned char         str_len;
+	unsigned long         resp_len;
+	int                   rv = 0;
+
+	resp = kmalloc(IPMI_MAX_MSG_LENGTH, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	param_select = 4;	/* parameter number for volatile OS name */
+	set_selector = 0;	/* set selector, block 0 */
+	string_encode = 0;	/* ASCII Encoding */
+	str_len = 5;		/* length of ASCII string - "Linux" */
+
+	msg[0] = IPMI_NETFN_APP_REQUEST << 2;
+	msg[1] = IPMI_SET_SYSTEM_INFO;
+	msg[2] = param_select;
+	msg[3] = set_selector;
+	msg[4] = string_encode;	
+	msg[5] = str_len;
+	msg[6] =  'L';	
+	msg[7] =  'i';	
+	msg[8] =  'n';	
+	msg[9] =  'u';	
+	msg[10] = 'x';	
+
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 11);
+
+	rv = wait_for_msg_done(smi_info);
+	if (rv)
+		goto out;
+
+	resp_len = smi_info->handlers->get_result(smi_info->si_sm,
+						  resp, IPMI_MAX_MSG_LENGTH);
+
+	if (resp_len < 3 ||
+			resp[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2 ||
+			resp[1] != IPMI_SET_SYSTEM_INFO   ||
+			resp[2] != 0) {
+		if (resp_len == 3 )
+			 rv = resp[2]; 
+		printk(KERN_WARNING PFX "Failed to set OS name as Linux: 0x%X\n", rv);
+
+		rv = -EINVAL;
+		goto out;
+	}
+	else
+		/* Volatile Opertaing System name */
+		printk(KERN_INFO PFX "OS Name successfully set as Linux\n");
+
+ out:
+	kfree(resp);
+	return rv;
+}
+
 static int try_enable_event_buffer(struct smi_info *smi_info)
 {
 	unsigned char         msg[3];
@@ -3216,6 +3281,13 @@ static int try_smi_init(struct smi_info *new_smi)
 	new_smi->intf_num = smi_num;
 	smi_num++;
 
+	/*
+ 	 * Set the OS in BMC as "Linux" using "Set System Info" Command 
+ 	 */
+	rv = try_set_system_info_os_name(new_smi);
+	if(rv) 
+		printk(KERN_WARNING PFX "Could not set OS Name in BMC\n");
+		
 	rv = try_enable_event_buffer(new_smi);
 	if (rv == 0)
 		new_smi->has_event_buffer = 1;
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