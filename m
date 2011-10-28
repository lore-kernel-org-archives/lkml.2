Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1J1Jag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 05:30:36 -0400
Received: from office.intopix.com ([212.166.54.212]:44920 "EHLO
	office.intopix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1J1Jaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 05:30:35 -0400
From: Charles Buysschaert <Charles.Buysschaert@intopix.com>
To: Matthias Schniedermeyer <ms@citd.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Speed of RAM reserved with memmap kernel command line option.
Thread-Topic: Speed of RAM reserved with memmap kernel command line option.
Thread-Index: AcyMoYqk4aToPCQsSBu7Gz7pox+iqAAHaCoAAiR2u0A=
Date: Fri, 28 Oct 2011 09:30:22 +0000
Message-ID: <894F5F1132E3C5458AAB08FA0A1AC9380F1E9AFF@IPX-MAIL.Intopix.com>
References: <894F5F1132E3C5458AAB08FA0A1AC9380F1E2F12@IPX-MAIL.Intopix.com>
 <20111017132318.GA9098@citd.de>
In-Reply-To: <20111017132318.GA9098@citd.de>
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
static inline pgprot_t pgprot_cached(pgprot_t _prot)
{
    unsigned long prot = pgprot_val(_prot);
    prot = (prot & ~_CACHE_MASK);
    return __pgprot(prot);
}
vma->vm_page_prot = pgprot_cached(vma->vm_page_prot);
remap_pfn_range(vma, vma->vm_start, myboard_var[board].dmablkp>>PAGE_SHIFT,DMA_BUFFER_SIZE, vma->vm_page_prot)
)

Thanks for your help,


Charles

