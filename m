Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0F3Ais (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:38:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54710 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0F3Aip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:38:45 -0400
Date: Tue, 29 Jun 2010 17:38:44 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100630003844.GE4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The primary exception to Yama's descendant-based PTRACE restrictions
is when an application has a predefined crash handler that is spawned
in parallel with the crashed application (e.g. KDE, Chromium).  These
applications want to bypass the common RLIMIT_CORE=0, and gather state
information from the process for upstream problem reporting.  When the
main application crashes, it generally has access to the PID of what
will debug it (e.g. when a KDE app crashes, it knows the parent PID of
the debugger that will be spawned).

So, since this programmatic method of PTRACEing is useful, there should be
a way for processes to actively declare who can PTRACE them.  This patch
adds a prctl hook for Yama so that processes can exempt themselves from
the PTRACE restrictions in the case of a crash when they know their
debugger's PID.

As a matter of demonstration, here is what the patch to KDE4 would look
like to support Yama, or other PTRACE-restricting LSMs that wanted to grant
a similar exception:

--- kde4libs-4.4.90.orig/kdeui/util/kcrash.cpp	2010-06-28 17:07:28.667869954 -0700
+++ kde4libs-4.4.90/kdeui/util/kcrash.cpp	2010-06-28 17:09:32.089958401 -0700
@@ -41,6 +41,7 @@
 #include <sys/wait.h>
 #include <sys/un.h>
 #include <sys/socket.h>
+#include <sys/prctl.h>
 #include <errno.h>
 
 #include <qwindowdefs.h>
@@ -437,6 +438,7 @@
             //if the process was started directly, use waitpid(), as it's a child...
             while(waitpid(-1, NULL, 0) != pid) {}
         } else {
+            prctl(PR_SET_PTRACER, pid, 0, 0, 0);
             //...else poll its status using kill()
             while(kill(pid, 0) >= 0) {
                 sleep(1);


-- 
Kees Cook
Ubuntu Security Team
