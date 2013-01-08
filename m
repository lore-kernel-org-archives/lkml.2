Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3AHHgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:36:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:18072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3AHHgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:36:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,428,1355126400"; 
   d="scan'208";a="188754630"
Message-ID: <50EBCC93.5000203@intel.com>
Date: Tue, 08 Jan 2013 15:36:51 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 3/4] block: implement runtime pm strategy
References: <Pine.LNX.4.44L0.1301071219540.1658-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301071219540.1658-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 01:21 AM, Alan Stern wrote:
> On Sun, 6 Jan 2013, Aaron Lu wrote:
> 
>> From: Lin Ming <ming.m.lin@intel.com>
>>
>> When a request is added:
>>     If device is suspended or is suspending and the request is not a
>>     PM request, resume the device.
>>
>> When the last request finishes:
>>     Call pm_runtime_mark_last_busy() and pm_runtime_autosuspend().
>>
>> When pick a request:
>>     If device is resuming/suspending, then only PM request is allowed to go.
>>     Return NULL for other cases.
>>
>> [aaron.lu@intel.com: PM request does not involve nr_pending counting]
>> [aaron.lu@intel.com: No need to check q->dev]
>> [aaron.lu@intel.com: Autosuspend when the last request finished]
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -974,6 +974,40 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
>>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
>>  extern void blk_pre_runtime_resume(struct request_queue *q);
>>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
>> +
>> +static inline void blk_pm_put_request(struct request *rq)
>> +{
>> +	if (!(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending) {
>> +		pm_runtime_mark_last_busy(rq->q->dev);
>> +		pm_runtime_autosuspend(rq->q->dev);
>> +	}
>> +}
>> +
>> +static inline struct request *blk_pm_peek_request(
>> +	struct request_queue *q, struct request *rq)
>> +{
>> +	if (q->rpm_status == RPM_SUSPENDED ||
>> +		  (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
>> +		return NULL;
>> +	else
>> +		return rq;
>> +}
>> +
>> +static inline void blk_pm_requeue_request(struct request *rq)
>> +{
>> +	if (!(rq->cmd_flags & REQ_PM))
>> +		rq->q->nr_pending--;
>> +}
>> +
>> +static inline void blk_pm_add_request(struct request_queue *q,
>> +	struct request *rq)
>> +{
>> +	if (!(rq->cmd_flags & REQ_PM) &&
>> +	    q->nr_pending++ == 0 &&
>> +	    (q->rpm_status == RPM_SUSPENDED ||
>> +	     q->rpm_status == RPM_SUSPENDING))
>> +		pm_request_resume(q->dev);
>> +}
> 
> These routines also don't belong in include/linux.  And they don't need 
> to be marked inline.

OK, will move them.

What about create a new file blk-pm.c for all these block pm related
code?

Thanks,
Aaron

