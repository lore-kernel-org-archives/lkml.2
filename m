Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2LUUSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:18:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23123 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LUUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:18:37 -0500
Date: Fri, 21 Dec 2012 15:18:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, dgdegra@tycho.nsa.gov,
        xen-devel@lists.xensource.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: oopsable race in xen-gntdev (unsafe vma access)
Message-ID: <20121221201824.GA31554@phenom.dumpdata.com>
References: <20121215181211.GV4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121215181211.GV4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 06:12:11PM +0000, Al Viro wrote:
> 	1) find_vma() is *not* safe without ->mmap_sem and its result may
> very well be freed just as it's returned to caller.  IOW,
> gntdev_ioctl_get_offset_for_vaddr() is racy and may end up with
> dereferencing freed memory.
> 
> 	2) gntdev_vma_close() is putting NULL into map->vma with only
> ->mmap_sem held by caller.  Things like
>                 if (!map->vma)
>                         continue;
>                 if (map->vma->vm_start >= end)
>                         continue;
>                 if (map->vma->vm_end <= start)
> done with just priv->lock held are racy.
> 
> 	I'm not familiar with the code, but it looks like we need to
> protect gntdev_vma_close() guts with the same spinlock and probably
> hold ->mmap_sem shared around the "find_vma()+get to map->{index,count}"
> in the ioctl.  Or replace the logics in ioctl with search through the
> list of grant_map under the same spinlock...
> 
> 	Comments?
Hey Al,

Thank you for your analysis.

CC-ing Daniel, David and Stefano. I recall we had some priv->lock movement
in the past and there is also interaction with another piece of code - 
the balloon code so we better be circumspect of not blowing up.

Al, it is around holidays and folks are mostly gone - so this will take
a bit of time to get sorted out.
