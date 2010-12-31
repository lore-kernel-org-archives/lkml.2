Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0LaKXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:23:14 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56386 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0LaKXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:23:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=eXyphJuKuUnIKGWgZaUHFtas3DRXAIgJK84DwpyMITwuNZ+iOtPl0QCQ1hhq08u7HU
         3SApFT4TBRaQH0tE6iQusp1MuFS418ZOp01iOY67EAfVCUcFIF5EH5hDxvP3gRKrifIr
         0cDaUdyWeBfkX6UcDZ8LkU5pvqCaTGkQErFIo=
Message-ID: <4D1DAF0A.40000@gmail.com>
Date: Fri, 31 Dec 2010 02:23:06 -0800
From: Stephen Boyd <bebarino@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: BUG in rt2x00lib_txdone() with 2.6.37-rc8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think I'm hitting a rare bug in rt2x00lib_txdone(). Usually I can't
capture it since a second or third bug hits immediately after and
everything wraps off the screen. I'm fairly certain the same bug is
hitting on rc8, but I only got the oops in my logs with an rc7 kernel
including the latest net tree merge. Reproducing the bug is hit or miss
and I don't know a good way to trigger it.

I have an rt73usb device on an x86_64 machine, lsusb shows:

Bus 001 Device 004: ID 050d:705a Belkin Components F5D7050 Wireless G
Adapter v3000 [Ralink RT2573]

This is all of the oops that I could recover.

[ 9085.714105] BUG: unable to handle kernel NULL pointer dereference at
00000000000000a4
[ 9085.714816] IP: [<ffffffffa0025458>] rt2x00lib_txdone+0x36/0x249
[rt2x00lib]
[ 9085.715017] PGD 215fd067 PUD 292f4067 PMD 0
[ 9085.715017] Oops: 0000 [#1] SMP
[ 9085.715017] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[ 9085.715017] CPU 1
[ 9085.715017] Modules linked in: usb_storage thermal snd_seq_oss
snd_seq_midi snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_hrtimer
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event
snd_seq_midi_emul snd_seq scsi_wait_scan powernow_k8 mperf i2c_i801 fuse
fan snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
snd_seq_device snd_timer snd_page_alloc snd_util_mem rt73usb crc_itu_t
rt2x00usb snd_hwdep snd processor r8169 via82cxxx rt2x00lib soundcore
mii button k8temp
[ 9085.715017]
[ 9085.715017] Pid: 11513, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #27
MS-7094/MS-7094
[ 9085.715017] RIP: 0010:[<ffffffffa0025458>]  [<ffffffffa0025458>]
rt2x00lib_txdone+0x36/0x249 [rt2x00lib]
[ 9085.715017] RSP: 0000:ffff880000057ca0  EFLAGS: 00010286
[ 9085.715017] RAX: 0000000000000030 RBX: ffff88003b64e3c0 RCX:
ffff880000057ca0
[ 9085.715017] RDX: 0000000000000006 RSI: ffff880000057d00 RDI:
0000000000000000
[ 9085.715017] RBP: ffff880000057cf0 R08: ffff88003c7c7110 R09:
0000000000000001
[ 9085.715017] R10: ffffffff81df3c10 R11: 0000000000000282 R12:
ffff88003c586280
[ 9085.715017] R13: 0000000000000000 R14: 0000000000000028 R15:
ffff880000057d00
[ 9085.715017] FS:  00002b41e037b160(0000) GS:ffff88003f

I think the entry or skb in the entry is NULL, but I'm not sure how
that's possible. Here's an objdump of the erroring code if that helps.

0000000000000422 <rt2x00lib_txdone>:
     422:       55                      push   %rbp
     423:       48 89 e5                mov    %rsp,%rbp
     426:       41 57                   push   %r15
     428:       41 56                   push   %r14
     42a:       41 55                   push   %r13
     42c:       41 54                   push   %r12
     42e:       53                      push   %rbx
     42f:       48 83 ec 28             sub    $0x28,%rsp
     433:       e8 00 00 00 00          callq  438 <rt2x00lib_txdone+0x16>
     438:       4c 8b 6f 10             mov    0x10(%rdi),%r13
     43c:       48 8b 47 08             mov    0x8(%rdi),%rax
     440:       49 89 fc                mov    %rdi,%r12
     443:       49 89 f7                mov    %rsi,%r15
     446:       48 8b 18                mov    (%rax),%rbx
     449:       49 8d 45 30             lea    0x30(%r13),%rax
     44d:       4c 89 ef                mov    %r13,%rdi
     450:       4d 8d 75 28             lea    0x28(%r13),%r14
     454:       48 89 45 c8             mov    %rax,-0x38(%rbp)
     458:       41 8b 95 a4 00 00 00    mov    0xa4(%r13),%edx  <--- here
     45f:       66 89 55 c2             mov    %dx,-0x3e(%rbp)
     463:       e8 00 00 00 00          callq  468 <rt2x00lib_txdone+0x46>
     468:       89 45 c4                mov    %eax,-0x3c(%rbp)
     46b:       41 8a 45 30             mov    0x30(%r13),%al
