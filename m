Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1EESAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:00:42 -0400
Received: from mail.tpi.com ([70.99.223.143]:1554 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab1EESAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:00:41 -0400
Message-ID: <4DC2E5C3.2050602@canonical.com>
Date: Thu, 05 May 2011 12:00:35 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Anca Emanuel <anca.emanuel@gmail.com>, kernel-team@lists.ubuntu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Patch not upstream: fix race between open and removal of framebuffers
References: <BANLkTikAc66kTknEKCX4Mbg7_9CGw+qDfQ@mail.gmail.com>	<4D9DC39A.2080207@canonical.com>	<BANLkTikcbGVemWrs+3ZeAvLFafM339CP9w@mail.gmail.com> <20110505095656.41bcd946@jbarnes-desktop>
In-Reply-To: <20110505095656.41bcd946@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 10:56 AM, Jesse Barnes wrote:
> On Thu, 5 May 2011 19:54:20 +0300
> Anca Emanuel<anca.emanuel@gmail.com>  wrote:
>> I'm using 2.6.39-rc6 now
>>
>> I still get:
>> [   21.964367] BUG: unable to handle kernel paging request at 0000010a00000010
>> [   21.964396] IP: [<ffffffff8130abe0>] fb_release+0x30/0x70
>> [   21.964410] PGD 0
>> [   21.964416] Oops: 0000 [#1] SMP
>> [   21.964424] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
>> [   21.964434] CPU 1
>> [   21.964438] Modules linked in: parport_pc ppdev
>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
>> adt7475 hwmon_vid snd_seq_midi snd_rawmidi snd_seq_midi_event nouveau
>> snd_seq snd_timer snd_seq_device ttm drm_kms_helper snd intel_agp
>> psmouse soundcore serio_raw intel_gtt snd_page_alloc drm i2c_algo_bit
>> video lp parport pata_marvell ahci libahci r8169 mii
>> [   21.964528]
>> [   21.964533] Pid: 221, comm: plymouthd Not tainted 2.6.39-rc6 #7
>> MICRO-STAR INTERNATIONAL CO.,LTD MS-7360/MS-7360
>> [   21.964548] RIP: 0010:[<ffffffff8130abe0>]  [<ffffffff8130abe0>]
>> fb_release+0x30/0x70
>> [   21.964560] RSP: 0018:ffff880037211eb8  EFLAGS: 00010286
>> [   21.964566] RAX: ffff880037210000 RBX: ffff88007f817000 RCX: 0000000000000001
>> [   21.964573] RDX: 0000010a00000000 RSI: ffff8800370f5540 RDI: ffff88007f817008
>> [   21.964580] RBP: ffff880037211ec8 R08: 0000000000000000 R09: 0000000000000000
>> [   21.964588] R10: ffff8800370f5550 R11: 0000000000000246 R12: ffff88007f817008
>> [   21.964595] R13: ffff88007d3db540 R14: ffff88007be34d90 R15: ffff88007be34d90
>> [   21.964604] FS:  00007fb335025720(0000) GS:ffff88007fc80000(0000)
>> knlGS:0000000000000000
>> [   21.964739] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   21.964746] CR2: 0000010a00000010 CR3: 000000007b41a000 CR4: 00000000000006e0
>> [   21.964754] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   21.964762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   21.964770] Process plymouthd (pid: 221, threadinfo
>> ffff880037210000, task ffff880036cd16c0)
>> [   21.964778] Stack:
>> [   21.964782]  ffff8800370f5540 0000000000000008 ffff880037211f18
>> ffffffff8115cfaa
>> [   21.964797]  ffff8800370f5550 ffff8800793c7b00 ffff88006744fcd0
>> ffff8800370f5540
>> [   21.964811]  ffff88007c3b9080 0000000000000000 000000000000000b
>> 0000000000000000
>> [   21.964825] Call Trace:
>> [   21.964834]  [<ffffffff8115cfaa>] fput+0xea/0x220
>> [   21.964842]  [<ffffffff811591f6>] filp_close+0x66/0x90
>> [   21.964849]  [<ffffffff811597c7>] sys_close+0xb7/0x120
>> [   21.964858]  [<ffffffff815b3002>] system_call_fastpath+0x16/0x1b
>> [   21.964865] Code: 83 ec 10 48 89 1c 24 4c 89 64 24 08 0f 1f 44 00
>> 00 48 8b 9e a0 00 00 00 4c 8d 63 08 4c 89 e7 e8 d7 ea 29 00 48 8b 93
>> b8 03 00 00
>> [   21.964944]  8b 42 10 48 85 c0 74 11 be 01 00 00 00 48 89 df ff d0 48 8b
>> [   21.964983] RIP  [<ffffffff8130abe0>] fb_release+0x30/0x70
>> [   21.964992]  RSP<ffff880037211eb8>
>> [   21.964997] CR2: 0000010a00000010
>>
>> I can use de PC, but when it wake up from S3, hangs.
>> full dmesg at: http://pastebin.com/rhMJrF2x
>> uname -a
>> Linux ubuntu 2.6.39-rc6 #7 SMP Wed May 4 12:26:39 EEST 2011 x86_64
>> x86_64 x86_64 GNU/Linux
>>
>> I read that Ubuntu have something like 150 patches NOT upstreamed. Why ?
>> And other guys complaining about the hard work they do to maintain
>> stable and mainline.
>>
>> If you not upstream your work, then what is the ideea ? Keep it only
>> for Ubuntu users ?
>>
>> I have the latest Linus git tree, and I applied the patch like this:
>> wget http://is.gd/otIfGc
>> git apply otIfGc
>>
>> Linus, if nobody ask you, please apply the patch.
>> With Tested-by: Anca Emanuel<anca.emanuel@gmail.com>
>>
>> full dmesg after the patch: http://pastebin.com/XtNXzgPc
>> Tested sleep and wake up from S3.
>
> Yeah, I'd like to see this fixed too.  Without it, everyone on
> the latest Ubuntu release will see this bug whenever they try to boot
> an upstream kernel.
>

OK, I've sent it to the references indicated by scripts/get_maintainers.pl

rtg
-- 
Tim Gardner tim.gardner@canonical.com
