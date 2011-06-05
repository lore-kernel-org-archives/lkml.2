Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1FEIVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:21:31 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44816 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1FEIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:21:25 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 5 Jun 2011 01:21:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Jeff Dike <jdike@addtoit.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
        Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Disable CONFIG_CONSTRUCTORS when not needed by
 CONFIG_GCOV_KERNEL
Message-ID: <20110605082100.GA18151@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_CONSTRUCTORS controls support for running constructor functions
at kernel init time.  According to commit
b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7, gcov (CONFIG_GCOV_KERNEL)
needs this.  However, CONFIG_CONSTRUCTORS currently defaults to y, with
no option to disable it, and CONFIG_GCOV_KERNEL depends on it.  Instead,
default it to n and have CONFIG_GCOV_KERNEL select it, so that the
normal case of CONFIG_GCOV_KERNEL=n will result in
CONFIG_CONSTRUCTORS=n.

Observed in the short list of =y values in a minimal kernel
configuration.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
CCing people copied on the original commit
b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7.

 init/Kconfig        |    1 -
 kernel/gcov/Kconfig |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..e9bf65f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -19,7 +19,6 @@ config DEFCONFIG_LIST
 config CONSTRUCTORS
 	bool
 	depends on !UML
-	default y
 
 config HAVE_IRQ_WORK
 	bool
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index b8cadf7..5bf924d 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -2,7 +2,8 @@ menu "GCOV-based kernel profiling"
 
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
-	depends on DEBUG_FS && CONSTRUCTORS
+	depends on DEBUG_FS
+	select CONSTRUCTORS
 	default n
 	---help---
 	This option enables gcov-based code profiling (e.g. for code coverage
-- 
1.7.5.3

