Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0HZJfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:35:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52520 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0HZJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:35:07 -0400
Message-ID: <4C7634E7.4010701@mvista.com>
Date: Thu, 26 Aug 2010 13:33:27 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Tejun Heo <teheo@suse.de>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 24.5/30] jbd2: Modify ASYNC_COMMIT code to not rely on
 queue draining on barrier
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <4C762476.2020802@suse.de>
In-Reply-To: <4C762476.2020802@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tejun Heo wrote:

> From 49f4cef00a1bd3c79fb2fe1f982c5157f0792867 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>

> Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
> feature is set. This property is going away so make JBD2 wait for buffers it
> needs on its own before submitting the cache flush.

> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> This patch is necessary before enabling flush/fua support in jbd2.
> The flush-fua git tree has been udpated to included this between patch
> 24 and 25.

> Thanks.

>  fs/jbd2/commit.c |   29 ++++++++++++++++-------------
>  1 files changed, 16 insertions(+), 13 deletions(-)

> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7c068c1..8797fd1 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
[...]
> @@ -845,6 +842,12 @@ wait_for_iobuf:
>  	}
>  	if (!err && !is_journal_aborted(journal))
>  		err = journal_wait_on_commit_record(journal, cbh);
> +	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
> +	    journal->j_flags & JBD2_BARRIER) {
> +			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,

    Overindented line.

> +				BLKDEV_IFL_WAIT);
> +	}
> 
>  	if (err)
>  		jbd2_journal_abort(journal, err);

WBR, Sergei
