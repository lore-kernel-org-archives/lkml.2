Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2AYAB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:01:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39494 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2AYAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:01:28 -0500
Message-ID: <1327449683.14373.12.camel@edumazet-laptop>
Subject: [PATCH v2] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Wed, 25 Jan 2012 01:01:23 +0100
In-Reply-To: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096
bytes, and is slow :

# strace -T -o /tmp/STRACE cat /proc/stat | wc -c
5826
# grep "cpu " /tmp/STRACE
read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826 <0.001504>


Thats partly because show_stat() must be called twice since initial
buffer size is too small (4096 bytes for less than 32 possible cpus)

Fix this by :

1) Taking into account nr_irqs in the initial buffer sizing.

2) Using ksize() to allow better filling of initial buffer.


Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Tuner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
V2: No change on "intr" line for compatibility sake.

 fs/proc/stat.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..ac44611 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -157,11 +157,14 @@ static int show_stat(struct seq_file *p, void *v)
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	unsigned size = 4096 * (1 + num_possible_cpus() / 32);
+	unsigned size = 1024 + 128 * num_possible_cpus();
 	char *buf;
 	struct seq_file *m;
 	int res;
 
+	/* minimum size to display an interrupt count : 2 bytes */
+	size += 2 * nr_irqs;
+
 	/* don't ask for more than the kmalloc() max size */
 	if (size > KMALLOC_MAX_SIZE)
 		size = KMALLOC_MAX_SIZE;
@@ -173,7 +176,7 @@ static int stat_open(struct inode *inode, struct file *file)
 	if (!res) {
 		m = file->private_data;
 		m->buf = buf;
-		m->size = size;
+		m->size = ksize(buf);
 	} else
 		kfree(buf);
 	return res;


