Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab3AHSp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:45:27 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42061 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3AHSpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:45:25 -0500
Date: Tue, 8 Jan 2013 10:45:20 -0800
From: Tejun Heo <tj@kernel.org>
To: ajithb.kumar@gmail.com
Cc: fa.linux.kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [block] allow blk_flush_policy to return REQ_FSEQ_DATA
 independent of *FLUSH
Message-ID: <20130108184520.GF3926@htj.dyndns.org>
References: <fa.WShHQz59YhGkw1sSCIqXCXLEJ3Q@ifi.uio.no>
 <52efc2cd-6d8c-4195-882a-8bc4105bc715@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52efc2cd-6d8c-4195-882a-8bc4105bc715@googlegroups.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 08, 2013 at 10:04:23AM -0800, ajithb.kumar@gmail.com wrote:
> Hi,
> Could you please provide clarity on the following.
> ">   Hmmm... yes, this can become a correctness issue if (and only if)
> >   blk_queue_flush() is called to change q->flush_flags while requests
> >   are in-flight;"
>
> Could you please clarify as to why is it a correctness issue only if
> blk_queue_flush() is used to change flush_flags when requests are in
> flight ?  As I understand, XFS does set WRITE_FLUSH_FUA flag in
> _xfs_buf_ioapply() function irrespective of whether the underlying
> device supports flush capabilities or not which will flow into
> blk_insert_flush().  Is my reading of the code correct and is there
> a general correctness issue here which potentially results in XFS
> file system corruption in case of an abrupt shutdown independent of
> q->flush_flags getting changed while request is in flight.

My memory is kinda fuzzy at this point but if a queue doesn't support
flush, its flush_flags should be zero and
generic_make_request_checks() will clear REQ_FLUSH|REQ_FUA from
bio->bi_rw so we never hit blk_insert_flush() and the request will be
processed as a normal IO one; however, if REQ_FLUSH goes off after a
request passed generic_make_request_checks() but before
blk_flush_policy(), it'll become null op and its data payload won't
get written out to the underlying device, which is data corruption.

Thanks.

-- 
tejun
