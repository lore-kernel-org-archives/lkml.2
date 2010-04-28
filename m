Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab0D1CCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:02:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43606 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0D1CCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:02:03 -0400
Message-ID: <4BD796A1.7050505@oracle.com>
Date: Wed, 28 Apr 2010 10:00:01 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] XFS: Let the broken fiemap work in query mode.
References: <1272349065-16383-1-git-send-email-tao.ma@oracle.com> <20100428015035.GC9783@dastard>
In-Reply-To: <20100428015035.GC9783@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BD796F1.0164:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Chinner wrote:
> On Tue, Apr 27, 2010 at 02:17:45PM +0800, Tao Ma wrote:
>> According to Documentation/filesystems/fiemap.txt, If fm_extent_count
>> is zero, then the fm_extents[] array is ignored (no extents will be
>> returned), and the fm_mapped_extents count will hold the number of
>> extents needed.
>>
>> But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
>> bmv_count to the caller's input buffer, this number query function can't
>> work any more. As this commit is written to change bmv_count from
>> MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
>> set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
>> much extents the file has, a big number may cause ENOMEM, while a small
>> one will mask the real extent no.
>>
>> So this patch try to resolve this problem by adding a temporary getbmapx
>> in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
>> the "out" either. Instead, every time we want to use 'out', use '&tmp'
>> instead.
>>
>> I know this solution is a bit ugly, but I can't find a way to resolve
>> this issue while not changing the codes too much. So any good suggestion
>> is welcomed.
> 
> I don't see a need to change xfs_getbmap() to fix this. We can limit
> the maximum allocation size to something realistic just by setting
> bm.bmv.count to something sane. e.g, in xfs_vn_fiemap:
> 
> -	bm.bmv_count = fieinfo->fi_extents_max + 1;
> +	bm.bmv.count = !fieinfo->fi_extents_max ? MAXEXTNUM :
> +					fieinfo->fi_extents_max - 1;
> +	bm.bmv_count = MIN(bm.bmv_count,
> 				(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
> 
> Unless I'm missing something, that should also prevent the case of
> an application providing a really large fi_extents_max from
> triggering ENOMEM in most cases as well.
I just worry about one thing: What if the real extent number is larger 
than the PAGE_SIZE * 16 / sizeof(struct getbmapx)? In this case, we will
give up the wrong extent number to the user space.
> 
> FWIW, how did you find this? Is it possible for you to add a test
> for this regression into xfstests so that we don't break it again
> in future?
Sure, I will check and see whether I can add it in xfstests.

Regards,
Tao
