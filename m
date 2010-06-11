Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0FKXjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:39:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46928 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0FKXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:39:08 -0400
Message-ID: <4C12C8BB.50604@oracle.com>
Date: Sat, 12 Jun 2010 07:37:31 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfs: Make fiemap works with sparse file.
References: <1276236135-12051-1-git-send-email-tao.ma@oracle.com> <4C125C0D.4080600@sandeen.net>
In-Reply-To: <4C125C0D.4080600@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4C12C911.0196:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Tao Ma wrote:
>   
>> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
>> to return fi_extent_max extents, but actually it won't work for
>> a sparse file. The reason is that in xfs_getbmap we will
>> calculate holes and set it in 'out', while out is malloced by
>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>> worst case, if 'out' vector looks like
>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>> we will only return half of fi_extent_max extents.
>>
>> So in xfs_vn_fiemap, we should consider this worst case. If the
>> user wants fi_extent_max extents, we need a 'out' with size of
>> 2 *fi_extent_max + 1.
>>     
>
> This all seems right to me, though your commit message above (+1)
> doesn't match the comment and code in the patch (+2)
>   
oh, yes, I will change the commit log and send a v2.
and can I add your ack for this patch?

Regards,
Tao
> -Eric
>
>   
>> Cc: Alex Elder <aelder@sgi.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> ---
>>  fs/xfs/linux-2.6/xfs_iops.c |   16 ++++++++++++++--
>>  1 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
>> index 9c8019c..1db92e3 100644
>> --- a/fs/xfs/linux-2.6/xfs_iops.c
>> +++ b/fs/xfs/linux-2.6/xfs_iops.c
>> @@ -672,9 +672,21 @@ xfs_vn_fiemap(
>>  	else
>>  		bm.bmv_length = BTOBB(length);
>>  
>> -	/* We add one because in getbmap world count includes the header */
>> +	/*
>> +	 * It is a bit tricky for us to calculate the bmv_count from
>> +	 * fi_extent_max.
>> +	 * If we support to return fi_extent_max extents to the user,
>> +	 * we need at most 2 * fi_extent_max + 1 for bmv_count since
>> +	 * in xfs_getbmap we will calculate holes while fi_extent_max
>> +	 * don't have them. So in the worst case, bmv can looks like
>> +	 * [hole, extent, hole, extent, hole, ... hole, extent, hole].
>> +	 * So there will be 2 *fi_extent_max + 1.
>> +	 * What's more, in getbmap world count have to include the
>> +	 * header, so we need another bmv. So the total number will
>> +	 * be 2 * fieinfo->fi_extents_max + 2.
>> +	 */
>>  	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
>> -					fieinfo->fi_extents_max + 1;
>> +			2 * fieinfo->fi_extents_max + 2;
>>  	bm.bmv_count = min_t(__s32, bm.bmv_count,
>>  			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
>>  	bm.bmv_iflags = BMV_IF_PREALLOC;
>>     
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

