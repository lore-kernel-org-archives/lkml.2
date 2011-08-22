Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1HVOin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:38:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59427
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1HVOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:38:39 -0400
Date: Mon, 22 Aug 2011 10:38:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] xen-blkback: sync I/O after backend disconnected
Message-ID: <20110822143829.GA2056@infradead.org>
References: <4E48A6A6.4040706@oracle.com>
 <20110815144610.GA3707@infradead.org>
 <4E4A149E.5080608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4A149E.5080608@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 02:56:30PM +0800, Joe Jin wrote:
> On 08/15/11 22:46, Christoph Hellwig wrote:
> > On Mon, Aug 15, 2011 at 12:55:02PM +0800, Joe Jin wrote:
> >> When backend disconnect, sync IO requests to the disk.
> > 
> > Care to explain why?
> 
> When backend disconnect, I think we'd better flush all dirty data 
> to the disk ASAP.

Then please state this in the commit log, and even better the code
also.

> > Also you'll just need a sync_blockdev, fsync_bdev does far to many
> > things that don't make any sense when you don't have a file system
> > mounted on a device.
> > 
> 
> xen-blkback support physical device and loopback file, so I think
> here should be fsync_bdev()? 

No, and in fact sync_blockdev is also wrong when thinking about it.
blkback always submits bios directly to the device, so flushing any
kernel caches won't do you any help.  The only thing that might make
sense to flush would be the disk write cache using a blkdev_issue_flush.

