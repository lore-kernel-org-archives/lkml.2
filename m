Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0H3GEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:04:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:24141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0H3GEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:04:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,290,1280732400"; 
   d="scan'208";a="652495555"
Subject: Re: linux-next: build warnings in Linus' tree
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100830114222.3a1f53e6.sfr@canb.auug.org.au>
References: <20100817112439.18f9d958.sfr@canb.auug.org.au>
	 <20100830114222.3a1f53e6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 14:08:02 +0800
Message-ID: <1283148482.3707.167.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 09:42 +0800, Stephen Rothwell wrote:
> Hi Len,
> 
> On Tue, 17 Aug 2010 11:24:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_param' from incompatible pointer type
> > include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, struct kernel_param *)' but argument is of type 'int (*)(const char *, const struct kernel_param *)'
> > 
> > Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACPI:
> > introduce drivers/acpi/sysfs.c") interacting with commit
> > 9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
> > kernel_param, rather than get and set fns directly").
> 
> Can we have this fixed, please?
patch attached. :)

Use module_param_cb instead of the obsoleted module_param_call to fix a build warning.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/sysfs.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/acpi/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sysfs.c
+++ linux-2.6/drivers/acpi/sysfs.c
@@ -100,7 +100,7 @@ static const struct acpi_dlevel acpi_deb
 	ACPI_DEBUG_INIT(ACPI_LV_EVENTS),
 };
 
-static int param_get_debug_layer(char *buffer, struct kernel_param *kp)
+static int param_get_debug_layer(char *buffer, const struct kernel_param *kp)
 {
 	int result = 0;
 	int i;
@@ -128,7 +128,7 @@ static int param_get_debug_layer(char *b
 	return result;
 }
 
-static int param_get_debug_level(char *buffer, struct kernel_param *kp)
+static int param_get_debug_level(char *buffer, const struct kernel_param *kp)
 {
 	int result = 0;
 	int i;
@@ -149,10 +149,18 @@ static int param_get_debug_level(char *b
 	return result;
 }
 
-module_param_call(debug_layer, param_set_uint, param_get_debug_layer,
-		  &acpi_dbg_layer, 0644);
-module_param_call(debug_level, param_set_uint, param_get_debug_level,
-		  &acpi_dbg_level, 0644);
+static struct kernel_param_ops param_ops_debug_layer = {
+	.set = param_set_uint,
+	.get = param_get_debug_layer,
+};
+
+static struct kernel_param_ops param_ops_debug_level = {
+	.set = param_set_uint,
+	.get = param_get_debug_level,
+};
+
+module_param_cb(debug_layer, &param_ops_debug_layer, &acpi_dbg_layer, 0644);
+module_param_cb(debug_level, &param_ops_debug_level, &acpi_dbg_level, 0644);
 
 static char trace_method_name[6];
 module_param_string(trace_method_name, trace_method_name, 6, 0644);



