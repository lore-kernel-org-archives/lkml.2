Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0FRArg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 20:47:36 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:35173 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752772Ab0FRArf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 20:47:35 -0400
Date: Fri, 18 Jun 2010 10:47:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Message-ID: <20100618004708.GZ6590@dastard>
References: <20100614122912.GD6590@dastard>
 <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:53:19PM +0800, Tao Ma wrote:
> Hi Dave,
> On 06/14/2010 08:29 PM, Dave Chinner wrote:
> > I just had a thought - if you want to avoid holes being reported to
> > fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
> > holes in the mappin gloop when this flag is set. That will make
> > fiemap fill in the full number of extents without hacking the
> > extent count...
> Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
> to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
> log. I guess maybe we can add another flag in xfs_bmapi so that it
> don't even give us the holes?

No need...

> 
> Regards,
> Tao
> 
> From cee1765ffd3e2b003b837666b4620b5107ed9ddd Mon Sep 17 00:00:00 2001
> From: Tao Ma <tao.ma@oracle.com>
> Date: Thu, 17 Jun 2010 16:14:22 +0800
> Subject: [PATCH v3] xfs: Make fiemap works with sparse file.
> 
> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
> to return fi_extent_max extents, but actually it won't work for
> a sparse file. The reason is that in xfs_getbmap we will
> calculate holes and set it in 'out', while out is malloced by
> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
> worst case, if 'out' vector looks like
> [hole, extent, hole, extent, hole, ... hole, extent, hole],
> we will only return half of fi_extent_max extents.
> 
> This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
> So with this flags, we don't use our 'out' in xfs_getbmap for
> a hole. The solution is a bit ugly by just don't increasing
> index of 'out' vector. I felt that it is not easy to skip it
> at the very beginning since we have the complicated check and
> some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.

... because I think we can safely skip xfs_getbmapx_fix_eof_hole()
it only modifies the hole. Hence  just adding a check after the
attribute fork end check (which needs to detect a hole to terminate)
should be fine: e.g something like:

			if (map[i].br_startblock == HOLESTARTBLOCK &&
			    whichfork == XFS_ATTR_FORK) {
				/* came to the end of attribute fork */
				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
				goto out_free_map;
			}
+			if (map[i].br_startblock == HOLESTARTBLOCK &&
+				 (iflags & BMV_IF_NO_HOLES)) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}

Should work and avoid the worst of the ugliness.

The rest of the patch looks fine.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
