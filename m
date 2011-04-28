Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab1D1UKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:10:46 -0400
Received: from smtp.tele.fi ([192.89.123.25]:47622 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750950Ab1D1UKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:10:45 -0400
X-Greylist: delayed 2446 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 16:10:44 EDT
X-Originating-Ip: [194.89.68.22]
Date: Thu, 28 Apr 2011 22:29:56 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alyssar@google.com, "konrad@kernel.org" <konrad@kernel.org>,
        vgoyal@redhat.com
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
Message-ID: <20110428192955.GI32595@reaktio.net>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com> <20110421033735.GA11501@infradead.org> <1303370925.5997.322.camel@zakaz.uk.xensource.com> <20110421080411.GA8969@infradead.org> <20110427220634.GA26316@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427220634.GA26316@dumpdata.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 06:06:34PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 21, 2011 at 04:04:12AM -0400, Christoph Hellwig wrote:
> > On Thu, Apr 21, 2011 at 08:28:45AM +0100, Ian Campbell wrote:
> > > On Thu, 2011-04-21 at 04:37 +0100, Christoph Hellwig wrote:
> > > > This should sit in userspace.  And last time was discussed the issue
> > > > Stefano said the qemu Xen disk backend is just as fast as this kernel
> > > > code.  And that's with an not even very optimized codebase yet.
> > > 
> > > Stefano was comparing qdisk to blktap. This patch is blkback which is a
> > > completely in-kernel driver which exports raw block devices to guests,
> > > e.g. it's very useful in conjunction with LVM, iSCSI, etc. The last
> > > measurements I heard was that qdisk was around 15% down compared to
> > > blkback.
> > 
> > Please show real numbers on why adding this to kernel space is required.
> 
> First off, many thanks go out to Alyssa Wilk and Vivek Goyal.
> 
> Alyssa for cluing me on the CPU banding problem (on the first machine I was
> doing the testing  I hit the CPU ceiling and had quite skewed results).
> Vivek for helping me figure out why the kernel blkback was sucking when a READ
> request got added on the stream of WRITEs with CFQ scheduler (I did not the
> REQ_SYNC on the WRITE request).
>   
> The setup is as follow:
> 
> iSCSI target - running Linux v2.6.39-rc4 with TCM LIO-4.1 patches (which
> provide iSCSI and Fibre target support) [1]. I export this 10GB RAMdisk over
> a 1GB network connection.
> 
> iSCSI initiator - Sandy Bridge i3-2100 3.1GHz w/8GB, runs v2.6.39-rc4
>  with pv-ops patches [2]. Either 32-bit or 64-bit, and with Xen-unstable
>  (c/s 23246), Xen QEMU (e073e69457b4d99b6da0b6536296e3498f7f6599) with
>  one patch to enable aio [3]. Upstream QEMU version is quite close to this
>  one (it has a bug-fix in it). Memory limited to Dom0/DomU to 2GB.
>  I boot of PXE and run everything from the ramdisk.
> 
> The kernel/initramfs that I am using for this testing is the same
> throughout and is based off VirtualIron's build system [4].
> 
> There are two tests, each test is run three times.
> 
> The first is random writes of 64K across the disk with four threads
> doing this pounding. The results are in the 'randw-bw.png' file.
> 
> The second is based off IOMeter - it does random reads (20%) and writes
> (80%), with various byte sizes : from 512 bytes up to 64K - two threads
> doing it. The results are in the 'iometer-bw.png' file.
> 

A summary for those who don't bother checking the attachments :)

xen-blkback (kernel) backend seems to perform a lot better
than qemu qdisc (usermode) backend.

Also cpu-usage is smaller with the kernel-backend driver.
Detailed numbers in the attachments in Konrad's previous email.

-- Pasi

