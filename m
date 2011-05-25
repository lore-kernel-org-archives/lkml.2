Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab1EYOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:25:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41794 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1EYOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:25:28 -0400
Date: Wed, 25 May 2011 09:25:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: hfsplus mount regression in 2.6.38
Message-ID: <20110525142521.GA32511@thinkpad-t410>
Mail-Followup-To: Christoph Hellwig <hch@tuxera.com>,
	Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been receiving reports of problems mounting HFS+ formatted volumes
(iPods mostly, but not exclusively) starting with the 2.6.38 kernel,
with messages like the following in dmesg.

  usb 2-2: new high speed USB device using ehci_hcd and address 12
  scsi7 : usb-storage 2-2:1.0
  scsi 7:0:0:0: Direct-Access Apple iPod 1.62 PQ: 0 ANSI: 0
  sd 7:0:0:0: Attached scsi generic sg2 type 0
  sd 7:0:0:0: [sdb] 1982464 2048-byte logical blocks: (4.06 GB/3.78 GiB)
  sd 7:0:0:0: [sdb] Write Protect is off
  sd 7:0:0:0: [sdb] Mode Sense: 68 00 00 08
  sd 7:0:0:0: [sdb] No Caching mode page present
  sd 7:0:0:0: [sdb] Assuming drive cache: write through
  sd 7:0:0:0: [sdb] 1982464 2048-byte logical blocks: (4.06 GB/3.78 GiB)
  sd 7:0:0:0: [sdb] No Caching mode page present
  sd 7:0:0:0: [sdb] Assuming drive cache: write through
  sdb: [mac] sdb1 sdb2 sdb3
  sd 7:0:0:0: [sdb] 1982464 2048-byte logical blocks: (4.06 GB/3.78 GiB)
  sd 7:0:0:0: [sdb] No Caching mode page present
  sd 7:0:0:0: [sdb] Assuming drive cache: write through
  sd 7:0:0:0: [sdb] Attached SCSI removable disk
  sd 7:0:0:0: [sdb] Bad block number requested
  hfs: unable to find HFS+ superblock
  sd 7:0:0:0: [sdb] Bad block number requested
  hfs: unable to find HFS+ superblock

Reverting commits 52399b1 (hfsplus: use raw bio access for the volume
headers) and 358f26d5 (hfsplus: use raw bio access for partition tables)
fixes the problems. It appears the problems are due to hfsplus
submitting 512 byte bios to a block device whose sector size is larger
than 512 byts (2 KB in the log above), and the block driver is quite
reasonably rejecting any requests without proper sector alignment.

How would you suggest fixing this?  Most file systems are using
sb_bread() for this sort of thing, but since the offending patches are
intended to stop using buffer_heads I'm assuming that's not an option.

Thanks,
Seth

