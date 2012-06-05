Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2FEAaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:30:22 -0400
Received: from server.atrad.com.au ([150.101.241.2]:47013 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2FEAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:30:21 -0400
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2012 20:30:20 EDT
Date: Tue, 5 Jun 2012 09:32:39 +0930
From: Jonathan Woithe <jwoithe@just42.net>
To: linux1394-devel@lists.sourceforge.net
Cc: jwoithe@just42.net, stefanr@s5r6.in-berlin.de,
        linux-kernel@vger.kernel.org
Subject: Re: Silent data corruption with kernel 3.4 and FireWire disks
Message-ID: <20120605000239.GA28823@marvin.atrad.com.au>
References: <mailman.408825.1338838130.11409.linux1394-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mailman.408825.1338838130.11409.linux1394-devel@lists.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 07:28:50PM +0000, Stefan Richter wrote:
> About a week ago I noticed silent data corruptions of files on FireWire
> disks:  Mount disk, read lots of data and e.g. compute their md5sum,
> unmount disk, mount disk again, read and md5sum the same files again ->
> MD5s may differ.
> 
> Defects in files that were written in May hint that not only reading from
> but also writing to FireWire disks resulted in corrupt data.  This was
> silent corruption without any error messages from the PCI, firewire, SCSI,
> block, or filesystem subsystems.
> 
> Affected:
>   - kernel 3.4
>   - kernel 3.4-rc5
> Not affected:
>   - kernel 3.3.1 (which I have been running now for the last 6 days)

Hmm, funny you should mention this.  Over the past few months I have also
been experiencing silent corruption of a firewire disc, although I suspect
it may be for a different reason.  The corruptions started occurring soon
after I upgraded a machine to kernel 2.6.39 in May 2011.  The filesystem was
xfs, and when corruption occurred it generally took out the entire
filesystem (on repair, everything would be bundled unsorted into
lost+found).

The disc is written to once a day using rsync.

I removed the drive from its enclosure and ran various SMART tests on it
directly (the enclosure prevents SMART from operating).  The drive showed no
pre-fail signs, passed all self-tests and didn't show any problems under
badblocks tests (read-write or destructive write).

On 18 May this year I upgraded the kernel to 3.3.6 and thus far I have not
had a repeat of the corruption.  Under 2.6.39 I was usually seeing a
corruption event well within 2 weeks of recreating the filesystem, although
sometimes it took longer.  Although it's early days it seems that 3.3.6 is
so far behaving better than 2.6.39.

Combined with Stefan's observations, this would indicate that there were
issues with 2.6.39, they weren't present in 3.3.x and then reappeared in
3.4.  It's the disappearance and reappearance which has me thinking that
perhaps we are seeing two different problems, one of which has been fixed.

> FireWire disks with different 1394-to-SATA or -IDE bridge chips are
> affected.  I noticed the problem at first on an Agere FW643e PCIe 1394
> controller which sits behind a PLX PEX 8505 PCIe switch.

In my case the enclosure was one based on the Oxford Semiconductor chipset
(911?).  The drive is a PATA Western Digital 500 GB drive (00AAKB-00H8A0 - I
think from memory it's a Green drive).  The firewire card is reported to be

  VIA Technologies, Inc. IEEE 1394 Host Controller (rev 46)
    Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller

(vendor/device ID: 1106:3044, subsystem: 1106:3044).

>   - whether SATA or USB disks are affected (SATA probably not, USB not
>     used yet),

The system concerned uses SATA discs for the system drives, driven by:

  RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller
    (rev 80)
  Subsystem: ASUSTeK Computer Inc. A7V600/K8V Deluxe/K8V-X/A8V Deluxe
    motherboard

I have seen no corruption on these.  Once a week I am also writing to
alternating external USB2 drives (again, using rsync) and none of those have
seen this corruption either.  The USB host is reported to be

  USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 20
    [EHCI])
  Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard

As I said, since there seems to be a working kernel between the version I
saw which exhibited the problem and the one where Stefan experienced an
issue, it's possible that these are two different issues (one fixed, one
still lurking).  I throw the above out there in case it helps.

Regards
  jonathan

PS: I'm not subscribed to lkml, but am to ieee1394-devel.
