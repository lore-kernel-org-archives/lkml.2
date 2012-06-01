Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2FAKkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab2FAKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:40:48 -0400
Subject: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        nstraz@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 11:39:53 +0100
Message-ID: <1338547193.2708.16.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just been taking a look at the seq_read() code, since we've noticed
that dumping files with large numbers of records can take some
considerable time. This is due to seq_read() using a buffer which, at
most is a single page in size, and that it has to find its place again
on every call to seq_read(). That makes it rather inefficient.

As an example, I created a GFS2 filesystem with 100k inodes in it, and
then ran ls -l to get a decent number of cached inodes. This result in
there being approx 400k lines in the debugfs file containing GFS2's
glocks. I then timed how long it takes to read this file:

[root@chywoon mnt]# time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks
of=/dev/null bs=1M
0+5769 records in
0+5769 records out
23273958 bytes (23 MB) copied, 63.3681 s, 367 kB/s

real    1m3.371s
user    0m0.005s
sys     1m3.317s

I tried this several times and it seems pretty consistent. Then I tried
again with the below patch applied:

[root@chywoon mnt]# time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks
of=/dev/null bs=1M
0+23 records in
0+23 records out
23107575 bytes (23 MB) copied, 1.64175 s, 14.1 MB/s

real	0m1.644s
user	0m0.000s
sys	0m1.643s

So that is a speed up of approx 38x, which isn't too bad I think. I
noticed that currently, the code caches the buffer page rather than
doing a free/alloc on each seq_read() call. Since my patch can make that
buffer rather large, I was not sure that this was a good idea, in
general, as it would seem to lead to potential DoS attacks in pinning
down large amounts of kmalloced memory. So my patch will free the buffer
on each cycle unless it is only a single page in size. That way we won't
pin down any more memory than the current code does, even when using a
larger buffer. I suspect that any time spent doing alloc/free will be
more than made up by the reduction in time traversing the records in the
file.

Also, since multipage kmalloc allocations are likely to fail in low
memory conditions, I've made that happen silently, and it falls back to
a single page buffer if a larger buffer cannot be allocated.


Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>


diff --git a/fs/seq_file.c b/fs/seq_file.c
index 0cbd049..feb86f2 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -153,7 +153,9 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	size_t n;
 	void *p;
 	int err = 0;
+	unsigned bsize = clamp(size, PAGE_SIZE, KMALLOC_MAX_SIZE);
 
+	bsize = round_up(bsize, PAGE_SIZE);
 	mutex_lock(&m->lock);
 
 	/*
@@ -169,6 +171,16 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	 */
 	m->version = file->f_version;
 
+	if ((m->size < bsize) || !m->buf) {
+		kfree(m->buf);
+		m->size = 0;
+		m->buf = kmalloc(m->size = bsize, GFP_KERNEL|__GFP_NOWARN);
+		if (!m->buf)
+			m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		if (!m->buf)
+			goto Enomem;
+	}
+
 	/* Don't assume *ppos is where we left it */
 	if (unlikely(*ppos != m->read_pos)) {
 		while ((err = traverse(m, *ppos)) == -EAGAIN)
@@ -277,6 +289,11 @@ Done:
 		m->read_pos += copied;
 	}
 	file->f_version = m->version;
+	if (m->size > PAGE_SIZE) {
+		kfree(m->buf);
+		m->buf = NULL;
+		m->size = 0;
+	}
 	mutex_unlock(&m->lock);
 	return copied;
 Enomem:



