Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1EWQQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:16:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37858 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1EWQQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PqBwwLTvKKDoAYGEozDdbdf8mHSEQoewrWTGrztD7cvY3VbIWWmq0t0btm1ixkg25/
         ue/Mld8sqJ8Pv8C3I3+UJ8k1jQTkgp2EOkmk0IvfzwXJy4HY/u6i8PLeZ/5DYlKQvcat
         1MPsTpSWai/Y9tKsvGuYanKga0Np/z4l33ZfY=
Subject: [PATCH] Kconfig: add warning about permission of config file
From: hiromu <hiromu1996@gmail.com>
To: llinux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
        lacombar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 01:16:41 +0900
Message-ID: <1306167401.18840.8.camel@hiromu-MacBook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kbuild targets don't warn us about permission of the configure.
If you don't set write permission, you lose changes.
So I added warning and error.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>

Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
---
 scripts/kconfig/conf.c     |    6 ++++++
 scripts/kconfig/confdata.c |   17 +++++++++++++++++
 scripts/kconfig/gconf.c    |    4 ++++
 scripts/kconfig/lkc.h      |    1 +
 scripts/kconfig/mconf.c    |    4 ++++
 scripts/kconfig/nconf.c    |    4 ++++
 scripts/kconfig/qconf.cc   |    4 ++++
 7 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 006ad81..d93e351 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -466,6 +466,12 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	if (conf_check_permission()) {
+		fprintf(stderr,
+			"*** Permission denied to write the configuration.\n\n");
+		exit(1);
+	}
+
 	while ((opt = getopt_long(ac, av, "", long_opts, NULL)) != -1) {
 		input_mode = (enum input_mode)opt;
 		switch (opt) {
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 61c35bf..3de1fbe 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -7,6 +7,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <libgen.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -1051,3 +1052,19 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			set_all_choice_values(csym);
 	}
 }
+
+int conf_check_permission(void)
+{
+	int ret, retval = 0;
+	const char *name;
+	char *dir;
+
+	name = conf_get_configname();
+	dir = dirname((char *)name);
+
+	ret = access(dir, W_OK);
+	if (ret < 0)
+		retval = -errno;
+
+	return retval;
+}
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 4558961..3567a23 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1510,6 +1510,10 @@ int main(int ac, char *av[])
 	bind_textdomain_codeset(PACKAGE, "UTF-8");
 	textdomain(PACKAGE);
 
+	if (conf_check_permission())
+		fprintf(stderr,
+			"Warning: Permission denied to write the configuration.\n");
+
 	/* GTK stuffs */
 	gtk_set_locale();
 	gtk_init(&ac, &av);
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index febf0c9..4d20841 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -91,6 +91,7 @@ char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 void conf_set_all_new_symbols(enum conf_def_mode mode);
+int conf_check_permission(void);
 
 /* confdata.c and expr.c */
 static inline void xfwrite(const void *str, size_t len, size_t count, FILE *out)
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d433c7a..c820e05 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -803,6 +803,10 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	if (conf_check_permission())
+		fprintf(stderr,
+			"Warning: Permission denied to write the configuration.\n");
+
 	conf_parse(av[1]);
 	conf_read(NULL);
 
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index db56377..1cea031 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1491,6 +1491,10 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	if (conf_check_permission())
+		fprintf(stderr,
+			"Warning: Permission denied to write the configuration.\n");
+
 	conf_parse(av[1]);
 	conf_read(NULL);
 
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 06dd2e3..7dca7ac 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1746,6 +1746,10 @@ int main(int ac, char** av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	if (conf_check_permission())
+		fprintf(stderr,
+			"Warning: Permission denied to write the configuration.\n");
+
 #ifndef LKC_DIRECT_LINK
 	kconfig_load();
 #endif
-- 
1.7.4.1



