Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2JOJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:28:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2JOJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:28:23 -0400
MIME-Version: 1.0
From: William Dauchy <wdauchy@gmail.com>
Date: Mon, 15 Oct 2012 11:27:58 +0200
Message-ID: <CAJ75kXZsBfhydOSF1Tjpp_OOndWs=jbC_YvrZ9Fw22+Q4rp1yw@mail.gmail.com>
Subject: xfs: fix buffer lookup race on allocation failure
To: stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I believe, the commit fe2429b fixes the attached kernel trace.
I tested it both on top of 3.2 and 3.4 stable tree.
Could we consider adding this patch in stable tree at least for 3.2 and 3.4?

commit fe2429b0966a7ec42b5fe3bf96f0f10de0a3b536
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 23 15:58:45 2012 +1000

    xfs: fix buffer lookup race on allocation failure

    When memory allocation fails to add the page array or tht epages to
    a buffer during xfs_buf_get(), the buffer is left in the cache in a
    partially initialised state. There is enough state left for the next
    lookup on that buffer to find the buffer, and for the buffer to then
    be used without finishing the initialisation.  As a result, when an
    attempt to do IO on the buffer occurs, it fails with EIO because
    there are no pages attached to the buffer.

    We cannot remove the buffer from the cache immediately and free it,
    because there may already be a racing lookup that is blocked on the
    buffer lock. Hence the moment we unlock the buffer to then free it,
    the other user is woken and we have a use-after-free situation.

    To avoid this race condition altogether, allocate the pages for the
    buffer before we insert it into the cache.  This then means that we
    don't have an allocation  failure case to deal after the buffer is
    already present in the cache, and hence avoid the problem
    altogether.  In most cases we won't have racing inserts for the same
    buffer, and so won't increase the memory pressure allocation before
    insertion may entail.

    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>


XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
fs/xfs/xfs_buf.c, line: 598
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:101!
invalid opcode: 0000 [#1] SMP
CPU 1
Modules linked in: ipv6 xt_multiport iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
dm_mod xfs

Pid: 12505, comm: imap Not tainted 3.2.26-xenU-6909-x86_64 #4
RIP: e030:[<ffffffffa00117ed>] [<ffffffffa00117ed>] assfail+0x1d/0x30 [xfs]
RSP: e02b:ffff8800351dbd98 EFLAGS: 00010296
RAX: 000000000000008b RBX: ffff88003c8c5a80 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000204
RBP: 0000000000030015 R08: 0000000000000000 R09: 0720072007200720
R10: 0720072007200720 R11: 0720072007200720 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000002 R15: 0000000000000008
FS: 00007f034ca2b700(0000) GS:ffff88005fc20000(0000) knlGS:0000000000000000
CS: e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000040d5e0 CR3: 00000000351f1000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process imap (pid: 12505, threadinfo ffff8800351da000, task ffff880004a7a100)
Stack:
ffff88005f8d4000 ffffffffa000432b 0000000000000001 0000000000030015
ffff88003c8c5a80 ffffffffa0004d3b ffff88001e93d200 ffff88001e93d200
ffff88005f8d4000 ffffffffa004970b ffff8800351dbe28 ffff880002ebd0f8
Call Trace:
[<ffffffffa000432b>] ? _xfs_buf_read+0x4b/0x90 [xfs]
[<ffffffffa0004d3b>] ? xfs_buf_read+0x6b/0xa0 [xfs]
[<ffffffffa004970b>] ? xfs_dir2_leaf_getdents+0x4db/0x790 [xfs]
[<ffffffff810fdfd0>] ? filldir64+0x100/0x100
[<ffffffff810fdfd0>] ? filldir64+0x100/0x100
[<ffffffffa004391c>] ? xfs_readdir+0x11c/0x120 [xfs]
[<ffffffff810fdfd0>] ? filldir64+0x100/0x100
[<ffffffffa0006484>] ? xfs_file_readdir+0x34/0x50 [xfs]
[<ffffffff810fe260>] ? vfs_readdir+0xc0/0xe0
[<ffffffff810fe3f6>] ? sys_getdents+0x86/0x100
[<ffffffff8134035b>] ? xen_hypervisor_callback+0x1b/0x20
[<ffffffff8133e152>] ? system_call_fastpath+0x16/0x1b
Code: 83 c4 68 c3 66 2e 0f 1f 84 00 00 00 00 00 48 89 f1 41 89 d0 48
83 ec 08 48 89 fa 48 c7 c6 a8 0a 08 a0 31 ff 31 c0 e8 83 ff ff ff <0f>
0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 4c 8b
RIP [<ffffffffa00117ed>] assfail+0x1d/0x30 [xfs]
RSP <ffff8800351dbd98>
---[ end trace a0cc6a9ab148ad36 ]---


Regards,

-- 
William
