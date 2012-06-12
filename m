Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2FLTGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:06:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17676 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2FLTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:06:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6740"; a="197996689"
Message-ID: <f397ea300740767478beda757d5e48a9.squirrel@www.codeaurora.org>
Date: Tue, 12 Jun 2012 12:05:51 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
From: merez@codeaurora.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: merez@codeaurora.org, "Seungwon Jeon" <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jun 12, 2012 at 1:40 AM,  <merez@codeaurora.org> wrote:
>>> On Mon, Jun 11, 2012 at 7:25 PM,  <merez@codeaurora.org> wrote:
>>>>> Maya Erez <merez@codeaurora.org> wrote:
>>>>>> > Hi,
>>>>>> >
>>>>>> > How can we check the effect?
>>>>>> > Do you have any result?
>>>>>> We ran parallel lmdd read and write operations and found out that
the
>>>>>> write packing causes the read throughput to drop from 24MB/s to
12MB/s.
>>>>>> The write packing control managed to increase the read throughput
back
>>>>>> to
>>>>>> the original value.
>>>>>> We also examined "real life" scenarios, such as performing a big
push
>>>>>> operation in parallel to launching several applications. We
measured
>>>>>> the
>>>>>> read latency and found out that with the write packing control the
worst
>>>>>> case of the read latency was smaller.
>>>>>> > Please check the several comment below.
>>>>>> >
>>>>>> > Maya Erez <merez@codeaurora.org> wrote:
>>>>>> >> The write packing control will ensure that read requests latency
>>>>>> is
>>>>>> >> not increased due to long write packed commands.
>>>>>> >>
>>>>>> >> The trigger for enabling the write packing is managing to pack
>>>>>> several
>>>>>> >> write requests. The number of potential packed requests that
will
>>>>>> >> trigger
>>>>>> >> the packing can be configured via sysfs by writing the required
>>>>>> value
>>>>>> >> to:
>>>>>> >> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing. The
trigger for disabling the write packing is fetching a read
>>>>>> request.
>>>>>> >>
>>>>>> >> ---
>>>>>> >>  Documentation/mmc/mmc-dev-attrs.txt |   17 ++++++
>>>>>> >>  drivers/mmc/card/block.c            |  100
>>>>>> >> ++++++++++++++++++++++++++++++++++-
>>>>>> >>  drivers/mmc/card/queue.c            |    8 +++
>>>>>> >>  drivers/mmc/card/queue.h            |    3 +
>>>>>> >>  include/linux/mmc/host.h            |    1 +
>>>>>> >>  5 files changed, 128 insertions(+), 1 deletions(-)
>>>>>> >>
>>>>>> >> diff --git a/Documentation/mmc/mmc-dev-attrs.txt
>>>>>> >> b/Documentation/mmc/mmc-dev-attrs.txt
>>>>>> >> index 22ae844..08f7312 100644
>>>>>> >> --- a/Documentation/mmc/mmc-dev-attrs.txt
>>>>>> >> +++ b/Documentation/mmc/mmc-dev-attrs.txt
>>>>>> >> @@ -8,6 +8,23 @@ The following attributes are read/write.
>>>>>> >>
>>>>>> >>   force_ro                Enforce read-only access even if write
>>>>>> protect switch is
>>>>>> >> off.
>>>>>> >>
>>>>>> >> + num_wr_reqs_to_start_packing    This attribute is used to
>>>>>> determine
>>>>>> >> + the trigger for activating the write packing, in case the
write
>>>>>> >> + packing control feature is enabled.
>>>>>> >> +
>>>>>> >> + When the MMC manages to reach a point where
>>>>>> >> num_wr_reqs_to_start_packing
>>>>>> >> + write requests could be packed, it enables the write packing
>>>>>> feature.
>>>>>> >> + This allows us to start the write packing only when it is
>>>>>> beneficial
>>>>>> >> + and has minimum affect on the read latency.
>>>>>> >> +
>>>>>> >> + The number of potential packed requests that will trigger the
>>>>>> packing
>>>>>> >> + can be configured via sysfs by writing the required value to:
+ /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing. +
>>>>>> >> + The default value of num_wr_reqs_to_start_packing was
>>>>>> determined
>>>>>> by
>>>>>> >> + running parallel lmdd write and lmdd read operations and
>>>>>> calculating
>>>>>> >> + the max number of packed writes requests.
>>>>>> >> +
>>>>>> >>  SD and MMC Device Attributes
>>>>>> >>  ============================
>>>>>> >>
>>>>>> >> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 2785fd4..ef192fb 100644
>>>>>> >> --- a/drivers/mmc/card/block.c
>>>>>> >> +++ b/drivers/mmc/card/block.c
>>>>>> >> @@ -114,6 +114,7 @@ struct mmc_blk_data {
>>>>>> >>   struct device_attribute force_ro;
>>>>>> >>   struct device_attribute power_ro_lock;
>>>>>> >>   int     area_type;
>>>>>> >> + struct device_attribute num_wr_reqs_to_start_packing;
>>>>>> >>  };
>>>>>> >>
>>>>>> >>  static DEFINE_MUTEX(open_lock);
>>>>>> >> @@ -281,6 +282,38 @@ out:
>>>>>> >>   return ret;
>>>>>> >>  }
>>>>>> >>
>>>>>> >> +static ssize_t
>>>>>> >> +num_wr_reqs_to_start_packing_show(struct device *dev,
>>>>>> >> +                           struct device_attribute *attr, char
>>>>>> *buf)
>>>>>> >> +{
>>>>>> >> + struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev)); + int
num_wr_reqs_to_start_packing;
>>>>>> >> + int ret;
>>>>>> >> +
>>>>>> >> + num_wr_reqs_to_start_packing =
>>>>>> md->queue.num_wr_reqs_to_start_packing;
>>>>>> >> +
>>>>>> >> + ret = snprintf(buf, PAGE_SIZE, "%d\n",
>>>>>> num_wr_reqs_to_start_packing);
>>>>>> >> +
>>>>>> >> + mmc_blk_put(md);
>>>>>> >> + return ret;
>>>>>> >> +}
>>>>>> >> +
>>>>>> >> +static ssize_t
>>>>>> >> +num_wr_reqs_to_start_packing_store(struct device *dev,
>>>>>> >> +                          struct device_attribute *attr, +    
                     const char *buf, size_t count) +{
>>>>>> >> + int value;
>>>>>> >> + struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev)); + +
sscanf(buf, "%d", &value);
>>>>>> >> + if (value >= 0)
>>>>>> >> +         md->queue.num_wr_reqs_to_start_packing = value; + +
mmc_blk_put(md);
>>>>>> >> + return count;
>>>>>> >> +}
>>>>>> >> +
>>>>>> >>  static int mmc_blk_open(struct block_device *bdev, fmode_t
mode)
>>>>>> >>  {
>>>>>> >>   struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
>>>>>> >> @@ -1313,6 +1346,48 @@ static void mmc_blk_rw_rq_prep(struct
mmc_queue_req *mqrq,
>>>>>> >>   mmc_queue_bounce_pre(mqrq);
>>>>>> >>  }
>>>>>> >>
>>>>>> >> +static void mmc_blk_write_packing_control(struct mmc_queue *mq,
+                                   struct request *req) +{
>>>>>> >> + struct mmc_host *host = mq->card->host;
>>>>>> >> + int data_dir;
>>>>>> >> +
>>>>>> >> + if (!(host->caps2 & MMC_CAP2_PACKED_WR))
>>>>>> >> +         return;
>>>>>> >> +
>>>>>> >> + /*
>>>>>> >> +  * In case the packing control is not supported by the host,
it
>>>>>> should
>>>>>> >> +  * not have an effect on the write packing. Therefore we have
>>>>>> to
>>>>>> >> enable
>>>>>> >> +  * the write packing
>>>>>> >> +  */
>>>>>> >> + if (!(host->caps2 & MMC_CAP2_PACKED_WR_CONTROL)) {
>>>>>> >> +         mq->wr_packing_enabled = true;
>>>>>> >> +         return;
>>>>>> >> + }
>>>>>> >> +
>>>>>> >> + if (!req || (req && (req->cmd_flags & REQ_FLUSH))) {
>>>>>> >> +         if (mq->num_of_potential_packed_wr_reqs >
>>>>>> >> +                         mq->num_wr_reqs_to_start_packing) +  
              mq->wr_packing_enabled = true;
>>>>>> >> +         return;
>>>>>> >> + }
>>>>>> >> +
>>>>>> >> + data_dir = rq_data_dir(req);
>>>>>> >> +
>>>>>> >> + if (data_dir == READ) {
>>>>>> >> +         mq->num_of_potential_packed_wr_reqs = 0;
>>>>>> >> +         mq->wr_packing_enabled = false;
>>>>>> >> +         return;
>>>>>> >> + } else if (data_dir == WRITE) {
>>>>>> >> +         mq->num_of_potential_packed_wr_reqs++;
>>>>>> >> + }
>>>>>> >> +
>>>>>> >> + if (mq->num_of_potential_packed_wr_reqs >
>>>>>> >> +                 mq->num_wr_reqs_to_start_packing)
>>>>>> >> +         mq->wr_packing_enabled = true;
>>>>>> > Write Packing is available only if continuing write requests are
>>>>>> over
>>>>>> > num_wr_reqs_to_start_packing?
>>>>>> > That means individual request(1...17) will be issued with
>>>>>> non-packing.
>>>>>> > Could you explain your policy more?
>>>>>> We try to identify the case where there is parallel read and write
operations. In our experiments we found out that the number of
write
>>>>>> requests between read requests in parallel read and write
operations
>>>>>> doesn't exceed 17 requests. Therefore, we can assume that fetching
more
>>>>>> than 17 write requests without hitting a read request can indicate
that
>>>>>> there is no read activity.
>>>>> We can apply this experiment regardless I/O scheduler?
>>>>> Which I/O scheduler was used with this experiment?
>>>> The experiment was performed with the CFQ scheduler. Since the
deadline
>>>> uses a batch of 16 requests it should also fit the deadline
scheduler.
>>>> In case another value is required, this value can be changed via
sysfs.
>>>>>> You are right that this affects the write throughput a bit but the
goal
>>>>>> of
>>>>>> this algorithm is to make sure the read throughput and latency are
not
>>>>>> decreased due to write. If this is not the desired result, this
algorithm
>>>>>> can be disabled.
>>>>>> >> +
>>>>>> >> +}
>>>>>> >> +
>>>>>> >>  static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct
>>>>>> request
>>>>>> >> *req)
>>>>>> >>  {
>>>>>> >>   struct request_queue *q = mq->queue;
>>>>>> >> @@ -1332,6 +1407,9 @@ static u8 mmc_blk_prep_packed_list(struct
mmc_queue *mq, struct request *req)
>>>>>> >>                   !card->ext_csd.packed_event_en)
>>>>>> >>           goto no_packed;
>>>>>> >>
>>>>>> >> + if (!mq->wr_packing_enabled)
>>>>>> >> +         goto no_packed;
>>>>>> > If wr_packing_enabled is set to true, several write requests can
>>>>>> be
>>>>>> > packed.
>>>>>> > We don't need to consider read request since packed write?
>>>>>> I'm not sure I understand the question. We check if there was a
read
>>>>>> request in the mmc_blk_write_packing_control, and in such a case
set
>>>>>> mq->wr_packing_enabled to false.
>>>>>> If I didn't answer the question, please explain it again.
>>>>> Packed write can be possible after exceeding 17 requests.
>>>>> Is it assured that read request doesn't follow immediately after
packed
>>>>> write?
>>>>> I wonder this case.
>>>> Currently in such a case we will send the packed command followed by
the
>>>> read request. The latency of this read request will be high due to
waiting
>>>> for the completion of the packed write. However, since we will
disable
>>>> the
>>>> write packing, the latency of the following read requests will be
low.
>>>> We are working on a solution where the read request will bypass the
write
>>>> requests in such a case. This change requires modification of the
scheduler in order to re-insert the write requests to the scheduler.
>>> Thats the precise reason for using foreground HPI (shameless plug :-))
I understand the intent of write packing control, but using the number of
requests
>>> as a metric is too coarse. Some writes could be for only one sector
(512B) and others
>>> could be in 512KB or more, giving a 1000x variance.
>>> Foreground HPI solves this problem by interrupting only on a wait
threshold.
>>> Another aspect is that if a packed write is in progress, and you have
a read request,
>>> you will most likely disable packing for the _next_ write, not the
ongoing one, right ?
>>> That's too late an intervention IMHO.
>> If a write request is in progress and a read is fetched we pln to use
HPI
>> to stop it and re-insert the remider of the write packed command back
to
>> the scheduler for a later dispatch.
> IIUC, there were 2 reasons mentioned by you for introducing write
packing control -
> 1) Read bandwidth drop
> 2) Use case "latency" or if I were to guess, "sluggish UI".
>
> So if (2) is solved by HPI, we can investigate the reason for (1) and
fix that, rather
> than adding another functionality (which belongs in the I/O scheduler
anyway) to MMC.
According to our measurements the stop transmission (CMD12) + HPI is a
heavy operation that takes several miliseconds. Intensive usage of HPI
will cause degradation of the performance.
When there is a packed write followed by a read request, we will stop the
packed write and issue the read request. Disabling the write packing due
to this read request (by the packing control function) will eliminate the
need for additional HPI operation to stop the next packed write request,
in case of a flow of read requests. When the read requests flow will end,
the write packing will be enabled again when there will be a flow of write
requests.

