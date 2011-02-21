Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1BUGRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:17:15 -0500
Received: from ozlabs.org ([203.10.76.45]:44934 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1BUGRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:17:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, dtor@vmware.com,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
In-Reply-To: <1298074455.2460.85.camel@pasglop>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com> <20110217.140119.39175251.davem@davemloft.net> <20110217221957.GA11244@dtor-ws.eng.vmware.com> <20110217.142320.102554706.davem@davemloft.net> <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com> <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com> <1298074455.2460.85.camel@pasglop>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Mon, 21 Feb 2011 14:30:01 +1030
Message-ID: <87pqqmrq9q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Except that .long is 32-bit on ppc64 :-( You need .llong for 64-bit.

OK, all options suck.  Do we want the workaround or not?

Cheers,
Rusty.

Subject: module: deal with alignment issues in built-in module versions
Date: Mon, 7 Feb 2011 16:02:25 -0800
From: Dmitry Torokhov <dtor@vmware.com>

On m68k natural alignment is 2-byte boundary but we are trying to
align structures in __modver section on sizeof(void *) boundary.
This causes trouble when we try to access elements in this section
in array-like fashion when create "version" attributes for built-in
modules.

Moreover, as DaveM said, we can't reliably put structures into
independent objects, put them into a special section, and then expect
array access over them (via the section boundaries) after linking the
objects together to just "work" due to variable alignment choices in
different situations. The only solution that seems to work reliably
is to make an array of plain pointers to the objects in question and
put those pointers in the special section.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   10 +++++-----
 kernel/params.c        |    9 ++++++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 9bdf27c..9b7081a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -174,10 +174,7 @@ extern struct module __this_module;
 #define MODULE_VERSION(_version)					\
 	extern ssize_t __modver_version_show(struct module_attribute *,	\
 					     struct module *, char *);	\
-	static struct module_version_attribute __modver_version_attr	\
-	__used								\
-    __attribute__ ((__section__ ("__modver"),aligned(sizeof(void *)))) \
-	= {								\
+	static struct module_version_attribute ___modver_attr = {	\
 		.mattr	= {						\
 			.attr	= {					\
 				.name	= "version",			\
@@ -187,7 +184,10 @@ extern struct module __this_module;
 		},							\
 		.module_name	= KBUILD_MODNAME,			\
 		.version	= _version,				\
-	}
+	};								\
+	static const struct module_version_attribute			\
+	__used __attribute__ ((__section__ ("__modver")))		\
+	* __moduleparam_const __modver_attr = &___modver_attr
 #endif
 
 /* Optional firmware file (or files) needed by the module
diff --git a/kernel/params.c b/kernel/params.c
index 0da1411..09a08cb 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -821,15 +821,18 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
 	return sprintf(buf, "%s\n", vattr->version);
 }
 
-extern struct module_version_attribute __start___modver[], __stop___modver[];
+extern const struct module_version_attribute *__start___modver[];
+extern const struct module_version_attribute *__stop___modver[];
 
 static void __init version_sysfs_builtin(void)
 {
-	const struct module_version_attribute *vattr;
+	const struct module_version_attribute **p;
 	struct module_kobject *mk;
 	int err;
 
-	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
+	for (p = __start___modver; p < __stop___modver; p++) {
+		const struct module_version_attribute *vattr = *p;
+
 		mk = locate_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
