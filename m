Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1KOKG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:06:27 -0500
Received: from office.intopix.com ([212.166.54.212]:34733 "EHLO
	office.intopix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1KOKG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:06:26 -0500
From: Charles Buysschaert <Charles.Buysschaert@intopix.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Matthias Schniedermeyer (ms@citd.de)" <ms@citd.de>
Subject: memmap= reserved memory not cached in 2.6.32
Thread-Topic: memmap= reserved memory not cached in 2.6.32
Thread-Index: Acyjd6IY9Sqt1rWpTCCtQlL8HFFvPA==
Date: Tue, 15 Nov 2011 10:06:12 +0000
Message-ID: <894F5F1132E3C5458AAB08FA0A1AC9380F1FDCDC@IPX-MAIL.Intopix.com>
Accept-Language: en-US, fr-BE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.0.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Intopix-MailScanner: Found to be clean
X-Intopix-MailScanner-From: charles.buysschaert@intopix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I am still trying to solve my problem (see https://lkml.org/lkml/2011/10/17/40 or email below):
When transferring data to the memory reserved with memmap kernel command line option, I get terrible performances (memory does not seem to be cached) on Ubuntu 10.04. (Transfer "RAM reserved" TO "RAM reserved" is about 1000 times slower than "mallocated RAM" TO "mallocated RAM").

I would like to share a result of my further tests: 
"memmap=" reserved memory is: 
- not cached on Ubuntu 10.04 (kernel 2.6.32-24 generic) x86_64. 
- cached on Ubuntu 9.04 (kernel 2.6.28-11 generic) x86_64.

So something did change between those two kernel versions.
Does anyone have a clue about why this behaviour changed?

What is the behaviour that we normally should expect?
Is there a way to change this? 

Thanks in advance,

Charles


-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Charles Buysschaert
Sent: 28 October 2011 11:30
To: Matthias Schniedermeyer
Cc: linux-kernel@vger.kernel.org
Subject: RE: Speed of RAM reserved with memmap kernel command line option.

Hello Matthias, 

Thanks for your feedback. 

>Smells to me like you are missing a mapping in MTRR ...
>Documentation/x86/mtrr.txt

I checked and those definitely look correct:

This is the physical ram map at boot:

[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 0000000000096800 (usable)
[    0.000000]  user: 0000000000096800 - 00000000000a0000 (reserved)
[    0.000000]  user: 00000000000e4c00 - 0000000000100000 (reserved)
[    0.000000]  user: 0000000000100000 - 0000000040000000 (usable)
[    0.000000]  user: 0000000040000000 - 0000000060000000 (reserved)
[    0.000000]  user: 0000000060000000 - 00000000bf780000 (usable)
[    0.000000]  user: 00000000bf780000 - 00000000bf798000 (ACPI data)
[    0.000000]  user: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
[    0.000000]  user: 00000000bf7dc000 - 00000000c0000000 (reserved)
[    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  user: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  user: 0000000100000000 - 00000001c0000000 (usable)

And this is the  MTRR contents.

$ cat /proc/mtrr
reg00: base=0x1c0000000 ( 7168MB), size= 1024MB, count=1: uncachable
reg01: base=0x000000000 (    0MB), size= 8192MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
reg03: base=0x0bf800000 ( 3064MB), size=    8MB, count=1: uncachable

The reserved zone is indeed marked as 'reserved' 512Mb located at 1Go.
And this zone is
covered by the reg01 MTRR without being overriden by anyother, so it's 'write-back' which is good.

> ... or PAT.
> Documentation/x86/pat.txt
This is also what we tried to set by modifying the protection field given to the remap_pfn_range.

we dumped the kernel_page_tables file provided by "debugfs", and we can see the following entry:
0xFFFF880040000000 -> 0xFFFF880060000000	512M	RW	PCD	PSE	GLB	NX	pmd

I am not 100% sure it is the mapping of my "0000000040000000" physical address, but it looks like (is there a way to see which physical address it relates to?).
I can see the flag "PCD" Page Cache Disabled. 

Does the kernel automatically create a mapping for memory reserved with "memmap=" option? 
Would "aliasing" be the reason why my "remap_pfn_range" seems to ignore the vma->vm_page_prot we are setting? 
(
static inline pgprot_t pgprot_cached(pgprot_t _prot) {
    unsigned long prot = pgprot_val(_prot);
    prot = (prot & ~_CACHE_MASK);
    return __pgprot(prot);
}
vma->vm_page_prot = pgprot_cached(vma->vm_page_prot);
remap_pfn_range(vma, vma->vm_start, myboard_var[board].dmablkp>>PAGE_SHIFT,DMA_BUFFER_SIZE, vma->vm_page_prot)
)

Thanks for your help,


Charles

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
