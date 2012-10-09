Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JIPcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:32:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:61543 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2JIPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:32:05 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <len.brown@intel.com>, <linux-kernel@vger.kernel.org>
CC: <mark.asselstine@windriver.com>
Subject: [PATCH] tools/power: turbostat: make Makefile a bit more capable
Date: Tue, 9 Oct 2012 11:31:44 -0400
Message-ID: <1349796704-6640-1-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The turbostat Makefile is pretty simple, its output is placed in the
same directory as the source, the install rule has no concept of a
prefix or sysroot, and you can set CC to use a specific compiler but
not use the more familiar CROSS_COMPILE. By making a few minor changes
these limitations are removed while leaving the default behavior
matching what it used to be.

Example build with these changes:
make CROSS_COMPILE=i686-wrs-linux-gnu- DESTDIR=/tmp install

or from the tools directory
make CROSS_COMPILE=i686-wrs-linux-gnu- DESTDIR=/tmp turbostat_install

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
Hi,

Just throwing this out there. I am not sure there is interest in
making these changes but when packaging turbostat I am thinking
these changes can prove to be useful.

Regards,
Mark

 tools/power/x86/turbostat/Makefile |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index f856495..aa354e3 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,9 +1,21 @@
+CC              = $(CROSS_COMPILE)gcc
+BUILD_OUTPUT    := $(PWD)
+PREFIX          := /usr
+DESTDIR         :=
+
 turbostat : turbostat.c
 CFLAGS +=	-Wall
 
+%: %.c
+	@mkdir -p $(BUILD_OUTPUT)
+	$(CC) $(CFLAGS) $< -o $(BUILD_OUTPUT)/$@
+
+.PHONY : clean
 clean :
-	rm -f turbostat
+	@rm -f $(BUILD_OUTPUT)/turbostat
 
-install :
-	install turbostat /usr/bin/turbostat
-	install turbostat.8 /usr/share/man/man8
+install : turbostat
+	install -d  $(DESTDIR)$(PREFIX)/bin
+	install $(BUILD_OUTPUT)/turbostat $(DESTDIR)$(PREFIX)/bin/turbostat
+	install -d  $(DESTDIR)$(PREFIX)/share/man/man8
+	install turbostat.8 $(DESTDIR)$(PREFIX)/share/man/man8
-- 
1.7.9.5

