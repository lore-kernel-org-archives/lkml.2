Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2FLLaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:30:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55310 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2FLL37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:29:59 -0400
Date: Tue, 12 Jun 2012 19:29:49 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] writeback: avoid race when update bandwidth
Message-ID: <20120612112936.GA3026@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1339496803-2885-1-git-send-email-liwp.linux@gmail.com>
 <20120612112129.GA16639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612112129.GA16639@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:21:29PM +0800, Fengguang Wu wrote:
>On Tue, Jun 12, 2012 at 06:26:43PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
>That email address is no longer in use?

No, :), you better use "Wanpeng Li <liwp@linux.vnet.ibm.com>" to commit
my patch. Because next month this email address will be available again,
and this also can help my colleagues to add my patches count this year,
thanks a lot.
>
>> Since bdi->wb.list_lock is used to protect the b_* lists,
>> so the flushers who call wb_writeback to writeback pages will
>> stuck when bandwidth update policy holds this lock. In order
>> to avoid this race we can introduce a new bandwidth_lock who
>> is responsible for protecting bandwidth update policy.
>
>This looks good to me. wb.list_lock could be contended and it's better
>for bdi_update_bandwidth() to use a standalone and hardly contended
>lock.
>
>btw, with this change, the dirty_lock in global_update_bandwidth() can
>be eliminated.

Ok, I will resend the patch.

Regards,
Wanpeng Li
>
>> Signed-off-by: Wanpeng Li <liswp@linux.vnet.ibm.com>
>> ---
>>  mm/page-writeback.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index c8945e0..b3b08fb 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1032,12 +1032,14 @@ static void bdi_update_bandwidth(struct backing_dev_info *bdi,
>>  				 unsigned long bdi_dirty,
>>  				 unsigned long start_time)
>>  {
>> +	static DEFINE_SPINLOCK(bandwidth_lock);
>> +
>>  	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
>>  		return;
>> -	spin_lock(&bdi->wb.list_lock);
>> +	spin_lock(&bandwidth_lock);
>>  	__bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
>>  			       bdi_thresh, bdi_dirty, start_time);
>> -	spin_unlock(&bdi->wb.list_lock);
>> +	spin_unlock(&bandwidth_lock);
>>  }
>>  
>>  /*
>> -- 
>> 1.7.9.5
