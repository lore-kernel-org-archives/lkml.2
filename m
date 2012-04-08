Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2DHWit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:38:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63241 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2DHWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:38:33 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>
Subject: =?y?q?=5BPATCH=202/2=5D=20bug=2Eh=3A=20add=20test/demo=20module?=
Date: Sun,  8 Apr 2012 16:38:18 -0600
Message-Id: <1333924698-3894-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add drivers/misc/build-asserts.c to test BUILD_BUG_DECL.

BUILD_BUG_DECL works as intended, but __attribute((unused)) appears to
be ineffective in the macro:

Code run at __init time is able to reference the storage w/o warnings
(no section complaints, even though those functions are not explicitly
marked as __init - I guess thats inferred..).

Code run from mod-param getter/setter callbacks pukes badly.
I guess this is to be expected, since __initdata is dropped
once boot is complete.  But why no compile warnings ??

root@voyage:~# cat /sys/module/build_asserts/parameters/*
build_asserts.cbint_get: got bufp:c65cd000='' kp:c8bb967c
build_asserts.cbint_get: kp-name:cbint
build_asserts.cbint_get: kp-arg:c8bb9113
build_asserts.cbint_get: kp-ops:c8bb973c
build_asserts.cbint_get: kp-ops-set:c8bb9179
build_asserts.cbint_get: kp-ops-get:c8bb9000
build_asserts.cbint_get: cbint_get me:c8bb9000
BUG: unable to handle kernel paging request at c8bbb000
IP: [<c8bb90d8>] cbint_get+0xd8/0x113 [build_asserts]
*pde = 06c76067 *pte = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: build_asserts scx200_gpio scx200_hrt pc8736x_gpio nsc_gpio pc87360 hwmon_vid scx200_acb acx_mac80211(O) arc4 rtl8180 mac80211 eeprom_93cx6 scx200 cfg80211 ohci_hcd pata_sc1200 [last unloaded: build_asserts]

Pid: 1364, comm: cat Tainted: G           O 3.4.0-rc1-ske+ #24
EIP: 0060:[<c8bb90d8>] EFLAGS: 00010282 CPU: 0
EIP is at cbint_get+0xd8/0x113 [build_asserts]
EAX: 00000035 EBX: c65cd000 ECX: c7450000 EDX: 00000003
ESI: c8bb967c EDI: c65cd000 EBP: c7451efc ESP: c7451ee0
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: c8bbb000 CR3: 066b7000 CR4: 00000000
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process cat (pid: 1364, ti=c7450000 task=c6524f80 task.ti=c7450000)
Stack:
 c8bb945e c8bb96bc c8bb9000 c65cd000 c8bb967c ffffffff c675c270 c7451f10
 c012f536 c675c270 c8bb9790 c012f503 c7451f24 c012f35b c6507740 c60deb40
 c043eb28 c7451f70 c02010d5 c6753680 00000000 c7451f44 c027fe90 c6753680
Call Trace:
 [<c8bb9000>] ? 0xc8bb8fff
 [<c012f536>] param_attr_show+0x33/0x57
 [<c012f503>] ? __kernel_param_unlock+0x14/0x14
 [<c012f35b>] module_attr_show+0x21/0x26
 [<c02010d5>] sysfs_read_file+0x9e/0x154
 [<c027fe90>] ? security_file_permission+0x27/0x2b
 [<c01bb5ee>] ? rw_verify_area+0xd0/0xf2
 [<c01bb956>] vfs_read+0x8d/0xd3
 [<c0201037>] ? sysfs_open_file+0x1fa/0x1fa
 [<c01bb9de>] sys_read+0x42/0x63
 [<c043592c>] syscall_call+0x7/0xb
