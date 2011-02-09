Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1BIAxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:53:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1BIAxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:user-agent;
        b=Ut0Z8dFgvvxno6Afu+GgJuB6kfGAWdqkkziXI6z8przaBRpTk6N1CC9r3hSAzDLJRo
         mtUMCrz+rhHyP8OKoJZg==
Date: Tue, 8 Feb 2011 16:52:31 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, msb@chromium.org, mingo@elte.hu,
        olofj@chromium.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110209005231.GE632@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208135618.b3a849fb.akpm@linux-foundation.org>
X-Operating-System: Linux/2.6.32-gg370-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 08 Feb 2011 13:52:51 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > On Tue, 2011-02-08 at 13:49 -0800, akpm@linux-foundation.org wrote:
> > > The patch titled
> > >      printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
> > > has been removed from the -mm tree.
> > > This patch was dropped because it had testing failures
> > 
> > The patch seems pretty simple.
> > What kind of testing failures did it have?
> > 
> 
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL undefined with CONFIG_PRINTK=n (Randy)

D'oh. Fixed.

---

We've been burned by regressions/bugs which we later realized could have
been triaged quicker if only we'd paid closer attention to dmesg.  To make
it easier to audit dmesg, we'd like to make DEFAULT_MESSAGE_LEVEL
Kconfig-settable.  That way we can set it to KERN_NOTICE and audit any
messages <= KERN_WARNING.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/printk.c   |    2 +-
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2ddbdc7..bddeee8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -53,7 +53,7 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
 /* We show everything that is MORE important than this.. */
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3967c23..bd1760c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -9,6 +9,17 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config DEFAULT_MESSAGE_LOGLEVEL
+	int "Default message log level (1-7)"
+	range 1 7
+	default "4"
+	help
+	  Default log level for printk statements with no specified priority.
+
+	  This was hard-coded to KERN_WARNING since at least 2.6.10 but folks
+	  that are auditing their logs closely may want to set it to a lower
+	  priority.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.7.3.1

