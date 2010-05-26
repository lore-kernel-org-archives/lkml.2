Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0EZMcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:32:25 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:62841 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0EZMcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:32:23 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 08:32:23 EDT
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=hkPdy95mig8VtHFTEM4Li1Ia7UOcmzH1jd1Qui7ld/wEiGNblRSxuZpuDNvxFy7fH9++TJnbB50AxvOoxLFGQDAfGOgvfn8to5HGPNDHfyycp8jL7SZmxMyFV1c1kU87oqnFtN1iJpppjH+Ujaf6dV1DiWOykbeguFp/hw7N/cI=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: [PATCH] dynamic_debug: allow to set dynamic debug flags right at module load time
User-Agent: KMail/1.13.3 (Linux/2.6.31.12-0.2-default; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <201005261425.39058.roman.fietze@telemotive.de>
Date: Wed, 26 May 2010 14:25:38 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 26.05.2010 14:25:39,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 26.05.2010 14:25:39,
	Serialize complete at 26.05.2010 14:25:39
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason, hello list,

If I'm not wrong one could only enable any dynamic debugging flag
after a module had been completely loaded, using debugfs. This makes
it impossible to use dev_dbg or pr_debug e.g. inside the module init
function or any function called by it.

My patch works by replacing _DPRINTK_FLAGS_DEFAULT after including all
kernel headers in my module source file and some small patch inside
dynamic_debug.c setting up the internal variables already when loading
a module with flags unequal to zero. This patch can of course be
optimized somewhat by reusing existing variables.

Subject: [PATCH] dynamic_debug: allow to set dynamic debug flags right at module load time

This allows to use e.g. pr_debug right from the beginning, e.g. in the
module init function.

- the module must redefine _DPRINTK_FLAGS_DEFAULT, e.g.

  #undef _DPRINTK_FLAGS_DEFAULT
  #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT

- when a module is loaded and the flags are not zero, the enabled
  count and hash masks are enabled right away

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 lib/dynamic_debug.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d6b8b9b..d10466e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -656,6 +656,8 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 {
 	struct ddebug_table *dt;
 	char *new_name;
+	size_t i;
+	char flagbuf[8];
 
 	dt = kzalloc(sizeof(*dt), GFP_KERNEL);
 	if (dt == NULL)
@@ -671,6 +673,22 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 	dt->ddebugs = tab;
 
 	mutex_lock(&ddebug_lock);
+	for (i = 0 ; i < dt->num_ddebugs ; i++) {
+		struct _ddebug *dp = &dt->ddebugs[i];
+
+		if (dp->flags) {
+			dt->num_enabled++;
+			dynamic_debug_enabled |= (1LL << dp->primary_hash);
+			dynamic_debug_enabled2 |= (1LL << dp->secondary_hash);
+			if (verbose)
+				printk(KERN_INFO
+					"ddebug: added %s:%d [%s]%s %s\n",
+					dp->filename, dp->lineno,
+					dt->mod_name, dp->function,
+					ddebug_describe_flags(dp, flagbuf,
+							sizeof(flagbuf)));
+		}
+	}
 	list_add_tail(&dt->link, &ddebug_tables);
 	mutex_unlock(&ddebug_lock);
 
-- 
1.7.1


-- 
Roman Fietze                Telemotive AG Büro Mühlhausen
Breitwiesen                              73347 Mühlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
