Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab2HQA33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:29:29 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41876
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932585Ab2HQA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:28:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 07/14] Tools: hv: Gather ipv[4,6] gateway information
Date: Thu, 16 Aug 2012 17:45:18 -0700
Message-Id: <1345164325-5198-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345164325-5198-1-git-send-email-kys@microsoft.com>
References: <1345164300-5146-1-git-send-email-kys@microsoft.com>
 <1345164325-5198-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/hv/hv_kvp_daemon.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index a63e83a..65d54c8 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -491,6 +491,68 @@ done:
 	return;
 }
 
+static void kvp_process_ipconfig_file(char *cmd,
+					char *config_buf, int len,
+					int element_size, int offset)
+{
+	char buf[256];
+	char *p;
+	char *x;
+	FILE *file;
+
+	/*
+	 * First execute the command.
+	 */
+	file = popen(cmd, "r");
+	if (file == NULL)
+		return;
+
+	if (offset == 0)
+		memset(config_buf, 0, len);
+	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
+		if ((len - strlen(config_buf)) < (element_size + 1))
+			break;
+
+		x = strchr(p, '\n');
+		*x = '\0';
+		strcat(config_buf, p);
+		strcat(config_buf, ";");
+	}
+	pclose(file);
+}
+
+static void kvp_get_ipconfig_info(char *if_name,
+				 struct hv_kvp_ipaddr_value *buffer)
+{
+	char cmd[512];
+
+	/*
+	 * Get the address of default gateway (ipv4).
+	 */
+	sprintf(cmd, "%s %s", "ip route show dev", if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }'");
+
+	/*
+	 * Execute the command to gather gateway info.
+	 */
+	kvp_process_ipconfig_file(cmd, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET_ADDRSTRLEN, 0);
+
+	/*
+	 * Get the address of default gateway (ipv6).
+	 */
+	sprintf(cmd, "%s %s", "ip -f inet6  route show dev", if_name);
+	strcat(cmd, " | awk '/default/ {print $3 }'");
+
+	/*
+	 * Execute the command to gather gateway info (ipv6).
+	 */
+	kvp_process_ipconfig_file(cmd, (char *)buffer->gate_way,
+				(MAX_GATEWAY_SIZE * 2), INET6_ADDRSTRLEN, 1);
+
+}
+
+
 static unsigned int hweight32(unsigned int *w)
 {
 	unsigned int res = *w - ((*w >> 1) & 0x55555555);
@@ -650,6 +712,12 @@ kvp_get_ip_address(int family, char *if_name, int op,
 				strcat((char *)ip_buffer->sub_net, ";");
 				sn_offset += strlen(sn_str) + 1;
 			}
+
+			/*
+			 * Collect other ip related configuration info.
+			 */
+
+			kvp_get_ipconfig_info(if_name, ip_buffer);
 		}
 
 gather_ipaddr:
-- 
1.7.4.1

