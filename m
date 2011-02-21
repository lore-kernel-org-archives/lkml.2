Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1BUUSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:18:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64740 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1BUUSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:18:11 -0500
Subject: Re: [PATCH] NFS: account direct-io into task io accounting
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20110221191546.5920.96947.stgit@localhost6>
Date: Mon, 21 Feb 2011 12:17:15 -0800
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CE953B49-D775-4A61-942B-4B2F5DE9D7BF@oracle.com>
References: <20110221191546.5920.96947.stgit@localhost6>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
X-Mailer: Apple Mail (2.1082)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D62C87E.00AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 21, 2011, at 11:15 AM, Konstantin Khlebnikov wrote:

> Account complete NFS direct-io reads and writes into Task I/O Accounting.
> 
> NFS have unusual direct-io implementation,
> thus accounting in generic code does not work.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
> fs/nfs/direct.c |    9 +++++++--
> 1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> index 9943a75..bab4185 100644
> --- a/fs/nfs/direct.c
> +++ b/fs/nfs/direct.c
> @@ -45,6 +45,7 @@
> #include <linux/pagemap.h>
> #include <linux/kref.h>
> #include <linux/slab.h>
> +#include <linux/task_io_accounting_ops.h>
> 
> #include <linux/nfs_fs.h>
> #include <linux/nfs_page.h>
> @@ -939,8 +940,10 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
> 		goto out;
> 
> 	retval = nfs_direct_read(iocb, iov, nr_segs, pos);
> -	if (retval > 0)
> +	if (retval > 0) {
> 		iocb->ki_pos = pos + retval;
> +		task_io_account_read(retval);
> +	}
> 
> out:
> 	return retval;
> @@ -1001,8 +1004,10 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
> 
> 	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);
> 
> -	if (retval > 0)
> +	if (retval > 0) {
> 		iocb->ki_pos = pos + retval;
> +		task_io_account_write(retval);
> +	}

The async path always returns -EIOCBQUEUED.  How are those bytes accounted for?

> 
> out:
> 	return retval;

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



