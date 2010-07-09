Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0GIXin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:38:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0GIXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:29 -0400
Message-Id: <20100709225818.373496364@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 14/20] Ring buffer library - documentation
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=ring-buffer-documentation.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 Documentation/ring-buffer/ring-buffer-design.txt |   78 ++++++
 Documentation/ring-buffer/ring-buffer-usage.txt  |  260 +++++++++++++++++++++++
 2 files changed, 338 insertions(+)

Index: linux.trees.git/Documentation/ring-buffer/ring-buffer-design.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/Documentation/ring-buffer/ring-buffer-design.txt	2010-07-02 12:34:02.000000000 -0400
@@ -0,0 +1,78 @@
+                        Ring Buffer Library Design
+
+                            Mathieu Desnoyers
+
+
+This document explains Linux Kernel Ring Buffer library.
+
+
+* Purpose of the ring buffer library
+
+Tracing: the main purpose of the ring buffer library is to perform tracing
+efficiently by providing an efficient ring buffer to transport trace data.
+
+Fast fifo queue for drivers: this library is meant to be generic enough to meet
+the requirements of audio, video and other drivers to provide an easy-to-use,
+yet efficient, buffering API.
+
+Lock-free write-side: the main advantage of this ring buffer implementation is
+that it provides non-blocking synchronization for the writer context. It
+furthermore provides a bounded write-side execution time for real-time
+applications. The per-CPU buffer configuration is wait-free. The global buffer
+configuration is lock-free. (wait-free is a stronger progress guarantee than
+lock-free.)
+
+
+* Semantic
+
+The execution context writing to the ring buffer is hereby called "producer" (or
+writer) and the thread reading the ring buffer content is called "consumer" (or
+reader). Each instance of either per-cpu or global ring buffers is called a
+"channel". A buffer is divided into subbuffers, which are synchronization points
+in the buffers (sometimes referred to as periods in the audio world). Each item
+stored in the ring buffer is called a "record". Both subbuffers and records
+may start with a "header". Records can also contain a variable-sized payload.
+
+The ring buffer supports two write modes. The "discard" mode drops data when the
+ring buffer is full. The "overwrite" (a.k.a. flight recorder) mode overwrites
+the oldest information when the ring buffer is full.
+
+Iterators are one way to consume data from the ring buffer. They allow a reader
+thread to read records one by one in the order they were written, either on a
+per-buffer or per-channel basis. Other ways to consume data are by using file
+descriptors which provide access to raw subbuffer content through, e.g.,
+splice() or mmap().
+
+
+* Programmer Interfaces
+
+The library presents a high-level interface that allows programmers to easily
+create and use a ring buffer instance. It also provides a more advanced client
+configuration API for clients with more elaborate needs (e.g. tracers).
+
+
+* Advanced client configuration options
+
+The options listed in the linux/ringbuffer/config.h header are tailored for ring
+buffer "clients" (a kernel object using the ring buffer library through its
+advanced options API) with more specific needs. The clients must set up a
+"static const" ring_buffer_config structure in which all options are spelled
+out. Given that this structure is known to be immutable, compiler optimizations
+can optimize away all the unneeded code from the library inline fast paths. The
+slow paths, however, dynamically select the correct code depending on the
+ring_buffer_config structure received as parameter. This saves space by sharing
+the slow path code between all ring buffer clients.
+
+
+* Frontend/backend layered design
+
+The ring buffer is made of two main layers: a frontend and a backend. The
+"frontend" locklessly manages space reservation within the buffer. It also
+manages timers, idle and cpu hotplug. The "backend" manages the memory backend
+used to allocate the buffers. It deals with subbuffer exchanges between the
+consumer and the producer in overwrite mode. Currently, only a page-based
+backend is implemented (RING_BUFFER_PAGE), but other backends are planned for
+the future: statically allocated backends (RING_BUFFER_STATIC) and vmap-based
+backends (RING_BUFFER_VMAP). These will allow, for instance, tracers to write
+trace data in a physically contiguous memory region allocated at boot time, or
+to write data in video card memory for crash reports.
Index: linux.trees.git/Documentation/ring-buffer/ring-buffer-usage.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/Documentation/ring-buffer/ring-buffer-usage.txt	2010-07-02 12:35:20.000000000 -0400
@@ -0,0 +1,260 @@
+		        Ring Buffer Library Usage
+
+			    Mathieu Desnoyers
+
+
+This document explains how to use the Linux Kernel Ring Buffer Library.
+
+The library presents a high-level interface that allows programmers to easily
+create and use a ring buffer instance. It also provides a more advanced client
+configuration API for clients with more elaborate needs (e.g. tracers).
+
+
+* Basic ring buffer configurations
+
+  The basic high-level configurations offered are pre-built clients with the
+following configuration selections under include/linux/ringbuffer/.
+
+  * The write-side (data producer) APIs are available in:
+
+    - global_overwrite.h:
+        global buffer, overwrite mode, channel-wide record iterator
+
+    - global_discard.h:
+        global buffer, discard mode, channel-wide record iterator
+
+    - percpu_overwrite.h:
+        per-cpu buffers, overwrite mode, channel-wide record iterator
+
+    - percpu_discard.h:
+        per-cpu buffers, discard mode, channel-wide record iterator
+
+    - percpu_local_overwrite.h:
+        per-cpu buffers, overwrite mode, per-cpu buffer record iterator
+
+    - percpu_local_discard.h:
+        per-cpu buffers, discard mode, per-cpu buffer record iterator
+
+  Typical use-case of the ring buffer write-side:
+
+    1) create
+    2) multiple calls to the write primitive.
+    3) destroy
+
+
+  * The read-side (data consumer) iterator APIs are available in:
+
+  - iterator.h
+
+    These iterators allow to iterate on records either on a per-cpu buffer or
+    channel-wide basis.
+
+    Typical life-span of a reader using the file descriptor read() iterator:
+
+    (in user-space)
+    # cat /path_to_file/filename
+
+    Typical life-span of a reader using the in-kernel API:
+
+    1) iterator_open()
+    2) get_next_record and read_current_record until get_next_record returns
+       -ENODATA. -EAGAIN means there is currently no data, but there might be
+       more data coming in the future.
+    3) iterator_close()
+
+
+* Advanced client configurations
+
+  * Advanced client configuration options
+
+  More options are available for clients with more advanced needs. These options
+are listed in the linux/ringbuffer/config.h header. A ring buffer "client" (a
+kernel object using the ring buffer library through its advanced options API)
+must set up a "static const" ring_buffer_config structure in which all options
+are spelled out.
+
+The pre-built basic configurations presented in the above set these advanced
+configuration options to values typically correct for driver use.
+
+A client using the advanced configuration options must first include
+linux/ringbuffer/config.h, declare its configuration structure, declare the
+required static inline functions used by the fast-paths, and then include
+linux/ringbuffer/api.h.
+
+The struct ring_buffer_config options are:
+
+  * alloc: RING_BUFFER_ALLOC_PER_CPU / RING_BUFFER_ALLOC_GLOBAL
+
+    Selects either global buffer or per-cpu ring buffers.
+
+  * sync: RING_BUFFER_SYNC_PER_CPU / RING_BUFFER_SYNC_GLOBAL
+
+    Selects which synchronization primitives must be used. Either expect
+    concurrency from other processors, or expect to only have concurrency with
+    the local processor. Separated from the "alloc" option because per-thread
+    buffers would fit in the "global alloc, per-cpu sync". Similarly, per-cpu
+    buffers written to with preemption enabled would fit in the "per-cpu
+    alloc, global sync" category, because migration could lead to a concurrent
+    write into a remote cpu buffer.
+
+  * mode: RING_BUFFER_OVERWRITE / RING_BUFFER_DISCARD
+
+    Either overwrite oldest subbuffers when buffer is full, or discard events.
+
+  * align: RING_BUFFER_NATURAL / RING_BUFFER_PACKED
+
+    Natural alignment aligns record headers on their natural alignment on the
+    architecture. It also aligns record payload on their natural alignment
+    (similarly to a C structure). The packed option does not perform any
+    alignment for record header and payloads. It corresponds to the "packed" gcc
+    type attribute.
+
+  * output:
+
+      RING_BUFFER_SPLICE:   Output raw subbuffers through per-buffer file
+                            descriptors with splice(). The read-side
+                            synchronization needed to select the current
+                            subbuffer is performed with ioctl().
+
+      RING_BUFFER_MMAP:     Output raw subbuffers through per-buffer memory
+                            mapped file descriptors. Read-side synchronization
+                            to select the current subbuffer is performed with
+                            ioctl().
+
+      RING_BUFFER_READ:     Output raw subbuffers through per-buffer file
+                            descriptors with read(). The read-side
+                            synchronization needed to select the current
+                            subbuffer is performed with ioctl().
+                            (unimplemented)
+
+      RING_BUFFER_ITERATOR: Iterators allow a reader thread to read records one
+                            by one in the order they were written, either on a
+                            per-buffer or per-channel basis.
+
+      RING_BUFFER_NONE:     No output provided by the library is used.
+
+  * backend:
+
+      RING_BUFFER_PAGE:     The memory backend used to hold the ring buffers is
+                            made of non-contiguous pages. A software-controlled
+                            "subbuffer table" indexes the pages. It allows
+                            sub-buffer exchange between the producer and
+                            consumer in overwrite mode.
+
+      RING_BUFFER_VMAP:     A vmap'd virtually contiguous memory area is used as
+                            memory backend. (unimplemented)
+
+      RING_BUFFER_STATIC:   A physically contiguous memory area is used as
+                            memory backend. e.g. memory allocated at early boot,
+                            or video card memory. (unimplemented)
+
+  * oops:
+        Select "oops" consistency if you plan to read from the ring buffer
+        after a kernel oops occurred. This is useful if you plan to use the
+        ring buffer data in a crash report. Adds a slight performance overhead
+        to keep track of how much contiguous data has been written in the
+        current subbuffer.
+
+  * ipi:
+        The IPI_BARRIER scheme issues IPIs when the consumer needs to grab a
+        sub-buffer. It issues the appropriate memory barriers on the writer
+        CPU(s). It is therefore possible to turn the memory barrier in the
+        commit fast-path into a simple compiler barrier, thus improving
+        performances. This scheme is recommended when both per-cpu allocation
+        and synchronization are used. This scheme is not recommended for
+        "global" buffers, because it would involve sending IPIs to all
+        processors.
+
+  * wakeup:
+        The option "RING_BUFFER_WAKEUP_BY_TIMER" reduces intrusiveness in
+        the writer code and guarantees wait-free/lock-free write primitives
+        by performing lazy reader wakeups in a periodic deferrable timer and
+        hooking into cpu idle notifiers. This option makes tracer code more
+        robust at the expense of additional data delivery delay.
+        Use in combination with "read_timer_interval" channel_create()
+        argument.
+                - Note: CPU idle notifiers are not implemented for all
+                  architectures at the moment. The deferrable timer delays can
+                  only expected to be met by architectures with idle notifiers.
+       RING_BUFFER_WAKEUP_BY_WRITER option specifies that the ring buffer
+       write-side must perform reader wakeups at each sub-buffer boundary.
+       RING_BUFFER_WAKEUP_NONE does not perform any wakeup whatsoever. The
+       client has the responsibility to perform wakeups.
+
+  * tsc_bits:
+        Timestamp compression scheme setting. 0 means that no timestamps
+        are used; 64 means that full 64-bit timestamps are written with
+        each record. For any value between 1 and 63, the ring buffer
+        library will set the RING_BUFFER_RFLAG_FULL_TSC bit in the
+        "rflags" ring_buffer_ctx field, which is also passed as parameter
+        passed to the "record_header_size()" callback to inform the client
+        that a full 64-bit timestamp is needed due to a "tsc_bits"
+        overflow since the last record.
+
+Some options are passed as parameter to channel_create():
+
+  * subbuf_size:
+        Size of a sub-buffer within a ring buffer. Extra synchronization is
+	performed when the data producer crosses sub-buffer boundaries. This
+        corresponds to "periods" in audio buffers. The maximum record size is
+        limited by the sub-buffer size. The minimum sub-buffer size is 1 page.
+
+  * num_subbuf:
+        Number of sub-buffers per buffer. Typically, using at least 2
+        sub-buffers is recommended to minimize record discards.
+
+  * switch_timer_interval:
+        The switch timer interval configures the periodical deferrable
+        timer which handles periodical buffer switch. It is used to make
+        data readily available for consumption periodically for live data
+	streaming. A buffer switch is a synchronization point between the data
+        producers and consumer.
+
+  * read_timer_interval:
+        The read timer interval is the time interval (in us) to wake up pending
+        readers.
+
+* Advanced client callbacks
+
+  These callbacks are configured by the cb field of the ring_buffer_config
+structure. They are provided to the ring buffer by the client. For both
+ring_buffer_clock_read() and record_header_size(), inline versions must also be
+provided before inclusion of linux/ringbuffer/api.h.
+
+  * ring_buffer_clock_read():
+        Returns the current ring buffer clock source time (64-bit value).
+
+  * record_header_size():
+        Returns the size of the current record size, including record header
+        size. It uses the "rflags" parameter to determine if a full 64-bit
+        timestamp is required or if "tsc_bits" bits are enough to represent the
+        current time and detect "tsc_bits"-bit overflow. The offset received as
+        parameter is relative to a page boundary, which allows alignment
+        calculation. data_size is the size of the event payload.
+        "pre_header_padding" can be set by record_header_size() to the amount of
+        padding required to align the record header (considered to be 0 if
+        unset).
+
+  * subbuffer_header_size():
+        Returns the size of the subbuffer header.
+
+  * buffer_begin():
+        Callback executed when crossing a sub-buffer boundary, when starting to
+        write into the sub-buffer.
+
+  * buffer_end():
+        Callback executed when crossing a sub-buffer boundary, before delivering
+        a sub-buffer. Has exclusive sub-buffer access when called; meaning that
+        no concurrent commits are left, no reader can access the sub-buffer, no
+        concurrent writers are allowed to overwrite the sub-buffer.
+
+  * buffer_create():
+        This callback is executed upon creation of a buffer, either at channel
+        creation, or at CPU hotplug.
+
+  * buffer_finalize():
+        Callback executed upon channel finalize, performed by channel_destroy().
+
+  * record_get():
+        Reader helper provided by the client, which can be used to extract the
+        record header from a record in the buffer.

