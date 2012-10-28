Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2J1XqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:46:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542Ab2J1X1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:25 -0400
Message-Id: <20121028231607.161726644@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 097/105] gen_init_cpio: avoid stack overflow when expanding
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 20f1de659b77364d55d4e7fad2ef657e7730323f upstream.

Fix possible overflow of the buffer used for expanding environment
variables when building file list.

In the extremely unlikely case of an attacker having control over the
environment variables visible to gen_init_cpio, control over the
contents of the file gen_init_cpio parses, and gen_init_cpio was built
without compiler hardening, the attacker can gain arbitrary execution
control via a stack buffer overflow.

  $ cat usr/crash.list
  file foo ${BIG}${BIG}${BIG}${BIG}${BIG}${BIG} 0755 0 0
  $ BIG=$(perl -e 'print "A" x 4096;') ./usr/gen_init_cpio usr/crash.list
  *** buffer overflow detected ***: ./usr/gen_init_cpio terminated

This also replaces the space-indenting with tabs.

Patch based on existing fix extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 usr/gen_init_cpio.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index af0f22f..aca6edc 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -303,7 +303,7 @@ static int cpio_mkfile(const char *name, const char *location,
 	int retval;
 	int rc = -1;
 	int namesize;
-	int i;
+	unsigned int i;
 
 	mode |= S_IFREG;
 
@@ -381,25 +381,28 @@ error:
 
 static char *cpio_replace_env(char *new_location)
 {
-       char expanded[PATH_MAX + 1];
-       char env_var[PATH_MAX + 1];
-       char *start;
-       char *end;
-
-       for (start = NULL; (start = strstr(new_location, "${")); ) {
-               end = strchr(start, '}');
-               if (start < end) {
-                       *env_var = *expanded = '\0';
-                       strncat(env_var, start + 2, end - start - 2);
-                       strncat(expanded, new_location, start - new_location);
-                       strncat(expanded, getenv(env_var), PATH_MAX);
-                       strncat(expanded, end + 1, PATH_MAX);
-                       strncpy(new_location, expanded, PATH_MAX);
-               } else
-                       break;
-       }
-
-       return new_location;
+	char expanded[PATH_MAX + 1];
+	char env_var[PATH_MAX + 1];
+	char *start;
+	char *end;
+
+	for (start = NULL; (start = strstr(new_location, "${")); ) {
+		end = strchr(start, '}');
+		if (start < end) {
+			*env_var = *expanded = '\0';
+			strncat(env_var, start + 2, end - start - 2);
+			strncat(expanded, new_location, start - new_location);
+			strncat(expanded, getenv(env_var),
+				PATH_MAX - strlen(expanded));
+			strncat(expanded, end + 1,
+				PATH_MAX - strlen(expanded));
+			strncpy(new_location, expanded, PATH_MAX);
+			new_location[PATH_MAX] = 0;
+		} else
+			break;
+	}
+
+	return new_location;
 }
 
 


