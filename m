Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab1FQWJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:09:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:7710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786Ab1FQWJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:09:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,383,1304319600"; 
   d="scan'208";a="17636022"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] PTI feature to allow user to name and mark masterchannel request.
Date: Fri, 17 Jun 2011 15:09:53 -0700
Message-Id: <1308348593-14649-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This feature addition provides a new parameter in
pti_request_masterchannel() to allow the user
to provide their own name to mark the request when
the trace is viewed in a PTI SW trace viewer
(like MPTA).  If a name is not provided and
NULL is provided, the 'current' process name is used.
API function header documentation documents this.

Signed-off-by: Jeremy Rocher <rocher.jeremy@gmail.com>
Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c  |   99 +++++++++++++++++++++++++++++++--------------------
 include/linux/pti.h |    3 +-
 2 files changed, 62 insertions(+), 40 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index e5f295a..8653bd0 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -146,45 +146,54 @@ static void pti_write_to_aperture(struct pti_masterchannel *mc,
 /**
  *  pti_control_frame_built_and_sent()- control frame build and send function.
  *
- *  @mc: The master / channel structure on which the function
- *       built a control frame.
+ *  @mc:          The master / channel structure on which the function
+ *                built a control frame.
+ *  @thread_name: The thread name associated with the master / channel or
+ *                'NULL' if using the 'current' global variable.
  *
  *  To be able to post process the PTI contents on host side, a control frame
  *  is added before sending any PTI content. So the host side knows on
  *  each PTI frame the name of the thread using a dedicated master / channel.
- *  The thread name is retrieved from the 'current' global variable.
+ *  The thread name is retrieved from 'current' global variable if 'thread_name'
+ *  is 'NULL', else it is retrieved from 'thread_name' parameter.
  *  This function builds this frame and sends it to a master ID CONTROL_ID.
  *  The overhead is only 32 bytes since the driver only writes to HW
  *  in 32 byte chunks.
  */
-
-static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc)
+static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc,
+					     const char *thread_name)
 {
 	struct pti_masterchannel mccontrol = {.master = CONTROL_ID,
 					      .channel = 0};
+	const char *thread_name_p;
 	const char *control_format = "%3d %3d %s";
 	u8 control_frame[CONTROL_FRAME_LEN];
 
-	/*
-	 * Since we access the comm member in current's task_struct,
-	 * we only need to be as large as what 'comm' in that
-	 * structure is.
-	 */
-	char comm[TASK_COMM_LEN];
+	if (!thread_name) {
+		/*
+		 * Since we access the comm member in current's task_struct,
+		 * we only need to be as large as what 'comm' in that
+		 * structure is.
+		 */
+		char comm[TASK_COMM_LEN];
 
-	if (!in_interrupt())
-		get_task_comm(comm, current);
-	else
-		strncpy(comm, "Interrupt", TASK_COMM_LEN);
+		if (!in_interrupt())
+			get_task_comm(comm, current);
+		else
+			strncpy(comm, "Interrupt", TASK_COMM_LEN);
 
-	/* Absolutely ensure our buffer is zero terminated. */
-	comm[TASK_COMM_LEN-1] = 0;
+		/* Absolutely ensure our buffer is zero terminated. */
+		comm[TASK_COMM_LEN-1] = 0;
+		thread_name_p = comm;
+	} else {
+		thread_name_p = thread_name;
+	}
 
 	mccontrol.channel = pti_control_channel;
 	pti_control_channel = (pti_control_channel + 1) & 0x7f;
 
 	snprintf(control_frame, CONTROL_FRAME_LEN, control_format, mc->master,
-		mc->channel, comm);
+		mc->channel, thread_name_p);
 	pti_write_to_aperture(&mccontrol, control_frame, strlen(control_frame));
 }
 
@@ -206,18 +215,20 @@ static void pti_write_full_frame_to_aperture(struct pti_masterchannel *mc,
 						const unsigned char *buf,
 						int len)
 {
-	pti_control_frame_built_and_sent(mc);
+	pti_control_frame_built_and_sent(mc, NULL);
 	pti_write_to_aperture(mc, (u8 *)buf, len);
 }
 
 /**
  * get_id()- Allocate a master and channel ID.
  *
- * @id_array: an array of bits representing what channel
- *            id's are allocated for writing.
- * @max_ids:  The max amount of available write IDs to use.
- * @base_id:  The starting SW channel ID, based on the Intel
- *            PTI arch.
+ * @id_array:    an array of bits representing what channel
+ *               id's are allocated for writing.
+ * @max_ids:     The max amount of available write IDs to use.
+ * @base_id:     The starting SW channel ID, based on the Intel
+ *               PTI arch.
+ * @thread_name: The thread name associated with the master / channel or
+ *               'NULL' if using the 'current' global variable.
  *
  * Returns:
  *	pti_masterchannel struct with master, channel ID address
@@ -227,7 +238,10 @@ static void pti_write_full_frame_to_aperture(struct pti_masterchannel *mc,
  * channel id. The bit is one if the id is taken and 0 if free. For
  * every master there are 128 channel id's.
  */
