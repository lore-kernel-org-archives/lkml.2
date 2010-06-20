Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0FTTFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 15:05:37 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:55044 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738Ab0FTTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 15:05:35 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Introduce buflock, a one-to-many circular buffer mechanism (rev2)
Date: Sun, 20 Jun 2010 21:05:05 +0200
Message-Id: <1277060705-3363-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OQPpV-0008Mi-BY.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OQPpV-0008Mi-BY a6fadb2a2c9a593c935a375db4ad1190
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In spite of the many lock patterns and fifo helpers in the kernel, the
case of a single writer feeding many readers via a circular event
buffer seems to be uncovered. This patch adds the buflock, a mechanism
for handling multiple concurrent read positions in a shared circular
buffer.  Under normal operation, given adequate buffer size, the
operation is lock-less. The mechanism is given the name buflock to
emphasize that the locking depends on the buffer read/write clashes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
This is version 2 of the buflock, which was first introduced as a
patch against the input subsystem. In the reviews, it was suggested
the file be placed in include/linux/, which is the patch presented
here. The major changes, taking review comments into account, are:

* The API has been rewritten to better abstract a lock, which
  hopefully provides a clearer reason to leave the actual memory
  handling to the user.

* The number of memory barriers has been reduced.

* Overlap detection now takes write interrupts larger than the buffer
  size into account.

* All methods are now static inlines.

Thanks,
Henrik

 include/linux/buflock.h |  230 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 230 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/buflock.h

