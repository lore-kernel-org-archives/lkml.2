Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0LAJFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:05:17 -0500
Received: from lo.gmane.org ([80.91.229.12]:57998 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab0LAJFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:05:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Simon Schubert <2@0x2c.org>
Subject: BUG in =?utf-8?b?c2tiX2RlcXVldWU=?= (skb->next is NULL) (was: Re: Kernel crash with 2.6.36)
Date: Wed, 1 Dec 2010 09:02:22 +0000 (UTC)
Message-ID: <loom.20101201T095252-592@post.gmane.org>
References: <alpine.LNX.2.00.1011071631550.2636@dyndns.pervalidus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.221.198.25 (Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Ubuntu/10.10 Chromium/7.0.517.44 Chrome/7.0.517.44 Safari/534.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric L. W. Meunier <2 <at> pervalidus.net> writes:

> Nov  7 16:21:23 pervalidus kernel: BUG: unable to handle kernel NULL pointer 
dereference at (null)

I can confirm the bug reported by Frederic.  The culprit is at:

        next->prev = prev;

in __skb_unlink().

Something must be putting NULL pointers in the skb list.

Let me know how I can be of further help.


BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81459069>] skb_dequeue+0x59/0x90
PGD 208379067 PUD 20a523067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
CPU 1 
Modules linked in: binfmt_misc kvm_intel kvm ipt_MASQUERADE iptable_nat nf_nat 
xfrm_user nf_conntrack_ipv4 xfrm4_tunnel tunnel4 nf_conntrack ipcomp xfrm_ipcomp 
esp4 ah4 nf_defrag_ipv4 xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle deflate 
ip_tables zlib_deflate ctr x_tables twofish_generic twofish_x86_64 
twofish_common camellia serpent blowfish cast5 des_generic xcbc rmd160 
sha512_generic sha1_generic crypto_null af_key pppoe pppox xfs exportfs 
snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer ftdi_sio snd_seq_device usbserial hwmon_vid 
coretemp snd lp tpm_tis ppdev tpm parport_pc asus_atk0110 tpm_bios parport 
soundcore snd_page_alloc sha256_generic cryptd aes_x86_64 aes_generic dm_crypt 
raid10 raid1 raid0 multipath linear raid456 async_pq async_xor xor async_memcpy 
async_raid6_recov raid6_pq async_tx fbcon tileblit font bitblit softcursor usb

Pid: 2229, comm: pulseaudio Not tainted 2.6.36 #10 P5Q-VM DO/System Product Name
RIP: 0010:[<ffffffff81459069>]  [<ffffffff81459069>] skb_dequeue+0x59/0x90
RSP: 0018:ffff880221927a78  EFLAGS: 00010097
RAX: 0000000000000282 RBX: ffff88017a6d5e14 RCX: ffff88022236d200
RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffff88017a6d5e14
RBP: ffff880221927a98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: ffff88022236d200
R13: ffff88017a6d5e00 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fedd4d9f740(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000020837a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pulseaudio (pid: 2229, threadinfo ffff880221926000, task 
ffff8802210096d0)
Stack:
 ffff88022236d200 ffff88022236d228 ffff88022236d200 ffff880221927f18
<0> ffff880221927be8 ffffffff814ef0fa ffff880221927e4c ffff880221927eb4
<0> 0000000000000040 ffff8802210096d0 ffff8802210096d0 ffff88017a6d5ea4
Call Trace:
 [<ffffffff814ef0fa>] unix_stream_recvmsg+0x1aa/0x790
 [<ffffffff8145124d>] sock_recvmsg+0xfd/0x130
 [<ffffffff81155fd0>] ? pollwake+0x0/0x60
 [<ffffffff81452b54>] __sys_recvmsg+0x144/0x2e0
 [<ffffffff81155fd0>] ? pollwake+0x0/0x60
 [<ffffffff8104d88a>] ? finish_task_switch+0x4a/0xd0
 [<ffffffff8154fa91>] ? schedule+0x411/0xa50
 [<ffffffff81452f99>] sys_recvmsg+0x49/0x80
 [<ffffffff8100b0b2>] system_call_fastpath+0x16/0x1b
Code: e5 74 4f 4d 85 e4 74 26 41 83 6d 10 01 49 8b 0c 24 49 8b 54 24 08 49 c7 04 
24 00 00 00 00 49 c7 44 24 08 00 00 00 00 48 89 51 08 <48> 89 0a 48 89 c6 48 89 
df e8 39 93 0f 00 4c 89 e0 48 8b 5d e8 
RIP  [<ffffffff81459069>] skb_dequeue+0x59/0x90
 RSP <ffff880221927a78>
CR2: 0000000000000000
---[ end trace d4be3de9fdd70935 ]---

cheers
  simon




