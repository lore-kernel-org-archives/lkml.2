Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3AHL1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:27:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AHL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:27:12 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org
Cc: kys@microsoft.com, jasowang@redhat.com, haiyangz@microsoft.com,
        linux-kernel@vger.kernel.org, habdi@microsoft.com,
        Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
Date: Tue,  8 Jan 2013 12:26:42 +0100
Message-Id: <1357644403-11140-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for the daemon code and for hv_set_ifconfig.sh script, so
that the created ifcfg-* file is consistent with initscripts
documentation.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c    | 73 ++++++++++++++++++++++-----------------------
 tools/hv/hv_set_ifconfig.sh | 22 ++++++--------
 2 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d25a469..6b56b75 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1162,16 +1162,13 @@ static int process_ip_string(FILE *f, char *ip_string, int type)
 				snprintf(str, sizeof(str), "%s", "DNS");
 				break;
 			}
-			if (i != 0) {
-				if (type != DNS) {
-					snprintf(sub_str, sizeof(sub_str),
-						"_%d", i++);
-				} else {
-					snprintf(sub_str, sizeof(sub_str),
-						"%d", ++i);
-				}
-			} else if (type == DNS) {
+			
+			if (type == DNS) {
 				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
+			} else if (type == GATEWAY && i == 0) {
+				++i;
+			} else {
+				snprintf(sub_str, sizeof(sub_str), "%d", i++);
 			}
 
 
@@ -1191,17 +1188,13 @@ static int process_ip_string(FILE *f, char *ip_string, int type)
 				snprintf(str, sizeof(str), "%s",  "DNS");
 				break;
 			}
-			if ((j != 0) || (type == DNS)) {
-				if (type != DNS) {
-					snprintf(sub_str, sizeof(sub_str),
-						"_%d", j++);
-				} else {
-					snprintf(sub_str, sizeof(sub_str),
-						"%d", ++i);
-				}
-			} else if (type == DNS) {
-				snprintf(sub_str, sizeof(sub_str),
-					"%d", ++i);
+			
+			if (type == DNS) {
+				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
+			} else if (j == 0) {
+				++j;
+			} else {
+				snprintf(sub_str, sizeof(sub_str), "_%d", j++);
 			}
 		} else {
 			return  HV_INVALIDARG;
@@ -1244,18 +1237,19 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	 * Here is the format of the ip configuration file:
 	 *
 	 * HWADDR=macaddr
-	 * IF_NAME=interface name
-	 * DHCP=yes (This is optional; if yes, DHCP is configured)
+	 * DEVICE=interface name
+	 * BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is configured
+	 *                       or "none" if no boot-time protocol should be used)
 	 *
-	 * IPADDR=ipaddr1
-	 * IPADDR_1=ipaddr2
-	 * IPADDR_x=ipaddry (where y = x + 1)
+	 * IPADDR0=ipaddr1
+	 * IPADDR1=ipaddr2
+	 * IPADDRx=ipaddry (where y = x + 1)
 	 *
-	 * NETMASK=netmask1
-	 * NETMASK_x=netmasky (where y = x + 1)
+	 * NETMASK0=netmask1
+	 * NETMASKx=netmasky (where y = x + 1)
 	 *
 	 * GATEWAY=ipaddr1
-	 * GATEWAY_x=ipaddry (where y = x + 1)
+	 * GATEWAYx=ipaddry (where y = x + 1)
 	 *
 	 * DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
 	 *
@@ -1294,20 +1288,23 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
-	error = kvp_write_file(file, "IF_NAME", "", if_name);
+	error = kvp_write_file(file, "DEVICE", "", if_name);
 	if (error)
 		goto setval_error;
 
-	if (new_val->dhcp_enabled) {
-		error = kvp_write_file(file, "DHCP", "", "yes");
-		if (error)
-			goto setval_error;
+	if (new_val->dhcp_enabled)
+		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
+	else
+		error = kvp_write_file(file, "BOOTPROTO", "", "none");
+        
+	if (error)
+		goto setval_error;
+
+	/*
+	 * We are done!.
+	 */
+	goto setval_done;
 
-		/*
-		 * We are done!.
-		 */
-		goto setval_done;
-	}
 
 	/*
 	 * Write the configuration for ipaddress, netmask, gateway and
diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
index 3e9427e..00b66be 100755
--- a/tools/hv/hv_set_ifconfig.sh
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -20,18 +20,19 @@
 # Here is the format of the ip configuration file:
 #
 # HWADDR=macaddr
-# IF_NAME=interface name
-# DHCP=yes (This is optional; if yes, DHCP is configured)
+# DEVICE=interface name
+# BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is configured
+#                       or "none" if no boot-time protocol should be used)
 #
-# IPADDR=ipaddr1
-# IPADDR_1=ipaddr2
-# IPADDR_x=ipaddry (where y = x + 1)
+# IPADDR0=ipaddr1
+# IPADDR1=ipaddr2
+# IPADDRx=ipaddry (where y = x + 1)
 #
-# NETMASK=netmask1
-# NETMASK_x=netmasky (where y = x + 1)
+# NETMASK0=netmask1
+# NETMASKx=netmasky (where y = x + 1)
 #
 # GATEWAY=ipaddr1
-# GATEWAY_x=ipaddry (where y = x + 1)
+# GATEWAYx=ipaddry (where y = x + 1)
 #
 # DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
 #
@@ -53,11 +54,6 @@ echo "NM_CONTROLLED=no" >> $1
 echo "PEERDNS=yes" >> $1
 echo "ONBOOT=yes" >> $1
 
-dhcp=$(grep "DHCP" $1 2>/dev/null)
-if [ "$dhcp" != "" ];
-then
-echo "BOOTPROTO=dhcp" >> $1;
-fi
 
 cp $1 /etc/sysconfig/network-scripts/
 
-- 
1.7.11.7

