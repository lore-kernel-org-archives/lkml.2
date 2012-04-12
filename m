Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966332Ab2DLXrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:47:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:60695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966260Ab2DLXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:47:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        sfr@canb.auug.org.au, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/3] kconfig: fix IS_ENABLED to not require all options to be defined
Date: Thu, 12 Apr 2012 19:46:32 -0400
Message-Id: <1334274394-13466-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com>
References: <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com>
 <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using IS_ENABLED() within C (vs. within CPP #if statements) in its
current form requires us to actually define every possible bool/tristate
Kconfig option twice (__enabled_* and __enabled_*_MODULE variants).

This results in a huge autoconf.h file, on the order of 16k lines
for a x86_64 defconfig.

Fixing IS_ENABLED to be able to work on the smaller subset of just
things that we really have defined is step one to fixing this.  Which
means it has to not choke when fed non-enabled options, such as:

  include/linux/netdevice.h:964:1: warning: "__enabled_CONFIG_FCOE_MODULE" is not defined [-Wundef]

The original prototype of how to implement a C and preprocessor
compatible way of doing this came from the Google+ user "comex ."
in response to Linus' crowdsourcing challenge for a possible
improvement on his earlier C specific solution:

	#define config_enabled(x)       (__stringify(x)[0] == '1')

In this implementation, I've chosen variable names that hopefully
make how it works more understandable.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/kconfig.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index 067eda0..be342b9 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -4,29 +4,43 @@
 #include <generated/autoconf.h>
 
 /*
- * Helper macros to use CONFIG_ options in C expressions. Note that
+ * Helper macros to use CONFIG_ options in C/CPP expressions. Note that
  * these only work with boolean and tristate options.
  */
 
 /*
+ * Getting something that works in C and CPP for an arg that may or may
+ * not be defined is tricky.  Here, if we have "#define CONFIG_BOOGER 1"
+ * we match on the placeholder define, insert the "0," for arg1 and generate
+ * the triplet (0, 1, 0).  Then the last step cherry picks the 2nd arg (a one).
+ * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
+ * the last step cherry picks the 2nd arg, we get a zero.
+ */
+#define __ARG_PLACEHOLDER_1 0,
+#define config_enabled(cfg) _config_enabled(cfg)
+#define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
+#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
+#define ___config_enabled(__ignored, val, ...) val
+
+/*
  * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
  * 0 otherwise.
  *
  */
 #define IS_ENABLED(option) \
-	(__enabled_ ## option || __enabled_ ## option ## _MODULE)
+	(config_enabled(option) || config_enabled(option##_MODULE))
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
  * otherwise. For boolean options, this is equivalent to
  * IS_ENABLED(CONFIG_FOO).
  */
-#define IS_BUILTIN(option) __enabled_ ## option
+#define IS_BUILTIN(option) config_enabled(option)
 
 /*
  * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
  * otherwise.
  */
-#define IS_MODULE(option) __enabled_ ## option ## _MODULE
+#define IS_MODULE(option) config_enabled(option##_MODULE)
 
 #endif /* __LINUX_KCONFIG_H */
-- 
1.7.9.1

