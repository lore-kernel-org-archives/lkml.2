Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0FXTBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:01:25 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:59839 "EHLO
	mrelay1-v.mgt.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755692Ab0FXTBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:01:23 -0400
X-Originating-IP: 217.70.178.40
X-Originating-IP: 74.107.143.84
Date: Thu, 24 Jun 2010 12:01:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
Message-ID: <20100624190107.GA15329@feather>
References: <20100612185538.GA4511@feather>
 <4C13F102.7000509@zytor.com>
 <20100612222634.GA1785@feather>
 <4C141214.5050601@zytor.com>
 <20100613000742.GA3469@feather>
 <4C14235B.7030605@zytor.com>
 <20100622052236.GA9130@feather>
 <4C205323.3010509@zytor.com>
 <20100624072729.GA7952@feather>
 <4C23693A.9040107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C23693A.9040107@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 07:18:34AM -0700, H. Peter Anvin wrote:
> On 06/24/2010 12:27 AM, Josh Triplett wrote:
> > The following patch fixes GRUB; with this patch, I can reserve memory
> > (such as with drivemap), boot 2.6.35-rc3 successfully, and it detects
> > all of my RAM.
> 
> Congratulations!  You have just committed the single most common BIOS
> implementation bug.  (Sorry for the sarcasm, but this seems to be a bug
> that almost everyone who tries to implement BIOS makes at one point or
> another... even the original IBM BIOS had it in at least one place.)

And a rather large number of sample interrupt code found on the web,
including the e820 hook from the version of gPXE/Etherboot that I used
as an example. :)  Given that I just tested against Linux, which very
carefully works around that particular BIOS bug, I didn't run into any
issue.

So, how high does GRUB's bug ("stc ; iret"/"clc ; iret") rank on the
list of common BIOS implementation bugs?

> You *must not* use "lret $2" to return to the caller, because the INT
> instruction will have cleared IF after pushing the registers to the
> stack.  You have to restore the original IF, which "lret $2" will not do.

The thought had crossed my mind to preserve the caller's flags, but I'd
ignored it because I'd figured that the interrupt handler could safely
trash the caller's flags as long as it set or cleared carry
appropriately.  I'd forgotten that IF lives there too. :)

> The best way to do this is to clobber the low byte of the flags register
> on the stack.  Since CF is bit 0, and the low byte only contains
> arithmetic flags anyway, you can simply overwrite the low byte with 0
> for CF=0 and 1 for CF=1.  This will zero SF, ZF, AF and PF as side
> effect, which is OK for almost all uses (including e820/e801/88.)
> 
> If you don't already have a pointer to the stack, you have to make one,
> since it is not possible in 16-bit mode to access the stack directly.
> One option is to replace each iret with a jump to the following common code:
> 
> carry_cf_iret:
> 	pushw	%bp
> 	movw	%sp, %bp
> 	setc	6(%bp)		/* Set CF on stack based on EFLAGS */
> 	popw	%bp
> 	iret

Nice.  Cleaner than the andw/orw solution I'd thought of using (and
actually written before dropping it in favor of "lret $2") to
specifically clear/set CF on the stack, since it doesn't require
separate exit paths for success and failure.

New patch:

--- mmap/i386/pc/mmap_helper.S	2010-03-26 23:04:14 +0000
+++ mmap/i386/pc/mmap_helper.S	2010-06-24 18:52:56 +0000
@@ -59,7 +59,7 @@
 	movw %bx, %dx
 	pop %ds
 	clc
-	iret
+	jmp LOCAL (iret_cf)
 
 LOCAL (h88):
 	popf
@@ -69,7 +69,7 @@
 	movw DS (LOCAL (kbin16mb)), %ax
 	pop %ds
 	clc
-	iret
+	jmp LOCAL (iret_cf)
 
 LOCAL (e820):
 	popf
@@ -101,12 +101,19 @@
 	mov $0x534d4150, %eax
 	pop %ds
 	clc
-	iret
+	jmp LOCAL (iret_cf)
 LOCAL (errexit):
 	mov $0x534d4150, %eax
 	pop %ds
+	xor %bx, %bx
 	stc
-	xor %bx, %bx
+	jmp LOCAL (iret_cf)
+
+LOCAL (iret_cf):
+	pushw %bp
+	movw %sp, %bp
+	setc 6(%bp)
+	popw %bp
 	iret
 
 VARIABLE(grub_machine_mmaphook_mmap_num)


- Josh Triplett
