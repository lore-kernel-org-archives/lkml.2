Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HTUuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 16:50:50 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:37874 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1HTUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 16:50:46 -0400
Subject: [PATCH] kconfig: handle SIGINT in menuconfig
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sat, 20 Aug 2011 16:50:32 -0400
Message-ID: <1313873432.2655.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

I recently got bitten in the ass when pressing Ctrl-C and lost all my current configuration changes. This patch captures SIGINT and allows the user to save any changes.
Some code refactoring was made in order to handle the exit behavior.

CC: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 scripts/kconfig/mconf.c |   76 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 820d2b6..7ca3bb7 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -6,6 +6,7 @@
  * 2002-11-06 Petr Baudis <pasky@ucw.cz>
  *
  * i18n, 2005, Arnaldo Carvalho de Melo <acme@conectiva.com.br>
+ * Handle SIGINT (Ctrl-C), 2011, Davidlohr Bueso <dave@gnu.org>
  */
 
 #include <ctype.h>
@@ -15,6 +16,7 @@
 #include <stdarg.h>
 #include <stdlib.h>
 #include <string.h>
+#include <signal.h>
 #include <unistd.h>
 #include <locale.h>
 
@@ -272,6 +274,7 @@ static struct menu *current_menu;
 static int child_count;
 static int single_menu_mode;
 static int show_all_options;
+static int saved_x, saved_y;
 
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
@@ -792,9 +795,54 @@ static void conf_save(void)
 	}
 }
 
+static int handle_exit(int res)
+{
+	switch (res) {
+	case 0:
+		if (conf_write(filename)) {
+			fprintf(stderr, _("\n\n"
+					  "Error while writing of the configuration.\n"
+					  "Your configuration changes were NOT saved."
+					  "\n\n"));
+			return 1;
+		}
+		/* fall through */
+	case -1:
+		printf(_("\n\n"
+			 "*** End of the configuration.\n"
+			 "*** Execute 'make' to start the build or try 'make help'."
+			 "\n\n"));
+		break;
+	default:
+		fprintf(stderr, _("\n\n"
+				  "Your configuration changes were NOT saved."
+				  "\n\n"));
+	}
+
+	return 0;
+}
+
+static void sig_handler(int signo __attribute__((__unused__)))
+{
+	int res;
+	
+	do {
+		dialog_clear();
+		if (conf_get_changed())
+			res = dialog_yesno(NULL,
+					   _("Do you wish to save your "
+					     "new configuration?\n"),
+					   6, 60);
+		else
+			res = -1;
+	} while (res == KEY_ESC);
+
+	end_dialog(saved_x, saved_y);
+	exit(handle_exit(res));
+}
+
 int main(int ac, char **av)
 {
-	int saved_x, saved_y;
 	char *mode;
 	int res;
 
@@ -802,6 +850,8 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
+	signal(SIGINT, sig_handler);
+
 	conf_parse(av[1]);
 	conf_read(NULL);
 
@@ -835,28 +885,6 @@ int main(int ac, char **av)
 	} while (res == KEY_ESC);
 	end_dialog(saved_x, saved_y);
 
-	switch (res) {
-	case 0:
-		if (conf_write(filename)) {
-			fprintf(stderr, _("\n\n"
-				"Error while writing of the configuration.\n"
-				"Your configuration changes were NOT saved."
-				"\n\n"));
-			return 1;
-		}
-		/* fall through */
-	case -1:
-		printf(_("\n\n"
-			"*** End of the configuration.\n"
-			"*** Execute 'make' to start the build or try 'make help'."
-			"\n\n"));
-		break;
-	default:
-		fprintf(stderr, _("\n\n"
-			"Your configuration changes were NOT saved."
-			"\n\n"));
-	}
-
-	return 0;
+	return handle_exit(res);
 }
 
-- 
1.7.4.1



