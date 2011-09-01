Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1IAU7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:59:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34262 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:59:06 -0400
Message-ID: <4E5FF216.2020207@suse.cz>
Date: Thu, 01 Sep 2011 22:59:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
 [3.0]
References: <20110828131502.GA2580@redhat.com>
In-Reply-To: <20110828131502.GA2580@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080707090905080808050108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080707090905080808050108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/28/2011 03:15 PM, Dave Jones wrote:
> Just saw this on a box that was recieving an rsync while I ssh'd in.
> The ssh session hung.

Yes, could you apply the attached debug patch and post a dmesg output?

> WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x52/0x90()
> Hardware name:
> Modules linked in: nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc p4_clockmod freq_table speedstep_lib nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack microcode serio_raw snd_hda_codec_realtek i2c_i801 snd_hda_intel snd_hda_codec iTCO_wdt snd_hwdep iTCO_vendor_support snd_seq snd_seq_device snd_pcm snd_timer snd r8169 soundcore mii snd_page_alloc pata_sil680 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: mperf]
> Pid: 1381, comm: sshd Not tainted 2.6.40-4.fc15.x86_64.debug #1
> Call Trace:
>   [<ffffffff81058e74>] warn_slowpath_common+0x83/0x9b
>   [<ffffffff81058ea6>] warn_slowpath_null+0x1a/0x1c
>   [<ffffffff812f8e18>] tty_ldisc_reinit+0x52/0x90
>   [<ffffffff812f9415>] tty_ldisc_hangup+0x13f/0x1e1
>   [<ffffffff812f21b6>] __tty_hangup+0x111/0x35f
>   [<ffffffff812f2429>] tty_vhangup+0xe/0x10
>   [<ffffffff812faade>] pty_close+0x128/0x132
>   [<ffffffff812f3404>] tty_release+0x1d8/0x4dc
>   [<ffffffff81087a2e>] ? lock_release_holdtime.part.8+0x6b/0x72
>   [<ffffffff8100eebf>] ? native_sched_clock+0x34/0x36
>   [<ffffffff8113cdb2>] fput+0x127/0x1f5
>   [<ffffffff81139d90>] filp_close+0x70/0x7b
>   [<ffffffff81139e91>] sys_close+0xf6/0x13b
>   [<ffffffff814fdf02>] system_call_fastpath+0x16/0x1b



-- 
js
suse labs

--------------080707090905080808050108
Content-Type: text/x-patch;
 name="0001-TTY-tty_ldisc_wait_idle-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-TTY-tty_ldisc_wait_idle-debug.patch"

>From 4fe9f5edcd187fb29298b59698cb920f2baccc15 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 8 Aug 2011 16:00:59 +0200
Subject: [PATCH 1/1] TTY: tty_ldisc_wait_idle debug

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_ldisc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 512c49f..0b90801 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -26,6 +26,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
+#include <linux/ratelimit.h>
 
 #include <linux/uaccess.h>
 #include <asm/system.h>
@@ -758,11 +759,17 @@ static void tty_reset_termios(struct tty_struct *tty)
 static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
 	struct tty_ldisc *ld = tty_ldisc_get(ldisc);
+	int ret;
 
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty));
+	ret = tty_ldisc_wait_idle(tty);
+	if (ret)
+		printk_ratelimited(KERN_DEBUG "%s: refcount of %ps is still %d\n",
+				__func__,
+				tty->ldisc->ops,
+				atomic_read(&tty->ldisc->users));
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
-- 
1.7.6.1


--------------080707090905080808050108--
