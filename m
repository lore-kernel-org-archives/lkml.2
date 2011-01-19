Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1ASMkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:40:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32861 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1ASMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MiPHVUp/DVNss+PwtVQY3bVEvJAjyUoRV1tnCRcUNjMhoTuE7skzk+Kg598gJ+4Eak
         FQsI6tDI9gPNJA3ZHEIH52PUZSCJwDtrigsiE3MhZwH3iTVT5RMM6d4h5qkbCMyE/3o9
         DvU7mxmH6feJV9NIbgsvl510a584TaWHs72a8=
Date: Wed, 19 Jan 2011 14:40:47 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, idryomov@gmail.com
Subject: [BUG] BUG: unable to handle kernel paging request at fffba000
Message-ID: <20110119124047.GA30274@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just built a fresh 38-rc1 kernel with transparent huge page support
built-in (TRANSPARENT_HUGEPAGE=y) and it failed to boot with the
following bug.  However after the reboot everything went fine.  It turns
out it only happens when fsck checks one or more filesystems before they
are mounted.

It's easily reproducable it with touch /forcefsck and reboot on one of
my 32-bit machines.  Haven't tried it on others yet.

Thanks,

		Ilya

Checking file systems...fsck from util-linux-ng 2.17.2
/dev/mapper/vg_zmb-lv_home: 235/2992416 files (0.4% non-contiguous),
2461505/11968512 blocks
/dev/mapper/vg_zmb-lv_tmp: 13/62464 files (0.0% non-contiguous), 8334/249856
blocks
/dev/mapper/vg_zmb-lv_usr: 24821/187680 files (0.2% non-contiguous),
152556/749568 blocks
/dev/mapper/vg_zmb-lv_var: 2871/375360 files (1.1% non-contiguous),
222844/1499136 blocks
[   13.716535] BUG: unable to handle kernel paging request at fffba000
[   13.717402] IP: [<c1149f3d>] khugepaged+0x9dd/0xd00
[   13.717402] *pde = 017da067 *pte = 00000000 
[   13.717402] Oops: 0000 [#1] PREEMPT SMP 
[   13.717402] last sysfs file: /sys/devices/virtual/net/lo/operstate
[   13.717402] Modules linked in:
[   13.717402] 
[   13.717402] Pid: 582, comm: khugepaged Not tainted 2.6.38-rc1-testbox2 #7
EP35-DS3/EP35-DS3
[   13.717402] EIP: 0060:[<c1149f3d>] EFLAGS: 00010287 CPU: 0
[   13.717402] EIP is at khugepaged+0x9dd/0xd00
[   13.717402] EAX: 00000000 EBX: f307ef68 ECX: fffba000 EDX: fffbb000
[   13.717402] ESI: f77eb4c0 EDI: f77d5000 EBP: f4731f9c ESP: f4731f1c
[   13.885304]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   13.885304] Process khugepaged (pid: 582, ti=f4730000 task=f51a1f80
task.ti=f4730000)
[   13.885304] Stack:
[   13.885304]  00000000 f51a1f80 b7000000 f51a1f80 df826067 00000001 fffbb000
00000292
[   13.885304]  f307ef68 efe8bb70 f307ef68 f77d5000 f3874570 fffba000 00002000
f307ef68
[   13.885304]  f3874534 00000000 00000004 f3874500 f51a1f80 f77d5000 f07a7000
00000001
[   13.885304] Call Trace:
[   13.885304]  [<c10948c0>] ? autoremove_wake_function+0x0/0x40
[   13.885304]  [<c1149560>] ? khugepaged+0x0/0xd00
[   13.885304]  [<c1094474>] kthread+0x74/0x80
[   13.885304]  [<c1094400>] ? kthread+0x0/0x80
[   13.885304]  [<c103977a>] kernel_thread_helper+0x6/0x10
[   13.885304] Code: 1d 00 89 d8 e8 15 75 f1 ff 8b 7d bc 8b 07 ff 80 a0 01 00 00
83 45 ac 20 83 45 b4 04 8b 55 98 39 55 b4 0f 83 35 02 00 00 8b 4d b4 <8b> 19 85
db 74 bb c1 eb 0c c1 e3 05 03 1d 00 20 d8 c1 89 d8 e8 
[   13.885304] EIP: [<c1149f3d>] khugepaged+0x9dd/0xd00 SS:ESP 0068:f4731f1c
[   13.885304] CR2: 00000000fffba000
[   13.885304] ---[ end trace 7890962500b65912 ]---
