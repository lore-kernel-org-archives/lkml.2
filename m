Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1BOBqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:46:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1BOBqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:46:34 -0500
Message-ID: <4D59DAF4.6070508@cn.fujitsu.com>
Date: Tue, 15 Feb 2011 09:46:28 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539804.9090308@cn.fujitsu.com> <20110214181322.GJ13097@redhat.com>
In-Reply-To: <20110214181322.GJ13097@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 09:45:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 09:45:38,
	Serialize complete at 2011-02-15 09:45:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Thu, Feb 10, 2011 at 03:47:16PM +0800, Gui Jianfeng wrote:
> 
> [..]
>> +/*
>> + * The time when a CFQ queue is put onto a service tree is recoreded in
>> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
>> + * on each service tree, and select the workload type that contains the lowest
>> + * reposition_time CFQ queue among them.
>> + */
>>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>>  				struct cfq_group *cfqg, enum wl_prio_t prio)
>>  {
>>  	struct cfq_entity *cfqe;
>> +	struct cfq_queue *cfqq;
>> +	unsigned long lowest_start_time;
>>  	int i;
>> -	bool key_valid = false;
>> -	unsigned long lowest_key = 0;
>> +	bool time_valid = false;
>>  	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>>  
>> +	/*
>> +	 * TODO: We may take io priority and io class into account when
>> +	 * choosing a workload type. But for the time being just make use of
>> +	 * reposition_time only.
>> +	 */
>>  	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
>> -		/* select the one with lowest rb_key */
>>  		cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
>> -		if (cfqe &&
>> -		    (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
>> -			lowest_key = cfqe->rb_key;
>> +		cfqq = cfqq_of_entity(cfqe);
>> +		if (cfqe && (!time_valid ||
>> +			     time_before(cfqq->reposition_time,
>> +					 lowest_start_time))) {
>> +			lowest_start_time = cfqq->reposition_time;
> 
> Gui,
> 
> Have you had a chance to run some mixed workloads in a group (some sync,
> some async and some sync-idle queues), and see how latency and throughput
> of sync-idle workload changes due to this "resposition_time" logic. I 
> just want to make sure that latency of sync-noidle workload does not
> go up as that's the workload that people care and gets noticed first.

Hi Vivek

Will do some tests.

Thanks,
Gui

> 
> Thanks
> Vivek
> 
