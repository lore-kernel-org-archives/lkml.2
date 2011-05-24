Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1EXRim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:38:42 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:50823 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab1EXRil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HYBzXK1SxogaA/vazN7Gor01njYRQclekKX5HJDFpLV87fI2Q6dfDvtHDFpV5aGyal
         Tq/RCXUS4hwrDrKSHaRb8XVWz/XQXCXKGG2dCe2mfPCWXDcq6VP00qLkqoj6ra9ZNrgU
         3PstkflgNndleqoIumG0IcmzkMGa9IDeeUuUE=
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Hiromu Yakura <hiromu1996@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
In-Reply-To: <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
	 <1306242400.7501.10.camel@hiromu-MacBook> <4DDBB150.2090602@suse.cz>
	 <1306247192.7501.25.camel@hiromu-MacBook> <4DDBC846.8050402@suse.cz>
	 <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 02:38:36 +0900
Message-ID: <1306258716.7501.35.camel@hiromu-MacBook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011, at 0:50, Arnaud Lacombe <lacombar@gmail.com>
wrote:
> On Tue, May 24, 2011 at 11:01 AM, Michal Marek <mmarek@suse.cz> wrote:
> > I see, qconf lacks a check for the return value of conf_write() in
> > ConfigMainWindow::closeEvent(), gconf does check the return value, but only
> > displays it in the bottom box of the main window instead of a message box.
> > Neither of them return failure in the error case. These bugs should be
> > indeed fixed.
> >
> agree.
> 
> > But I don't like the directory permission check, it only
> > handles one case, but does not handle permission on the .config file itself
> > with KCONFIG_OVERWRITECONFIG=1, ENOSPC and so on.
> >
> seconded.
I'm sorry for forgetting to handle a case which was set KCONFIG_OVERWRITECONFIG.
So I rewrote the patch and attach it.

Thanks for your advice.

Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
---
 scripts/kconfig/conf.c     |    6 ++++++
 scripts/kconfig/confdata.c |   24 ++++++++++++++++++++++++
 scripts/kconfig/gconf.c    |    4 ++++
 scripts/kconfig/lkc.h      |    1 +
 scripts/kconfig/mconf.c    |    4 ++++
 scripts/kconfig/nconf.c    |    4 ++++
 scripts/kconfig/qconf.cc   |    4 ++++
 7 files changed, 47 insertions(+), 0 deletions(-)

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
index 61c35bf..2070ac0 100644
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
@@ -1051,3 +1052,26 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			set_all_choice_values(csym);
 	}
 }
+
+int conf_check_permission(void)
+{
+	int ret, retval = 0;
+	const char *name;
+	char *dir, *env;
+
+	name = conf_get_configname();
+
+	env = getenv("KCONFIG_OVERWRITECONFIG");
+	if (!env || !*env) {
+		dir = dirname((char *)name);
+		ret = access(dir, W_OK);
+		if (ret < 0)
+			retval = -errno;
+	} else {
+		ret = access(name, W_OK);
+		if (ret < 0)
+			retval = -errno;
+	}
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