Code: 04 24 3a 94 bb c8 89 44 24 08 e8 89 7c 87 f7 c7 44 24 08 00 90 bb c8 c7 44 24 04 bc 96 bb c8 c7 04 24 5e 94 bb c8 e8 6d 7c 87 f7 <a1> 00 b0 bb c8 c7 44 24 04 bc 96 bb c8 89 44 24 0c 89 44 24 08
EIP: [<c8bb90d8>] cbint_get+0xd8/0x113 [build_asserts] SS:ESP 0068:c7451ee0
CR2: 00000000c8bbb000
---[ end trace bfbcc6aee803d03b ]---

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/misc/Makefile        |    2 +
 drivers/misc/build-asserts.c |  239 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/build-asserts.c

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3e1d8010..5aff6bb 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -49,3 +49,5 @@ obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
+
+obj-m			+= build-asserts.o
diff --git a/drivers/misc/build-asserts.c b/drivers/misc/build-asserts.c
new file mode 100644
index 0000000..95e8567
--- /dev/null
+++ b/drivers/misc/build-asserts.c
@@ -0,0 +1,239 @@
+
+#define pr_fmt(fmt)  KBUILD_MODNAME ".%s: " fmt, __FUNCTION__
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/stringify.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+int a[] = {1,2,3,4};
+int b[] = {1,2,3,5};
+int c[] = {3,5};
+long d[] = {1,2};
+
+const char *names[] = { "bart", "lisa", "homer", "marge" };
+
+struct bridge {
+	int member_ids[4];
+	char *names[4];
+	char *snacks[3];	// hungry ?
+} clubs[4];
+
+BUILD_BUG_DECL(foo, ARRAY_SIZE(a) != ARRAY_SIZE(b));
+BUILD_BUG_DECL(buz, sizeof(a) != sizeof(b));		// good
+// BUILD_BUG_DECL(a, sizeof(a) != sizeof(d));		// brittle
+BUILD_BUG_DECL(b, ARRAY_SIZE(a) != ARRAY_SIZE(names));	// good, on different types
+
+// BUILD_BUG_DECL(d, ARRAY_SIZE(a) != ARRAY_SIZE(d));	// compile err, correct
+// BUILD_BUG_DECL(bonk, sizeof(a) != sizeof(names));	// breaks, correct
+// BUILD_BUG_DECL(ac, sizeof(a) != sizeof(c));		// err
+
+
+BUILD_BUG_DECL(joe, ARRAY_SIZE(a) != ARRAY_SIZE(clubs));
+BUILD_BUG_DECL(bob, ARRAY_SIZE(a) != ARRAY_SIZE(clubs[0].member_ids));
+BUILD_BUG_DECL(mike, ARRAY_SIZE(a) != ARRAY_SIZE(clubs[0].names));
+
+// BUILD_BUG_DECL(sue, ARRAY_SIZE(a) != ARRAY_SIZE(clubs[0].snacks));
+// cant use typeof like this
+// BUILD_BUG_DECL(ike, typeof(clubs[0].snacks) != typeof(clubs[0].names));
+
+union {
+	int a;
+	long b;
+	char c;
+	char *s;
+	int arr[4];
+} pba;
+
+// these cause warning at file scope, but ok inside fn.
+// warning: variably modified ‘field’ at file scope [enabled by default]
+// BUILD_BUG_DECL(x, (void*)&pba.a != (void*)&pba.b);
+// BUILD_BUG_DECL(y, (void*)&pba.a != (void*)&pba.c);
+
+int cmp_ints(int sz, int *arg1, int *arg2)
+{
+	int i;
+
+	// NG: compiler doesnt know the arrays passed.
+	// BUILD_BUG_DECL(y, ARRAY_SIZE(*arg1) != ARRAY_SIZE(*arg2));
+
+	pr_notice("all equal ?\n");
+	for (i=0; i<sz; i++) {
+		pr_notice("%d ?= %d\n", arg1[i], arg2[i]);
+		if (arg1[i] != arg2[i]) {
+			pr_notice("nope\n");
+			return 1;
+		}
+	}
+	pr_notice("yup\n");
+	i = BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0];
+	pr_notice("i-mike %d\n", i);
+	return 0;
+}
+
+// ok, but hmm
+BUILD_BUG_DECL(fn, sizeof(cmp_ints) != sizeof(cmp_ints));
+
+int use_cmp_ints(void)
+{
+	int i = 20, j = 30;
+
+	BUILD_BUG_DECL(foo, ARRAY_SIZE(a) != ARRAY_SIZE(b));
+	BUILD_BUG_DECL(a, (void*)&pba.a != (void*)&pba.b);
+
+	pr_notice("hello\n");
+	cmp_ints(4, a, b);
+
+	pr_notice("i:%d j:%d\n", i, j);
+
+	// derefs w/o error !!
+	i = BUILD_BUG_DECL_a[0].BUILD_BUG_DECL_a[0];
+	j = BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0];
+
+	pr_notice("access a? %d, %d\n", i,
+		BUILD_BUG_DECL_a[0].BUILD_BUG_DECL_a[0]);
+	pr_notice("access mike? %d, %d\n", i,
+		BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0]);
+
+	//BUILD_BUG_DECL_a[0].a_sizecheck = 1;
+	return 0;
+}
+// ok, but obviously useless
+BUILD_BUG_DECL(fn2, sizeof(cmp_ints) != sizeof(use_cmp_ints));
+
+/*
+  for some reason, refs to BUILD_BUG_DECL_* declarations works in
+  *cmp_ints(), despite unused attribute and placement in __initdata.
+  Maybe this is cuz *cmp_ints() is (so far) called from module_init,
+  where it should work.
+
+  So code below adds mod-params and getter/setters to try to invoke it
+  during runtime, to see what happens.
+
+  Apparently what happens is kernel fault.  That makes some sense
+  given that __init is no longer current, and has been dropped.  But
+  why is referencing initdata not flagged by compiler ??
+
+root@voyage:~# cat /sys/module/build_asserts/parameters/*
+build_asserts.cbint_get: got bufp:c65cd000='' kp:c8bb967c
+build_asserts.cbint_get: kp-name:cbint
+build_asserts.cbint_get: kp-arg:c8bb9113
+build_asserts.cbint_get: kp-ops:c8bb973c
+build_asserts.cbint_get: kp-ops-set:c8bb9179
+build_asserts.cbint_get: kp-ops-get:c8bb9000
+build_asserts.cbint_get: cbint_get me:c8bb9000
+BUG: unable to handle kernel paging request at c8bbb000
+IP: [<c8bb90d8>] cbint_get+0xd8/0x113 [build_asserts]
+*pde = 06c76067 *pte = 00000000
+Oops: 0000 [#1] PREEMPT
+Modules linked in: build_asserts scx200_gpio scx200_hrt pc8736x_gpio nsc_gpio pc87360 hwmon_vid scx200_acb acx_mac80211(O) arc4 rtl8180 mac80211 eeprom_93cx6 scx200 cfg80211 ohci_hcd pata_sc1200 [last unloaded: build_asserts]
+
+Pid: 1364, comm: cat Tainted: G           O 3.4.0-rc1-ske+ #24
+EIP: 0060:[<c8bb90d8>] EFLAGS: 00010282 CPU: 0
+EIP is at cbint_get+0xd8/0x113 [build_asserts]
+EAX: 00000035 EBX: c65cd000 ECX: c7450000 EDX: 00000003
+ESI: c8bb967c EDI: c65cd000 EBP: c7451efc ESP: c7451ee0
+ DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
+CR0: 8005003b CR2: c8bbb000 CR3: 066b7000 CR4: 00000000
+DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
+DR6: ffff0ff0 DR7: 00000400
+Process cat (pid: 1364, ti=c7450000 task=c6524f80 task.ti=c7450000)
+Stack:
+ c8bb945e c8bb96bc c8bb9000 c65cd000 c8bb967c ffffffff c675c270 c7451f10
+ c012f536 c675c270 c8bb9790 c012f503 c7451f24 c012f35b c6507740 c60deb40
+ c043eb28 c7451f70 c02010d5 c6753680 00000000 c7451f44 c027fe90 c6753680
+Call Trace:
+ [<c8bb9000>] ? 0xc8bb8fff
+ [<c012f536>] param_attr_show+0x33/0x57
+ [<c012f503>] ? __kernel_param_unlock+0x14/0x14
+ [<c012f35b>] module_attr_show+0x21/0x26
+ [<c02010d5>] sysfs_read_file+0x9e/0x154
+ [<c027fe90>] ? security_file_permission+0x27/0x2b
+ [<c01bb5ee>] ? rw_verify_area+0xd0/0xf2
+ [<c01bb956>] vfs_read+0x8d/0xd3
+ [<c0201037>] ? sysfs_open_file+0x1fa/0x1fa
+ [<c01bb9de>] sys_read+0x42/0x63
+ [<c043592c>] syscall_call+0x7/0xb
+
+ */
+
+int decl_user(void)
+{
+	// BUILD_BUG_DECL(ac, sizeof(a) != sizeof(c));	// errors, properly
+
+	// no complaints testing the union from here.
+	BUILD_BUG_DECL(x, (void*)&pba.a != (void*)&pba.c);
+	// fine for use inside a struct
+	BUILD_BUG_DECL(y, ARRAY_SIZE(clubs[1].names)
+		       != ARRAY_SIZE(clubs[0].member_ids));
+
+	return 0;
+}
+
+// not usable as a mod-param, boot-only I guess
+// also, gives unused warning at compile ?
+static int __init bar_setup(char *str)
+{
+	pr_notice("bar setup: %s\n", str);
+	decl_user();
+	use_cmp_ints();
+	return 1;
+}
+__setup("bar=", bar_setup);
+
+static int cbvar = 0;
+static int cbint_set(const char *val, const struct kernel_param *kp)
+{
+	int i;
+	int err = param_set_int(val, kp);
+
+	pr_notice("err: %d val:%s", err, val);
+        if (err)
+                return err;
+
+	i = BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0];
+	pr_notice("access mike? %d, %d\n", i,
+		BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0]);
+
+        return 0;
+}
+static int cbint_get(char *buffer, const struct kernel_param *kp)
+{
+	int i;
+
+        pr_notice("got bufp:%p='%s' kp:%p\n", buffer, buffer, kp);
+        pr_notice("kp-name:%s\n", kp->name);
+        pr_notice("kp-arg:%p\n", kp->arg);
+        pr_notice("kp-ops:%p\n", kp->ops);
+        pr_notice("kp-ops-set:%p\n", kp->ops->set);
+        pr_notice("kp-ops-get:%p\n", kp->ops->get);
+        pr_notice("cbint_get me:%p\n", &cbint_get);
+
+	i = BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0];
+	pr_notice("access mike? %d, %d\n", i,
+		BUILD_BUG_DECL_mike[0].BUILD_BUG_DECL_mike[0]);
+
+	strcpy(buffer, "hello from cbint_get");
+        return strlen(buffer);
+}
+static struct kernel_param_ops cbint_ops = {
+        .set = cbint_set,
+        .get = cbint_get,  // need one, no default provided
+};
+module_param_cb(cbint, &cbint_ops, cbint_cb, 0644);
+
+static int fooint;
+module_param_named(foo, fooint, int, 0644);
+
+void myexit(void)
+{
+	pr_notice("bye\n");
+}
+
+module_init(use_cmp_ints);
+module_exit(myexit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("jim.cromie@gmail.com");
+MODULE_DESCRIPTION("test BUILD_BUG_DECL");
-- 
1.7.7.6

