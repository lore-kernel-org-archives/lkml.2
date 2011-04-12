Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1DLAOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:14:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57961 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab1DLAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qu5Amcpv1smL3wtroWvJXHvFFEFF46U+Qxc8vLAeLFjpexGJU/k75RzrXVOgjEu5bq
         Csziqafr66YZNjkfaXxqcSPqt44RlYywMZFHvoLoAjBwBKq3AtP3U1XRSMrCvZHZjdtk
         n+E6+HKtHwbu7zSHe7fiOZCI1YrNwY38if/m8=
Date: Tue, 12 Apr 2011 09:14:27 +0900
From: Tejun Heo <tj@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110412001427.GH9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
 <20110411171803.GG9673@mtj.dyndns.org>
 <1302544330.2596.31.camel@dolmen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302544330.2596.31.camel@dolmen>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 11, 2011 at 06:52:10PM +0100, Steven Whitehouse wrote:
> WARNING: at lib/kref.c:34 kref_get+0x2d/0x30()
> Hardware name: PowerEdge R710
> Modules linked in:
> Pid: 12, comm: kworker/2:0 Not tainted 2.6.39-rc2+ #188
> Call Trace:
>  [<ffffffff8108fa9a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8108fae5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff813c97cd>] kref_get+0x2d/0x30
>  [<ffffffff813c81ca>] kobject_get+0x1a/0x30
>  [<ffffffff814607f4>] get_device+0x14/0x20
>  [<ffffffff81478b57>] scsi_request_fn+0x37/0x4a0
>  [<ffffffff813aff2a>] __blk_run_queue+0x6a/0x110
>  [<ffffffff813b1f66>] blk_delay_work+0x26/0x40
>  [<ffffffff810aa9c7>] process_one_work+0x197/0x520
>  [<ffffffff810acfec>] worker_thread+0x15c/0x330
>  [<ffffffff810b1f16>] kthread+0xa6/0xb0
>  [<ffffffff816870e4>] kernel_thread_helper+0x4/0x10
> ---[ end trace 3681e9da2630a94b ]---

Hmm, it could be that the root cause of the problem is
premature/double put of scsi_device.  Without the patch, it makes
scsi_request_fn() call into device destruction path prematurely
triggering deadlock while after the patch, the deadlock is gone but
the ref count reaches zero prematurely triggering kref warning on the
next request.

The problem doesn't seem widespread so something about the setup is
peculiar.  Steven, can you please detail the setup (and steps needed
to trigger the problem) and attach the full boot log?  James, any
ideas?

Thanks.

-- 
tejun
