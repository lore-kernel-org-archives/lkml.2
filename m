Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0KHUfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:35:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10993 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0KHUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:33:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=mikFkPHJig8S8Wxpr69RgO5L41fPMVigyz34n2yfHpBudohVVAlxcuz0FP/jz/9Wg
	+k+sEXu0RELJa3PfEtpng==
Subject: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Date: Mon, 08 Nov 2010 12:32:47 -0800
Message-ID: <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As preparation for moving netpoll_targets out of netconsole and making
them available to other clients, introduce new Kconfig options.

CONFIG_NETPOLL_TARGETS

Access to targets APIs.  Only supports parameter based parsing of
targets (via the kernel command line or module paramters).

CONFIG_NETPOLL_TARGETS_DYNAMIC

Extends the support that netpoll_targets provides by allowing for the
dynamic creation of targets in configfs on a per client basis.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/Kconfig      |   16 +++++++++++++---
 drivers/net/netconsole.c |   10 +++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f6668cd..b014cd6 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3367,14 +3367,15 @@ config NET_FC
 
 config NETCONSOLE
 	tristate "Network console logging support"
+	select NETPOLL_TARGETS
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
-	depends on NETCONSOLE && SYSFS
-	select CONFIGFS_FS
+	depends on NETCONSOLE
+	select NETPOLL_TARGETS_DYNAMIC
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
@@ -3382,7 +3383,16 @@ config NETCONSOLE_DYNAMIC
 	  See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETPOLL
-	def_bool NETCONSOLE
+	def_bool false
+
+config NETPOLL_TARGETS
+	bool
+	select NETPOLL
+
+config NETPOLL_TARGETS_DYNAMIC
+	bool
+	select CONFIGFS_FS
+	select NETPOLL_TARGETS
 
 config NETPOLL_TRAP
 	bool "Netpoll traffic trapping"
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 4348d23..2fe571d 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -68,7 +68,7 @@ __setup("netconsole=", option_setup);
 struct netpoll_targets {
 	struct list_head list;
 	spinlock_t lock;
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 	struct configfs_subsystem configfs_subsys;
 #endif
 	struct notifier_block netdev_notifier;
@@ -110,7 +110,7 @@ static DEFINE_NETPOLL_TARGETS(targets);
 struct netpoll_target {
 	struct netpoll_targets *nts;
 	struct list_head	list;
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 	struct config_item	item;
 #endif
 	int			np_state;
@@ -193,7 +193,7 @@ static void free_param_target(struct netpoll_target *nt)
 	kfree(nt);
 }
 
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 
 /*
  * Our subsystem hierarchy is:
@@ -720,7 +720,7 @@ static void netpoll_target_put(struct netpoll_target *nt)
 		config_item_put(&nt->item);
 }
 
-#else	/* !CONFIG_NETCONSOLE_DYNAMIC */
+#else	/* !CONFIG_NETPOLL_TARGETS_DYNAMIC */
 
 static int __init dynamic_netpoll_targets_init(const char *subsys_name,
 					       struct netpoll_targets *nts)
@@ -744,7 +744,7 @@ static void netpoll_target_put(struct netpoll_target *nt)
 {
 }
 
-#endif	/* CONFIG_NETCONSOLE_DYNAMIC */
+#endif	/* CONFIG_NETPOLL_TARGETS_DYNAMIC */
 
 /*
  * Call netpoll_cleanup on this target asynchronously.

