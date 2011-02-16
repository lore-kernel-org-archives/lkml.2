Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1BPAZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:00 -0500
Received: from kroah.org ([198.145.64.141]:49730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab1BPAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.290808338@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Whitcroft <apw@canonical.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [232/272] Input: sysrq - ensure sysrq_enabled and __sysrq_enabled are consistent
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Whitcroft <apw@canonical.com>

commit 8c6a98b22b750c9eb52653ba643faa17db8d3881 upstream.

Currently sysrq_enabled and __sysrq_enabled are initialised separately
and inconsistently, leading to sysrq being actually enabled by reported
as not enabled in sysfs.  The first change to the sysfs configurable
synchronises these two:

    static int __read_mostly sysrq_enabled = 1;
    static int __sysrq_enabled;

Add a common define to carry the default for these preventing them becoming
out of sync again.  Default this to 1 to mirror previous behaviour.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/tty/sysrq.c   |    2 +-
 include/linux/sysrq.h |    3 +++
 kernel/sysctl.c       |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -46,7 +46,7 @@
 #include <asm/irq_regs.h>
 
 /* Whether we react on sysrq keys or just ignore them */
-static int __read_mostly sysrq_enabled = 1;
+static int __read_mostly sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 static bool __read_mostly sysrq_always_enabled;
 
 static bool sysrq_on(void)
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -17,6 +17,9 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
+/* Enable/disable SYSRQ support by default (0==no, 1==yes). */
+#define SYSRQ_DEFAULT_ENABLE	1
+
 /* Possible values of bitmask for enabling sysrq functions */
 /* 0x0001 is reserved for enable everything */
 #define SYSRQ_ENABLE_LOG	0x0002
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -169,7 +169,8 @@ static int proc_taint(struct ctl_table *
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
-static int __sysrq_enabled; /* Note: sysrq code ises it's own private copy */
+/* Note: sysrq code uses it's own private copy */
+static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 
 static int sysrq_sysctl_handler(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,


