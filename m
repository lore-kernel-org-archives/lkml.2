Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab2BSXl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:41:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45781 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2BSXl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:41:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of james@albanarts.com designates 10.180.14.193 as permitted sender) smtp.mail=james@albanarts.com
Date: Sun, 19 Feb 2012 23:41:51 +0000
From: James Hogan <james@albanarts.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] divide by zero in uvc_video_clock_update, v3.3-rc4
Message-ID: <20120219234151.GA32005@balrog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tried v3.3-rc4 on an Acer Aspire One Happy 2 netbook. I happened
to open the settings dialog box of kopete, which shows a view of the
webcam. The kernel switched to a text console with a register dump (see below),
indicating a divide error in uvc_video_clock_update.

The IP is on 7482, a divide, presumably by %r11 (see objdump output below)
which is 0 in the register dump. It appears to be the div_u64 in
uvc_video_clock_update().

I haven't tried any other recent kernel versions.

My asm is rusty and I don't really have any time to look further into it. Is
this enough to go on?

Thanks
James


objdump output:

    7468:       48 69 c0 00 ca 9a 3b    imul   $0x3b9aca00,%rax,%rax
    746f:       48 29 d0                sub    %rdx,%rax
    7472:       8d 97 00 36 65 c4       lea    -0x3b9aca00(%rdi),%edx
    7478:       48 0f af 55 a8          imul   -0x58(%rbp),%rdx
    747d:       48 01 d0                add    %rdx,%rax
    7480:       31 d2                   xor    %edx,%edx
    7482:       49 f7 f3                div    %r11
    7485:       48 ba 53 5a 9b a0 2f    movabs $0x44b82fa09b5a53,%rdx
    748c:       b8 44 00 
          - (u64)y2 * (u64)x1;
        y = div_u64(y, x2 - x1);

        div = div_u64_rem(y, NSEC_PER_SEC, &rem);
        ts.tv_sec = first->host_ts.tv_sec - 1 + div;

kernel log:

divide error: 0000 [#1] SMP 
CPU 1 
Modules linked in: sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables rfcomm bnep arc4 brcmsmac mac80211 snd_hda_codec_realtek btusb bluetooth snd_hda_intel uvcvideo snd_hda_codec videobuf2_core videodev snd_hwdep snd_seq brcmutil cfg80211 snd_seq_device snd_pcm acer_wmi sparse_keymap snd_timer media v4l2_compat_ioctl32 videobuf2_vmalloc rfkill crc8 cordic videobuf2_memops bcma iTCO_wdt iTCO_vendor_support r8169 snd i2c_i801 microcode serio_raw joydev mii pcspkr soundcore snd_page_alloc wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]

Pid: 1393, comm: kopete Not tainted 3.3.0-rc4 #104 Acer AOHAPPY2/JE06_PT 
RIP: 0010:[<ffffffffa0267482>]  [<ffffffffa0267482>] uvc_video_clock_update+0x1d2/0x3b0 [uvcvideo]
RSP: 0018:ffff880018741ac8  EFLAGS: 00010046
RAX: 0000060d5419b0a3 RBX: ffff88003aba1800 RCX: 0000000008650000
RDX: 0000000000000000 RSI: 0000000008650000 RDI: 000000003b9c96c9
RBP: ffff880018741b98 R08: 000000003b9c96c9 R09: 0000000000000098
R10: 0000000000000079 R11: 0000000000000000 R12: ffff880010fd9780
R13: ffff880010fd9760 R14: 000000000bc1c40b R15: ffff88003aba1d50
FS:  00007f2cf7e28840(0000) GS:ffff88003f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000229cf0c CR3: 0000000018724000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kopete (pid: 1393, threadinfo ffff880018740000, task ffff880018641720)
Stack:
 ffff8800034772d0 0000000000000000 ffff880018741b28 ffff880021eaef80
 ffff880018741b18 0000000000000000 ffff880016613900 0000000002f04820
 0000000000000000 0000000000000000 ffff880018741ea4 0000000000000000
Call Trace:
 [<ffffffff81191266>] ? do_sys_poll+0x416/0x500
 [<ffffffffa0262f66>] uvc_buffer_finish+0x26/0x30 [uvcvideo]
 [<ffffffffa023073a>] vb2_dqbuf+0x23a/0x3c0 [videobuf2_core]
 [<ffffffff81290a74>] ? avc_has_perm_flags+0x74/0x90
 [<ffffffff8160e7f6>] ? mutex_lock_interruptible+0x16/0x50
 [<ffffffff815a14e4>] ? unix_stream_recvmsg+0x674/0x780
 [<ffffffffa02632c8>] uvc_dequeue_buffer+0x48/0x70 [uvcvideo]
 [<ffffffffa0264df4>] uvc_v4l2_do_ioctl+0xd64/0x1290 [uvcvideo]
 [<ffffffffa02102d0>] video_usercopy+0x120/0x550 [videodev]
 [<ffffffffa0264090>] ? uvc_v4l2_open+0x130/0x130 [uvcvideo]
 [<ffffffff81290a74>] ? avc_has_perm_flags+0x74/0x90
 [<ffffffffa02637e9>] uvc_v4l2_ioctl+0x29/0x70 [uvcvideo]
 [<ffffffffa020f3db>] v4l2_ioctl+0xcb/0x160 [videodev]
 [<ffffffff8118f018>] do_vfs_ioctl+0x98/0x550
 [<ffffffff8118f561>] sys_ioctl+0x91/0xa0
 [<ffffffff81618be9>] system_call_fastpath+0x16/0x1b
Code: f2 48 89 45 a8 89 c8 41 89 cb 49 0f af d0 41 29 f3 48 69 c0 00 ca 9a 3b 48 29 d0 8d 97 00 36 65 c4 48 0f af 55 a8 48 01 d0 31 d2 <49> f7 f3 48 ba 53 5a 9b a0 2f b8 44 00 4d 8b 5c 24 08 49 89 c0 
RIP  [<ffffffffa0267482>] uvc_video_clock_update+0x1d2/0x3b0 [uvcvideo]
 RSP <ffff880018741ac8>
---[ end trace d8809c0cd76234c6 ]---
uvcvideo: Failed to resubmit video URB (-27).
uvcvideo: Failed to resubmit video URB (-27).
uvcvideo: Failed to resubmit video URB (-27).
uvcvideo: Failed to resubmit video URB (-27).
uvcvideo: Failed to resubmit video URB (-27).
