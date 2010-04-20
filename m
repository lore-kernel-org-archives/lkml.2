Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0DTTym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:54:42 -0400
Received: from reaktio.net ([194.89.68.22]:48569 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0DTTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:54:41 -0400
Date: Tue, 20 Apr 2010 22:54:42 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Tracy Reed <treed@ultraviolet.org>, xen-devel@lists.xensource.com,
       Aoetools-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420195442.GC1878@reaktio.net>
References: <20100420080958.GN5660@tracyreed.org> <20100420084955.GV1878@reaktio.net> <20100420193952.GP5660@tracyreed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100420193952.GP5660@tracyreed.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:39:52PM -0700, Tracy Reed wrote:
> On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi Kärkkäinen spake thusly:
> > Please paste your domU partition table:
> > sfdisk -d /dev/xvda
> 
> I have tried many different things including dd straight to the raw
> unpartitioned device. That should not be affected by
> partitioning/lvm/filesystem problems right?
> 

Yeah, partitioning doesn't affect when you use the straight/raw disk device.

> > Are you using filesystems on normal partitions, or LVM in the domU? 
> > I'm pretty sure this is a domU partitioning problem.
> 
> I have done all of the above. Here I am an xvdg device in my domU to
> which I am directly doing a dd to, no partitioning or anything:
> 
> # dd if=/dev/zero of=/dev/xvdg bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 449.109 seconds, 27.4 MB/s
>

Please try with "bs=1024k" and maybe with "bs=64k" aswell.
 
4k blocksize transfer will always be slower in domU than in dom0
since virtual disk abstraction makes some overhead, which is more
visible with small blocksizes.


> # /sbin/sfdisk -d /dev/xvdg
> 
> sfdisk: ERROR: sector 0 does not have an msdos signature
>  /dev/xvdg: unrecognized partition table type
> No partitions found
> 
> and running iostat on the target shows the following:
> 
> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00  3474.60 1070.60 46.40  4311.20 13680.00    32.21     2.08    1.83   0.49  54.32
> sdb               0.00  3376.00 1060.20 45.60  4289.60 13686.40    32.51     2.46    2.23   0.53  58.12
> 
> Or I can partition it with a geometry of 248 heads and 56 sectors
> which is a multiple of 8 which should avoid the misalignment due to
> the extra partition table (there is a partition on the physical disk
> on the target already then I create a logical volume to export to the
> initiator which then puts its own partition in it which causes
> misalignment):
> 
> dd if=/dev/zero of=/dev/xvdg1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 445.338 seconds, 27.6 MB/s
> 

So the speed is the same to the partitioned disk than to the raw disk? 
What disk backend are you using in dom0? phy:? tap:aio: ?


> # /sbin/sfdisk -d /dev/xvdg
> # partition table of /dev/xvdg
> unit: sectors
> 
> /dev/xvdg1 : start=       56, size=566227592, Id=8e
> /dev/xvdg2 : start=        0, size=        0, Id= 0
> /dev/xvdg3 : start=        0, size=        0, Id= 0
> /dev/xvdg4 : start=        0, size=        0, Id= 0
> 
> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sda               0.00  3472.20 1188.20 51.00  4805.60 14097.60    30.51     2.71    2.13   0.52  64.02
> sdb               0.00  3472.40 1187.00 52.00  4784.00 14092.80    30.47     2.82    2.22   0.56  68.80
> 
> Or I can take a standard partition geometry and set it to start at 64
> instead of 63 like so many RAID alignment pages talk about:
> 
> It is taking even longer this time and I am tired of waiting for dd
> before sending off this email but suffice it to say it is painfully
> slow.
>

You can cancel dd and it'll print the stats so far.

-- Pasi


