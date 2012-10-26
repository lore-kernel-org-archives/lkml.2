Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966634Ab2JZVzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:55:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40766 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964787Ab2JZVzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:55:44 -0400
Date: Fri, 26 Oct 2012 14:55:33 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: [PATCH] Yama: enable link restrictions when selected
Message-ID: <20121026215533.GA10402@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Systems running with Yama enabled expect restrictions on various
potentially dangerous operations that could create backward-compaibility
issues with rare userspace corner-cases. Since 561ec64ae67e ("VFS:
don't do protected {sym,hard}links by default") has disabled VFS link
restrictions by default, enable them for systems using Yama.

Cc: stable@vger.kernel.org # v3.6
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/yama/Kconfig    |    4 +++-
 security/yama/yama_lsm.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/yama/Kconfig b/security/yama/Kconfig
index 20ef514..2a91598 100644
--- a/security/yama/Kconfig
+++ b/security/yama/Kconfig
@@ -8,7 +8,9 @@ config SECURITY_YAMA
 	  This selects Yama, which extends DAC support with additional
 	  system-wide security settings beyond regular Linux discretionary
 	  access controls. Currently available is ptrace scope restriction.
-	  Further information can be found in Documentation/security/Yama.txt.
+	  Enables the VFS link restriction sysctls (protected_symlinks and
+	  protected_hardlinks) by default. Further information can be found
+	  in Documentation/security/Yama.txt.
 
 	  If you are unsure how to answer this question, answer N.
 
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index b4c2984..3bef1c1 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -17,6 +17,7 @@
 #include <linux/ptrace.h>
 #include <linux/prctl.h>
 #include <linux/ratelimit.h>
+#include <linux/fs.h>
 
 #define YAMA_SCOPE_DISABLED	0
 #define YAMA_SCOPE_RELATIONAL	1
@@ -397,6 +398,10 @@ static __init int yama_init(void)
 		panic("Yama: sysctl registration failed.\n");
 #endif
 
+	/* Enable link restrictions when Yama is enabled. */
+	sysctl_protected_symlinks = 1;
+	sysctl_protected_hardlinks = 1;
+
 	return 0;
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
