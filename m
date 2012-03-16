Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032657Ab2CPIun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:50:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51371 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460Ab2CPIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:50:37 -0400
X-AuditID: 9c930179-b7b27ae000000e38-c8-4f62fed8ffae
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] perf ui browser: Introduce ui_browser__input_window
Date: Fri, 16 Mar 2012 17:50:52 +0900
Message-Id: <1331887855-874-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ui_browser__input_window() function is to get user's key input.
Current implementation can handle maximum 49 characters.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browser.h |    2 +
 tools/perf/util/ui/keysyms.h |    2 +
 tools/perf/util/ui/util.c    |   78 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 84d761b730c1..6ee82f60feaf 100644
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
index 3458b1985761..809eca5707fa 100644
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
index 45daa7c41dad..360f43fd5400 100644
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
-- 
1.7.9

