Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0LFR2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:28:41 -0500
Received: from proxy.quengel.org ([213.146.113.159]:56428 "EHLO
	gerlin1.hsp-law.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166Ab0LFR2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:28:40 -0500
From: Ralf Gerbig <rge@quengel.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.36 Crash/Panik in scsi_eh
References: <87fwvkm215.fsf@gerlin1.hsp-law.de>
	<1288710413.3056.256.camel@mulgrave.site>
	<87pqunwszm.fsf@gerlin1.hsp-law.de>
	<1288723004.3056.473.camel@mulgrave.site>
Date: Mon, 06 Dec 2010 18:28:37 +0100
In-Reply-To: <1288723004.3056.473.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 02 Nov 2010 14:36:44 -0400")
Message-ID: <87d3pe6cai.fsf@gerlin1.hsp-law.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

* James Bottomley writes:

> On Tue, 2010-11-02 at 18:11 +0100, Ralf Gerbig wrote:
>> >> Nov  2 10:40:57 gerlin1 kernel: [45977.560407] RIP: 0010:[<ffffffff811d2290>]  [<ffffffff811d2290>] scsi_dispatch_cmd+0x92/0x22e
>> 
>> > This is the faulting location ... could you run addr2line on this
>> > address to map it to a line of source code?
>> 
>> addr2line id only say ??:0
>> 
>> I recompiled vmlinux with debugging symbols, and gdb says:
>> 
>> Reading symbols from /usr/src/linux-git/linux-2.6/vmlinux...done.
>> (gdb) l *(scsi_dispatch_cmd + 0x92)
>> 0xffffffff811d2290 is in scsi_dispatch_cmd (drivers/scsi/scsi.c:707).
>> 702              * We will wait MIN_RESET_DELAY clock ticks after the
>> last reset so
>> 703              * we can avoid the drive not being ready.
>> 704              */
>> 705             timeout = host->last_reset + MIN_RESET_DELAY;
>> 706
>> 707             if (host->resetting && time_before(jiffies, timeout)) {
>> 708                     int ticks_remaining = timeout - jiffies;
>> 709                     /*
>> 710                      * NOTE: This may be executed from within an interrupt
>> 711                      * handler!  This is bad, but for now, it'll do. The irq

> Um, that's bad.  It's saying the junk pointer is host on line 707 but
> when it was dereferenced on line 705 it was fine.  This is most likely
> to indicate either memory corruption (another thread overwrote the host
> location or even a hardware fault).


just to wrap this up: you where right, the commits between
2.6.36-rc8-00045-g51ea8a8 and 2.6.36 where not at fault, as
the former also crashed after 11 days.

Without any bright, or even dim, ideas I changed -Os to -O2

 -CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set

and 2.6.36 runs without problems since Nov. 14th.

Thanks for caring,

Ralf
