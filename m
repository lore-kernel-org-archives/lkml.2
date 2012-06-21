Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2FUVSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:18:51 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55714
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760352Ab2FUVSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:18:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 12/13] Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO
Date: Thu, 21 Jun 2012 14:31:44 -0700
Message-Id: <1340314305-27126-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now implement the KVP verb - KVP_OP_GET_IP_INFO. This operation retrieves IP
information for the specified interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   95 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index dcf67fa..569f4d7 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -41,6 +41,7 @@
 #include <syslog.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <dirent.h>
 
 /*
  * KVP protocol: The user mode component first registers with the
@@ -490,6 +491,64 @@ done:
 	return;
 }
 
+/*
+ * Retrieve an interface name corresponding to the specified guid.
+ * If there is a match, the function returns a pointer
+ * to the interface name and if not, a NULL is returned.
+ * If a match is found, the caller is responsible for
+ * freeing the memory.
+ */
+
+static char *kvp_get_if_name(char *guid, int guid_len)
+{
+	DIR *dir;
+	struct dirent *entry;
+	FILE    *file;
+	char    *p, *q;
+	char    *if_name = NULL;
+	char    buf[256];
+	char *kvp_net_dir = "/sys/class/net/";
+	char dev_id[100];
+
+	dir = opendir(kvp_net_dir);
+	if (dir == NULL)
+		return NULL;
+
+	memset(dev_id, 0, sizeof(dev_id));
+	strcat(dev_id, kvp_net_dir);
+	q = dev_id + strlen(kvp_net_dir);
+
+	while ((entry = readdir(dir)) != NULL) {
+		/*
+		 * Set the state for the next pass.
+		 */
+		*q = '\0';
+		strcat(dev_id, entry->d_name);
+		strcat(dev_id, "/device/device_id");
+
+		file = fopen(dev_id, "r");
+		if (file == NULL)
+			continue;
+
+		p = fgets(buf, sizeof(buf), file);
+		if (p) {
+			if (!strncmp(p, guid, guid_len)) {
+				/*
+				 * Found the guid match; return the interface
+				 * name. The caller will free the memory.
+				 */
+				if_name = strdup(entry->d_name);
+				break;
+			}
+		}
+		fclose(file);
+	}
+
+	closedir(dir);
+	return if_name;
+}
+
+
 static void kvp_process_ipconfig_file(char *config_file,
 					char *config_buf, int len,
 					int element_size, int offset)
@@ -651,7 +710,7 @@ static int kvp_process_ip_address(void *addrp,
 }
 
 static int
-kvp_get_ip_address(int family, char *if_name, int op,
+kvp_get_ip_info(int family, char *if_name, int op,
 		 void  *out_buffer, int length)
 {
 	struct ifaddrs *ifap;
@@ -858,6 +917,10 @@ int main(void)
 	char	*key_name;
 	int	op;
 	int	pool;
+	char    *if_name;
+	struct hv_kvp_ipaddr_value *kvp_ip_val;
+
+
 
 	daemon(1, 0);
 	openlog("KVP", 0, LOG_USER);
@@ -959,6 +1022,32 @@ int main(void)
 			}
 			continue;
 
+		case KVP_OP_GET_IP_INFO:
+			kvp_ip_val = &hv_msg->body.kvp_ip_val;
+			if_name = kvp_get_if_name(
+						(char *)kvp_ip_val->adapter_id,
+						MAX_ADAPTER_ID_SIZE);
+			if (if_name == NULL) {
+				/*
+				 * We could not map the guid to an
+				 * interface name; return error.
+				 */
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+					HV_ERROR_DEVICE_NOT_CONNECTED;
+				break;
+			}
+			error = kvp_get_ip_info(
+						0, if_name, KVP_OP_GET_IP_INFO,
+						kvp_ip_val,
+						(MAX_IP_ADDR_SIZE * 2));
+
+			if (error)
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+					HV_ERROR_DEVICE_NOT_CONNECTED;
+
+			free(if_name);
+			break;
+
 		case KVP_OP_SET:
 			if (kvp_key_add_or_modify(hv_msg->kvp_hdr.pool,
 					hv_msg->body.kvp_set.data.key,
@@ -1026,12 +1115,12 @@ int main(void)
 			strcpy(key_value, lic_version);
 			break;
 		case NetworkAddressIPv4:
-			kvp_get_ip_address(AF_INET, NULL, KVP_OP_ENUMERATE,
+			kvp_get_ip_info(AF_INET, NULL, KVP_OP_ENUMERATE,
 				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv4");
 			break;
 		case NetworkAddressIPv6:
-			kvp_get_ip_address(AF_INET6, NULL, KVP_OP_ENUMERATE,
+			kvp_get_ip_info(AF_INET6, NULL, KVP_OP_ENUMERATE,
 				key_value, HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
 			strcpy(key_name, "NetworkAddressIPv6");
 			break;
-- 
1.7.4.1

