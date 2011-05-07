Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1EGHIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 03:08:41 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:34185 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1EGHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 03:08:39 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsI3ALLvxE1V5qkTPGdsb2JhbACmHQsBAQEBHhkNJYhxvFcOhX0ElBWCa4c+
X-IronPort-AV: E=Sophos;i="4.64,330,1301868000"; 
   d="scan'208";a="187700491"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 7 May 2011 09:11:51 +0200
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110507071151.GA10901@polaris.bitmath.org>
References: <1304574244.32152.666.camel@edumazet-laptop>
 <1304576495.2943.40.camel@work-vm>
 <1304604284.3032.78.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051630390.3005@ionos>
 <1304608095.3032.95.camel@edumazet-laptop>
 <1304744552.2821.571.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304744552.2821.571.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

> > Defeating seqlock power? My thoughts are that seqlocks are nice
> > lightweight reader/writer locks that avoid writer starvation. You seem
> > to be trying to redefine or extend them to be something else which is
> > more subtle. 
> > 
> 
> All I am trying to explain is that a seqlock is a compound of two
> things : One spinlock to synchronize writers among themselves, one
> seqcount to synchronize readers with a writer.
> 
> But the API provides only a compound one. Writer uses the whole locking,
> while it would be nice to be able to separate the two steps. Note that
> because write_seqlock() and write_sequnlock() are inlined, this would
> not increase text size.

