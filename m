Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab1BZAom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:44:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab1BZAol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:44:41 -0500
Message-ID: <4D684CF5.2060206@suse.com>
Date: Fri, 25 Feb 2011 19:44:37 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] kconfig: add support for type handlers
References: <4D671556.80607@suse.com> <20110225060706.GA12723@merkur.ravnborg.org>
In-Reply-To: <20110225060706.GA12723@merkur.ravnborg.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch adds type handlers for compressed config files. Initial
 support provides callouts for gzip and bzip2, but there's no reason
 others could be added if demand is there.

 This is intended to allow /proc/config.gz be a configuration source
 for 'make oldconfig' when .config is absent.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 scripts/kconfig/zconf.l |   50 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -256,6 +256,44 @@ static void zconf_endhelp(void)
 	BEGIN(INITIAL);
 }
 
+static const struct type_handler {
+	const char *suffix;
+	const char *command;
+} type_handlers[] = {
+	{
+		.suffix = ".gz",
+		.command = "zcat",
+	},
+	{
+		.suffix = ".bz2",
+		.command = "bzcat",
+	},
+	/* Whatever other algorithms you like */
+	{}
+};
+
+static const struct type_handler *get_type_handler(const char *name)
+{
+	char *p = rindex(name, '.');
+	if (p) {
+		const struct type_handler *ops = type_handlers;
+		for (ops = type_handlers; ops->suffix; ops++) {
+			if (!strcasecmp(ops->suffix, p))
+				break;
+		}
+		if (!ops->suffix)
+			return NULL;
+		return ops;
+	}
+	return NULL;
+}
+
+static FILE *zconf_popen(const char *command, const char *name)
+{
+	char cmdbuf[PATH_MAX + strlen(command) + 2];
+	snprintf(cmdbuf, sizeof(cmdbuf), "%s %s", command, name);
+	return popen(cmdbuf, "r");
+}
 
 /*
  * Try to open specified file with following names:
@@ -267,15 +305,23 @@ static void zconf_endhelp(void)
  */
 FILE *zconf_fopen(const char *name)
 {
+	const struct type_handler *handler = get_type_handler(name);
 	char *env, fullname[PATH_MAX+1];
 	FILE *f;
 
-	f = fopen(name, "r");
+	if (handler)
+		f = zconf_popen(handler->command, name);
+	else
+		f = fopen(name, "r");
+
 	if (!f && name != NULL && name[0] != '/') {
 		env = getenv(SRCTREE);
 		if (env) {
 			sprintf(fullname, "%s/%s", env, name);
-			f = fopen(fullname, "r");
+			if (handler)
+				f = zconf_popen(handler->command, fullname);
+			else
+				f = fopen(fullname, "r");
 		}
 	}
 	return f;

-- 
Jeff Mahoney
SUSE Labs
