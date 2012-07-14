Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2GNUpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:45:20 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:43443
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753010Ab2GNUoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:44:38 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 15/15] Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO
Date: Sat, 14 Jul 2012 13:34:20 -0700
Message-Id: <1342298060-12662-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now implement the KVP verb - KVP_OP_GET_IP_INFO. This operation retrieves IP
information for the specified interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6d224e7..723e78e 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -590,6 +590,69 @@ static char *kvp_if_name_to_mac(char *if_name)
 }
 
 
+/*
+ * Retrieve the interface name given tha MAC address.
+ */
+
+static char *kvp_mac_to_if_name(char *mac)
+{
+	DIR *dir;
+	struct dirent *entry;
+	FILE    *file;
+	char    *p, *q, *x;
+	char    *if_name = NULL;
+	char    buf[256];
+	char *kvp_net_dir = "/sys/class/net/";
+	char dev_id[100];
+	int i;
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
+
+		strcat(dev_id, entry->d_name);
+		strcat(dev_id, "/address");
+
+		file = fopen(dev_id, "r");
+		if (file == NULL)
+			continue;
+
+		p = fgets(buf, sizeof(buf), file);
+		if (p) {
+			x = strchr(p, '\n');
+			if (x)
+				*x = '\0';
+
+			for (i = 0; i < strlen(p); i++)
+				p[i] = toupper(p[i]);
+
+			if (!strcmp(p, mac)) {
+				/*
+				 * Found the MAC match; return the interface
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
 static void kvp_process_ipconfig_file(char *cmd,
 					char *config_buf, int len,
 					int element_size, int offset)
@@ -1272,6 +1335,32 @@ int main(void)
 			}
 			continue;
 
+		case KVP_OP_GET_IP_INFO:
+			kvp_ip_val = &hv_msg->body.kvp_ip_val;
+			if_name =
+			kvp_mac_to_if_name((char *)kvp_ip_val->adapter_id);
+
+			if (if_name == NULL) {
+				/*
+				 * We could not map the mac address to an
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
 		case KVP_OP_SET_IP_INFO:
 			kvp_ip_val = &hv_msg->body.kvp_ip_val;
 			if_name = kvp_get_if_name(
-- 
1.7.4.1

