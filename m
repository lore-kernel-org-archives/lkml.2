Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab0JXTOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 15:14:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab0JXTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 15:14:22 -0400
Message-ID: <4CC48587.5010907@redhat.com>
Date: Sun, 24 Oct 2010 21:14:15 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: OOPs on loop module removal
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,
Simple modprobe loop ; rmmod loop
on Linus' tree now produces now OOPS.

Bisected to patch (and reverting fixes problem)

commit 7681bfeeccff5efa9eb29bf09249a3c400b15327
Author: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Date:   Tue Oct 19 09:05:00 2010 +0200

    block: fix accounting bug on cross partition merges

The problem is probably that patch uses directly q->queue_lock
even if queue is being destroyed (QUEUE_FLAG_DEAD is set).
See what loop (and not only this code) does:

        blk_cleanup_queue(lo->lo_queue);
	put_disk(lo->lo_disk);

Milan


OOPS:
[   40.778161] BUG: unable to handle kernel NULL pointer dereference at (null)
[   40.779104] IP: [<c11bf2e5>] do_raw_spin_trylock+0x5/0x37
[   40.779843] *pde = 00000000 
[   40.780113] Oops: 0000 [#1] PREEMPT SMP 
[   40.780410] last sysfs file: /sys/devices/virtual/block/loop7/removable
[   40.780876] Modules linked in: loop(-) usbcore dm_mod
[   40.781442] 
[   40.781740] Pid: 3781, comm: rmmod Not tainted 2.6.36+ #85 440BX Desktop Reference Platform/VMware Virtual Platform
[   40.782177] EIP: 0060:[<c11bf2e5>] EFLAGS: 00010082 CPU: 1
[   40.782437] EIP is at do_raw_spin_trylock+0x5/0x37
[   40.782667] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[   40.782906] ESI: 00000010 EDI: cee60800 EBP: cef07ea4 ESP: cef07ea4
[   40.804954]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   40.805080] Process rmmod (pid: 3781, ti=cef06000 task=cf5fe070 task.ti=cef06000)
[   40.805254] Stack:
[   40.805343]  cef07ec4 c130ee92 00000000 00000002 00000000 c11acf48 ce1412e0 ced14070
[   40.805521] <0> cef07ed4 c11acf48 cec08c00 c14a1a50 cef07ee0 c11acfbd ce1f6d40 cef07eec
[   40.805747] <0> c122d14c cec08c58 cef07f00 c11b5982 cec08c74 c11b5942 ce14fe00 cef07f10
[   40.807338] Call Trace:
[   40.807576]  [<c130ee92>] ? _raw_spin_lock_irq+0x35/0x5e
[   40.807681]  [<c11acf48>] ? disk_replace_part_tbl+0x27/0x49
[   40.807771]  [<c11acf48>] ? disk_replace_part_tbl+0x27/0x49
[   40.807858]  [<c11acfbd>] ? disk_release+0x1b/0x3b
[   40.807944]  [<c122d14c>] ? device_release+0x35/0x65
[   40.808030]  [<c11b5982>] ? kobject_release+0x40/0x50
[   40.808113]  [<c11b5942>] ? kobject_release+0x0/0x50
[   40.808197]  [<c11b6765>] ? kref_put+0x39/0x42
[   40.808277]  [<c11b58be>] ? kobject_put+0x37/0x3c
[   40.808360]  [<c11ad1fd>] ? put_disk+0xf/0x11
[   40.808636]  [<d087a07a>] ? loop_free+0x1c/0x4b [loop]
[   40.808723]  [<d087c199>] ? loop_exit+0x4d/0x8d [loop]
[   40.808821]  [<c1060c74>] ? sys_delete_module+0x18c/0x1f5
[   40.808913]  [<c10a5c00>] ? unmap_region+0x10f/0x12f
[   40.809000]  [<c1002893>] ? sysenter_do_call+0x12/0x32
[   40.809113] Code: 89 c3 85 c0 74 0e 89 06 89 f2 8b 45 f0 e8 37 26 07 00 eb 07 89 f0 e8 89 20 07 00 59 89 d8 5b 5b 5e 5f c9 c3 90 90 55 89 c2 89 e5 <0f> b7 02 38 e0 8d 88 00 01 00 00 75 05 f0 66 0f b1 0a 0f 94 c1 
[   40.809938] EIP: [<c11bf2e5>] do_raw_spin_trylock+0x5/0x37 SS:ESP 0068:cef07ea4
[   40.810128] CR2: 0000000000000000


