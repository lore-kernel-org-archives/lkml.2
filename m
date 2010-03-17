Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0CQDX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:23:27 -0400
Received: from tenax.loup.net ([209.169.16.66]:53184 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0CQDXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:23:25 -0400
Date: Tue, 16 Mar 2010 21:09:50 -0600
Message-Id: <201003170309.o2H39o1H010844@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: hancockrwd@gmail.com
CC: linux-kernel@vger.kernel.org, mvds.00@gmail.com
In-reply-to: <4B9EC36F.8010404@gmail.com> (message from Robert Hancock on Mon,
	15 Mar 2010 17:31:59 -0600)
Subject: Re: SCSI GENERIC command queueing for block storage is unstable.
References: <201003151825.o2FIPUTV006948@alien.loup.net> <4B9EC36F.8010404@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

 > > After discovering that O_NONBLOCK reads and writes were actually
 > > blocking calls, I attempted to use the SCSI generic driver for
 > > nonblocking io.  The good news is that it is nonblocking; the bad news
 > > is that it is not dependable in any of the systems I have tested with.
 > >
 > > Does anyone know if these defects have been fixed in later kernels?
 > >
 > > 1. When queueing, write can occassionally return errno 12 (ENOMEM, Cannot
 > >     allocate memory).  This is documented in the SCSI GENERIC HOWTO,
 > >     however only for indirect io and it says extremely rare.  I can cause
 > >     it easily within a few hours and it can return even for direct io when
 > >     no io's are queued and 80% of the ram is free or in buffer cache.  The
 > >     fd polls as available for writing, but retrying never clears the error
 > >     and the fd is no longer usable.  This is a complete show stopper.
 > >
 > >     Linux 2.6.22.1-32.fc6 #1 SMP Wed Aug 1 14:30:16 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
 > 
 > First off, have you tested any of these problems against a newer kernel?

It appears all of the problems have existed at least from 2.6.18
through 2.6.32 since I'm seeing essentially the same behavior on those
plus the two intermediate kernel versions in the last mail, same
hardware.  We also see the relevant ones on a recent ubuntu arm device:

Linux armage 2.6.22.18 #1 Thu Mar 19 14:46:22 IST 2009 armv5tejl GNU/Linux

I'm wondering if anyone has recently worked on anything that might be
related.  The kernel is issuing error messages independent of a
specific system or kernel and it is very repeatable.  The ENOMEM
problem (1) above is much less likely to occur than the other issues
and I have yet to cause it on 2.6.32; doesn't mean it isn't still
there if someone hasn't worked on it recently...

----------------------------------------------------------------------
Linux opt2.loup.net 2.6.32.9-70.fc12.x86_64 #1 SMP Wed Mar 3 04:40:41 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

interface_id S dxfer_direction -3 cmd_len 10 mx_sb_len 252 iovec_count 0 dxfer_len 10000 dxferp 0x1263200 cmdp 1368cf8 sbp 1368d08 timeout 20000 flags 1 pack_id 0 usr_ptr 0x1368cc0
CDB 28 00 00 11 49 83 00 00 80 00 19 01 00 00 00 00
CDB OP 28 READ_10(10)
CDB READ_10 RELADR 0 FUA 0 DPO 0 LBA 00114983 TRANSFERLEN 0080
CDB Control Vendor 0 NACA 0 LINK 0
status 2 masked_status 1 host_status 0 driver_status 8 resid 0 duration 277 info 1
SENSE FIXED RESPONSE CODE 72 VALID 0 SENSEKEY NO_SENSE
SENSE FIXED ILI 0 EOM 0 FILEMARK 0 INFO 00000000 ASENSELEN 0c
SENSE FIXED COMMANDINFO 000a8000 ADDSENSE 0000
SENSE FIXED FRUCODE 00
SKSData SKSV 0

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata4.00: port_status 0x20080000
ata4.00: failed command: READ DMA
ata4.00: cmd c8/00:80:83:49:11/00:00:00:00:00/e0 tag 0 dma 65536 in
         res 50/00:00:02:4a:11/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
----------------------------------------------------------------------

I'd like to mention another issue I forgot in the last email:

7. The sg info result is supposed to return a nonzero result if it
   transfers data DIRECT according to HOWTO but despite issuing aligned
   dxferp (as you can see in the one that failed) and setting flags to
   DIRECT, it never indicates a direct transfer occurred.

Am I like the only one really using sg driver queueing?  From the
number of issues I've found right off the bat, it makes me think it
must be primarily used in blocking ioctl mode.

Are there formal regression tests somewhere that are normally run
against the kernel?  I've never seen any in the kernel downloads
themselves.  Do such regressions cover the scsi generic driver?

- Mike
