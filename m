Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1BYPdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab1BYPdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:33:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] afs: Fix oops in afs_unlink_writeback
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>, David Howells <dhowells@redhat.com>
Date: Fri, 25 Feb 2011 15:33:02 +0000
Message-ID: <20110225153301.27864.14291.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@au1.ibm.com>

I'm seeing the following oops when testing afs:

Unable to handle kernel paging request for data at address 0x00000008
...
NIP [c0000000003393b0] .afs_unlink_writeback+0x38/0xc0
LR [c00000000033987c] .afs_put_writeback+0x98/0xec
Call Trace:
[c00000000345f600] [c00000000033987c] .afs_put_writeback+0x98/0xec
[c00000000345f690] [c00000000033ae80] .afs_write_begin+0x6a4/0x75c
[c00000000345f790] [c00000000012b77c] .generic_file_buffered_write+0x148/0x320
[c00000000345f8d0] [c00000000012e1b8] .__generic_file_aio_write+0x37c/0x3e4
[c00000000345f9d0] [c00000000012e2a8] .generic_file_aio_write+0x88/0xfc
[c00000000345fa90] [c0000000003390a8] .afs_file_write+0x10c/0x178
[c00000000345fb40] [c000000000188788] .do_sync_write+0xc4/0x128
[c00000000345fcc0] [c000000000189658] .vfs_write+0xe8/0x1d8
[c00000000345fd70] [c000000000189884] .SyS_write+0x68/0xb0
[c00000000345fe30] [c000000000008564] syscall_exit+0x0/0x40

afs_write_begin hits an error and calls afs_unlink_writeback. In there
we do list_del_init on an uninitialised list.

The patch below initialises ->link when creating the afs_writeback struct.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/write.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 15690bb..789b3af 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -140,6 +140,7 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 	candidate->first = candidate->last = index;
 	candidate->offset_first = from;
 	candidate->to_last = to;
+	INIT_LIST_HEAD(&candidate->link);
 	candidate->usage = 1;
 	candidate->state = AFS_WBACK_PENDING;
 	init_waitqueue_head(&candidate->waitq);

