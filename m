Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0DTU0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:26:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0DTU0b convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 20 Apr 2010 16:26:31 -0400
X-Greylist: delayed 6250 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 16:26:31 EDT
Date: Tue, 20 Apr 2010 16:25:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tracy Reed <treed@ultraviolet.org>,
       Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
       xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420202519.GB9220@phenom.dumpdata.com>
References: <20100420080958.GN5660@tracyreed.org> <20100420084955.GV1878@reaktio.net> <20100420200004.GQ5660@tracyreed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100420200004.GQ5660@tracyreed.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BCE0DE4.0018:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:00:04PM -0700, Tracy Reed wrote:
> On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi Kärkkäinen spake thusly:
> > Are you using filesystems on normal partitions, or LVM in the domU? 
> > I'm pretty sure this is a domU partitioning problem.
> 
> Also: What changes in the view of the partitioning between domU and
> dom0? Wouldn't a partitioning error manifest itself in tests in the
> dom0 as well as in the domU?
> 
> BTW: The dd from the last time in my last email finally finished:
> 
> # dd if=/dev/zero of=/dev/xvdg1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 734.714 seconds, 16.7 MB/s
> 
> If I run that very same dd as above (the last test in my previous

The DomU disk from the Dom0 perspective is using 'phy' which means
there is no caching in Dom0 for that disk (but it is in DomU).
Caching should be done in DomU in that case - which begs the question -
how much memory do you have in your DomU? What happens if you
give to both Dom0 and DomU the same amount of memory?

> email) with the same partition setup again but this time from the
> dom0:
> 
> # dd if=/dev/zero of=/dev/etherd/e6.1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 107.352 seconds, 114 MB/s

OK. That is possibly caused by the fact that you are caching the data.
Look at your buffers cache (and  drop the cache before this) and see
how it grows.

> 
> # /sbin/sfdisk -d /dev/etherd/e6.1 
> # partition table of /dev/etherd/e6.1
> unit: sectors
> 
> /dev/etherd/e6.1p1 : start=       64, size=566226926, Id=83

How do you know this is a mis-aligned sectors issue? Is this what your
AOE vendor is telling you ?

I was thinking of first eliminating caching from the picture and seeing
the speeds you get when you do direct IO to the spindles. You can do this using
a tool called 'fio' or 'dd' with the oflag=direct. Try doing that from
both Dom0 and DomU and see what the speeds are.

