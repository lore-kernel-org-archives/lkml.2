Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0KWPt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:49:27 -0500
Received: from blade4.isti.cnr.it ([194.119.192.20]:57428 "EHLO
	BLADE4.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab0KWPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:49:26 -0500
Date: Tue, 23 Nov 2010 16:51:11 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Bug: sync's hangup forever in call_rwsem_down_read_failed
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4CEBE2EF.5080008@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 155.253.6.254 Auth Done
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there
on 2.6.37-rc2 I was doing some speed tests. I had just unmounted various 
arrays, recreated them differently with mdadm assume-clean, and then I 
was formatting all of them:

# for i in /dev/md10* ; do echo $i ; time mkfs.ext4 -m0 $i ; time sync ; 
done
         /dev/md101
         mke2fs 1.41.9 (22-Aug-2009)
         /dev/md101 is apparently in use by the system; will not make a 
filesystem here!

         real    0m0.038s
         user    0m0.000s
         sys     0m0.000s

Here I was pretty sure the error message was wrong: md101 was not in use 
by the system anyhow, and was not mounted. I had just created it.
Anyway the subsequent sync hanged!

# cat /proc/7686/stack
         [<ffffffff8129e894>] call_rwsem_down_read_failed+0x14/0x30
         [<ffffffff81137ff1>] iterate_supers+0x71/0xf0
         [<ffffffff8115d92b>] sync_filesystems+0x1b/0x20
         [<ffffffff8115da32>] sys_sync+0x12/0x40
         [<ffffffff8100af42>] system_call_fastpath+0x16/0x1b
         [<ffffffffffffffff>] 0xffffffffffffffff

After a while I tried to launch another sync, from another shell; that 
hanged identically.

/proc# grep call_rwsem */stack
         7686/stack:[<ffffffff8129e894>] 
call_rwsem_down_read_failed+0x14/0x30
         7714/stack:[<ffffffff8129e894>] 
call_rwsem_down_read_failed+0x14/0x30
(this shows only the two syncs)

Then I tried to shut it down with poweroff -f (which does sync) and that 
hanged again

/proc# grep rwsem */stack
         7686/stack:[<ffffffff8129e894>] 
call_rwsem_down_read_failed+0x14/0x30
         7714/stack:[<ffffffff8129e894>] 
call_rwsem_down_read_failed+0x14/0x30
         7815/stack:[<ffffffff8129e894>] 
call_rwsem_down_read_failed+0x14/0x30

so I shut it down with poweroff -n -f ; that worked.

It seems to me some process did not reset the semaphore after having 
finished (= resource leak)

Sorry for not being able to help you much more than this as I have reset 
the computer now, but this is another guy reporting apparently the same 
problem on Ubuntu 10.10 kernel (I was on vanilla 2.6.37-rc2)
http://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg2579131.html

My dmesg never notified about the problem, in something like 5minutes, btw.

If you reply, please reply also to me as I am not subsribed to 
linuk-kernel .
Thanks for your work
