Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0CTSVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:21:31 -0400
Received: from authsmtp-0-5.virt.iitsp.net ([66.197.170.103]:54170 "EHLO
	authsmtp-0-5.virt.iitsp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab0CTSVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:21:30 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2010 14:21:29 EDT
Message-ID: <4BA51022.4010309@lbsd.net>
Date: Sat, 20 Mar 2010 18:12:50 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091201 IceDove/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
References: <4B519F14.7020104@lbsd.net> <4B5CD711.7050204@zytor.com>
In-Reply-To: <4B5CD711.7050204@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/10 23:26, H. Peter Anvin wrote:
> On 01/16/2010 03:12 AM, Nigel Kukard wrote:
>   
>> Generating a initramfs with the following, one of about 30Mb, one of 77Mb.
>> find . | cpio -o -H newc > ../initramfs.cpio
>>
>> Only difference is adding of more files to the 77Mb image.
>>
>> It makes no difference if its compiled into kernel or used as initrd.
>> Compression types makes no difference either.
>>
>> Tested on 2.6.32.3->2.6.33-rc4 , all fail with the below.
>>
>> The 30Mb initramfs loads fine, the 77Mb image throws the following...
>>
>>     
> What are the exact compressed and uncompressed files (or is that an
> uncompressed initramfs)?
>   

Ok ... I revisited this, sorry for the delay, all tests done on kernel
2.6.33.1

(initramfs uploaded, link below)

It is generated using two commands...
find . | cpio -o --quiet -H newc -A -O ../initramfs.cpio

and the kernel modules are appended to this using...
find . | cpio -o --quiet -H newc -A -O ../initramfs.cpio

The exact size is ..
% ls -la initramfs.cpio
-rw-r--r-- 1 nkukard nkukard 115944448 Mar 19 22:15 initramfs.cpio

It is available here...
http://www.linuxrulz.org/nkukard/kernel/initramfs.cpio

> Also, you're describing how to reproduce this with Qemu, but have you
> tried with other bootloaders?  Which version of Qemu (some versions of
> the Qemu bootloaders had a lot of problems.)

Qemu 0.12.1.2 .

I've set Makefile.lib to use coreutils 8.4 /usr/bin/printf . Just to be
sure my stripped down bash I use for /bin/sh isn't to blame.

The boxes used are as follows...
centrino is a Dell E6400 ATG , bootloader is grub with fedora patches
applied
qemu x86_64 is run on a IBM X60 using qemu-system-x86_64 -kernel
/tmp/bzImage

Each rebuild done with ...
make clean && make bzImage

I'm using ...
bzip2 1.0.5
gzip 1.4
lzma (xz) 4.999.9
gcc 4.4.1
coreutils 8.4

Here is the results... all run with kernel compression set to LZMA.

Initramfs compressed with NONE
Booted on a centrino - boots fine
Booted under qemu x86_64 - Hang one line down after Probing EDD

Initramfs compressed with Gzip
Booted on a centrino - boots fine
Booted under qemu x86_64 - boots with panic #1 below

Initramfs compressed with Bzip2
Booted on a cenrino - reboot just after displaying "Decompressing Linux..."
Booted under qemu x86_64 - 5 seconds of 100% cpu usage and then hangs
while "Decompressing Linux..."

Initramfs compressed with LZMA
Booted on a centrino - reboot just after displaying "Decompressing Linux..."
Booted under qemu x86_64 - 5 seconds of 100% cpu and then hangs while
"Decompressing Linux..."

Initramfs compressed with LZO
Booted on a centrino - boots fine
Booted under qemu x86_64 - Hang one line down after Probing EDD

panic #1:
[   12.981377] swapper invoked oom-killer: gfp_mask=0x200d2, order=0,
oom_adj=0
[   12.982592] swapper cpuset=/ mems_allowed=0
[   12.983523] Pid: 1, comm: swapper Not tainted 2.6.33.1-1.0 #9
[   12.984293] Call Trace:
[   12.985777]  [<ffffffff8108687c>] ?
cpuset_print_task_mems_allowed+0x8c/0xa0
[   12.986846]  [<ffffffff810a586b>] dump_header+0x6b/0x180
[   12.987547]  [<ffffffff810a5f83>] __out_of_memory+0xa3/0xc0
[   12.988251]  [<ffffffff810a6021>] out_of_memory+0x81/0x1c0
[   12.988946]  [<ffffffff810a9f96>] __alloc_pages_nodemask+0x646/0x660
[   12.989748]  [<ffffffff810d5ed0>] alloc_page_interleave+0x40/0xa0
[   12.990847]  [<ffffffff810d6074>] alloc_pages_current+0xc4/0xd0
[   12.991595]  [<ffffffff810a348f>] __page_cache_alloc+0x5f/0x70
[   12.992320]  [<ffffffff810a36c7>] grab_cache_page_write_begin+0x77/0xc0
[   12.993156]  [<ffffffff8110af39>] simple_write_begin+0x39/0x80
[   12.993881]  [<ffffffff810a26be>] generic_file_buffered_write+0xfe/0x250
[   12.994706]  [<ffffffff8104ffc2>] ? current_fs_time+0x22/0x30
[   12.995428]  [<ffffffff810a44e8>] __generic_file_aio_write+0x238/0x450
[   12.996235]  [<ffffffff81165126>] ? security_d_instantiate+0x16/0x30
[   12.997141]  [<ffffffff810a4764>] generic_file_aio_write+0x64/0xd0
[   12.997909]  [<ffffffff810eba02>] do_sync_write+0xd2/0x110
[   12.998596]  [<ffffffff81196375>] ? __up_write+0xe5/0x160
[   12.999343]  [<ffffffff811641f1>] ? security_file_permission+0x11/0x20
[   13.000416]  [<ffffffff8150607d>] ? flush_buffer+0x0/0xa3
[   13.001128]  [<ffffffff810ec498>] vfs_write+0xb8/0x180
[   13.001781]  [<ffffffff810ec63c>] sys_write+0x4c/0x80
[   13.002424]  [<ffffffff815064ce>] do_copy+0x84/0xb0
[   13.003055]  [<ffffffff815060fa>] flush_buffer+0x7d/0xa3
[   13.003714]  [<ffffffff81190b60>] ? nofill+0x0/0x10
[   13.004331]  [<ffffffff81190b60>] ? nofill+0x0/0x10
[   13.004948]  [<ffffffff815271a4>] gunzip+0x27b/0x32a
[   13.005590]  [<ffffffff81506650>] unpack_to_rootfs+0x156/0x28c
[   13.006324]  [<ffffffff81505eed>] ? error+0x0/0x17
[   13.006934]  [<ffffffff81506ed4>] ? populate_rootfs+0x0/0xd7
[   13.007642]  [<ffffffff81506ef7>] populate_rootfs+0x23/0xd7
[   13.008341]  [<ffffffff81506ed4>] ? populate_rootfs+0x0/0xd7
[   13.009072]  [<ffffffff81002047>] do_one_initcall+0x37/0x1a0
[   13.009778]  [<ffffffff81504734>] kernel_init+0x167/0x1bd
[   13.010696]  [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
[   13.011440]  [<ffffffff815045cd>] ? kernel_init+0x0/0x1bd
[   13.012140]  [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
[   13.013056] Mem-Info:
[   13.013461] Node 0 DMA per-cpu:
[   13.013949] CPU    0: hi:    0, btch:   1 usd:   0
[   13.014597] Node 0 DMA32 per-cpu:
[   13.015039] CPU    0: hi:   42, btch:   7 usd:  16
[   13.015907] active_anon:0 inactive_anon:0 isolated_anon:0
[   13.015936]  active_file:161 inactive_file:0 isolated_file:0
[   13.015964]  unevictable:19294 dirty:0 writeback:0 unstable:0
[   13.015992]  free:0 slab_reclaimable:773 slab_unreclaimable:284
[   13.016021]  mapped:0 shmem:0 pagetables:0 bounce:0
[   13.019220] Node 0 DMA free:0kB min:0kB low:0kB high:0kB
active_anon:0kB inactive_anon:0kB active_file:124kB inactive_file:0kB
unevictable:15084kB isolated(anon):0kB isolated(file):0kB
present:15372kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:708kB slab_unreclaimable:44kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:3771 all_unreclaimable? no
[   13.024223] lowmem_reserve[]: 0 0 0 0
[   13.024862] Node 0 DMA32 free:0kB min:0kB low:0kB high:0kB
active_anon:0kB inactive_anon:0kB active_file:520kB inactive_file:0kB
unevictable:62092kB isolated(anon):0kB isolated(file):0kB
present:113108kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:2384kB slab_unreclaimable:1092kB
kernel_stack:136kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:15523 all_unreclaimable? no
[   13.029376] lowmem_reserve[]: 0 0 0 0
[   13.029960] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[   13.031806] Node 0 DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[   13.033440] 19455 total pagecache pages
[   13.033942] 0 pages in swap cache
[   13.034375] Swap cache stats: add 0, delete 0, find 0/0
[   13.035027] Free swap  = 0kB
[   13.035404] Total swap = 0kB
[   13.041253] 32765 pages RAM
[   13.041666] 11446 pages reserved
[   13.042079] 0 pages shared
[   13.042432] 21286 pages non-shared
[   13.043081] Kernel panic - not syncing: Out of memory and no killable
processes...
[   13.043118]
[   13.044258] Pid: 1, comm: swapper Not tainted 2.6.33.1-1.0 #9
[   13.044950] Call Trace:
[   13.045329]  [<ffffffff8133f37c>] panic+0x73/0x137
[   13.045967]  [<ffffffff810a587b>] ? dump_header+0x7b/0x180
[   13.046675]  [<ffffffff810a5f91>] __out_of_memory+0xb1/0xc0
[   13.047387]  [<ffffffff810a6021>] out_of_memory+0x81/0x1c0
[   13.048105]  [<ffffffff810a9f96>] __alloc_pages_nodemask+0x646/0x660
[   13.048906]  [<ffffffff810d5ed0>] alloc_page_interleave+0x40/0xa0
[   13.049675]  [<ffffffff810d6074>] alloc_pages_current+0xc4/0xd0
[   13.050720]  [<ffffffff810a348f>] __page_cache_alloc+0x5f/0x70
[   13.051450]  [<ffffffff810a36c7>] grab_cache_page_write_begin+0x77/0xc0
[   13.052269]  [<ffffffff8110af39>] simple_write_begin+0x39/0x80
[   13.053017]  [<ffffffff810a26be>] generic_file_buffered_write+0xfe/0x250
[   13.053863]  [<ffffffff8104ffc2>] ? current_fs_time+0x22/0x30
[   13.054592]  [<ffffffff810a44e8>] __generic_file_aio_write+0x238/0x450
[   13.055397]  [<ffffffff81165126>] ? security_d_instantiate+0x16/0x30
[   13.056191]  [<ffffffff810a4764>] generic_file_aio_write+0x64/0xd0
[   13.057090]  [<ffffffff810eba02>] do_sync_write+0xd2/0x110
[   13.057792]  [<ffffffff81196375>] ? __up_write+0xe5/0x160
[   13.058481]  [<ffffffff811641f1>] ? security_file_permission+0x11/0x20
[   13.059295]  [<ffffffff8150607d>] ? flush_buffer+0x0/0xa3
[   13.059972]  [<ffffffff810ec498>] vfs_write+0xb8/0x180
[   13.060899]  [<ffffffff810ec63c>] sys_write+0x4c/0x80
[   13.061547]  [<ffffffff815064ce>] do_copy+0x84/0xb0
[   13.062165]  [<ffffffff815060fa>] flush_buffer+0x7d/0xa3
[   13.062870]  [<ffffffff81190b60>] ? nofill+0x0/0x10
[   13.063480]  [<ffffffff81190b60>] ? nofill+0x0/0x10
[   13.064096]  [<ffffffff815271a4>] gunzip+0x27b/0x32a
[   13.064730]  [<ffffffff81506650>] unpack_to_rootfs+0x156/0x28c
[   13.065449]  [<ffffffff81505eed>] ? error+0x0/0x17
[   13.066055]  [<ffffffff81506ed4>] ? populate_rootfs+0x0/0xd7
[   13.066762]  [<ffffffff81506ef7>] populate_rootfs+0x23/0xd7
[   13.067466]  [<ffffffff81506ed4>] ? populate_rootfs+0x0/0xd7
[   13.068172]  [<ffffffff81002047>] do_one_initcall+0x37/0x1a0
[   13.068882]  [<ffffffff81504734>] kernel_init+0x167/0x1bd
[   13.069561]  [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
[   13.070487]  [<ffffffff815045cd>] ? kernel_init+0x0/0x1bd
[   13.071167]  [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10

