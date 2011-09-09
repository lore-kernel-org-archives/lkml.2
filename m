Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab1IIPQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:16:12 -0400
Received: from masquerade.micron.com ([137.201.242.130]:17282 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1IIPQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:16:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
Date: Fri, 9 Sep 2011 08:10:42 -0700
Message-ID: <2A9BE4FF6209B644B6F8EB62DE6AEA1E077C9E70@ntxfrembx01.micron.com>
In-Reply-To: <4E69D519.8070802@fusionio.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
Thread-Index: Acxuzpk+kJPeB9OpS0+HDhz3axgHxwAMzv4w
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <4E69D519.8070802@fusionio.com>
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: "Jens Axboe" <jaxboe@fusionio.com>,
        "Christoph Hellwig" <hch@infradead.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Jeff Garzik" <jgarzik@pobox.com>,
        <jmoyer@redhat.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 2011-09-09 10:54, Christoph Hellwig wrote:
> > On Mon, Aug 22, 2011 at 02:28:11PM -0700, Sam Bradshaw (sbradshaw)
wrote:
> >> New patch for mtip32xx driver based on feedback from
> >> Jens Axboe, Christoph Hellwig, and Alan Cox.
> >
> > A few comments that need addressing:
> >
> >  - the ioctl handler always returns 0 for the BLKFLSBUF ioctl,
without
> >    doing anything.  Given that the ioctl is supposed to flush all
kinds
> >    of higher level cached data this is a serious data integrity
issue.
> >    It must simply do the default -ENOTTY return for it and let the
block
> >    layer do the right thing.
> >  - handling of REQ_FUA / REQ_FLUSH requests is completely broken.
> >    There is a weird barrier flag to mtip_hw_submit_io which set the
> >    hwardware FUA bit if the FLUSH bit is set on a request.
> >    Please take a look at how this should be handled, the
> >    Documentation/block/writeback_cache_control.txt file is the
canonical
> >    resource.  Implementing your driver at the make_request layer
> >    unfortunately means you will have to do all the hard work
yourself.
> >  - also the call to blk_queue_flush(queue, 0); from ->make_request
for
> >    a non-data request is completely wrong.
> 
> I noticed both of these flush/fua problems too and have fixed them up.
> 
> >  - the 64-bit case in fill_command_sg will blow up on big endian
> >    systems, please use your current 32-bit case unconditionally
> >  - mtip_block_getgeo should just use sector_div instead of the ifdef
> >    mess.
> >  - please check the driver using sparse, and most importantly the
> >    optional endianess checking pass of it.  Currently the driver
> >    uses plain unsigned int and similar types for little endian
> >    hardware structures.  Take a look at Documentation/sparse.txt
> >    on how to use it.
> >  - the mtip_check_surprise_removal check should be unconditional,
not
> >    under #ifdef CONFIG_HOTPLUG
> 
> In general, the dependency on HOTPLUG_PCI_PCIE is odd as well.
> 
> >  - Given that the driver has a single c implementation file all
symbols
> >    should be marked static, and there should be no prototypes in the
> >    header
> 
> Sam, would be nice if you could send in patches for the other bugs
that
> Christoph have pointed out. I already found and fixed the flush parts.

Will do.  I'll send out patches against for-3.2/mtip32xx, given that
Jens has already made some changes.

Thanks for the tip on sparse endianness checking.  I wasn't aware of
this tool until now.

-Sam


