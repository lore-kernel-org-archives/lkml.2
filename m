Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1ADDsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:48:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:43466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1ADDsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/11] perf util: Move do_read from session to util
Date: Tue,  4 Jan 2011 01:48:17 -0200
Message-Id: <1294112905-25325-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Not really something to be exported from session.c. Rename it to
'readn' as others did in the past.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  |    6 +++---
 tools/perf/util/session.c |   22 ++--------------------
 tools/perf/util/session.h |    1 -
 tools/perf/util/util.c    |   17 +++++++++++++++++
 tools/perf/util/util.h    |    1 +
 5 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ecb5a84..05dec98 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -604,7 +604,7 @@ int perf_header__write(struct perf_header *self, int fd, bool at_exit)
 static int perf_header__getbuffer64(struct perf_header *self,
 				    int fd, void *buf, size_t size)
 {
-	if (do_read(fd, buf, size) <= 0)
+	if (readn(fd, buf, size) <= 0)
 		return -1;
 
 	if (self->needs_swap)
@@ -660,7 +660,7 @@ int perf_file_header__read(struct perf_file_header *self,
 {
 	lseek(fd, 0, SEEK_SET);
 
-	if (do_read(fd, self, sizeof(*self)) <= 0 ||
+	if (readn(fd, self, sizeof(*self)) <= 0 ||
 	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
 		return -1;
 
@@ -821,7 +821,7 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
 				       struct perf_header *ph, int fd,
 				       bool repipe)
 {
-	if (do_read(fd, self, sizeof(*self)) <= 0 ||
+	if (readn(fd, self, sizeof(*self)) <= 0 ||
 	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
 		return -1;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0f7e544..b163dfd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -838,23 +838,6 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 	return thread;
 }
 
-int do_read(int fd, void *buf, size_t size)
-{
-	void *buf_start = buf;
-
-	while (size) {
-		int ret = read(fd, buf, size);
-
-		if (ret <= 0)
-			return ret;
-
-		size -= ret;
-		buf += ret;
-	}
-
-	return buf - buf_start;
-}
-
 #define session_done()	(*(volatile int *)(&session_done))
 volatile int session_done;
 
@@ -872,7 +855,7 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 
 	head = 0;
 more:
-	err = do_read(self->fd, &event, sizeof(struct perf_event_header));
+	err = readn(self->fd, &event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -892,8 +875,7 @@ more:
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
-		err = do_read(self->fd, p,
-			      size - sizeof(struct perf_event_header));
+		err = readn(self->fd, p, size - sizeof(struct perf_event_header));
 		if (err <= 0) {
 			if (err == 0) {
 				pr_err("unexpected end of event stream\n");
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ffe4b98..decd83f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -109,7 +109,6 @@ void mem_bswap_64(void *src, int byte_size);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
-int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
 void perf_session__set_sample_id_all(struct perf_session *session, bool value);
 void perf_session__set_sample_type(struct perf_session *session, u64 type);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 2142656..5b3ea49 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -114,3 +114,20 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 	return value;
 }
+
+int readn(int fd, void *buf, size_t n)
+{
+	void *buf_start = buf;
+
+	while (n) {
+		int ret = read(fd, buf, n);
+
+		if (ret <= 0)
+			return ret;
+
+		n -= ret;
+		buf += ret;
+	}
+
+	return buf - buf_start;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7562707..e833f26 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,6 +265,7 @@ void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
 unsigned long convert_unit(unsigned long value, char *unit);
+int readn(int fd, void *buf, size_t size);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.6.2.5

