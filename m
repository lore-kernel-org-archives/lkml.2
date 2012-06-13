Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2FMO15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2FMO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:27:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 13 Jun 2012 10:27:50 -0400
In-Reply-To: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com> (Wanpeng
	Li's message of "Wed, 13 Jun 2012 12:42:33 +0800")
Message-ID: <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <liwp.linux@gmail.com> writes:

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index f2d0109..df879ee 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1311,7 +1311,11 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  	bdi_queue_work(sb->s_bdi, &work);
> -	wait_for_completion(&done);
> +	if (sysctl_hung_task_timeout_secs)
> +		while (!wait_for_completion_timeout(&done, HZ/2))
> +			;
> +	else
> +		wait_for_completion(&done);
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr);

Is it really expected that writeback_inodes_sb_nr will routinely queue
up more than 2 seconds worth of I/O (Yes, I understand that it isn't the
only entity issuing I/O)?  For devices that are really slow, it may make
more sense to tune the system so that you don't have too much writeback
I/O submitted at once.  Dropping nr_requests for the given queue should
fix this situation, I would think.

This really feels like we're papering over the problem.

Cheers,
Jeff
