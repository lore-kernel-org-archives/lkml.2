Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2GSVOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:14:11 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:37413 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2GSVOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:14:08 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZA==
Date: Thu, 19 Jul 2012 21:13:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-19_06:2012-07-19,2012-07-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207190250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]
 When efi_pstore holds just one log and it doesn't overwrite an exisiting entry,
 we lose a critical message if kernel panics while system is rebooting.

 [Solution]
  With this patch, efi_pstore can hold multiple logs with a new kernel parameter, efi_pstore_log_num.
  We can simply avoid losing a critical message in case mutiple events happen.

[Patch Description]
 - Introduce a new kernel parameter specifying the number of logs efi_pstore holds.
 - Pass ctime to an argument of erase callback.
    - Current variable name consists of type, id and ctime. So, when handling mutiple logs,
      pstore should pass ctime to erase callback to avoid erasing invisible entries via /dev/pstore.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/acpi/apei/erst.c            |    4 ++--
 drivers/firmware/efivars.c          |   33 +++++++++++++++++++++++++--------
 fs/pstore/inode.c                   |    2 +-
 fs/pstore/ram.c                     |    2 +-
 include/linux/pstore.h              |    2 +-
 6 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a92c5eb..9d38561 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -786,6 +786,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efivars.efi_pstore_log_num=
+			Set the maximum number of logs efi_pstore saves into
+			NVRAM. n >= 1 limits the number of logs. n <= 0 is
+			invalid.
+			default: 1
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index e4d9d24..0bd6ae4 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -938,7 +938,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi);
+			struct timespec time, struct pstore_info *psi);
 
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
@@ -1102,7 +1102,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 }
 
 static int erst_clearer(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi)
+			struct timespec time, struct pstore_info *psi)
 {
 	return erst_clear(id);
 }
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 75a7c82..55188d7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -628,6 +628,27 @@ efivar_unregister(struct efivar_entry *var)
 
 #ifdef CONFIG_PSTORE
 
+static unsigned long efi_pstore_log_num = 1;
+static int param_set_efi_pstore_log_num(const char *val,
+					struct kernel_param *kp)
+{
+	int ret;
+	unsigned long l;
+
+	ret = kstrtoul(val, 0, &l);
+	if (ret || l == 0)
+		return -EINVAL;
+
+	ret = param_set_ulong(val, kp);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+module_param_call(efi_pstore_log_num, param_set_efi_pstore_log_num,
+		  param_get_ulong, &efi_pstore_log_num, S_IRUGO | S_IWUSR);
+
 static int efi_pstore_open(struct pstore_info *psi)
 {
 	struct efivars *efivars = psi->data;
@@ -731,7 +752,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	current_log_num = get_current_log_num(efi_name, efivars);
 
-	if (current_log_num >= 1) {
+	if (current_log_num >= efi_pstore_log_num) {
 		spin_unlock(&efivars->lock);
 		*id = part;
 		return -EEXIST;
@@ -756,7 +777,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 };
 
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
-			    struct pstore_info *psi)
+			    struct timespec time, struct pstore_info *psi)
 {
 	char stub_name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
@@ -765,7 +786,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 	struct efivar_entry *entry, *found = NULL;
 	int i;
 
-	sprintf(stub_name, "dump-type%u-%llu-", type, id);
+	sprintf(stub_name, "dump-type%u-%llu-%lu", type, id, time.tv_sec);
 
 	spin_lock(&efivars->lock);
 
@@ -783,10 +804,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 		if (utf16_strncmp(entry->var.VariableName, efi_name,
 				  utf16_strlen(efi_name)))
 			continue;
-		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)]
-		    == 0)
-			continue;
 
 		/* found */
 		found = entry;
@@ -832,7 +849,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 }
 
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
-			    struct pstore_info *psi)
+			    struct timespec time, struct pstore_info *psi)
 {
 	return 0;
 }
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 11a2aa2..9acd703 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -75,7 +75,7 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	struct pstore_private *p = dentry->d_inode->i_private;
 
 	if (p->psi->erase)
-		p->psi->erase(p->type, p->id, p->psi);
+		p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime, p->psi);
 
 	return simple_unlink(dir, dentry);
 }
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 453030f..06357c9 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -178,7 +178,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 }
 
 static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
-				struct pstore_info *psi)
+				timespec time, struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index e1461e1..92cb90e 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -48,7 +48,7 @@ struct pstore_info {
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi);
+			struct timespec time, struct pstore_info *psi);
 	void		*data;
 };
 
-- 1.7.1 

