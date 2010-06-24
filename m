Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0FXH2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:28:06 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:46017 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0FXH2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:28:03 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.37
X-Originating-IP: 74.107.143.84
Date: Thu, 24 Jun 2010 00:27:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
Message-ID: <20100624072729.GA7952@feather>
References: <1276351120.14011.194.camel@localhost>
 <4C13D1E7.7060604@zytor.com>
 <20100612185538.GA4511@feather>
 <4C13F102.7000509@zytor.com>
 <20100612222634.GA1785@feather>
 <4C141214.5050601@zytor.com>
 <20100613000742.GA3469@feather>
 <4C14235B.7030605@zytor.com>
 <20100622052236.GA9130@feather>
 <4C205323.3010509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C205323.3010509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:07:31PM -0700, H. Peter Anvin wrote:
> On 06/21/2010 10:22 PM, Josh Triplett wrote:
> > 
> > How might I diagnose this further?  What might cause Linux to refuse to
> > use the e820 and e801 results provided by GRUB, but accept the ones
> > provided by the BIOS?
> > 
> 
> This is interesting... you apparently have a ACPI 3-style e820 BIOS as
> evidenced by the [1] markers, but Grub presents it as legacy style.
> Now, the kernel shouldn't care, but this at least gives a clue.
> 
> Something that might be worthwhile is to add printf's to the kernel's
> e820-parsing routine (in arch/x86/boot/e820.c) and figure out why it
> doesn't like the output.  It's a bit strange that meminfo would produce
> sensible-looking output (well, legal, at least; presenting a two-byte
> range is rather beyond crazy, and so forth) and the kernel wouldn't
> accept it, as the code is intentionally very similar.

OK, I managed to track down the problem to a bug in GRUB's int15 hook
code, which older Linux kernels didn't run into.

GRUB's int15 hook, when it returned, would stc or clc as appropriate,
and then iret, replacing the carry flag it set with the original flags
set on entry to int15.  More recent Linux kernels had CF=1 on entry to
the int15 hook, so GRUB's iret left CF=1, and detect_memory_e820 would
treat that as the end of the e820 map.

This same problem applies to the e801 and 88 handlers, likely triggering
the error case in detect_memory_e801 as well.  detect_memory_88 doesn't
actually check CF, though.

(Fun debugging trick: in detect_memory_e820, since I couldn't call
printk and I wanted to print something that would get preserved in
dmesg, I stashed debug values in boot_params._pad9 and then printk'd
them from default_machine_specific_memory_setup.)

The following patch fixes GRUB; with this patch, I can reserve memory
(such as with drivemap), boot 2.6.35-rc3 successfully, and it detects
all of my RAM.


=== modified file 'mmap/i386/pc/mmap_helper.S'
--- mmap/i386/pc/mmap_helper.S	2010-03-26 23:04:14 +0000
+++ mmap/i386/pc/mmap_helper.S	2010-06-24 06:54:54 +0000
@@ -59,7 +59,7 @@
 	movw %bx, %dx
 	pop %ds
 	clc
-	iret
+	lret $2
 
 LOCAL (h88):
 	popf
@@ -69,7 +69,7 @@
 	movw DS (LOCAL (kbin16mb)), %ax
 	pop %ds
 	clc
-	iret
+	lret $2
 
 LOCAL (e820):
 	popf
@@ -101,13 +101,13 @@
 	mov $0x534d4150, %eax
 	pop %ds
 	clc
-	iret
+	lret $2
 LOCAL (errexit):
 	mov $0x534d4150, %eax
 	pop %ds
+	xor %bx, %bx
 	stc
-	xor %bx, %bx
-	iret
+	lret $2
 
 VARIABLE(grub_machine_mmaphook_mmap_num)
 LOCAL (mmap_num):


I don't see any trivial way Linux could work around this bug.  If the
e820 call left CF=0 on entry, then the error case would get incorrectly
treated as a valid e820 entry (albeit a final one, since bx=0).

- Josh Triplett
