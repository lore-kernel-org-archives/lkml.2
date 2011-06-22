Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1FVXSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:18:03 -0400
Received: from mail.gransy.com ([82.208.29.194]:57322 "EHLO mail.gransy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab1FVXSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:18:01 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 19:18:00 EDT
Message-ID: <4E0275D8.6000001@fuzzy.cz>
Date: Thu, 23 Jun 2011 01:08:08 +0200
From: Tomas Vondra <tv@fuzzy.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110619 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Nvidia MCP55 and WRITE FPDMA QUEUED failed commands
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a few days ago I've bought a new SSD (Intel 320), and it didn't take
long to get a bunch of I/O errors like this:

ata6: EH in SWNCQ mode,QC:qc_active 0x7FFFFFFF sactive 0x7FFFFFFF
ata6: SWNCQ:qc_active 0x1E031 defer_bits 0x7FFE1FCE last_issue_tag 0x10
  dhfis 0xE031 dmafis 0x6010 sdbfis 0x0
ata6: ATA_REG 0x40 ERR_REG 0x0
ata6: tag : dhfis dmafis sdbfis sacitve
ata6: tag 0x0: 1 0 0 1
ata6: tag 0x4: 1 1 0 1
ata6: tag 0x5: 1 0 0 1
ata6: tag 0xd: 1 1 0 1
ata6: tag 0xe: 1 1 0 1
ata6: tag 0xf: 1 0 0 1
ata6: tag 0x10: 0 0 0 1
ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x6 frozen
ata6.00: failed command: WRITE FPDMA QUEUED
ata6.00: cmd 61/10:00:10:d7:f0/00:00:05:00:00/40 tag 0 ncq 8192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata6.00: status: { DRDY }
ata6: hard resetting link
ata6: nv: skipping hardreset on occupied port
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: configured for UDMA/133
ata6.00: device reported invalid CHS sector 0

The machine just freezes for a few seconds and then everything works
fine again. Until the next bunch of errors - sometimes it's a few
minutes, sometimes a whole day.

The filesystem seems not to be corrupted (fsck finds no problem) and
everything seems to be OK.

The full dmesg output (including the errors) is available here:

  http://pastebin.com/uHvTVmss

I've been searching for possible causes / fixes, but no matter what I do
I still occassionally get those I/O errors :-(

It seems to be somehow related to the controller on my mobo - I'm using
Asus M2N-e with Nvidia MCP55, and I've found this:

  http://marc.info/?l=linux-kernel&m=126847285022959&w=2

which describes a similar issue (same failed command, a bit different
result). I've been using this mobo for a few years, everything worked
just fine till now (OK, I got a few panics, but in all cases it was my
stupid fault). I've switched there various HDDs from various vendors,
not a single problem.

The post mentions the problems may be related to SMART - not sure how to
confirm/refute this, but I'm somehow used that products from Intel work
fine most of the time. OTOH after executing a long self-test, smartctl
reports this (full output: http://pastebin.com/DwJfxdTK)

SMART Self-test log structure revision number 1
Num  Test_Description Status                  Remaining  ...
  1  Vendor (0x78)    Completed without error 150%       ...

That seems a bit fishy, of course. 150%? And how could it be already
completed when there's still 150% remaining?

What I've tried till today:

  1) flashed BIOS to a recent version

  2) switched from reiserfs 3.6 to ext4

  3) disabled the NCQ (libata.force=noncq kernel parameter)

  4) set DMA queue depth to 1 (hdparm -Q 1 /dev/sdb)

  5) upgraded from 2.6.36.1 to 2.6.38

None of those helped :-(

Any ideas how to solve those issues? If those are "just" timing errors
(i.e. the data are actually written but the drive does not notify that)
or is there a danger of corruption?

A bit more (possibly useful) info:

.config http://pastebin.com/PYeLKaBL
lspci output : http://pastebin.com/nQPS0rxU

regards
Tomas
