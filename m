Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2KLI4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab2KLIz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:55:59 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com, ben@decadent.org.uk
Cc: Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 1/3] tools/hv: Fix /var subdirectory
Date: Mon, 12 Nov 2012 09:55:04 +0100
Message-Id: <1352710506-12590-1-git-send-email-thozza@redhat.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
References: <426367E2313C2449837CD2DE46E7EAF930E22362@CH1PRD0310MB381.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial patch by Ben Hutchings <ben@decadent.org.uk>

We will install this in /usr, so it must use /var/lib for its state.
Only programs installed under /opt should use /var/opt.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 54ecb95..d80a612 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -98,7 +98,7 @@ static struct utsname uts_buf;
  * The location of the interface configuration file.
  */
 
-#define KVP_CONFIG_LOC	"/var/opt/"
+#define KVP_CONFIG_LOC	"/var/lib/hyperv"
 
 #define MAX_FILE_NAME 100
 #define ENTRIES_PER_BLOCK 50
@@ -235,9 +235,9 @@ static int kvp_file_init(void)
 	int i;
 	int alloc_unit = sizeof(struct kvp_record) * ENTRIES_PER_BLOCK;
 
-	if (access("/var/opt/hyperv", F_OK)) {
-		if (mkdir("/var/opt/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
-			syslog(LOG_ERR, " Failed to create /var/opt/hyperv");
+	if (access(KVP_CONFIG_LOC, F_OK)) {
+		if (mkdir(KVP_CONFIG_LOC, S_IRUSR | S_IWUSR | S_IROTH)) {
+			syslog(LOG_ERR, " Failed to create %s", KVP_CONFIG_LOC);
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -246,7 +246,7 @@ static int kvp_file_init(void)
 		fname = kvp_file_info[i].fname;
 		records_read = 0;
 		num_blocks = 1;
-		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
+		sprintf(fname, "%s/.kvp_pool_%d", KVP_CONFIG_LOC, i);
 		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IROTH);
 
 		if (fd == -1)
@@ -1263,7 +1263,7 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	 */
 
 	snprintf(if_file, sizeof(if_file), "%s%s%s", KVP_CONFIG_LOC,
-		"hyperv/ifcfg-", if_name);
+		"/ifcfg-", if_name);
 
 	file = fopen(if_file, "w");
 
-- 
1.7.11.7