diff --git a/include/linux/buflock.h b/include/linux/buflock.h
new file mode 100644
index 0000000..3d5df22
--- /dev/null
+++ b/include/linux/buflock.h
@@ -0,0 +1,230 @@
+#ifndef _BUFLOCK_H
+#define _BUFLOCK_H
+/*
+ * Circular event buffer lock for single writer, concurrent readers
+ *
+ * Copyright (c) 2010 Henrik Rydberg
+ *
+ * The buflock is a mechanism for handling multiple concurrent read
+ * positions in a shared circular buffer. The buflock does not handle
+ * the actual buffer, which can therefore be of any type.
+ *
+ * The writer does not block, but overwrites older events as the
+ * buffer gets full. Writing is performed in two stages; writing the
+ * data and telling the readers about it (syncing).
+ *
+ * The readers all read from the same shared buffer, but at individual
+ * positions. Reading from the position currently being written to
+ * will cause the reader to retry until the read is coherent. During
+ * normal operation, with sufficient buffer size, the mechanism is
+ * practically lock-less.
+ *
+ * The buflock is particularly suitable for input event buffers, where
+ * the single writer must not be starved, and where there are several
+ * threads reading the same data.
+ *
+ * Buflocks are similar to seqlocks, but while seqlocks have a finite
+ * retry frequency, buflocks virtually never retry. Like seqlocks,
+ * buflocks are not very cache friendly, and require the buffer to be
+ * valid in all threads.
+ *
+ * Multiple writers and re-entrant readers require additional locking.
+ *
+ * Event queue writer example.  Readers are synchronized individually.
+ *
+ *    bufwrite_lock(&writer);
+ *
+ *    buffer[bufwrite_at(&writer)] = event_to_write;
+ *
+ *    bufwrite_unlock(&writer);
+ *
+ *    for (i = 0; i < NUM_READERS; i++)
+ *            bufwrite_sync(&writer, &client[i]->reader);
+ *
+ * Event queue reader example, reading all available events.
+ *
+ *    while (!bufread_empty(&reader)) {
+ *            do {
+ *                    bufread_try(&reader, &writer);
+ *                    event_to_read = buffer[bufread_at(&reader, &writer)];
+ *            } while (bufread_retry(&reader, &writer));
+ *    }
+ *
+ */
+
+/**
+ * struct buflock_writer - buflock writer
+ * @page: the bits of the circular buffer (page = size - 1)
+ * @head: the current writer head
+ * @next: the head to take effect after the lock
+ *
+ * The buffer size must be a power of two, such that page is the set
+ * of bits in which the buffer positions live.
+ *
+ */
+struct buflock_writer {
+	unsigned int page;
+	unsigned int head;
+	unsigned int next;
+};
+
+/**
+ * struct buflock_reader - buflock reader
+ * @last: the last write head seen beforing trying
+ * @head: the current reader head
+ * @tail: the current reader tail
+ */
+struct buflock_reader {
+	unsigned int last;
+	unsigned int head;
+	unsigned int tail;
+};
+
+/**
+ * bufwrite_init - initialize writer
+ * @bw: the buflock_writer to initialize
+ * @size: the size of the buffer (must be power of two)
+ */
+static inline void bufwrite_init(struct buflock_writer *bw, unsigned int size)
+{
+	bw->page = size - 1;
+	bw->head = 0;
+	bw->next = 0;
+}
+
+/**
+ * bufwrite_lock - lock to write one event
+ * @bw: the buflock_writer to lock
+ *
+ * This method prepares to write one event.  The write lock does not
+ * sleep and is thus suitable for use in atomic contexts.
+ *
+ */
+static inline void bufwrite_lock(struct buflock_writer *bw)
+{
+	++bw->next;
+	smp_wmb();
+}
+
+/**
+ * bufwrite_at - return position to write to
+ * @bw: the buflock_writer keeping track of the write position
+ *
+ * Returns the buffer position to write to. Must be called from within
+ * the write lock.
+ *
+ */
+static inline unsigned int bufwrite_at(const struct buflock_writer *bw)
+{
+	return bw->head & bw->page;
+}
+
+/**
+ * bufwrite_unlock - unlock writing
+ * @bw: the buflock_writer to unlock
+ */
+static inline void bufwrite_unlock(struct buflock_writer *bw)
+{
+	++bw->head;
+	smp_wmb();
+}
+
+/**
+ * bufwrite_sync - synchronize reader with current writer
+ * @bw: the buflock_writer to sync with
+ * @br: the buflock_reader to sync
+ *
+ * Synchronize the reader head with the writer head, effectively
+ * telling the reader thread that there is new data to read.
+ *
+ */
+static inline void bufwrite_sync(const struct buflock_writer *bw,
+				 struct buflock_reader *br)
+{
+	br->head = bw->head;
+}
+
+/**
+ * bufread_init - initialize reader
+ * @br: the buflock_reader to initialize
+ * @head: the initial reader head
+ * @tail: the initial reader tail
+ *
+ * This function must be called while bufwrite_sync() and
+ * bufread_empty() are out of reach, since the reader state is updated
+ * without coherence guarantees.
+ */
+static inline void bufread_init(struct buflock_reader *br,
+				unsigned int head, unsigned int tail)
+{
+	br->head = head;
+	br->tail = tail;
+	smp_wmb();
+}
+
+/**
+ * bufread_empty - true if reader is empty
+ * @br: the buflock_reader to check
+ */
+static inline bool bufread_empty(const struct buflock_reader *br)
+{
+	return br->head == br->tail;
+}
+
+/**
+ * bufread_try - try to read data
+ * @br: the buflock_reader to try to read from
+ * @bw: the buflock_writer keeping track of the write position
+ *
+ * Prepare to read from buffer. The reader must be non-empty before
+ * trying to read from it.
+ *
+ */
+static inline void bufread_try(struct buflock_reader *br,
+			       const struct buflock_writer *bw)
+{
+	br->last = bw->head;
+	smp_rmb();
+}
+
+/**
+ * bufread_at - return position to read from
+ * @br: the buflock_reader keeping track of the read position
+ * @bw: the buflock_writer keeping track of the buffer size
+ *
+ * Returns the buffer position to read from. Must be called from
+ * within the read try block.
+ *
+ */
+static inline unsigned int bufread_at(const struct buflock_reader *br,
+				      const struct buflock_writer *bw)
+{
+	return br->tail & bw->page;
+}
+
+/**
+ * bufread_retry - try to finish read
+ * @br: the buflock_reader to try to finish
+ * @bw: the buflock_writer keeping track of the write position
+ *
+ * Try to finish the read. Returns false if successful. Otherwise, the
+ * read was incoherent and one must bufread_try() again.  During
+ * normal operation, with adequate buffer size, this method will
+ * always return false.
+ *
+ * If the reader falls behind, it catches up by jumping to the head,
+ * as if all available events had actually been read.
+ *
+ */
+static __always_inline bool __must_check bufread_retry(struct buflock_reader *br, const struct buflock_writer *bw)
+{
+	smp_rmb();
+	if (unlikely(((br->tail - br->last) & bw->page) < bw->next - br->last))
+		return true;
+	++br->tail;
+	if (unlikely(br->head - br->tail > bw->page))
+		br->tail = br->head;
+	return false;
+}
+
+#endif /* _BUFLOCK_H */
-- 
1.6.3.3

