Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2FABmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:42:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32796 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab2FABmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:42:19 -0400
Message-ID: <4FC81DE0.5080403@oracle.com>
Date: Fri, 01 Jun 2012 09:41:52 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com> <x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 10:08 PM, Jeff Moyer wrote:
> Junxiao Bi <junxiao.bi@oracle.com> writes:
>
>> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
>> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
>> io flag is involved in it to serialize the unaligned aio. As
>> *private is not initialized in init_sync_kiocb() of do_sync_write(),
>> this unaligned io flag may be unexpectly set in an aligned dio.
>> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
>> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
>> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().
>> We can't initialized this flag in ocfs2_file_write_iter() since
>> it may be invoked several times by do_sync_write(). So we initialize
>> it in init_sync_kiocb(), it's also useful for other similiar use of
>> it in the future.
> I don't see any ocfs2_file_write_iter in the upstream kernel.
> ocfs2_file_aio_write most certainly could set ->private to 0, it
> will only be called once for a given kiocb.
>From sys_io_submit->..->io_submit_one->aio_run_iocb->aio_rw_vect_retry, 
it seems that aio_write could be called two times. See the following
scenario.
1. There is a file opened with direct io flag, in aio_rw_vect_retry,
aio_write is called first time. If the direct io can
not be completed, it will fall back into buffer io, see line 2329 in
aio_write.
2. If the very buffer io is a partial write, then it will return back
to  aio_rw_vect_retry and issue the second aio_write.
>
> That point aside, I have no issues with setting private to NULL in
> init_sync_kiocb.  If you fix up the comment to reflect reality
> w.r.t. the upstream kernel source, I'll ack the patch.
OK, I will fix the comment.
>
> Cheers,
> Jeff

