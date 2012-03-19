Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162335Ab2CSUDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:03:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162239Ab2CSUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:03:31 -0400
Date: Mon, 19 Mar 2012 13:03:11 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-aa49f6ec990baa9d8f1b46a86fc169a8028776d4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887855-874-2-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser:
  Introduce ui_browser__input_window
Git-Commit-ID: aa49f6ec990baa9d8f1b46a86fc169a8028776d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:03:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa49f6ec990baa9d8f1b46a86fc169a8028776d4
Gitweb:     http://git.kernel.org/tip/aa49f6ec990baa9d8f1b46a86fc169a8028776d4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:50:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:32:36 -0300

perf ui browser: Introduce ui_browser__input_window

The ui_browser__input_window() function is to get user's key input.
Current implementation can handle maximum 49 characters.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.h |    2 +
 tools/perf/util/ui/keysyms.h |    2 +
 tools/perf/util/ui/util.c    |   78 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 84d761b..6ee82f6 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -49,6 +49,8 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 			const char *format, ...);
 int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_sec);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/util/ui/keysyms.h b/tools/perf/util/ui/keysyms.h
index 3458b19..809eca5 100644
--- a/tools/perf/util/ui/keysyms.h
+++ b/tools/perf/util/ui/keysyms.h
@@ -16,6 +16,8 @@
 #define K_TAB	'\t'
 #define K_UNTAB	SL_KEY_UNTAB
 #define K_UP	SL_KEY_UP
+#define K_BKSPC 0x7f
+#define K_DEL	SL_KEY_DELETE
 
 /* Not really keys */
 #define K_TIMER	 -1
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 45daa7c..360f43f 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -69,6 +69,84 @@ int ui__popup_menu(int argc, char * const argv[])
 	return popup_menu__run(&menu);
 }
 
+int ui_browser__input_window(const char *title, const char *text, char *input,
+			     const char *exit_msg, int delay_secs)
+{
+	int x, y, len, key;
+	int max_len = 60, nr_lines = 0;
+	static char buf[50];
+	const char *t;
+
+	t = text;
+	while (1) {
+		const char *sep = strchr(t, '\n');
+
+		if (sep == NULL)
+			sep = strchr(t, '\0');
+		len = sep - t;
+		if (max_len < len)
+			max_len = len;
+		++nr_lines;
+		if (*sep == '\0')
+			break;
+		t = sep + 1;
+	}
+
+	max_len += 2;
+	nr_lines += 8;
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2;
+	x = SLtt_Screen_Cols / 2 - max_len / 2;
+
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, x++, nr_lines, max_len);
+	if (title) {
+		SLsmg_gotorc(y, x + 1);
+		SLsmg_write_string((char *)title);
+	}
+	SLsmg_gotorc(++y, x);
+	nr_lines -= 7;
+	max_len -= 2;
+	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
+				   nr_lines, max_len, 1);
+	y += nr_lines + 1;
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y - 1, x + 1, 3, max_len - 2);
+
+	SLsmg_gotorc(y + 3, x);
+	SLsmg_write_nstring((char *)exit_msg, max_len);
+	SLsmg_refresh();
+
+	x += 2;
+	len = 0;
+	key = ui__getch(delay_secs);
+	while (key != K_TIMER && key != K_ENTER && key != K_ESC) {
+		if (key == K_BKSPC) {
+			if (len == 0)
+				goto next_key;
+			SLsmg_gotorc(y, x + --len);
+			SLsmg_write_char(' ');
+		} else {
+			buf[len] = key;
+			SLsmg_gotorc(y, x + len++);
+			SLsmg_write_char(key);
+		}
+		SLsmg_refresh();
+
+		/* XXX more graceful overflow handling needed */
+		if (len == sizeof(buf) - 1) {
+			ui_helpline__push("maximum size of symbol name reached!");
+			key = K_ENTER;
+			break;
+		}
+next_key:
+		key = ui__getch(delay_secs);
+	}
+
+	buf[len] = '\0';
+	strncpy(input, buf, len+1);
+	return key;
+}
+
 int ui__question_window(const char *title, const char *text,
 			const char *exit_msg, int delay_secs)
 {
