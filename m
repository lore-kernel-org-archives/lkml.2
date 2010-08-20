Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0HTNgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:36:45 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:7057 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab0HTNgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:36:42 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <20100818203143.735033743@clark.site>
References: <20100818203143.735033743@clark.site>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 13:54:47 +0100
Message-ID: <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard
 page
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=isDwiucj6PoA:10 a=IkcTkHD0fZMA:10 a=pfAEsQY0zHeJQJWgyw0A:9 a=H9RkHlfbOmziW10brJIA:7 a=SEaPx774p6rcqUbq-2ajP-F_6oQA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 13:30 -0700, Greg KH wrote:
> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
> 

>  - by also teaching the _real_ mlock() functionality not to try to lock
>    the guard page.
> 
>    That would just expand the mapping down to create a new guard page,
>    so there really is no point in trying to lock it in place.

> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -167,6 +167,14 @@ static long __mlock_vma_pages_range(stru
>  	if (vma->vm_flags & VM_WRITE)
>  		gup_flags |= FOLL_WRITE;
>  
> +	/* We don't try to access the guard page of a stack vma */
> +	if (vma->vm_flags & VM_GROWSDOWN) {
> +		if (start == vma->vm_start) {
> +			start += PAGE_SIZE;
> +			nr_pages--;
> +		}
> +	}
> +

Is this really correct?

I have an app which tries to mlock a portion of its stack. With this
patch (and a bunch of debug) in place I get:
        [  170.977782] sys_mlock 0xbfd8b000-0xbfd8c000 4096
        [  170.978200] sys_mlock aligned, range now 0xbfd8b000-0xbfd8c000 4096
        [  170.978209] do_mlock 0xbfd8b000-0xbfd8c000 4096 (locking)
        [  170.978216] do_mlock vma de47d8f0 0xbfd7e000-0xbfd94000
        [  170.978223] mlock_fixup split vma de47d8f0 0xbfd7e000-0xbfd94000 at start 0xbfd8b000
        [  170.978231] mlock_fixup split vma de47d8f0 0xbfd8b000-0xbfd94000 at end 0xbfd8c000
        [  170.978240] __mlock_vma_pages_range locking 0xbfd8b000-0xbfd8c000 (1 pages) in VMA bfd8b000 0xbfd8c000-0x0
        [  170.978248] __mlock_vma_pages_range adjusting start 0xbfd8b000->0xbfd8c000 to avoid guard
        [  170.978256] __mlock_vma_pages_range now locking 0xbfd8c000-0xbfd8c000 (0 pages)
        [  170.978263] do_mlock error = 0

Note how we end up locking 0 pages.

The stack layout is:
         0xbfd94000 stack VMA end / base
        
         0xbfd8c000 mlock requested end
         0xbfd8b000 mlock requested start
        
         0xbfd7f000 stack VMA start / top
        
         0xbfd7e000 guard page

As part of the mlock_fixup the original VMA (0xbfd7e000-0xbfd94000) is
split into 3, 0xbfd7e000-0xbfd8b000 + 0xbfd8b000-0xbfd8c000 +
0xbfd8c000-0xbfd94000 in order to mlock the middle bit.

Since we have split the original VMA into 3, shouldn't only the bottom
one still have VM_GROWSDOWN set? (how can the top two grow down with the
bottom one in the way?) Certainly it seems wrong to enforce a guard page
on anything but the bottom VMA (which is what appears to be happening).

Although perhaps the larger issue is whether or not it is valid to mlock
below the current end of your current stack, I don't see why it wouldn't
be so perhaps the above is just completely bogus? Isn't it possible that
a process may try and mlock something on a stack page which hasn't
previously been touched and therefore isn't currently mapped and which
therefore could contain the guard page?

Out of interest how does the guard page interact with processes which do
alloca(N*PAGE_SIZE)?

Ian.
-- 
Ian Campbell
Current Noise: Opeth - White Cluster

If we do not change our direction we are likely to end up where we are headed.

