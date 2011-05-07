Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1EGGzD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:55:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1EGGzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ReCrEzjNIPvVp36ehoyE9ofDR4ECnrXqhzaHWodR/UlVA1avBM4Bp0/QsnScagqWFI
         rsTfZNOvHeAS8ShzSNcOeMMnr21U4MhiQzOXd0lA7NtxkAPEh2E1xCLxW+tiGoqznaq8
         NLXvUEL/rNfrPyZ9NEkscxIK7hpUjjc0EA+D8=
MIME-Version: 1.0
Date: Fri, 6 May 2011 23:54:59 -0700
Message-ID: <BANLkTimXpLx9GsOUF921ZGGhiV9GkcoS2A@mail.gmail.com>
Subject: Re: Oops with Kernel 2.6.38.5
From: Connor H <cmdkhh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am pretty new to kernel development in general, so I  decided to try
to track down the kernel oops below.

Anyway, this is what I have so far.....

RIP at oops was at
*ata_eh_recover+0x9a1

gdb offset listed:
(gdb) list *ata_eh_recover+0x9a1
0xffffffff813465f6 is in ata_scsi_port_error_handler
(drivers/ata/libata-eh.c:785).
785      ata_port_printk(ap, KERN_ERR, "EH pending after %d "
                      "tries, giving up\n", ATA_EH_MAX_TRIES);
which didnt make sense because the only think that could fail is ap
which is checked before its called and is under spinlock

I tried to disassemble the oops Code:
Dump of assembler code for function str:
   0x0000000000601040 <+0>:      8b 95 70 ff ff ff      mov    -0x90(%rbp),%edx
   0x0000000000601046 <+6>:      b8 00 00 00 00 mov    $0x0,%eax
   0x000000000060104b <+11>:     48 3b 9a 10 2e 00 00   cmp    0x2e10(%rdx),%rbx
   0x0000000000601052 <+18>:     48 0f 44 c2    cmove  %rdx,%rax
   0x0000000000601056 <+22>:     48 89 85 70 ff ff ff   mov    %rax,-0x90(%rbp)
   0x000000000060105d <+29>:     48 8b 8d 70 ff ff ff   mov    -0x90(%rbp),%rcx
   0x0000000000601064 <+36>:     f6 83 69 02 00 00 01   testb  $0x1,0x269(%rbx)
   0x000000000060106b <+43>:     <48> 8b 41 18    mov    0x18(%rcx),%rax
   0x000000000060106f <+47>:     0f 85 48 01 00 00      jne    0x6011bd
   0x0000000000601075 <+53>:     48 85 c9       test   %rcx,%rcx
   0x0000000000601078 <+56>:     74 12  je     0x60108c
   0x000000000060107a <+58>:     48 8b 51 08    mov    0x8(%rcx),%rdx
   0x000000000060107e <+62>:     48 83 00 00    addq   $0x0,(%rax)

And marked in bold the instruction pointer at the oops

assembly
Starting at +0
+0 move -0x90(rbp) to edx
+6 move 0 to eax
+11 compare some rdx value to rbx (not really enough in the code debug
to tell what this is doing)
+18 conditional move rdx and rax if equal rdx = rax = 0 (assume no,
rdx came from stack)
+22 move 0(rax) to some stack at -0x90(rbp)
+29 move 0( -0x90(rbp) was just set to 0) to rcx
+36 test if 1 = some rbx value (again not really useful)
+43 move 0x18(rcx is 0 here), rax    null pointer dereference when
trying to access rcx, his kernel log show both rax and rdx as 0

I am having some trouble from here. I'm not sure I am even on the
right path, but what better way to swim than to jump, included the
kernel oops below,
Connor


On Wed, May 04, 2011 at 08:27:57PM -0400, Nathan A. Mourey II wrote:
> I am resending this to the kernel mailing list.  I sent it before

> as an attachment.  I have just included the bare essentials this time.
> Hope it helps.
>
>
> Kernel Oops for v 2.6.38.5
>
>
> May  2 19:00:11 localhost kernel: [   47.919691] EXT4-fs (sda6): re-mounted. Opts: commit=0

