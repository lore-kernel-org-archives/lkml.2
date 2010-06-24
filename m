Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0FXOS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:18:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56651 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0FXOS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:18:57 -0400
Message-ID: <4C23693A.9040107@zytor.com>
Date: Thu, 24 Jun 2010 07:18:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <1276351120.14011.194.camel@localhost> <4C13D1E7.7060604@zytor.com> <20100612185538.GA4511@feather> <4C13F102.7000509@zytor.com> <20100612222634.GA1785@feather> <4C141214.5050601@zytor.com> <20100613000742.GA3469@feather> <4C14235B.7030605@zytor.com> <20100622052236.GA9130@feather> <4C205323.3010509@zytor.com> <20100624072729.GA7952@feather>
In-Reply-To: <20100624072729.GA7952@feather>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 12:27 AM, Josh Triplett wrote:
> 
> The following patch fixes GRUB; with this patch, I can reserve memory
> (such as with drivemap), boot 2.6.35-rc3 successfully, and it detects
> all of my RAM.
> 

Congratulations!  You have just committed the single most common BIOS
implementation bug.  (Sorry for the sarcasm, but this seems to be a bug
that almost everyone who tries to implement BIOS makes at one point or
another... even the original IBM BIOS had it in at least one place.)

You *must not* use "lret $2" to return to the caller, because the INT
instruction will have cleared IF after pushing the registers to the
stack.  You have to restore the original IF, which "lret $2" will not do.

The best way to do this is to clobber the low byte of the flags register
on the stack.  Since CF is bit 0, and the low byte only contains
arithmetic flags anyway, you can simply overwrite the low byte with 0
for CF=0 and 1 for CF=1.  This will zero SF, ZF, AF and PF as side
effect, which is OK for almost all uses (including e820/e801/88.)

If you don't already have a pointer to the stack, you have to make one,
since it is not possible in 16-bit mode to access the stack directly.
One option is to replace each iret with a jump to the following common code:

carry_cf_iret:
	pushw	%bp
	movw	%sp, %bp
	setc	6(%bp)		/* Set CF on stack based on EFLAGS */
	popw	%bp
	iret

> 
> I don't see any trivial way Linux could work around this bug.  If the
> e820 call left CF=0 on entry, then the error case would get incorrectly
> treated as a valid e820 entry (albeit a final one, since bx=0).
> 

More importantly, it makes the error direction the wrong one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

