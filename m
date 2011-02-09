Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1BITDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:03:03 -0500
Received: from daytona.panasas.com ([67.152.220.89]:29527 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1BITDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:03:00 -0500
Message-ID: <4D52E4E1.7070705@panasas.com>
Date: Wed, 09 Feb 2011 21:02:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Regression with calibrate_xor_blocks, probably UML related
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2011 19:02:59.0196 (UTC) FILETIME=[F7B3DBC0:01CBC88B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a new module that uses the async_tx.h lib.

On an exact same module code based on 3.6.37 I see the:
	xor: measuring software checksum speed
	   8regs     : 11312.000 MB/sec
	   8regs_prefetch:  9792.800 MB/sec
	   32regs    : 11220.400 MB/sec
	   32regs_prefetch:  9750.800 MB/sec
	xor: using function: 8regs (11312.000 MB/sec)

And all is well. But on code based on 2.6.38-rc4 I get hard stuck
right after:
	xor: measuring software checksum speed

the UML is completely frozen. When I kill the uml from the host
I can sometimes get this trace.

750c7498:  [<6005f936>] bad_page+0xd8/0xf3
750c74c8:  [<60060c93>] get_page_from_freelist+0x333/0x47b
750c7508:  [<60131243>] put_dec+0x20/0x3c
750c75a0:  [<6001a0ac>] change_pre_exec+0x0/0x24
750c75b8:  [<60060ef1>] __alloc_pages_nodemask+0x116/0x65b
750c7668:  [<60132e25>] sprintf+0xa1/0xa3
750c76a0:  [<6001a0ac>] change_pre_exec+0x0/0x24
750c76b8:  [<60061446>] __get_free_pages+0x10/0x43
750c76c8:  [<60012875>] alloc_stack+0x1b/0x1d
750c76d8:  [<6001fe27>] run_helper+0x26/0x1b5
750c76e8:  [<60021553>] set_signals+0x1c/0x2e
750c7708:  [<6007efac>] __kmalloc+0x9e/0xc4
750c7748:  [<6001a544>] change+0x124/0x189
750c77e8:  [<601b77db>] _raw_spin_unlock+0x9/0xb
750c7818:  [<6001a5a9>] close_addr+0x0/0x1c
750c7828:  [<6001a5c3>] close_addr+0x1a/0x1c
750c7838:  [<6001926a>] iter_addresses+0x5f/0x76
750c7858:  [<6007e8e8>] kfree+0x92/0x9b
750c7898:  [<60022d01>] tuntap_close+0x24/0x38
750c78b8:  [<600194e4>] close_devices+0x4a/0x7f
750c78d8:  [<600121bf>] do_uml_exitcalls+0x12/0x23
750c78f8:  [<60012cd2>] uml_cleanup+0x1a/0x87
750c7928:  [<6002039b>] last_ditch_exit+0x9/0x16
750c79e8:  [<78817031>] xor_8regs_2+0x31/0x58 [xor]
750c7a18:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
750c7aa8:  [<601b77ce>] _raw_spin_unlock_irqrestore+0x18/0x1c
750c7ac8:  [<60029d8d>] try_to_wake_up+0x86/0x98
750c7d78:  [<601b548d>] printk+0xa0/0xa3
750c7e08:  [<78817633>] do_xor_speed+0x54/0xaf [xor]
750c7e20:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
750c7e58:  [<7881b057>] calibrate_xor_blocks+0x57/0xdf [xor]
750c7e68:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
750c7e78:  [<6001105a>] do_one_initcall+0x76/0x121
750c7eb8:  [<600563fd>] sys_init_module+0x78/0x1a6
750c7ee8:  [<60014d60>] handle_syscall+0x58/0x70
750c7f08:  [<60024163>] userspace+0x2dd/0x38a
750c7fc8:  [<600126af>] fork_handler+0x62/0x69

(gdb) list *(xor_8regs_2+0x31)
0x55 is in xor_8regs_2 (/usr0/export/dev/bharrosh/git/pub/scsi-misc/include/asm-generic/xor.h:29).
24                      p1[0] ^= p2[0];
25                      p1[1] ^= p2[1];
26                      p1[2] ^= p2[2];
27                      p1[3] ^= p2[3];
28                      p1[4] ^= p2[4];
29                      p1[5] ^= p2[5];
30                      p1[6] ^= p2[6];
31                      p1[7] ^= p2[7];
32                      p1 += 8;
33                      p2 += 8;
(gdb) list *(calibrate_xor_blocks+0x0)
0xd52 is in calibrate_xor_blocks (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:101).
96                     speed / 1000, speed % 1000);
97      }
98
99      static int __init
100     calibrate_xor_blocks(void)
101     {
102             void *b1, *b2;
103             struct xor_block_template *f, *fastest;
104
105             /*
(gdb) list *(do_xor_speed+0x54)
0x657 is in do_xor_speed (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:84).
79                      now = jiffies;
80                      count = 0;
81                      while (jiffies == now) {
82                              mb(); /* prevent loop optimzation */
83                              tmpl->do_2(BENCH_SIZE, b1, b2);
84                              mb();
85                              count++;
86                              mb();
87                      }
88                      if (count > max)
(gdb) list *(calibrate_xor_blocks+0x57)
0xda9 is in calibrate_xor_blocks (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:137).
132                             "checksumming function: %s\n",
133                             fastest->name);
134                     xor_speed(fastest);
135             } else {
136                     printk(KERN_INFO "xor: measuring software checksum speed\n");
137                     XOR_TRY_TEMPLATES;
138                     fastest = template_list;
139                     for (f = fastest; f; f = f->next)
140                             if (f->speed > fastest->speed)
141                                     fastest = f;
(gdb) q

So it looks like the code in UML links the include/asm-generic/xor.h and that it gets
stuck. Any thing changed in this area in last merge window?

Before I start the very difficult bisect?

Thanks for any tips
Boaz
