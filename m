Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1BOEmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 23:42:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:45563 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1BOEmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 23:42:15 -0500
Date: Tue, 15 Feb 2011 15:42:09 +1100
From: Anton Blanchard <anton@au1.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: afs: Fix oops in afs_unlink_writeback
Message-ID: <20110215154209.31471f05@kryten>
In-Reply-To: <20110215153856.10e19fbf@kryten>
References: <20110215153856.10e19fbf@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org 
Subject: afs: Fix oops in afs_unlink_writeback

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
---

Index: linux-2.6/fs/afs/write.c
===================================================================
--- linux-2.6.orig/fs/afs/write.c	2011-02-15 08:57:38.941571526 +1100
+++ linux-2.6/fs/afs/write.c	2011-02-15 13:50:34.793404142 +1100
@@ -144,6 +144,7 @@ int afs_write_begin(struct file *file, s
 	candidate->first = candidate->last = index;
 	candidate->offset_first = from;
 	candidate->to_last = to;
+	INIT_LIST_HEAD(&candidate->link);
 	candidate->usage = 1;
 	candidate->state = AFS_WBACK_PENDING;
 	init_waitqueue_head(&candidate->waitq);
