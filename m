Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1HWGAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:00:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab1HWGAL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:00:11 -0400
Subject: [PATCH] setarch: Add --uname-2.6 option for personality flag UNAME26
From: Ben Hutchings <ben@decadent.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        util-linux@vger.kernel.org
Date: Tue, 23 Aug 2011 07:00:01 +0100
In-Reply-To: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314079201.12047.68.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
On Fri, 2011-08-19 at 16:15 -0700, Andi Kleen wrote:
[...]
> To use:
> 
> wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> gcc -o uname26 uname26.c
> ./uname26 program
[...]

I would suggest adding this to setarch, as that handles all the other
personality flags.  The following patch to util-linux seems to do the
trick.

Ben.

 configure.ac        |    1 +
 sys-utils/setarch.8 |    3 +++
 sys-utils/setarch.c |   12 +++++++++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0d3b889..51d06fd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -792,6 +792,7 @@ AC_CHECK_MEMBERS([struct stat.st_mtim.tv_nsec],,,
 	[#include <sys/stat.h>])
 
 AC_CHECK_DECLS([
+ UNAME26,
  ADDR_NO_RANDOMIZE,
  FDPIC_FUNCPTRS,
  MMAP_PAGE_ZERO,
diff --git a/sys-utils/setarch.8 b/sys-utils/setarch.8
index 0764a45..b6f5b77 100644
--- a/sys-utils/setarch.8
+++ b/sys-utils/setarch.8
@@ -29,6 +29,9 @@ Be verbose.
 .I "\-h," "\-\-help"
 Display help (it is also displayed when setarch takes no arguments).
 .TP
+.I "\-\-uname\-2.6"
+Causes the program to see a kernel version number beginning with 2.6.
+.TP
 .I "\-3," "\-\-3gb"
 Specifies that processes should use a maximum of 3GB of address space on systems where it is supported (ADDR_LIMIT_3GB).
 .TP
diff --git a/sys-utils/setarch.c b/sys-utils/setarch.c
index 35efca4..b53bf36 100644
--- a/sys-utils/setarch.c
+++ b/sys-utils/setarch.c
@@ -41,6 +41,8 @@
 /* Option --4gb has no equivalent short option, use a non-character as a
    pseudo short option. */
 #define OPT_4GB (CHAR_MAX+1)
+/* Similarly for --uname-2.6 */
+#define OPT_UNAME26 (OPT_4GB+1)
 
 #define turn_on(_flag, _opts) \
 	do { \
@@ -50,6 +52,9 @@
 	} while(0)
 

+#if !HAVE_DECL_UNAME26
+# define UNAME26                 0x0020000
+#endif
 #if !HAVE_DECL_ADDR_NO_RANDOMIZE
 # define ADDR_NO_RANDOMIZE       0x0040000
 #endif
@@ -98,6 +103,7 @@ static const struct option longopts[] =
     { "sticky-timeouts",    0, 0, 'T' },
     { "3gb",                0, 0, '3' },
     { "4gb",                0, 0, OPT_4GB },
+    { "uname-2.6",          0, 0, OPT_UNAME26 },
     { NULL,                 0, 0, 0 }
 };
 
@@ -125,7 +131,8 @@ show_help(void)
    " -S, --whole-seconds      turns on WHOLE_SECONDS\n"
    " -T, --sticky-timeouts    turns on STICKY_TIMEOUTS\n"
    " -3, --3gb                limits the used address space to a maximum of 3 GB\n"
-   "     --4gb                ignored (for backward compatibility only)\n"));
+   "     --4gb                ignored (for backward compatibility only)\n"
+   "     --uname-2.6          turns on UNAME26\n"));
 
   printf(_("\nFor more information see setarch(8).\n"));
   exit(EXIT_SUCCESS);
@@ -306,6 +313,9 @@ int main(int argc, char *argv[])
 	break;
     case OPT_4GB:          /* just ignore this one */
       break;
+    case OPT_UNAME26:
+	turn_on(UNAME26, options);
+	break;
     }
   }
 
-- 
1.7.5.4


