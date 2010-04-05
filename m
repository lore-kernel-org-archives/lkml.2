Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0DEKbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 06:31:37 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56967 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0DEKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:31:31 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
Date: Mon, 5 Apr 2010 11:31:29 +0100
Message-ID: <u2j6a4b170b1004050331mf0ec0dd4pf2e47d9dda5e6be9@mail.gmail.com>
Subject: [PATCH] watchdog docs: Fix use of WDIOC_SETOPTIONS ioctl.
From: James Hogan <james@albanarts.com>
To: Wim Van Sebroeck <wim@iguana.be>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, Trevor Keith <tsrk@tsrk.net>,
       James Hogan <james.hogan@imgtec.com>,
       Ladinu Chandrasinghe <ladinu.pub@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the watchdog-test program and watchdog-api.txt, pass the values to
the WDIOC_SETOPTIONS ioctl as a pointer to an integer containing the
values intead of directly in the third ioctl argument. The actual
watchdog drivers in drivers/watchdog don't read the options directly
from the argument but use get_user and copy_from_user.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 Documentation/watchdog/src/watchdog-test.c |    8 ++++++--
 Documentation/watchdog/watchdog-api.txt    |    5 ++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/watchdog/src/watchdog-test.c
b/Documentation/watchdog/src/watchdog-test.c
index a750532..63fdc34 100644
--- a/Documentation/watchdog/src/watchdog-test.c
+++ b/Documentation/watchdog/src/watchdog-test.c
@@ -31,6 +31,8 @@ static void keep_alive(void)
  */
 int main(int argc, char *argv[])
 {
+    int flags;
+
     fd = open("/dev/watchdog", O_WRONLY);

     if (fd == -1) {
@@ -41,12 +43,14 @@ int main(int argc, char *argv[])

     if (argc > 1) {
 	if (!strncasecmp(argv[1], "-d", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_DISABLECARD);
+	    flags = WDIOS_DISABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card disabled.\n");
 	    fflush(stderr);
 	    exit(0);
 	} else if (!strncasecmp(argv[1], "-e", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_ENABLECARD);
+	    flags = WDIOS_ENABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card enabled.\n");
 	    fflush(stderr);
 	    exit(0);
diff --git a/Documentation/watchdog/watchdog-api.txt
b/Documentation/watchdog/watchdog-api.txt
index 4cc4ba9..eb7132e 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -222,11 +222,10 @@ returned value is the temperature in degrees fahrenheit.
     ioctl(fd, WDIOC_GETTEMP, &temperature);

 Finally the SETOPTIONS ioctl can be used to control some aspects of
-the cards operation; right now the pcwd driver is the only one
-supporting this ioctl.
+the cards operation.

     int options = 0;
-    ioctl(fd, WDIOC_SETOPTIONS, options);
+    ioctl(fd, WDIOC_SETOPTIONS, &options);

 The following options are available:

-- 
1.6.6.1
