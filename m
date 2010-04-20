Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0DTJAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:00:44 -0400
Received: from reaktio.net ([194.89.68.22]:53172 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0DTJAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:00:42 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 05:00:42 EDT
Date: Tue, 20 Apr 2010 11:54:36 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Tracy Reed <treed@ultraviolet.org>, xen-devel@lists.xensource.com,
       Aoetools-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420085436.GW1878@reaktio.net>
References: <20100420080958.GN5660@tracyreed.org> <20100420084955.GV1878@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100420084955.GV1878@reaktio.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi Kärkkäinen wrote:
> On Tue, Apr 20, 2010 at 01:09:58AM -0700, Tracy Reed wrote:
> > Anyone know why my xen xvda devices would be doing (apparently)
> > unaligned writes to my SAN causing horrible performance and massive
> > seeking and lots of reading for page cache backfill? BUT writing to
> > the device in the dom0 is very fast and causes no extra reads?
> > 
> > I am running the 2.6.18-164.11.1.el5xen xen/kernel which came with
> > CentOS 5.4
> > 
> > After spending a lot of time banging my head on this I seem to have
> > finally tracked it down to a difference between domU and dom0.  I
> > never would have thought it would be this but it is extremely
> > reproduceable. We're talking a difference of 4-5x in write speed.
> > Reads are equally fast everywhere.
> > 
> > I am using AoE v72 kernel module (initiator) on a Dell R610's to talk
> > to vblade-19 (target) on Dell R710's all running CentOS 5.4. I have
> > striped two 7200 RPM SATA disks and exported the md with AoE (although
> > I have done these tests with individual disks also). Read performance
> > is excellent:
> > 
> > # dd of=/dev/null if=/dev/xvdg1 bs=4096 count=3000000
> > 3000000+0 records in
> > 3000000+0 records out
> > 12288000000 bytes (12 GB) copied, 106.749 seconds, 115 MB/s
> > 
> > I dropped the cache with:
> > 
> > echo 1 > /proc/sys/vm/drop_caches
> > 
> > on both target and initiator before starting the test. This is great
> > for just a single gig-e link. This suggests that the network is fine.
> > 
> > However, write performance is odious. Typically around 20MB/s. It
> > should be more like 70MB/s per disk or better (7200rpm SATA) and max
> > out my gig-e with write performance similar to the above read
> > performance. I mentioned above that these are unaligned writes because
> > when running iostat on the target machine I can see lots of reads
> > happening which are surely causing seeks and killing
> > performance. Typical is something like 8MB/s of reads while doing
> > 16MB/s of writes.
> > 
> > HOWEVER, if I do the writes from the dom0 the performance is
> > excellent:
> > 
> > # dd if=/dev/zero of=/dev/etherd/e6.2 bs=4096 count=3000000
> > 3000000+0 records in
> > 3000000+0 records out
> > 12288000000 bytes (12 GB) copied, 104.679 seconds, 117 MB/s
> > 
> > And I see no reads happening on the disks being written to in
> > iostat. Purely streaming writes at high speeds.
> > 
> > I have had AoE working very well with Xen previously although not with
> > this particular hardware/xen/aoe version. Also it occurs to me that in
> > the past when I have done this I network booted the domU's and they
> > got root over AoE using a complicated initrd that I cooked up. In the
> > last year or so I decided that it was too complicated and went to
> > booting my dom0's from compact flash with the AoE driver in the dom0
> > instead of the domU. I now handing the domU xvd's from the AoE driver
> > in dom0. I strongly suspect that this is why things worked great
> > before but stink now. Unfortunately I don't have a working network
> > boot initrd setup like I used to and although I still have all of the
> > code etc. it would take a while to set up. I don't want to run that
> > setup in production anymore anyway if I can help it.
> > 
> > I have tried manually aligning the disk by setting the beginning of
> > data on the partition from 63 to 64 (although this is usually done for
> > RAID alignment) and I have tried changing the disk geometry to account
> > for the extra partition table which causes a half-block page-cache
> > misalignment as described by the ever insightful Kelsey Hudson in his
> > writeup on the issue here:
> > 
> > http://copilotco.com/Virtualization/wiki/aoe-caching-alignment.pdf/at_download/file
> > 
> > All to no avail. What am I missing here? Why is domU apparently
> > fudging my writes?
> > 
> 
> Please paste your domU partition table:
> sfdisk -d /dev/xvda
> 
> Are you using filesystems on normal partitions, or LVM in the domU? 
> I'm pretty sure this is a domU partitioning problem.
> 

Also it's easy to verify.. add another disk (xvdb) to the domU,
and use dd to write directly to non-partitioned disk!

dd if=/dev/zero of=/dev/xvdb bs=something count=whatever

This shouldn't cause any un-aligned writes.

Also make sure you try different block sizes.. 4k might be ok for testing max iops,
but 64k or even 1024k is good for measuring max throughput.

-- Pasi

