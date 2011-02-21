Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1BUKUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:20:25 -0500
Received: from mail-bw0-f52.google.com ([209.85.214.52]:49067 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BUKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Krnz83JWMBtMVBq1ndnyjtIxozim12oaVrs0w6RZM5P0bBhrMbC0tET3wqAv4MM805
         5Evw1HdmT/JiYBhsjJU3h0zmmLSC43WCuEKFQZEozQDn2nyZeHMAP6wxpczZsbTHFPdM
         KYxqHfgU8VlEVVtOlxXJJor54hFqY7P1s8x1Q=
Message-ID: <4D623C62.8030509@suse.cz>
Date: Mon, 21 Feb 2011 11:20:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: jlbec@evilplan.org
CC: npiggin@kernel.dk, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: OOPS in configfs when doing d_delete
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when configfs_attach_group fails in configfs_register_subsystem:
        dentry = d_alloc(configfs_sb->s_root, &name);
        if (dentry) {
                d_add(dentry, NULL);

                err = configfs_attach_group(sd->s_element, &group->cg_item,
                                            dentry);
                if (err) {
                        d_delete(dentry);
                        dput(dentry);


d_delete kills the kernel. I don't know what the actual bug is here, but
d_delete looks broken anyway:
        spin_lock(&dentry->d_lock);
        inode = dentry->d_inode;
        isdir = S_ISDIR(inode->i_mode);  <======== dereference
        if (dentry->d_count == 1) {
                if (inode && !spin_trylock(&inode->i_lock)) {
                    ^^^^^  <============= test

It seems like a superfluous test, not a potential null dereference to
me, right?

The oops:
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ba
IP: [<ffffffff81166f64>] d_delete+0x34/0x100
PGD 26108067 PUD 26111067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/tty/digi_ctl255/uevent
CPU 0
Modules linked in: ...
Pid: 6876, comm: modprobe Not tainted 2.6.37-22-desktop #1 /Bochs
RIP: 0010:[<ffffffff81166f64>]  [<ffffffff81166f64>] d_delete+0x34/0x100
RSP: 0018:ffff880026123ea8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880028beb380 RCX: ffffffffa45c7bc0
RDX: 0000000000000001 RSI: ffff880028beb42d RDI: ffff880028beb388
RBP: ffff880028beb388 R08: 00000000d70f3acb R09: 000000009e367ab8
R10: 0000000000000000 R11: 000000009d377ab8 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000406750
FS:  00007f574dd28700(0000) GS:ffff88003e400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000ba CR3: 0000000026002000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 6876, threadinfo ffff880026122000, task
ffff880026dc4440)
Stack:
 ffffffffa45c0c80 ffff880028beb380 ffffffffa29204e0 ffffffffa291ca00
 0000000000000001 ffffffffffffffef 0000000c9f97db74 ffffffffa45c0c88
 ffffffffa45c0c80 ffffffffa45c0948 ffffffffa45d4000 ffffffffa45d4041
Call Trace:
 [<ffffffffa291ca00>] configfs_register_subsystem+0x110/0x1d0 [configfs]
 [<ffffffffa45d4041>] configfs_example_init+0x41/0x96
[configfs_example_macros]
 [<ffffffff810002da>] do_one_initcall+0x3a/0x170
 [<ffffffff810963ba>] sys_init_module+0xba/0x210
 [<ffffffff81002f8b>] system_call_fastpath+0x16/0x1b
 [<00007f574d672d2a>] 0x7f574d672d2a
Code: 89 fb 48 89 6c 24 08 48 8d 6b 08 48 c7 c7 80 22 a0 81 4c 89 64 24
10 e8 cb b6 3b 00 48 89 ef 45 31 e4 e8 c0 b6 3b 00 48 8b 43 10 <0f> b7
80 ba 00 00 00 25 00 f0 00 00 3d 00 40 00 00 8b 03 41 0f
RIP  [<ffffffff81166f64>] d_delete+0x34/0x100
 RSP <ffff880026123ea8>
CR2: 00000000000000ba

regards,
-- 
js
suse labs
