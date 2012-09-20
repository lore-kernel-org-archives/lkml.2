Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2ITVtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:49:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48019 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ITVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:49:06 -0400
Subject: [PATCH v2] ipconfig: add nameserver IPs to kernel-parameter ip=
From: Christoph Fritz <chf.fritz@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: rob@landley.net, kuznet@ms2.inr.ac.ru, j.weitzel@phytec.de,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, hjk@hansjkoch.de, daniel@zonque.org
In-Reply-To: <20120920.173719.1238894522809866676.davem@davemloft.net>
References: <1348176485.3858.92.camel@mars>
	 <20120920.173719.1238894522809866676.davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 20 Sep 2012 23:48:50 +0200
Message-ID: <1348177730.3858.98.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On small systems (e.g. embedded ones) IP addresses are often configured
by bootloaders and get assigned to kernel via parameter "ip=".  If set to
"ip=dhcp", even nameserver entries from DHCP daemons are handled. These
entries exported in /proc/net/pnp are commonly linked by /etc/resolv.conf.

To configure nameservers for networks without DHCP, this patch adds option
<dns0-ip> and <dns1-ip> to kernel-parameter 'ip='.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Tested-by: Jan Weitzel <j.weitzel@phytec.de>
---
v2: - fix indent
---
 Documentation/filesystems/nfs/nfsroot.txt |    7 +++++
 net/ipv4/ipconfig.c                       |   39 ++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsroot.txt b/Documentation/filesystems/nfs/nfsroot.txt
index ffdd9d8..4ed7875 100644
--- a/Documentation/filesystems/nfs/nfsroot.txt
+++ b/Documentation/filesystems/nfs/nfsroot.txt
@@ -158,6 +158,13 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
 
                 Default: any
 
+  <dns0-ip>	IP address of first nameserver.
+		Value gets exported by /proc/net/pnp which is often linked
+		on embedded systems by /etc/resolv.conf.
+
+  <dns1-ip>	IP address of secound nameserver.
+		Same as above.
+
 
 nfsrootdebug
 
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 67e8a6b..1c0e7e0 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -743,14 +743,22 @@ static void __init ic_bootp_init_ext(u8 *e)
 
 
 /*
- *  Initialize the DHCP/BOOTP mechanism.
+ *  Predefine Nameservers
  */
-static inline void __init ic_bootp_init(void)
+static inline void __init ic_nameservers_predef(void)
 {
 	int i;
 
 	for (i = 0; i < CONF_NAMESERVERS_MAX; i++)
 		ic_nameservers[i] = NONE;
+}
+
+/*
+ *  Initialize the DHCP/BOOTP mechanism.
+ */
+static inline void __init ic_bootp_init(void)
+{
+	ic_nameservers_predef();
 
 	dev_add_pack(&bootp_packet_type);
 }
@@ -1379,6 +1387,7 @@ static int __init ip_auto_config(void)
 	int retries = CONF_OPEN_RETRIES;
 #endif
 	int err;
+	unsigned int i;
 
 #ifdef CONFIG_PROC_FS
 	proc_net_fops_create(&init_net, "pnp", S_IRUGO, &pnp_seq_fops);
@@ -1499,7 +1508,15 @@ static int __init ip_auto_config(void)
 		&ic_servaddr, &root_server_addr, root_server_path);
 	if (ic_dev_mtu)
 		pr_cont(", mtu=%d", ic_dev_mtu);
-	pr_cont("\n");
+	for (i = 0; i < CONF_NAMESERVERS_MAX; i++)
+		if (ic_nameservers[i] != NONE) {
+			pr_info("     nameserver%u=%pI4",
+				i, &ic_nameservers[i]);
+			break;
+		}
+	for (i++; i < CONF_NAMESERVERS_MAX; i++)
+		if (ic_nameservers[i] != NONE)
+			pr_cont(", nameserver%u=%pI4\n", i, &ic_nameservers[i]);
 #endif /* !SILENT */
 
 	return 0;
@@ -1570,6 +1587,8 @@ static int __init ip_auto_config_setup(char *addrs)
 		return 1;
 	}
 
+	ic_nameservers_predef();
+
 	/* Parse string for static IP assignment.  */
 	ip = addrs;
 	while (ip && *ip) {
@@ -1613,6 +1632,20 @@ static int __init ip_auto_config_setup(char *addrs)
 					ic_enable = 0;
 				}
 				break;
+			case 7:
+				if (CONF_NAMESERVERS_MAX >= 1) {
+					ic_nameservers[0] = in_aton(ip);
+					if (ic_nameservers[0] == ANY)
+						ic_nameservers[0] = NONE;
+				}
+				break;
+			case 8:
+				if (CONF_NAMESERVERS_MAX >= 2) {
+					ic_nameservers[1] = in_aton(ip);
+					if (ic_nameservers[1] == ANY)
+						ic_nameservers[1] = NONE;
+				}
+				break;
 			}
 		}
 		ip = cp;
-- 
1.7.2.5



