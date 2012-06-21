Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab2FVAms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:42:48 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47182
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760780Ab2FVAmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:42:47 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/13] Tools: hv: Gather DNS information
Date: Thu, 21 Jun 2012 14:31:41 -0700
Message-Id: <1340314305-27126-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now gather DNS information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 8a153c5..101ab7f 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -490,6 +490,50 @@ done:
 	return;
 }
 
+static void kvp_get_ipconfig_info(char *if_name,
+				 struct hv_kvp_ipaddr_value *buffer)
+{
+	char cmd[512];
+	char *dns_config = "/var/opt/hyperv/.kvp_dns_cfg";
+	FILE *file;
+	char buf[256];
+	char *dns_buf;
+	char *p;
+	char *x;
+
+	memset(cmd, 0, 512);
+	strcat(cmd, "cat /etc/resolv.conf 2>/tmp/null | ");
+	strcat(cmd, " awk '/nameserver/ {print $2 }' > ");
+	strcat(cmd, "/var/opt/hyperv/.kvp_dns_cfg");
+
+	/*
+	 * Execute the command to gather dns info.
+	 */
+	system(cmd);
+	file = fopen(dns_config, "r");
+	if (file == NULL)
+		return;
+
+	dns_buf = (char *)(buffer->dns_addr);
+	/*
+	 * The buffer is an array of __u16 elements.
+	 */
+	memset(dns_buf, 0, (MAX_IP_ADDR_SIZE * 2));
+	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
+		if (((MAX_IP_ADDR_SIZE * 2) - strlen(dns_buf)) <
+				(INET6_ADDRSTRLEN + 1))
+			break;
+
+		x = strchr(p, '\n');
+		*x = '\0';
+		strcat(dns_buf, p);
+		strcat(dns_buf, ";");
+	}
+	fclose(file);
+
+}
+
+
 static unsigned int hweight32(unsigned int *w)
 {
 	unsigned int res = *w - ((*w >> 1) & 0x55555555);
@@ -649,6 +693,12 @@ kvp_get_ip_address(int family, char *if_name, int op,
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