Regarding the degradation of the read throughput in case of mix read/write
operations:
Our test showed that there is a degradation of ~40% in the read throughput
in mix read/write operations even without packing. Enabling the write
packing increases this degradation to ~60%. Those numbers are applicable
to CFQ scheduler while the deadline scheduler resulted in even lower read
throughput in mix operations.
While investigating this degradation we found out that the main cause for
it is the way the application issues the read requests and the policy of
the scheduler.
Therefore, the write packing control is only one piece of the complete
solution that we are working on. The complete solution will be released in
a later phase and will include:
- Usage of stop transmission in order to stop a packed write in case of a
read request
- Issue a read request that is fetched at the end of a packed list
preparation before the packed write
- The ability to re-insert the write requests back to the scheduler in
case of the above cases (re-queuing them back to the dispatch queue will
not give a real solution in case of a flow of read requests).
- Modify the scheduler to ensure preferring of reads over writes in mix
read/write scenarios

I hope this makes things a bit clearer. Let me know if you have additional
questions.
>
>> Regarding the packing control trigger, we also tried using a trigger of
an
>> amount of write bytes between read. However, the number of potential
packed requests seemed like the reasonable trigger since we would like to
>> activate the packing only when it will be beneficial, regardless of the
write requests sizes.
> Why ? How do you know "when it will be beneficial" ? As I mentioned, the
number of
> blocks per request would vary over time, and also depends on the
filesystem. OTOH, even small
> writes could take a lot longer than usual (>500ms) due to garbage
collection etc.
>
Based on our experiments the write packing is mostly beneficial in long
sequential write scenarios. Therefore, we would still like the write
packing to be enabled in such cases (as long as there are no parallel
reads). The trigger of number of potential packed requests ensures that
the packing will be enabled in case of a flow of write.

Can you please explain why you refer to the number of blocks per request
when the write packing solution doesn't take into account the request
size?

Thanks,
Maya Erez

--
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





