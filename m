Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0I0RrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:47:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58537 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab0I0RrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ii3gZbc6VMtzfS+Z6dCuKGRnbOzkvBlEjjcqdPWtpumwPSMvWt8ztxhV5LG6CRLXQ+
         t2R+KylcqNnEqnvjl2mQ1Kgqu/clPLnOoZYnQb2C4MTpe/f7TUXOWnThbnvtyC4qHulM
         D+rJ5/utpDZkRLe/COIxDWuOi4t3zUZiVaeww=
MIME-Version: 1.0
In-Reply-To: <20100924162619.488476565@clark.site>
References: <20100924162706.GA7381@kroah.com>
	<20100924162619.488476565@clark.site>
Date: Mon, 27 Sep 2010 13:47:05 -0400
Message-ID: <AANLkTim+rssCPPfvzmntXfP+c2pU5LzojqCueuXidNF2@mail.gmail.com>
Subject: Re: [53/80] SCSI: mptsas: fix hangs caused by ATA pass-through
From: John Drescher <drescherjm@gmail.com>
To: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:24 PM, Greg KH <gregkh@suse.de> wrote:
> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Ryan Kuester <rkuester@kspace.net>
>
> commit 2a1b7e575b80ceb19ea50bfa86ce0053ea57181d upstream.
>
> I may have an explanation for the LSI 1068 HBA hangs provoked by ATA
> pass-through commands, in particular by smartctl.
>
> First, my version of the symptoms.  On an LSI SAS1068E B3 HBA running
> 01.29.00.00 firmware, with SATA disks, and with smartd running, I'm seeing
> occasional task, bus, and host resets, some of which lead to hard faults of
> the HBA requiring a reboot.  Abusively looping the smartctl command,
>
>    # while true; do smartctl -a /dev/sdb > /dev/null; done
>
> dramatically increases the frequency of these failures to nearly one per
> minute.  A high IO load through the HBA while looping smartctl seems to
> improve the chance of a full scsi host reset or a non-recoverable hang.
>
> I reduced what smartctl was doing down to a simple test case which
> causes the hang with a single IO when pointed at the sd interface.  See
> the code at the bottom of this e-mail.  It uses an SG_IO ioctl to issue
> a single pass-through ATA identify device command.  If the buffer
> userspace gives for the read data has certain alignments, the task is
> issued to the HBA but the HBA fails to respond.  If run against the sg
> interface, neither the test code nor smartctl causes a hang.
>
> sd and sg handle the SG_IO ioctl slightly differently.  Unless you
> specifically set a flag to do direct IO, sg passes a buffer of its own,
> which is page-aligned, to the block layer and later copies the result
> into the userspace buffer regardless of its alignment.  sd, on the other
> hand, always does direct IO unless the userspace buffer fails an
> alignment test at block/blk-map.c line 57, in which case a page-aligned
> buffer is created and used for the transfer.
>
> The alignment test currently checks for word-alignment, the default
> setup by scsi_lib.c; therefore, userspace buffers of almost any
> alignment are given directly to the HBA as DMA targets.  The LSI 1068
> hardware doesn't seem to like at least a couple of the alignments which
> cross a page boundary (see the test code below).  Curiously, many
> page-boundary-crossing alignments do work just fine.
>
> So, either the hardware has an bug handling certain alignments or the
> hardware has a stricter alignment requirement than the driver is
> advertising.  If stricter alignment is required, then in no case should
> misaligned buffers from userspace be allowed through without being
> bounced or at least causing an error to be returned.
>
> It seems the mptsas driver could use blk_queue_dma_alignment() to advertise
> a stricter alignment requirement.  If it does, sd does the right thing and
> bounces misaligned buffers (see block/blk-map.c line 57).  The following
> patch to 2.6.34-rc5 makes my symptoms go away.  I'm sure this is the wrong
> place for this code, but it gets my idea across.
>

Interesting. I have recently experienced lockups (bus resets ...)
while testing an older server machine with 2 new LSI PCI-X SAS1068E
cards and 10+ SATA drives. I thought the problem was the machine I was
testing on. This was on 2.6.35.X about 1 month ago (not sure the exact
revision). I will try to setup the machine again and test before and
after the patch.

BTW, my testing was forcing a check or rebuild on a 10 drive software
raid 6 and while that was going on run smart checks on the drives.
This would cause the bad behavior on the 2nd pass.

John
