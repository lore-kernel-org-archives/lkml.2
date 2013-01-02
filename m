Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3ABW6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:58:24 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:58472 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752735Ab3ABW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:58:21 -0500
X-TM-IMSS-Message-ID: <5cefc27c00096f1b@nsa.gov>
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
To: viro@ZenIV.linux.org.uk, konrad.wilk@oracle.com
Cc: david.vrabel@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: oopsable race in xen-gntdev [PATCH 0/3]
Date: Wed,  2 Jan 2013 17:57:10 -0500
Message-Id: <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20121221201824.GA31554@phenom.dumpdata.com>
References: <20121221201824.GA31554@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 03:18 PM, Konrad Rzeszutek Wilk wrote:
> On Sat, Dec 15, 2012 at 06:12:11PM +0000, Al Viro wrote:
>> 	1) find_vma() is *not* safe without ->mmap_sem and its result may
>> very well be freed just as it's returned to caller.  IOW,
>> gntdev_ioctl_get_offset_for_vaddr() is racy and may end up with
>> dereferencing freed memory.

I agree, this one should be fixed by taking mmap_sem in
gntdev_ioctl_get_offset_for_vaddr. Iterating the grant_map list here
will not work under HVM, where map->vma is not filled in.

>> 	2) gntdev_vma_close() is putting NULL into map->vma with only
>> ->mmap_sem held by caller.  Things like
>>                 if (!map->vma)
>>                         continue;
>>                 if (map->vma->vm_start >= end)
>>                         continue;
>>                 if (map->vma->vm_end <= start)
>> done with just priv->lock held are racy.
>>
>> 	I'm not familiar with the code, but it looks like we need to
>> protect gntdev_vma_close() guts with the same spinlock and probably
>> hold ->mmap_sem shared around the "find_vma()+get to map->{index,count}"
>> in the ioctl.  Or replace the logics in ioctl with search through the
>> list of grant_map under the same spinlock...
>>
>> 	Comments?

Although I don't think the mmu notifier is ever called without mmap_sem
on this particular device file (we map only with VM_DONTCOPY and other
paths like truncate generally aren't triggered), it's probably best not
to rely on that behavior, so adding the spinlock in gntdev_vma_close
seems to be the best solution.

> Hey Al,
> 
> Thank you for your analysis.
> 
> CC-ing Daniel, David and Stefano. I recall we had some priv->lock movement
> in the past and there is also interaction with another piece of code - 
> the balloon code so we better be circumspect of not blowing up.
> 
> Al, it is around holidays and folks are mostly gone - so this will take
> a bit of time to get sorted out.

While I was digging in this code, I found a related bug in
mn_invl_range_start: if gntdev_ioctl_unmap_grant_ref is called on
a range before unmapping it, the entry is removed from priv->maps and
the later call to mn_invl_range_start won't find it to do the unmapping.
This could be fixed by using find_vma, but I don't think there's a safe
way to do that from inside the mmu notifier, so instead I created a list
of these unlinked but still mapped pages.

The third patch is a fix to an unrelated bug that I found while testing
the fixes in the other two patches.

[PATCH 1/3] xen/gntdev: fix unsafe vma access
[PATCH 2/3] xen/gntdev: correctly unmap unlinked maps in mmu
[PATCH 3/3] xen/gntdev: remove erronous use of copy_to_user
