Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0FRGWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:22:55 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:39816 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753529Ab0FRGWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:22:54 -0400
Date: Fri, 18 Jun 2010 16:22:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>,
       Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Message-ID: <20100618062225.GC6590@dastard>
References: <20100614122912.GD6590@dastard>
 <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
 <20100618004708.GZ6590@dastard>
 <4C1AD9A5.8010600@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1AD9A5.8010600@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 10:27:49AM +0800, Tao Ma wrote:
> >>This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
> >>So with this flags, we don't use our 'out' in xfs_getbmap for
> >>a hole. The solution is a bit ugly by just don't increasing
> >>index of 'out' vector. I felt that it is not easy to skip it
> >>at the very beginning since we have the complicated check and
> >>some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.
> >
> >... because I think we can safely skip xfs_getbmapx_fix_eof_hole()
> >it only modifies the hole. Hence  just adding a check after the
> >attribute fork end check (which needs to detect a hole to terminate)
> >should be fine: e.g something like:
> >
> >			if (map[i].br_startblock == HOLESTARTBLOCK&&
> >			whichfork == XFS_ATTR_FORK) {
> >				/* came to the end of attribute fork */
> >				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
> >				goto out_free_map;
> >			}
> >+			if (map[i].br_startblock == HOLESTARTBLOCK&&
> >+				 (iflags&  BMV_IF_NO_HOLES)) {
> >+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
> >+				continue;
> >+			}
> >
> >Should work and avoid the worst of the ugliness.
> I am afraid it doesn't work, at least from my test. It enters a dead loop.
> I think the root cause is that your change doesn't update bmv_offset
> and bmv_length for a hole. So in the large loop,

Yes, you are right - I didn't consider the outer loop termination
properly. My bad.

I'll add your patch to my qa list and move it onwards. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
