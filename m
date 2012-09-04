Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab2IDVhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:37:07 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56756
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757906Ab2IDVg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:36:26 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 07/10] Tools: hv: Add an example script to configure an interface
Date: Tue,  4 Sep 2012 14:46:39 -0700
Message-Id: <1346795202-25655-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346795202-25655-1-git-send-email-kys@microsoft.com>
References: <1346795156-25614-1-git-send-email-kys@microsoft.com>
 <1346795202-25655-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep the KVP daemon code free of distro specific details, we invoke an
external script to configure the interface. This is an example script that
was used to test the KVP code. This script has to be implemented in a Distro
specific fashion. For instance on distros that ship with Network Manager enabled,
this script can be based on NM APIs.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_set_ifconfig.sh |   68 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100755 tools/hv/hv_set_ifconfig.sh

diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
new file mode 100755
index 0000000..3e9427e
--- /dev/null
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+
+# This example script activates an interface based on the specified
+# configuration.
+#
+# In the interest of keeping the KVP daemon code free of distro specific
+# information; the kvp daemon code invokes this external script to configure
+# the interface.
+#
+# The only argument to this script is the configuration file that is to
+# be used to configure the interface.
+#
+# Each Distro is expected to implement this script in a distro specific
+# fashion. For instance on Distros that ship with Network Manager enabled,
+# this script can be based on the Network Manager APIs for configuring the
+# interface.
+#
+# This example script is based on a RHEL environment.
+#
+# Here is the format of the ip configuration file:
+#
+# HWADDR=macaddr
+# IF_NAME=interface name
+# DHCP=yes (This is optional; if yes, DHCP is configured)
+#
+# IPADDR=ipaddr1
+# IPADDR_1=ipaddr2
+# IPADDR_x=ipaddry (where y = x + 1)
+#
+# NETMASK=netmask1
+# NETMASK_x=netmasky (where y = x + 1)
+#
+# GATEWAY=ipaddr1
+# GATEWAY_x=ipaddry (where y = x + 1)
+#
+# DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
+#
+# IPV6 addresses will be tagged as IPV6ADDR, IPV6 gateway will be
+# tagged as IPV6_DEFAULTGW and IPV6 NETMASK will be tagged as
+# IPV6NETMASK.
+#
+# The host can specify multiple ipv4 and ipv6 addresses to be
+# configured for the interface. Furthermore, the configuration
+# needs to be persistent. A subsequent GET call on the interface
+# is expected to return the configuration that is set via the SET
+# call.
+#
+
+
+
+echo "IPV6INIT=yes" >> $1
+echo "NM_CONTROLLED=no" >> $1
+echo "PEERDNS=yes" >> $1
+echo "ONBOOT=yes" >> $1
+
+dhcp=$(grep "DHCP" $1 2>/dev/null)
+if [ "$dhcp" != "" ];
+then
+echo "BOOTPROTO=dhcp" >> $1;
+fi
+
+cp $1 /etc/sysconfig/network-scripts/
+
+
+interface=$(echo $1 | awk -F - '{ print $2 }')
+
+/sbin/ifdown $interface 2>/dev/null
+/sbin/ifup $interfac 2>/dev/null
-- 
1.7.4.1

