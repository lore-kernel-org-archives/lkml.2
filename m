Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2FIOqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 10:46:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57074 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2FIOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 10:46:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6736"; a="199441764"
Message-ID: <780c1dad11fe08de17a3ff41b22ba3b8.squirrel@www.codeaurora.org>
In-Reply-To: <007c01cd455a$56392050$02ab60f0$%jun@samsung.com>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
    <1338576911-17089-2-git-send-email-merez@codeaurora.org>
    <007c01cd455a$56392050$02ab60f0$%jun@samsung.com>
Date: Sat, 9 Jun 2012 07:46:18 -0700 (PDT)
Subject: RE: [PATCH v2 1/1] mmc: block: Add write packing control
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: "'Maya Erez'" <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
>
> How can we check the effect?
> Do you have any result?
We ran parallel lmdd read and write operations and found out that the
write packing causes the read throughput to drop from 24MB/s to 12MB/s.
The write packing control managed to increase the read throughput back to
the original value.
We also examined "real life" scenarios, such as performing a big push
operation in parallel to launching several applications. We measured the
read latency and found out that with the write packing control the worst
case of the read latency was smaller.

> Please check the several comment below.
>
> Maya Erez <merez@codeaurora.org> wrote:
>> The write packing control will ensure that read requests latency is
>> not increased due to long write packed commands.
>>
>> The trigger for enabling the write packing is managing to pack several
>> write requests. The number of potential packed requests that will
>> trigger
>> the packing can be configured via sysfs by writing the required value
>> to:
>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>> The trigger for disabling the write packing is fetching a read request.
>>
>> ---
>>  Documentation/mmc/mmc-dev-attrs.txt |   17 ++++++
>>  drivers/mmc/card/block.c            |  100
>> ++++++++++++++++++++++++++++++++++-
>>  drivers/mmc/card/queue.c            |    8 +++
>>  drivers/mmc/card/queue.h            |    3 +
>>  include/linux/mmc/host.h            |    1 +
>>  5 files changed, 128 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/mmc/mmc-dev-attrs.txt
>> b/Documentation/mmc/mmc-dev-attrs.txt
>> index 22ae844..08f7312 100644
>> --- a/Documentation/mmc/mmc-dev-attrs.txt
>> +++ b/Documentation/mmc/mmc-dev-attrs.txt
>> @@ -8,6 +8,23 @@ The following attributes are read/write.
>>
>>  	force_ro		Enforce read-only access even if write protect switch is
>> off.
>>
>> +	num_wr_reqs_to_start_packing 	This attribute is used to determine
>> +	the trigger for activating the write packing, in case the write
>> +	packing control feature is enabled.
>> +
>> +	When the MMC manages to reach a point where
>> num_wr_reqs_to_start_packing
>> +	write requests could be packed, it enables the write packing feature.
>> +	This allows us to start the write packing only when it is beneficial
>> +	and has minimum affect on the read latency.
>> +
>> +	The number of potential packed requests that will trigger the packing
>> +	can be configured via sysfs by writing the required value to:
>> +	/sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>> +
>> +	The default value of num_wr_reqs_to_start_packing was determined by
>> +	running parallel lmdd write and lmdd read operations and calculating
>> +	the max number of packed writes requests.
>> +
>>  SD and MMC Device Attributes
>>  ============================
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 2785fd4..ef192fb 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -114,6 +114,7 @@ struct mmc_blk_data {
>>  	struct device_attribute force_ro;
>>  	struct device_attribute power_ro_lock;
>>  	int	area_type;
>> +	struct device_attribute num_wr_reqs_to_start_packing;
>>  };
>>
>>  static DEFINE_MUTEX(open_lock);
>> @@ -281,6 +282,38 @@ out:
>>  	return ret;
>>  }
>>
>> +static ssize_t
>> +num_wr_reqs_to_start_packing_show(struct device *dev,
>> +				  struct device_attribute *attr, char *buf)
>> +{
>> +	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
>> +	int num_wr_reqs_to_start_packing;
>> +	int ret;
>> +
>> +	num_wr_reqs_to_start_packing = md->queue.num_wr_reqs_to_start_packing;
>> +
>> +	ret = snprintf(buf, PAGE_SIZE, "%d\n", num_wr_reqs_to_start_packing);
>> +
>> +	mmc_blk_put(md);
>> +	return ret;
>> +}
>> +
>> +static ssize_t
>> +num_wr_reqs_to_start_packing_store(struct device *dev,
>> +				 struct device_attribute *attr,
>> +				 const char *buf, size_t count)
>> +{
>> +	int value;
>> +	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
>> +
>> +	sscanf(buf, "%d", &value);
>> +	if (value >= 0)
>> +		md->queue.num_wr_reqs_to_start_packing = value;
>> +
>> +	mmc_blk_put(md);
>> +	return count;
>> +}
>> +
>>  static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
>>  {
>>  	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
>> @@ -1313,6 +1346,48 @@ static void mmc_blk_rw_rq_prep(struct
>> mmc_queue_req *mqrq,
>>  	mmc_queue_bounce_pre(mqrq);
>>  }
>>
>> +static void mmc_blk_write_packing_control(struct mmc_queue *mq,
>> +					  struct request *req)
>> +{
>> +	struct mmc_host *host = mq->card->host;
>> +	int data_dir;
>> +
>> +	if (!(host->caps2 & MMC_CAP2_PACKED_WR))
>> +		return;
>> +
>> +	/*
>> +	 * In case the packing control is not supported by the host, it should
>> +	 * not have an effect on the write packing. Therefore we have to
>> enable
>> +	 * the write packing
>> +	 */
>> +	if (!(host->caps2 & MMC_CAP2_PACKED_WR_CONTROL)) {
>> +		mq->wr_packing_enabled = true;
>> +		return;
>> +	}
>> +
>> +	if (!req || (req && (req->cmd_flags & REQ_FLUSH))) {
>> +		if (mq->num_of_potential_packed_wr_reqs >
>> +				mq->num_wr_reqs_to_start_packing)
>> +			mq->wr_packing_enabled = true;
>> +		return;
>> +	}
>> +
>> +	data_dir = rq_data_dir(req);
>> +
>> +	if (data_dir == READ) {
>> +		mq->num_of_potential_packed_wr_reqs = 0;
>> +		mq->wr_packing_enabled = false;
>> +		return;
>> +	} else if (data_dir == WRITE) {
>> +		mq->num_of_potential_packed_wr_reqs++;
>> +	}
>> +
>> +	if (mq->num_of_potential_packed_wr_reqs >
>> +			mq->num_wr_reqs_to_start_packing)
>> +		mq->wr_packing_enabled = true;
> Write Packing is available only if continuing write requests are over
> num_wr_reqs_to_start_packing?
> That means individual request(1...17) will be issued with non-packing.
> Could you explain your policy more?
We try to identify the case where there is parallel read and write
operations. In our experiments we found out that the number of write
requests between read requests in parallel read and write operations
doesn't exceed 17 requests. Therefore, we can assume that fetching more
than 17 write requests without hitting a read request can indicate that
there is no read activity.
You are right that this affects the write throughput a bit but the goal of
this algorithm is to make sure the read throughput and latency are not
decreased due to write. If this is not the desired result, this algorithm
can be disabled.
>> +
>> +}
>> +
>>  static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request
>> *req)
>>  {
>>  	struct request_queue *q = mq->queue;
>> @@ -1332,6 +1407,9 @@ static u8 mmc_blk_prep_packed_list(struct
>> mmc_queue *mq, struct request *req)
>>  			!card->ext_csd.packed_event_en)
>>  		goto no_packed;
>>
>> +	if (!mq->wr_packing_enabled)
>> +		goto no_packed;
> If wr_packing_enabled is set to true, several write requests can be
> packed.
> We don't need to consider read request since packed write?
I'm not sure I understand the question. We check if there was a read
request in the mmc_blk_write_packing_control, and in such a case set
mq->wr_packing_enabled to false.
If I didn't answer the question, please explain it again.

>
> Thanks,
> Seungwon Jeon

Thanks,
Maya Erez
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

