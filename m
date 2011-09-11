Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1IKBbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:31:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1IKBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:31:51 -0400
Message-ID: <4E6C1016.8030703@vlnb.net>
Date: Sat, 10 Sep 2011 21:34:14 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110424 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Lockdep and rw_semaphores
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:bwDRD9FPkjgxLOp0mICGfwrJZ0hgttP1GZX7O+t9SGd
 3GUF4m8oU3cOdFfSS8JxquiCV4xr/2Xn6G11vmksp83Wcf7uTW
 1srz7kJDS9+xo5lZytW9hBJ/NmWoQjdLljh5gb3g9AaLHplLbb
 TzxT4SfasBNc4qdQOXAkdSvy4glLhbNEwW369wzfKrsN/AEfJA
 9uZkQnLXNnGWyTt0hrWQ7Q3dkRlXH34utCYUPFoIxhAN/2GB2m
 tFoCdoNizSFSJZPQNJ7+3nGQ/NeMgr2W1/wPoUZSNMzVus0CYM
 HbSEaLb5gC6eBHLYWhkPawY+ZX2eSfnMLcblt0ItWhedKWmuzZ
 tWsDbBGrOpa0oHd/rWZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Looks like lockdep somehow over-restrictive for rw_semaphores in case when they
are taken for read (down_read()) and requires them to follow the same inner-outer
rules as for plain locks.

For instance, code like:

DECLARE_RWSEM(QQ_sem);
DECLARE_RWSEM(QQ1_sem);

thread1:

        down_read(&QQ_sem);
        down_read(&QQ1_sem);

        msleep(60000);

        up_read(&QQ1_sem);
        up_read(&QQ_sem);

thread2:

	down_read(&QQ1_sem);
	down_read(&QQ_sem);

	fn();

	up_read(&QQ_sem);
	up_read(&QQ1_sem);

will trigger possible circular locking dependency detected warning, like:

=======================================================
[ INFO: possible circular locking dependency detected ]
3.0.0 #20
-------------------------------------------------------
thread2/5290 is trying to acquire lock:
 (QQ_sem){.+.+..}, at: [<ffffffffa04453a5>] thread2+0x135/0x220

but task is already holding lock:
 (QQ1_sem){.+.+..}, at: [<ffffffffa0445399>] thread2+0x129/0x220

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (QQ1_sem){.+.+..}:
       [<ffffffff81080fb1>] validate_chain+0x6a1/0x7a0
       [<ffffffff8108139b>] __lock_acquire+0x2eb/0x4c0
       [<ffffffff81081c07>] lock_acquire+0x97/0x140
       [<ffffffff8141871c>] down_read+0x4c/0xa0
       [<ffffffffa0418b3e>] thread1+0x4e/0xb0
       [<ffffffff81068976>] kthread+0xa6/0xb0
       [<ffffffff81422254>] kernel_thread_helper+0x4/0x10

-> #0 (QQ_sem){.+.+..}:
       [<ffffffff810808e7>] check_prev_add+0x517/0x540
       [<ffffffff81080fb1>] validate_chain+0x6a1/0x7a0
       [<ffffffff8108139b>] __lock_acquire+0x2eb/0x4c0
       [<ffffffff81081c07>] lock_acquire+0x97/0x140
       [<ffffffff8141871c>] down_read+0x4c/0xa0
       [<ffffffffa04455c7>] thread2+0x137/0x2d0
       [<ffffffff81068976>] kthread+0xa6/0xb0
       [<ffffffff81422254>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(QQ1_sem);
                               lock(QQ_sem);
                               lock(QQ1_sem);
  lock(QQ_sem);

 *** DEADLOCK ***

1 lock held by thread2/5290:
 #0:  (QQ1_sem){.+.+..}, at: [<ffffffffa0445399>] thread2+0x129/0x220
stack backtrace:
Pid: 5290, comm: thread2 Not tainted 3.0.0 #20
Call Trace:
 [<ffffffff8107e9b7>] print_circular_bug+0x107/0x110
 ...

Is it by design or just something overlooked? I don't see how reverse order of
down_read()'s can lead to any deadlock. Or am I missing anything?

Thanks,
Vlad