> May  2 19:00:12 localhost kernel: [   48.451802] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> May  2 19:00:12 localhost kernel: [   48.451808] IP: [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510

> May  2 19:00:12 localhost kernel: [   48.451815] PGD 0
> May  2 19:00:12 localhost kernel: [   48.451817] Oops: 0000 [#1] SMP
> May  2 19:00:12 localhost kernel: [   48.451819] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host4/scsi_host/host4/link_power_management_policy

> May  2 19:00:12 localhost kernel: [   48.451823] CPU 1
> May  2 19:00:12 localhost kernel: [   48.451824] Modules linked in: binfmt_misc vboxnetadp vboxnetflt vboxdrv parport_pc ppdev snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep nvidia(P) arc4 snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy usblp snd_seq_oss snd_seq_midi iwlagn snd_rawmidi snd_seq_midi_event uvcvideo videodev v4l2_compat_ioctl32 iwlcore snd_seq snd_timer mac80211 snd_seq_device joydev cfg80211 snd psmouse soundcore serio_raw snd_page_alloc jmb38x_ms memstick video lp parport usbhid hid ahci r8169 libahci sdhci_pci sdhci firewire_ohci firewire_core crc_itu_t btrfs zlib_deflate libcrc32c

> May  2 19:00:12 localhost kernel: [   48.451859]
> May  2 19:00:12 localhost kernel: [   48.451861] Pid: 295, comm: scsi_eh_4 Tainted: P            2.6.38.5-core2 #1 System76, Inc. Serval Professional/Serval Professional

> May  2 19:00:12 localhost kernel: [   48.451867] RIP: 0010:[<ffffffff813f98e1>]  [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510
> May  2 19:00:12 localhost kernel: [   48.451870] RSP: 0018:ffff880132defbf0  EFLAGS: 00010246

> May  2 19:00:12 localhost kernel: [   48.451872] RAX: 0000000000000000 RBX: ffff880132f40000 RCX: 0000000000000000
> May  2 19:00:12 localhost kernel: [   48.451874] RDX: ffff88013377c000 RSI: ffff880132f40000 RDI: 0000000000000000

> May  2 19:00:12 localhost kernel: [   48.451876] RBP: ffff880132defce0 R08: ffff88013377dc58 R09: ffff880132defd98
> May  2 19:00:12 localhost kernel: [   48.451878] R10: 0000000000000000 R11: 00000000ffffffff R12: 0000000000000000

> May  2 19:00:12 localhost kernel: [   48.451880] R13: 0000000000000000 R14: ffff88013377c000 R15: 0000000000000000
> May  2 19:00:12 localhost kernel: [   48.451882] FS:  0000000000000000(0000) GS:ffff8800bf700000(0000) knlGS:0000000000000000

> May  2 19:00:12 localhost kernel: [   48.451884] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> May  2 19:00:12 localhost kernel: [   48.451886] CR2: 0000000000000018 CR3: 0000000001a03000 CR4: 00000000000406e0

> May  2 19:00:12 localhost kernel: [   48.451888] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> May  2 19:00:12 localhost kernel: [   48.451890] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

> May  2 19:00:12 localhost kernel: [   48.451892] Process scsi_eh_4 (pid: 295, threadinfo ffff880132dee000, task ffff880133b416c0)
> May  2 19:00:12 localhost kernel: [   48.451894] Stack:
> May  2 19:00:12 localhost kernel: [   48.451895]  0000000000000000 ffff880132defcc0 0000000000000000 ffff880132f42738

> May  2 19:00:12 localhost kernel: [   48.451899]  ffffffff813ee8f0 ffffffff813eefe0 ffff880132defd98 ffff88013377f190
> May  2 19:00:12 localhost kernel: [   48.451903]  ffffffffa00b3e30 ffffffff813ef030 0000000032defc60 ffff880100000000

> May  2 19:00:12 localhost kernel: [   48.451906] Call Trace:
> May  2 19:00:12 localhost kernel: [   48.451910]  [<ffffffff813ee8f0>] ? ata_std_postreset+0x0/0x190
> May  2 19:00:12 localhost kernel: [   48.451913]  [<ffffffff813eefe0>] ? sata_std_hardreset+0x0/0x50

> May  2 19:00:12 localhost kernel: [   48.451919]  [<ffffffffa00b3e30>] ? ahci_softreset+0x0/0x1d0 [libahci]
> May  2 19:00:12 localhost kernel: [   48.451922]  [<ffffffff813ef030>] ? ata_std_prereset+0x0/0xd0

> May  2 19:00:12 localhost kernel: [   48.451925]  [<ffffffff81400867>] sata_pmp_error_handler+0x607/0xc30
> May  2 19:00:12 localhost kernel: [   48.451928]  [<ffffffff813ef030>] ? ata_std_prereset+0x0/0xd0

> May  2 19:00:12 localhost kernel: [   48.451931]  [<ffffffffa00b3e30>] ? ahci_softreset+0x0/0x1d0 [libahci]
> May  2 19:00:12 localhost kernel: [   48.451935]  [<ffffffffa00b3970>] ? ahci_hardreset+0x0/0x110 [libahci]

> May  2 19:00:12 localhost kernel: [   48.451939]  [<ffffffffa00b2790>] ? ahci_postreset+0x0/0x60 [libahci]
> May  2 19:00:12 localhost kernel: [   48.451943]  [<ffffffff813e86a9>] ? ata_wait_register+0x49/0xc0

> May  2 19:00:12 localhost kernel: [   48.451947]  [<ffffffffa00b273f>] ahci_error_handler+0x1f/0x70 [libahci]
> May  2 19:00:12 localhost kernel: [   48.451950]  [<ffffffff813faade>] ata_scsi_error+0x5be/0x900

> May  2 19:00:12 localhost kernel: [   48.451953]  [<ffffffff813cf724>] scsi_error_handler+0x124/0x650
> May  2 19:00:12 localhost kernel: [   48.451956]  [<ffffffff813cf600>] ? scsi_error_handler+0x0/0x650

> May  2 19:00:12 localhost kernel: [   48.451960]  [<ffffffff810834b6>] kthread+0x96/0xa0
> May  2 19:00:12 localhost kernel: [   48.451963]  [<ffffffff8100cd64>] kernel_thread_helper+0x4/0x10
> May  2 19:00:12 localhost kernel: [   48.451966]  [<ffffffff81083420>] ? kthread+0x0/0xa0

> May  2 19:00:12 localhost kernel: [   48.451968]  [<ffffffff8100cd60>] ? kernel_thread_helper+0x0/0x10
> May  2 19:00:12 localhost kernel: [   48.451970] Code: 8b 95 70 ff ff ff b8 00 00 00 00 48 3b 9a 10 2e 00 00 48 0f 44 c2 48 89 85 70 ff ff ff 48 8b 8d 70 ff ff ff f6 83 69 02 00 00 01 <48> 8b 41 18 0f 85 48 01 00 00 48 85 c9 74 12 48 8b 51 08 48 83

> May  2 19:00:12 localhost kernel: [   48.451998] RIP  [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510
> May  2 19:00:12 localhost kernel: [   48.452001]  RSP <ffff880132defbf0>
> May  2 19:00:12 localhost kernel: [   48.452002] CR2: 0000000000000018

> May  2 19:00:12 localhost kernel: [   48.452005] ---[ end trace 87b7b160e066e854 ]---
> May  2 19:04:10 localhost kernel: imklog 4.6.4, log source = /proc/kmsg started.
> May  2 19:04:10 localhost kernel: [    0.000000] Initializing cgroup subsys cpuset

>
>
> Linux bean 2.6.38.4-core2 #2 SMP Fri Apr 22 02:58:16 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
>
> Gnu C                  4.5.2
> Gnu make               3.81
> binutils               2.21.0.20110327

> util-linux             2.17.2
> mount                  support
> module-init-tools      3.12
> e2fsprogs              1.41.14
> pcmciautils            015
> PPP                    2.4.5

> Linux C Library        2.13
> Dynamic linker (ldd)   2.13
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15
> Sh-utils               8.5
> wireless-tools         30

> Modules Loaded         binfmt_misc vboxnetadp vboxnetflt vboxdrv parport_pc ppdev snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep nvidia snd_pcm arc4 snd_seq_midi snd_rawmidi snd_seq_midi_event uvcvideo videodev v4l2_compat_ioctl32 snd_seq snd_timer snd_seq_device iwlagn iwlcore snd joydev mac80211 soundcore snd_page_alloc jmb38x_ms memstick psmouse serio_raw cfg80211 video lp parport ahci sdhci_pci firewire_ohci firewire_core libahci crc_itu_t sdhci r8169

>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org

> More majordomo info at  http://vger.kernel.org/majordomo-info.html

> Please read the FAQ at  http://www.tux.org/lkml/
