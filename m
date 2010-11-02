Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0KBSg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:36:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab0KBSgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:36:50 -0400
Subject: Re: 2.6.36 Crash/Panik in scsi_eh
From: James Bottomley <James.Bottomley@suse.de>
To: Ralf Gerbig <rge@quengel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <87pqunwszm.fsf@gerlin1.hsp-law.de>
References: <87fwvkm215.fsf@gerlin1.hsp-law.de>
	 <1288710413.3056.256.camel@mulgrave.site>
	 <87pqunwszm.fsf@gerlin1.hsp-law.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 14:36:44 -0400
Message-ID: <1288723004.3056.473.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 18:11 +0100, Ralf Gerbig wrote:
> >> Nov  2 10:40:57 gerlin1 kernel: [45977.560407] RIP: 0010:[<ffffffff811d2290>]  [<ffffffff811d2290>] scsi_dispatch_cmd+0x92/0x22e
> 
> > This is the faulting location ... could you run addr2line on this
> > address to map it to a line of source code?
> 
> addr2line id only say ??:0
> 
> I recompiled vmlinux with debugging symbols, and gdb says:
> 
> Reading symbols from /usr/src/linux-git/linux-2.6/vmlinux...done.
> (gdb) l *(scsi_dispatch_cmd + 0x92)
> 0xffffffff811d2290 is in scsi_dispatch_cmd (drivers/scsi/scsi.c:707).
> 702              * We will wait MIN_RESET_DELAY clock ticks after the
> last reset so
> 703              * we can avoid the drive not being ready.
> 704              */
> 705             timeout = host->last_reset + MIN_RESET_DELAY;
> 706
> 707             if (host->resetting && time_before(jiffies, timeout)) {
> 708                     int ticks_remaining = timeout - jiffies;
> 709                     /*
> 710                      * NOTE: This may be executed from within an interrupt
> 711                      * handler!  This is bad, but for now, it'll do. The irq

Um, that's bad.  It's saying the junk pointer is host on line 707 but
when it was dereferenced on line 705 it was fine.  This is most likely
to indicate either memory corruption (another thread overwrote the host
location or even a hardware fault).

James
 

