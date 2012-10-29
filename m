Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab2J2V5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:57:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:48400 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761508Ab2J2VlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/54] gen_init_cpio: avoid stack overflow when expanding
Date: Mon, 29 Oct 2012 14:40:05 -0700
Message-Id: <20121029213803.239923186@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 usr/gen_init_cpio.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -303,7 +303,7 @@ static int cpio_mkfile(const char *name,
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
 
-       return new_location;
+	return new_location;
 }
 
 


