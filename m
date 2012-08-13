Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2HMUYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53789 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2HMUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:19 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 13 Aug 2012 13:18:34 -0700
Message-Id: <1344889115-21610-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+1mjWZgW188K5XZ5pjD4HMgVZ+rchgNmc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 20/21] userns: Make the airo wireless driver use kuids for proc uids and gids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/net/wireless/airo.c |   48 +++++++++++++++++++++++++-----------------
 init/Kconfig                |    2 -
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index f9f15bb..c586f78 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -232,8 +232,10 @@ static int adhoc;
 
 static int probe = 1;
 
+static kuid_t proc_kuid;
 static int proc_uid /* = 0 */;
 
+static kgid_t proc_kgid;
 static int proc_gid /* = 0 */;
 
 static int airo_perm = 0555;
@@ -4499,78 +4501,79 @@ struct proc_data {
 static int setup_proc_entry( struct net_device *dev,
 			     struct airo_info *apriv ) {
 	struct proc_dir_entry *entry;
+
 	/* First setup the device directory */
 	strcpy(apriv->proc_name,dev->name);
 	apriv->proc_entry = proc_mkdir_mode(apriv->proc_name, airo_perm,
 					    airo_entry);
 	if (!apriv->proc_entry)
 		goto fail;
-	apriv->proc_entry->uid = proc_uid;
-	apriv->proc_entry->gid = proc_gid;
+	apriv->proc_entry->uid = proc_kuid;
+	apriv->proc_entry->gid = proc_kgid;
 
 	/* Setup the StatsDelta */
 	entry = proc_create_data("StatsDelta", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
 		goto fail_stats_delta;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the Stats */
 	entry = proc_create_data("Stats", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
 		goto fail_stats;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the Status */
 	entry = proc_create_data("Status", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
 		goto fail_status;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the Config */
 	entry = proc_create_data("Config", proc_perm,
 				 apriv->proc_entry, &proc_config_ops, dev);
 	if (!entry)
 		goto fail_config;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the SSID */
 	entry = proc_create_data("SSID", proc_perm,
 				 apriv->proc_entry, &proc_SSID_ops, dev);
 	if (!entry)
 		goto fail_ssid;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the APList */
 	entry = proc_create_data("APList", proc_perm,
 				 apriv->proc_entry, &proc_APList_ops, dev);
 	if (!entry)
 		goto fail_aplist;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the BSSList */
 	entry = proc_create_data("BSSList", proc_perm,
 				 apriv->proc_entry, &proc_BSSList_ops, dev);
 	if (!entry)
 		goto fail_bsslist;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	/* Setup the WepKey */
 	entry = proc_create_data("WepKey", proc_perm,
 				 apriv->proc_entry, &proc_wepkey_ops, dev);
 	if (!entry)
 		goto fail_wepkey;
-	entry->uid = proc_uid;
-	entry->gid = proc_gid;
+	entry->uid = proc_kuid;
+	entry->gid = proc_kgid;
 
 	return 0;
 
@@ -5697,11 +5700,16 @@ static int __init airo_init_module( void )
 {
 	int i;
 
+	proc_kuid = make_kuid(&init_user_ns, proc_uid);
+	proc_kgid = make_kgid(&init_user_ns, proc_gid);
+	if (!uid_valid(proc_kuid) || !gid_valid(proc_kgid))
+		return -EINVAL;
+
 	airo_entry = proc_mkdir_mode("driver/aironet", airo_perm, NULL);
 
 	if (airo_entry) {
-		airo_entry->uid = proc_uid;
-		airo_entry->gid = proc_gid;
+		airo_entry->uid = proc_kuid;
+		airo_entry->gid = proc_kgid;
 	}
 
 	for (i = 0; i < 4 && io[i] && irq[i]; i++) {
diff --git a/init/Kconfig b/init/Kconfig
index 76ffca9..eac23a6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1003,8 +1003,6 @@ config UIDGID_CONVERTED
 	depends on !UML || HOSTFS = n
 
 	# The rare drivers that won't build
-	depends on AIRO = n
-	depends on AIRO_CS = n
 	depends on TUN = n
 	depends on INFINIBAND_QIB = n
 	depends on BLK_DEV_LOOP = n
-- 
1.7.5.4

