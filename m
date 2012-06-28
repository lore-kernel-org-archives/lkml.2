Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2F1Qpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:45:30 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:48149 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2F1Qp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:45:28 -0400
X-Loopcount0: from 10.175.216.250
From: <Srinivas_G_Gowda@Dell.com>
To: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Thu, 28 Jun 2012 22:14:30 +0530
Subject: [PATCH 0/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Topic: [PATCH 0/1 v2 ] ipmi: Setting OS name as Linux in BMC
Thread-Index: Ac1VTVec3/Mp5k/VQXe8AuLnzDWfbw==
Message-ID: <4FEC89EE.60203@dell.com>
References: <4FEC88C2.3050309@dell.com>
In-Reply-To: <4FEC88C2.3050309@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
x-forwarded-message-id: <4FEC88C2.3050309@dell.com>
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>The idea here is fine, but it's probably more appropriate to do this in 
>ipmi_msghandler.c, not ipmi_si_intf.c, since the latter only handles 
>some interface types.
v2 patch - moving the code to ipmi_msghandler. Called soon after BMC is
registered by the driver.

There is an option in IPMI spec using which BMC can be made aware
of the OS name that it is talking to.
IPMI_Spec-IPMI2_0E4_061209  -  ref - 22.14a ,  .Set System Info.

This patch will update the OS name as "Linux" in BMC during
IPMI Driver initialization. In the current patch declaration of
the OS name is done only for the Volatile param.


Signed-off-by: Srinivas Gowda G <Srinivas_G_Gowda@Dell.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2c29942..d0abb3a 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -55,8 +55,10 @@ static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
 static void smi_recv_tasklet(unsigned long);
 static void handle_new_recv_msgs(ipmi_smi_t intf);
+static void set_os_name_bmc(ipmi_smi_t intf);
 
 static int initialized;
+static unsigned char os_name_set;
 
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *proc_ipmi_root;
@@ -2568,6 +2570,11 @@ static int ipmi_bmc_register(ipmi_smi_t intf, int ifnum,
 			 bmc->id.manufacturer_id,
 			 bmc->id.product_id,
 			 bmc->id.device_id);
+		/* 
+		 * Set the OS in BMC as "Linux" using 
+ 		 * "Set System Info" Command
+ 		 */
+		set_os_name_bmc(intf);
 	}
 
 	/*
@@ -2702,6 +2709,27 @@ get_guid(ipmi_smi_t intf)
 	intf->null_user_handler = NULL;
 }
 
+/*
+ *   Set the Operating System Name as "Linux" in BMC 
+ *   using "Set System Info" command.
+ *   Only setting Volatile variable - Parameter 4
+ */
+static void
+set_os_name_bmc(ipmi_smi_t intf)
+{
+	int rv;
+	
+	intf->null_user_handler = set_os_name_handler;
+	rv = send_set_os_name_cmd(intf);
+	if (rv)
+		printk(KERN_WARNING PFX
+			"Send Failed: Set_System_Info - OS name Linux\n");
+
+	os_name_set = 0;
+	wait_event(intf->waitq, os_name_set == 1);
+	intf->null_user_handler = NULL;
+}
+
 static int
 send_channel_info_cmd(ipmi_smi_t intf, int chan)
 {
-- 
1.7.1


Thanks,
G