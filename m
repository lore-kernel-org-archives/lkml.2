Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1BUNH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:07:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57853 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1BUNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:07:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=n2eXccWPnMOrF9bfmpQzOEjkmHEnhJb8reItBJEIZi6B5DYXwQe31Gz47sPLHJBk2g
         R15j6GxJEekt2E5k1zRb76bWwI+ZafU1SWPb/7cHWg4kmdHiq6Shvqj+lmQTBQPZvjQm
         rdXq/4ee10yC9WsCMkxfoS06UMZG2ZIczMlnI=
MIME-Version: 1.0
Date: Mon, 21 Feb 2011 18:37:26 +0530
Message-ID: <AANLkTimvEQEwewMDw+KiXGv2vrMbj6C4BW8A3WRzD7BG@mail.gmail.com>
Subject: Issue on 2.6.35.9 kernel with module insertion when Rootfs is NFS mounted
From: naveen yadav <yad.naveen@gmail.com>
To: kernelnewbies@nl.linux.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

When I am trying to insert some modules on 2.6.35.9, I am getting some
random crash's.
There are 2 scenarios:-

1) When my rootfs is NFS mounted.

In this case, when I insmod modules some get inserted and some gives crash.
I have tried with following modules :-
a)	ext2.ko ; size 93K ; status - successfully inserted
b)	ext3.ko ; size 188K ; status - insertion failed
c)	xfs.ko ; size 823K ; status - insertion failed
d)	usbcore.ko ; size 243K ; status - insertion failed

2) When I created kernel Image using Initramfs, hence making all
modules part of ramfs image
all insertions are successfull

In case of rootfs as NFS mounted here are some of the crash logs :-
Crash 1
Linux#> insmod usbcore.ko
Module len 238547 truncated
insmod: can't insert 'usbcore.ko': invalid module format
Crash 2
Linux#> insmod  usbcore.ko
CPU 0 Unable to handle kernel paging request at virtual address
00100100, epc == 8008fb00, ra == 8008cf9c
Oops[#1]:
Cpu 0
$ 0   : 00000000 00000001 84166e00 00100100
$ 4   : 84166e00 8415e870 84166e00 8415e870
$ 8   : 84086720 83c12178 00000000 000081a4
$12   : 00000000 00000000 01a0c43d 00000000
$16   : 84166e00 83c12120 8410de58 00000000
$20   : 84166100 83c0b380 00000024 00002001
$24   : 00000000 800f058c
$28   : 8410c000 8410ddb8 00000000 8008cf9c
Hi    : 000bf0c5
Lo    : 6ab94a84
epc   : 8008fb00 file_move+0x20/0x68
    Not tainted
ra    : 8008cf9c __dentry_open+0x110/0x278
Status: 11008c03    KERNEL EXL IE
Cause : 0080000c
BadVA : 00100100
PrId  : 00019555 (MIPS 34Kc)
Modules linked in:
Process insmod (pid: 260, threadinfo=8410c000, task=84136b20, tls=005c9470)
Stack : 8410de58 8410de68 83c0b380 00000001 8410de58 84166e00 00000000 8410de58
        8410de68 00000000 00002000 8008d1ec 83c06080 8410de58 00000000 83c06080
        84086720 00000000 00000000 80099f4c ebb5351b 80380000 84086720 803177a0
        8410de68 800900c0 ffffffe9 00000003 00002000 8410de68 ffffff9c 00000024
        00000002 8009c23c 000003fc 00000000 84150420 84136b20 00000000 8400a000
        ...
Call Trace:
[<8008fb00>] file_move+0x20/0x68
[<8008cf9c>] __dentry_open+0x110/0x278
[<8008d1ec>] nameidata_to_filp+0x38/0x5c
[<80099f4c>] do_last+0x58c/0x6fc
[<8009c23c>] do_filp_open+0x1c0/0x62c
[<8008ce04>] do_sys_open+0x6c/0xc8
[<80002164>] stack_done+0x20/0x3c


Code: af820014  8c830004  8c820000 <ac620000> 8ce40000  ac430004
acc40000  ac860004  ace60000
Disabling lock debugging due to kernel taint
note: insmod[260] exited with preempt_count 1
BUG: scheduling while atomic: insmod/260/0x10000002
Modules linked in:
Call Trace:
[<800051b4>] dump_stack+0x8/0x34
[<800054e0>] schedule+0x9c/0x4b4
[<80005a20>] _cond_resched+0x3c/0x60
[<80077788>] unmap_vmas+0x594/0x690
[<8007bf2c>] exit_mmap+0xc0/0x1a4
[<80024474>] mmput+0x3c/0x118
[<80028a88>] exit_mm+0x130/0x164
[<8002a89c>] do_exit+0x1b4/0x624
[<8000e3e8>] default_cu2_call+0x0/0x4c

Segmentation fault

I tried to debug myself and put some print in kernel/module.c function
load_module, printing the length and offset of each section header.
I found that on some sections the values are wrongly shown

Linux#> insmod usbcore.ko
load_module: umod=2aaa8008, len=238950, uargs=005c2f70
hdr->e_shnum 601 <= number of sections shown correctly
header type sechdrs[i].sh_type =7 sechdrs[i].sh_offset=52
sechdrs[i].sh_size=36  <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=96
sechdrs[i].sh_size=0 <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=96
sechdrs[i].sh_size=72 <= correct
header type sechdrs[i].sh_type =9 sechdrs[i].sh_offset=154448
sechdrs[i].sh_size=8 <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=168
sechdrs[i].sh_size=64 <= correct
header type sechdrs[i].sh_type =9 sechdrs[i].sh_offset=154456
sechdrs[i].sh_size=8 <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=232
sechdrs[i].sh_size=64 <= correct
header type sechdrs[i].sh_type =2136364925
sechdrs[i].sh_offset=4286298862  sechdrs[i].sh_size=1602090478  <=
Incorrect
header type sechdrs[i].sh_type =-1386227977
sechdrs[i].sh_offset=4293914174  sechdrs[i].sh_size=1429526523  <=
Incorrect
header type sechdrs[i].sh_type =-780708260
sechdrs[i].sh_offset=1579921686  sechdrs[i].sh_size=1562763221  <=
Incorrect
header type sechdrs[i].sh_type =-571181733
sechdrs[i].sh_offset=1875703162  sechdrs[i].sh_size=3600104807  <=
Incorrect
header type sechdrs[i].sh_type =9 sechdrs[i].sh_offset=182792
sechdrs[i].sh_size=32 <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=69044
sechdrs[i].sh_size=32 <= correct
header type sechdrs[i].sh_type =9 sechdrs[i].sh_offset=182824
sechdrs[i].sh_size=32 <= correct
header type sechdrs[i].sh_type =1 sechdrs[i].sh_offset=69076
sechdrs[i].sh_size=48 <= correct

The prints goes on this way and lastly the insertion failed with this message :-
CPU 0 Unable to handle kernel paging request at virtual address
ed79cc5b, epc == 80054254, ra == 800541d8
Oops[#1]:

Please suggest me some ideas to debug as to why when rootfs is NFS
mounted I am not able to load modules.