-static struct pti_masterchannel *get_id(u8 *id_array, int max_ids, int base_id)
+static struct pti_masterchannel *get_id(u8 *id_array,
+					int max_ids,
+					int base_id,
+					const char *thread_name)
 {
 	struct pti_masterchannel *mc;
 	int i, j, mask;
@@ -257,7 +271,7 @@ static struct pti_masterchannel *get_id(u8 *id_array, int max_ids, int base_id)
 	mc->master  = base_id;
 	mc->channel = ((i & 0xf)<<3) + j;
 	/* write new master Id / channel Id allocation to channel control */
-	pti_control_frame_built_and_sent(mc);
+	pti_control_frame_built_and_sent(mc, thread_name);
 	return mc;
 }
 
@@ -273,18 +287,22 @@ static struct pti_masterchannel *get_id(u8 *id_array, int max_ids, int base_id)
  *				a master, channel ID address
  *				to write to PTI HW.
  *
- * @type: 0- request Application  master, channel aperture ID write address.
- *        1- request OS master, channel aperture ID write
- *           address.
- *        2- request Modem master, channel aperture ID
- *           write address.
- *        Other values, error.
+ * @type:        0- request Application  master, channel aperture ID
+ *                  write address.
+ *               1- request OS master, channel aperture ID write
+ *                  address.
+ *               2- request Modem master, channel aperture ID
+ *                  write address.
+ *               Other values, error.
+ * @thread_name: The thread name associated with the master / channel or
+ *               'NULL' if using the 'current' global variable.
  *
  * Returns:
  *	pti_masterchannel struct
  *	0 for error
  */
-struct pti_masterchannel *pti_request_masterchannel(u8 type)
+struct pti_masterchannel *pti_request_masterchannel(u8 type,
+						    const char *thread_name)
 {
 	struct pti_masterchannel *mc;
 
@@ -293,15 +311,18 @@ struct pti_masterchannel *pti_request_masterchannel(u8 type)
 	switch (type) {
 
 	case 0:
-		mc = get_id(drv_data->ia_app, MAX_APP_IDS, APP_BASE_ID);
+		mc = get_id(drv_data->ia_app, MAX_APP_IDS,
+			    APP_BASE_ID, thread_name);
 		break;
 
 	case 1:
-		mc = get_id(drv_data->ia_os, MAX_OS_IDS, OS_BASE_ID);
+		mc = get_id(drv_data->ia_os, MAX_OS_IDS,
+			    OS_BASE_ID, thread_name);
 		break;
 
 	case 2:
-		mc = get_id(drv_data->ia_modem, MAX_MODEM_IDS, MODEM_BASE_ID);
+		mc = get_id(drv_data->ia_modem, MAX_MODEM_IDS,
+			    MODEM_BASE_ID, thread_name);
 		break;
 	default:
 		mc = NULL;
@@ -472,9 +493,9 @@ static int pti_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 			return -ENOMEM;
 
 		if (idx == PTITTY_MINOR_START)
-			pti_tty_data->mc = pti_request_masterchannel(0);
+			pti_tty_data->mc = pti_request_masterchannel(0, NULL);
 		else
-			pti_tty_data->mc = pti_request_masterchannel(2);
+			pti_tty_data->mc = pti_request_masterchannel(2, NULL);
 
 		if (pti_tty_data->mc == NULL) {
 			kfree(pti_tty_data);
@@ -563,7 +584,7 @@ static int pti_char_open(struct inode *inode, struct file *filp)
 	 * before assigning the value to filp->private_data.
 	 * Slightly easier to debug if this driver needs debugging.
 	 */
-	mc = pti_request_masterchannel(0);
+	mc = pti_request_masterchannel(0, NULL);
 	if (mc == NULL)
 		return -ENOMEM;
 	filp->private_data = mc;
diff --git a/include/linux/pti.h b/include/linux/pti.h
index 81af667..b3ea01a 100644
--- a/include/linux/pti.h
+++ b/include/linux/pti.h
@@ -36,7 +36,8 @@ struct pti_masterchannel {
 
 /* the following functions are defined in misc/pti.c */
 void pti_writedata(struct pti_masterchannel *mc, u8 *buf, int count);
-struct pti_masterchannel *pti_request_masterchannel(u8 type);
+struct pti_masterchannel *pti_request_masterchannel(u8 type,
+						    const char *thread_name);
 void pti_release_masterchannel(struct pti_masterchannel *mc);
 
 #endif /*PTI_H_*/
-- 
1.7.2.3

