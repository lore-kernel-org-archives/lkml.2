Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0FRC3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:29:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26269 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0FRC3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:29:00 -0400
Message-ID: <4C1AD9A5.8010600@oracle.com>
Date: Fri, 18 Jun 2010 10:27:49 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>,
       "tao.ma" <tao.ma@oracle.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
References: <20100614122912.GD6590@dastard> <1276764799-4837-1-git-send-email-tao.ma@oracle.com> <20100618004708.GZ6590@dastard>
In-Reply-To: <20100618004708.GZ6590@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C1AD9D6.0099:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 06/18/2010 08:47 AM, Dave Chinner wrote:
> On Thu, Jun 17, 2010 at 04:53:19PM +0800, Tao Ma wrote:
>> Hi Dave,
>> On 06/14/2010 08:29 PM, Dave Chinner wrote:
>>> I just had a thought - if you want to avoid holes being reported to
>>> fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
>>> holes in the mappin gloop when this flag is set. That will make
>>> fiemap fill in the full number of extents without hacking the
>>> extent count...
>> Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
>> to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
>> log. I guess maybe we can add another flag in xfs_bmapi so that it
>> don't even give us the holes?
>
> No need...
I am fine with it.
>
>>
>> Regards,
>> Tao
>>
>>  From cee1765ffd3e2b003b837666b4620b5107ed9ddd Mon Sep 17 00:00:00 2001
>> From: Tao Ma<tao.ma@oracle.com>
>> Date: Thu, 17 Jun 2010 16:14:22 +0800
>> Subject: [PATCH v3] xfs: Make fiemap works with sparse file.
>>
>> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
>> to return fi_extent_max extents, but actually it won't work for
>> a sparse file. The reason is that in xfs_getbmap we will
>> calculate holes and set it in 'out', while out is malloced by
>> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
>> worst case, if 'out' vector looks like
>> [hole, extent, hole, extent, hole, ... hole, extent, hole],
>> we will only return half of fi_extent_max extents.
>>
>> This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
>> So with this flags, we don't use our 'out' in xfs_getbmap for
>> a hole. The solution is a bit ugly by just don't increasing
>> index of 'out' vector. I felt that it is not easy to skip it
>> at the very beginning since we have the complicated check and
>> some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.
>
> ... because I think we can safely skip xfs_getbmapx_fix_eof_hole()
> it only modifies the hole. Hence  just adding a check after the
> attribute fork end check (which needs to detect a hole to terminate)
> should be fine: e.g something like:
>
> 			if (map[i].br_startblock == HOLESTARTBLOCK&&
> 			whichfork == XFS_ATTR_FORK) {
> 				/* came to the end of attribute fork */
> 				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
> 				goto out_free_map;
> 			}
> +			if (map[i].br_startblock == HOLESTARTBLOCK&&
> +				 (iflags&  BMV_IF_NO_HOLES)) {
> +				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
> +				continue;
> +			}
>
> Should work and avoid the worst of the ugliness.
I am afraid it doesn't work, at least from my test. It enters a dead loop.
I think the root cause is that your change doesn't update bmv_offset and 
bmv_length for a hole. So in the large loop,
do {
                 nmap = (nexleft > subnex) ? subnex : nexleft;
		error = xfs_bmapi(NULL, ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
                                   XFS_BB_TO_FSB(mp, bmv->bmv_length),
                                   bmapi_flags, NULL, 0, map, &nmap,
                                   NULL, NULL);
                 if (error)
                         goto out_free_map;
...
} while (nmap && nexleft && bmv->bmv_length);

We will dead loop there and we need xfs_getbmapx_fix_eof_hole to go out 
directly.

Regards,
Tao
