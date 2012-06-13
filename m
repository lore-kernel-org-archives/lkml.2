Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2FMBSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:18:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:4023 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2FMBSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164890362"
Date: Wed, 13 Jun 2012 09:18:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] writeback: fix hung_task alarm when sync block
Message-ID: <20120613011817.GA24315@localhost>
References: <1339548774-4834-1-git-send-email-liwp.linux@gmail.com>
 <20120613005945.GA24091@localhost>
 <20120613011151.GA2181@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613011151.GA2181@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -1311,7 +1312,12 @@ void writeback_inodes_sb_nr(struct super_block *sb,
> >>  
> >>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> >>  	bdi_queue_work(sb->s_bdi, &work);
> >> -	wait_for_completion(&done);
> >> +	hangcheck = sysctl_hung_task_timeout_secs;
> >> +	if (hangcheck)
> >
> >The hangcheck variable looks redundant.
> 
> if sysctl_hung_task_timeout_secs is equal to ZERO, it means infinite
> timeout -- no checking done. So I think wait_for_completion_timeout 
> makes no sense this time.

I mean, you can test sysctl_hung_task_timeout_secs directly?
It's a one shot test anyway.

> >> +		while (!wait_for_completion_timeout(&done, HZ/2))
> >> +			;
> >> +	else
> >> +		wait_for_completion(&done);
> >>  }
> >>  EXPORT_SYMBOL(writeback_inodes_sb_nr);
> >>  
> >> -- 
> >> 1.7.9.5
