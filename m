Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2FMBac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:30:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2FMBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:30:31 -0400
Date: Wed, 13 Jun 2012 09:30:19 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] writeback: fix hung_task alarm when sync block
Message-ID: <20120613013018.GA5432@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1339548774-4834-1-git-send-email-liwp.linux@gmail.com>
 <20120613005945.GA24091@localhost>
 <20120613011151.GA2181@kernel>
 <20120613011817.GA24315@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613011817.GA24315@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:18:17AM +0800, Fengguang Wu wrote:
>> >> @@ -1311,7 +1312,12 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>> >>  
>> >>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>> >>  	bdi_queue_work(sb->s_bdi, &work);
>> >> -	wait_for_completion(&done);
>> >> +	hangcheck = sysctl_hung_task_timeout_secs;
>> >> +	if (hangcheck)
>> >
>> >The hangcheck variable looks redundant.
>> 
>> if sysctl_hung_task_timeout_secs is equal to ZERO, it means 
>> timeout -- no checking done. So I think wait_for_completion_timeout 
>> makes no sense this time.
>
>I mean, you can test sysctl_hung_task_timeout_secs directly?
>It's a one shot test anyway.

/*
 * Zero means infinite timeout - no checking done:
 */
unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;

The comment in kernel/hung_task.c says "Zero means infinite timeout - no
cheking done". Maybe I can just test if this time alarm doesn't flood my
logs. Do you have more suggestion. :-)

Regards,
Wanpeng Li

>
>> >> +		while (!wait_for_completion_timeout(&done, HZ/2))
>> >> +			;
>> >> +	else
>> >> +		wait_for_completion(&done);
>> >>  }
>> >>  EXPORT_SYMBOL(writeback_inodes_sb_nr);
>> >>  
>> >> -- 
>> >> 1.7.9.5
