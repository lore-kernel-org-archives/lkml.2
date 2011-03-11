Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1CKCo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:44:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1CKCoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:44:54 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=FJmM_9MKRmUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=z11f-joXAAAA:8 a=IXr_WNlcAAAA:8 a=yPCof4ZbAAAA:8 a=rOUgymgbAAAA:8 a=meVymXHHAAAA:8 a=kFKY8uGTF4j53sS4a1oA:9 a=5_39NmU-ao7o0nXeshHUjdWkUksA:4 a=PUjeQqilurYA:10 a=CJVq-v20pXUA:10 a=T5ZRoNnfl4MA:10 a=7DSvI1NPTFQA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] netconsole: Fix strange kconfig dependency on configfs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 21:44:51 -0500
Message-ID: <1299811491.15854.891.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing ktest rand config tests, I hit the following build bug:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `netconsole_target_get':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
drivers/built-in.o: In function `netconsole_target_put':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
drivers/built-in.o: In function `netconsole_target_get':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
drivers/built-in.o: In function `netconsole_target_put':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
drivers/built-in.o: In function `drop_netconsole_target':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:634: undefined reference to `config_item_put'
drivers/built-in.o: In function `make_netconsole_target':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:607: undefined reference to `config_item_init_type_name'
drivers/built-in.o: In function `dynamic_netconsole_init':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:109: undefined reference to `config_group_init'
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:111: undefined reference to `configfs_register_subsystem'
drivers/built-in.o: In function `dynamic_netconsole_exit':
/home/rostedt/work/autotest/nobackup/linux-test.git/drivers/net/netconsole.c:116: undefined reference to `configfs_unregister_subsystem'
make[1]: *** [.tmp_vmlinux1] Error 1

The .config had the following settings:

CONFIG_CONFIGFS_FS=m
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y

NETCONSOLE_DYNAMIC depends on NETCONSOLE and CONFIGFS_FS, but
NETCONSOLE_DYNAMIC is just a boolean and not a tristate, where both
NETCONSOLE and CONFIGFS_FS are tristates and can be built as modules.

As we can see from the resulting config, NETCONSOLE_DYNAMIC can be set
to be builtin when CONFIGFS_FS which it depends on is built as a module.

The simplest solution is not to allow NETCONSOLE_DYNAMIC be enabled if
CONFIGFS_FS is a module but NETCONSOLE is built in, as
NETCONSOLE_DYNAMIC depends on code that is only compiled in when
CONFIGFS_FS is set.

Cc: Michal Marek <mmarek@suse.cz>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-test.git/drivers/net/Kconfig
===================================================================
--- linux-test.git.orig/drivers/net/Kconfig	2011-03-10 18:19:54.644008709 -0500
+++ linux-test.git/drivers/net/Kconfig	2011-03-10 18:21:21.320194133 -0500
@@ -3390,6 +3390,7 @@ config NETCONSOLE
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
 	depends on NETCONSOLE && SYSFS && CONFIGFS_FS
+	depends on !(NETCONSOLE=y && CONFIGFS_FS=m)
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)


