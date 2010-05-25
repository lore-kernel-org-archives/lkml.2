Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab0EYSPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:15:51 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:32809 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756378Ab0EYSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:15:50 -0400
Message-ID: <4BFC13D1.4020003@example.com>
Date: Tue, 25 May 2010 20:15:45 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 	icedove-bin/5449
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins> <AANLkTimYiuKGPnYjEgf_vh7bGnZz30XS3ioiuDxWtOL7@mail.gmail.com>
In-Reply-To: <AANLkTimYiuKGPnYjEgf_vh7bGnZz30XS3ioiuDxWtOL7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1446499906249978243
X-Ovh-Remote: 83.6.191.44 (abbb44.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.05.2010 20:07, Divyesh Shah wrote:
> On Tue, May 25, 2010 at 1:50 AM, Peter Zijlstra<peterz@infradead.org>  wrote:
>> On Mon, 2010-05-24 at 05:03 +0200, Piotr Hosowicz wrote:
>>> [  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
>>> [  720.313612] caller is native_sched_clock+0x3c/0x68
>>> [  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
>>> [  720.313618] Call Trace:
>>> [  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
>>> [  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
>>> [  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
>>> [  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
>>> [  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
>>> [  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
>>
>> This comes from wreckage in the blk tree..
>>
>> ---
>> commit 9195291e5f05e01d67f9a09c756b8aca8f009089
>> Author: Divyesh Shah<dpshah@google.com>
>> Date:   Thu Apr 1 15:01:41 2010 -0700
>>
>>     blkio: Increment the blkio cgroup stats for real now
>>
>>     We also add start_time_ns and io_start_time_ns fields to struct request
>>     here to record the time when a request is created and when it is
>>     dispatched to device. We use ns uints here as ms and jiffies are
>>     not very useful for non-rotational media.
>>
>>     Signed-off-by: Divyesh Shah<dpshah@google.com>
>>     Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
>> ---
>>
>> +#ifdef CONFIG_BLK_CGROUP
>> +static inline void set_start_time_ns(struct request *req)
>> +{
>> +       req->start_time_ns = sched_clock();
>> +}
>> +
>> +static inline void set_io_start_time_ns(struct request *req)
>> +{
>> +       req->io_start_time_ns = sched_clock();
>> +}
>> +#else
>> +static inline void set_start_time_ns(struct request *req) {}
>> +static inline void set_io_start_time_ns(struct request *req) {}
>> +#endif
>>
>> ---
>>
>> Clearly nobody tested this, and its terribly broken to boot.
>
> @Piotr, do you have kernel pre-emption enabled?

Yes.

Regards,

Piotr Hosowicz

-- 
Janusz Korwin-Mikke:
"Dyktatury dziel± siê na dobre i z³e. Demokracja jest zawsze g³upia."
NP:  -
NB: 2.6.34-20100525-1754-patched
