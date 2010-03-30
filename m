Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0CaAji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:39:38 -0400
Received: from kroah.org ([198.145.64.141]:48487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab0C3XJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:04 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:54 2010
Message-Id: <20100330224953.284932305@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Salman Qazi <sqazi@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [20/45] drivers/char/mem.c: avoid OOM lockup during large reads from /dev/zero
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 730c586ad5228c339949b2eb4e72b80ae167abc4 upstream.

While running 20 parallel instances of dd as follows:

  #!/bin/bash
  for i in `seq 1 20`; do
           dd if=/dev/zero of=/export/hda3/dd_$i bs=1073741824 count=1 &
  done
  wait

on a 16G machine, we noticed that rather than just killing the processes,
the entire kernel went down.  Stracing dd reveals that it first does an
mmap2, which makes 1GB worth of zero page mappings.  Then it performs a
read on those pages from /dev/zero, and finally it performs a write.

The machine died during the reads.  Looking at the code, it was noticed
that /dev/zero's read operation had been changed by
557ed1fa2620dc119adb86b34c614e152a629a80 ("remove ZERO_PAGE") from giving
zero page mappings to actually zeroing the page.

The zeroing of the pages causes physical pages to be allocated to the
process.  But, when the process exhausts all the memory that it can, the
kernel cannot kill it, as it is still in the kernel mode allocating more
memory.  Consequently, the kernel eventually crashes.

To fix this, I propose that when a fatal signal is pending during
/dev/zero read operation, we simply return and let the user process die.

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Modified error return and comment trivially.  - Linus]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -724,6 +724,9 @@ static ssize_t read_zero(struct file * f
 		written += chunk - unwritten;
 		if (unwritten)
 			break;
+		/* Consider changing this to just 'signal_pending()' with lots of testing */
+		if (fatal_signal_pending(current))
+			return written ? written : -EINTR;
 		buf += chunk;
 		count -= chunk;
 		cond_resched();


