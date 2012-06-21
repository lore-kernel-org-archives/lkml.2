Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449Ab2FUVTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:19:48 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55695
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760316Ab2FUVSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:18:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 11/13] Tools: hv: Gather dhcp information
Date: Thu, 21 Jun 2012 14:31:43 -0700
Message-Id: <1340314305-27126-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect information on dhcp setting for the specified interface.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 68a4cc1..dcf67fa 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -524,6 +524,10 @@ static void kvp_get_ipconfig_info(char *if_name,
 	char cmd[512];
 	char *dns_config = "/var/opt/hyperv/.kvp_dns_cfg";
 	char *gw_config = "/var/opt/hyperv/.kvp_gw_cfg";
+	char if_cfg_file[256];
+	FILE *file;
+	char *p;
+	char buf[256];
 
 	memset(cmd, 0, 512);
 	strcat(cmd, "cat /etc/resolv.conf 2>/tmp/null | ");
@@ -569,6 +573,35 @@ static void kvp_get_ipconfig_info(char *if_name,
 	kvp_process_ipconfig_file(gw_config, (char *)buffer->gate_way,
 				(MAX_GATEWAY_SIZE * 2), INET6_ADDRSTRLEN,
 				strlen(gw_config));
+
+	/*
+	 * Get the boot protocol for the interface.
+	 * We will get the info from:
+	 * /etc/sysconfig/network-scripts/ifcfg-ethx
+	 * If need to parse other files to get
+	 * this info, we need to add code to parse
+	 * other files.
+	 */
+	memset(if_cfg_file, 0, sizeof(if_cfg_file));
+	strcat(if_cfg_file, "/etc/sysconfig/network-scripts/ifcfg-");
+	strcat(if_cfg_file, if_name);
+
+	file = fopen(if_cfg_file, "r");
+	if (file == NULL)
+		/*
+		 * Add code to parse other files.
+		 */
+		return;
+
+	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
+		if (strncmp(p, "BOOTPROTO", 9))
+			continue;
+		if (strncmp(p, "BOOTPROTO=none", 14))
+			buffer->dhcp_enabled = 0;
+		else
+			buffer->dhcp_enabled = 1;
+	}
+
 }
 
 
-- 
1.7.4.1