The separate writer and reader idea also came up in the input
subsystem about a year ago, to adress the one-writer-many-readers
situation. The patch went a few rounds on lkml
(https://lkml.org/lkml/2010/6/20/87), but the final version included
below got dropped because of an unrelated problem with the (evdev)
usecase. Perhaps it is useful in this setting?

Cheers,
Henrik

>From bd26d8972130978deb9056a7a6da30b5c049914f Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 25 Jun 2010 01:59:16 +0200
Subject: [PATCH] Introduce mrbuf, a multi-reader buffer mechanism

In spite of the many lock patterns and fifo helpers in the kernel, the
case of a single writer feeding many readers via a circular event
buffer seems to be uncovered. This patch adds mrbuf, a mechanism
for handling multiple concurrent read positions in a shared circular
buffer.  Under normal operation, given adequate buffer size, the
operation is lock-less.
---
 include/linux/mrbuf.h |  228 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mrbuf.h

diff --git a/include/linux/mrbuf.h b/include/linux/mrbuf.h
new file mode 100644
index 0000000..86ab656
--- /dev/null
+++ b/include/linux/mrbuf.h
@@ -0,0 +1,228 @@
+#ifndef _MRBUF_H
+#define _MRBUF_H
+/*
+ * Multi-reader buffer lock for single writer, concurrent readers
+ *
+ * Copyright (c) 2010 Henrik Rydberg
+ *
+ * The mrbuf is a mechanism for handling multiple concurrent read
+ * positions in a shared circular buffer. The mrbuf does not handle
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
+ * The mrbuf is particularly suitable for input event buffers, where
+ * the single writer must not be starved, and where there are several
+ * threads reading the same data.
+ *
+ * Multi-reader buffer locks are similar to seqlocks, but while
+ * seqlocks have a finite retry frequency, mrbufs virtually never
+ * retry. Like seqlocks, mrbufs are not very cache friendly, and
+ * require the buffer to be valid in all threads.
+ *
+ * Multiple writers and re-entrant readers require additional locking.
+ *
+ * Event queue writer example.  Readers are synchronized individually.
+ *
+ *    mrbuf_write_lock(&writer);
+ *
+ *    buffer[mrbuf_write_at(&writer)] = event_to_write;
+ *
+ *    mrbuf_write_unlock(&writer);
+ *
+ *    for (i = 0; i < NUM_READERS; i++)
+ *            mrbuf_write_sync(&writer, &client[i]->reader);
+ *
+ * Event queue reader example, reading all available events.
+ *
+ *    while (!mrbuf_read_empty(&reader)) {
+ *            do {
+ *                    mrbuf_read_try(&reader, &writer);
+ *                    event_to_read = buffer[mrbuf_read_at(&reader, &writer)];
+ *            } while (mrbuf_read_retry(&reader, &writer));
+ *    }
+ *
+ */
+
+/**
+ * struct mrbuf_writer - mrbuf writer
+ * @page: the bits of the circular buffer (page = size - 1)
+ * @head: the current writer head
+ * @next: the head to take effect after the lock
+ *
+ * The buffer size must be a power of two, such that page is the set
+ * of bits in which the buffer positions live.
+ *
+ */
+struct mrbuf_writer {
+	unsigned int page;
+	unsigned int head;
+	unsigned int next;
+};
+
+/**
+ * struct mrbuf_reader - mrbuf reader
+ * @last: the last write head seen beforing trying
+ * @head: the current reader head
+ * @tail: the current reader tail
+ */
+struct mrbuf_reader {
+	unsigned int last;
+	unsigned int head;
+	unsigned int tail;
+};
+
+/**
+ * mrbuf_write_init - initialize writer
+ * @bw: the mrbuf_writer to initialize
+ * @size: the size of the buffer (must be power of two)
+ */
+static inline void mrbuf_write_init(struct mrbuf_writer *bw, unsigned int size)
+{
+	bw->page = size - 1;
+	bw->head = 0;
+	bw->next = 0;
+}
+
+/**
+ * mrbuf_write_lock - lock to write one event
+ * @bw: the mrbuf_writer to lock
+ *
+ * This method prepares to write one event.  The write lock does not
+ * sleep and is thus suitable for use in atomic contexts.
+ *
+ */
+static inline void mrbuf_write_lock(struct mrbuf_writer *bw)
+{
+	++bw->next;
+	smp_wmb();
+}
+
+/**
+ * mrbuf_write_at - return position to write to
+ * @bw: the mrbuf_writer keeping track of the write position
+ *
+ * Returns the buffer position to write to. Must be called from within
+ * the write lock.
+ *
+ */
+static inline unsigned int mrbuf_write_at(const struct mrbuf_writer *bw)
+{
+	return bw->head & bw->page;
+}
+
+/**
+ * mrbuf_write_unlock - unlock writing
+ * @bw: the mrbuf_writer to unlock
+ */
+static inline void mrbuf_write_unlock(struct mrbuf_writer *bw)
+{
+	smp_wmb();
+	++bw->head;
+}
+
+/**
+ * mrbuf_write_sync - synchronize reader with current writer
+ * @bw: the mrbuf_writer to sync with
+ * @br: the mrbuf_reader to sync
+ *
+ * Synchronize the reader head with the writer head, effectively
+ * telling the reader thread that there is new data to read.
+ *
+ */
+static inline void mrbuf_write_sync(const struct mrbuf_writer *bw,
+				    struct mrbuf_reader *br)
+{
+	br->head = bw->head;
+}
+
+/**
+ * mrbuf_read_init - initialize reader
+ * @br: the mrbuf_reader to initialize
+ * @head: the initial reader head
+ * @tail: the initial reader tail
+ *
+ * This function must be called while mrbuf_write_sync() and
+ * mrbuf_read_empty() are out of reach, since the reader state is updated
+ * without coherence guarantees.
+ */
+static inline void mrbuf_read_init(struct mrbuf_reader *br,
+				   unsigned int head, unsigned int tail)
+{
+	br->head = head;
+	br->tail = tail;
+	smp_wmb();
+}
+
+/**
+ * mrbuf_read_empty - true if reader is empty
+ * @br: the mrbuf_reader to check
+ */
+static inline bool mrbuf_read_empty(const struct mrbuf_reader *br)
+{
+	return br->head == br->tail;
+}
+
+/**
+ * mrbuf_read_try - try to read data
+ * @br: the mrbuf_reader to try to read from
+ * @bw: the mrbuf_writer keeping track of the write position
+ *
+ * Prepare to read from buffer. The reader must be non-empty before
+ * trying to read from it. If the reader has fallen behind, it catches
+ * up by jumping to the last page being written to.
+ *
+ */
+static inline void mrbuf_read_try(struct mrbuf_reader *br,
+				  const struct mrbuf_writer *bw)
+{
+	br->last = bw->head;
+	smp_rmb();
+	br->tail += (br->head - 1 - br->tail) & ~bw->page;
+}
+
+/**
+ * mrbuf_read_at - return position to read from
+ * @br: the mrbuf_reader keeping track of the read position
+ * @bw: the mrbuf_writer keeping track of the buffer size
+ *
+ * Returns the buffer position to read from. Must be called from
+ * within the read try block.
+ *
+ */
+static inline unsigned int mrbuf_read_at(const struct mrbuf_reader *br,
+					 const struct mrbuf_writer *bw)
+{
+	return br->tail & bw->page;
+}
+
+/**
+ * mrbuf_read_retry - try to finish read
+ * @br: the mrbuf_reader to try to finish
+ * @bw: the mrbuf_writer keeping track of the write position
+ *
+ * Try to finish the read. Returns false if successful. Otherwise, the
+ * read was incoherent and one must mrbuf_read_try() again.  During
+ * normal operation, with adequate buffer size, this method will
+ * always return false.
+ *
+ */
+static inline bool __must_check mrbuf_read_retry(struct mrbuf_reader *br,
+						 const struct mrbuf_writer *bw)
+{
+	smp_rmb();
+	if (unlikely(((br->tail - br->last) & bw->page) < bw->next - br->last))
+		return true;
+	++br->tail;
+	return false;
+}
+
+#endif /* _MRBUF_H */
-- 
1.6.3.3

