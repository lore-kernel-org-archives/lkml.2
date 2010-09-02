Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0IBSzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0IBSzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:55:11 -0400
Date: Thu, 2 Sep 2010 14:55:09 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: bdi-default hung waiting for kthread_stop to finish
Message-ID: <20100902145509.28e4f998@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing some cifs patches by running the fsstress program from
LTP on a cifs mount on a very recent kernel. After running ~70 minutes
or so, I got this in the ring buffer:

INFO: task bdi-default:26 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bdi-default   D 0000000000000001  3256    26      2 0x00000000
 ffff88003e789c60 0000000000000046 ffffffff00000000 00000000001d5180
 00000000001d5180 ffff88003e782450 ffff88003e789fd8 00000000001d5180
 00000000001d5180 00000000001d5180 00000000001d5180 ffff88003e789fd8
Call Trace:
 [<ffffffff814994e1>] schedule_timeout+0x39/0xfe
 [<ffffffff8107d99a>] ? lock_acquired+0x1fd/0x20c
 [<ffffffff8107fc2a>] ? lock_release+0x19a/0x1a6
 [<ffffffff81080158>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff814992bb>] wait_for_common+0xb0/0x10a
 [<ffffffff81049fc1>] ? default_wake_function+0x0/0x14
 [<ffffffff814993cd>] wait_for_completion+0x1d/0x1f
 [<ffffffff8106c497>] kthread_stop+0x73/0xc2
 [<ffffffff810f95f3>] bdi_forker_thread+0x38c/0x42a
 [<ffffffff810f9267>] ? bdi_forker_thread+0x0/0x42a
 [<ffffffff8106c41c>] kthread+0x9d/0xa5
 [<ffffffff8100ab24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8149bc10>] ? restore_args+0x0/0x30
 [<ffffffff8106c37f>] ? kthread+0x0/0xa5
 [<ffffffff8100ab20>] ? kernel_thread_helper+0x0/0x10

I'm assuming that it's waiting on flush-* to exit. The problem is that
all of the ones that I see on the box just seem to be sitting there
idle. Here's the one for cifs, but the others seem to be sitting in
exactly the same spot:

flush-cifs-2  S 0000000000000003  6512  8398      2 0x00000000
 ffff880007f41e20 0000000000000046 ffff880007f41d90 00000000001d5180
 00000000001d5180 ffff88003bcec8a0 ffff880007f41fd8 00000000001d5180
 00000000001d5180 00000000001d5180 00000000001d5180 ffff880007f41fd8
Call Trace:
 [<ffffffff8114987f>] bdi_writeback_thread+0x14f/0x211
 [<ffffffff81149730>] ? bdi_writeback_thread+0x0/0x211
 [<ffffffff8106c41c>] kthread+0x9d/0xa5
 [<ffffffff8100ab24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8149bc10>] ? restore_args+0x0/0x30
 [<ffffffff8106c37f>] ? kthread+0x0/0xa5
 [<ffffffff8100ab20>] ? kernel_thread_helper+0x0/0x10

Stuff like statfs() and readdir() to the cifs mount seems to be fine,
but writeback seems to be frozen. 

    2.6.36-0.14.rc3.git0.fc15.x86_64

The machine is a KVM guest. The fsstress command is:

    # fsstress -d /mnt/cifs/fsstress -l0 -n 1000 -p 8

Let me know if other info would be helpful in tracking this down.
-- 
Jeff Layton <jlayton@redhat.com>
