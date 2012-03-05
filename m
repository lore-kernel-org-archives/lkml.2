Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2CEWaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:30:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46970 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2CEWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:30:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.216.4 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [RFC] perf tools: Add API for adding 'private' data to struct thread
Date: Mon,  5 Mar 2012 15:29:51 -0700
Message-Id: <1330986591-77397-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow commands to attach 'private' data to a thread struct. This allows
commands to avoid caching data locally with corresponding lookup code.
Pointer to private data is obtained using thread__get_priv() and set
using thread__set_priv.

If a struct thread is deleted, the corresponding private data is also
freed. On fork and comm events (comm == exec right now) the privata data
is freed.

The default handler for freeing private memory does a simple
free(). If the private data is a complex structure with additional
internal memory allocations users can define a callback:

    void (*priv_free)(void *p)

and set thread_conf.priv_free.

This API differs from symbol_conf wherein users set priv_size and the
size of allocations is increased accordingly. This works fine for
constant-sized allocations - as needed for symbol processing. However,
a more flexible API is needed for threads to allow for more complicated
associations of data.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/thread.c |   16 ++++++++++++++++
 tools/perf/util/thread.h |   16 ++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index fb4b7ea..7dcb70f 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -22,9 +22,22 @@ static struct thread *thread__new(pid_t pid)
 	return self;
 }
 
+struct thread_conf thread_conf = {
+	.priv_free = free,
+};
+
+static void thread__free_priv(struct thread *self)
+{
+	if (self->priv) {
+		thread_conf.priv_free(self->priv);
+		self->priv = NULL;
+	}
+}
+
 void thread__delete(struct thread *self)
 {
 	map_groups__exit(&self->mg);
+	thread__free_priv(self);
 	free(self->comm);
 	free(self);
 }
@@ -40,6 +53,7 @@ int thread__set_comm(struct thread *self, const char *comm)
 	if (!err) {
 		self->comm_set = true;
 		map_groups__flush(&self->mg);
+		thread__free_priv(self);
 	}
 	return err;
 }
@@ -110,6 +124,8 @@ int thread__fork(struct thread *self, struct thread *parent)
 {
 	int i;
 
+	thread__free_priv(self);
+
 	if (parent->comm_set) {
 		if (self->comm)
 			free(self->comm);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 70c2c13..dc4e38f 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -16,8 +16,14 @@ struct thread {
 	bool			comm_set;
 	char			*comm;
 	int			comm_len;
+	void			*priv;
 };
 
+struct thread_conf {
+	void (*priv_free)(void *p);
+};
+extern struct thread_conf thread_conf;
+
 struct machine;
 
 void thread__delete(struct thread *self);
@@ -41,4 +47,14 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
+
+static inline void *thread__get_priv(struct thread *thread)
+{
+	return thread->priv;
+}
+
+static inline void thread__set_priv(struct thread *thread, void *p)
+{
+	thread->priv = p;
+}
 #endif	/* __PERF_THREAD_H */
-- 
1.7.5.4

