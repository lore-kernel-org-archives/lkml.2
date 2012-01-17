Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2AQIOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:14:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47117 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2AQIO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:14:28 -0500
From: Minchan Kim <minchan@kernel.org>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org,
        Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 3/3] test program
Date: Tue, 17 Jan 2012 17:13:58 +0900
Message-Id: <1326788038-29141-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1326788038-29141-1-git-send-email-minchan@kernel.org>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test program allocates 10M per second and when
memory pressure notify happens, it releases 20M.

I tested this patch on 512M qemu machine with 3 test program.
I saw some swapout but not too many and even didn't see OOM.
It obviously reduces swap out.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 poll.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 poll.c

diff --git a/poll.c b/poll.c
new file mode 100644
index 0000000..3215f8b
--- /dev/null
+++ b/poll.c
@@ -0,0 +1,121 @@
+#include <poll.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+
+#define ALLOC_UNIT	10 /* MB */
+#define FREE_UNIT	20 /* MB */
+
+void alloc_memory();
+void free_memory();
+
+unsigned int total_memory = 0; /* MB */
+
+pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; 
+
+/*
+ * If total memory is higher than 200M
+ */
+bool memory_full()
+{
+	return total_memory >= 400 ? true : false;
+}
+
+struct alloc_chunk {
+	void *ptr;
+	struct alloc_chunk *next;
+};
+
+struct alloc_chunk head_chunk;
+
+void init_alloc_chunk(void)
+{
+	head_chunk.ptr = NULL;
+	head_chunk.next = NULL;
+}
+
+void add_memory(void *ptr)
+{
+	struct alloc_chunk *new_chunk = malloc(sizeof(struct alloc_chunk));
+	new_chunk->ptr = ptr;
+
+	pthread_mutex_lock(&mutex);
+	new_chunk->next = head_chunk.next;
+	head_chunk.next = new_chunk;
+	total_memory += ALLOC_UNIT;
+	pthread_mutex_unlock(&mutex);
+
+	printf("[%d] Add total memory %d(MB)\n", getpid(), total_memory);
+}
+
+void alloc_memory(void)
+{
+	while(1) {
+		if (memory_full()) {
+			sleep(10);
+			continue;
+		}
+
+		void *new = malloc(ALLOC_UNIT*1024*1024);
+		memset(new, 0, ALLOC_UNIT*1024*1024);
+		add_memory(new);
+		sleep(1);
+	}
+}
+
+void free_memory(void)
+{
+	int count = FREE_UNIT / ALLOC_UNIT;
+	while(count--) {
+		struct alloc_chunk *chunk = head_chunk.next;
+		if (chunk == NULL)
+			break;
+
+		pthread_mutex_lock(&mutex);
+		head_chunk.next = chunk->next;
+		total_memory -= ALLOC_UNIT;
+		pthread_mutex_unlock(&mutex);
+
+		free(chunk->ptr);
+		free(chunk);
+
+		printf("[%d] Free total memory %d(MB)\n", getpid(), total_memory);
+	}
+}
+
+void *poll_thread(void *dummy)
+{
+	struct pollfd pfd;	
+	int fd = open("/dev/low_mem_notify", O_RDONLY); 
+	if (fd == -1) {
+		fprintf(stderr, "Fail to open\n");
+		return;
+	}
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+
+	while(1) {
+		poll(&pfd, 1, -1);
+		free_memory();
+	}
+}
+
+int main()
+{
+	pthread_t threadid;
+	init_alloc_chunk();
+
+	if (pthread_create(&threadid, NULL, poll_thread, NULL)) {
+		fprintf(stderr, "pthread create fail\n");
+		return 1;
+	}
+
+	alloc_memory();
+	return 0;
+}
-- 
1.7.7.5

