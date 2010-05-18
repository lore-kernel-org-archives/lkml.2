Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0ERWWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:22:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55210 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0ERWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:22:31 -0400
Message-ID: <4BF31322.5090206@us.ibm.com>
Date: Tue, 18 May 2010 15:22:26 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: dvhltc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan-Bernd Themann <themann@de.ibm.com>, niv@linux.vnet.ibm.com,
       Michael Ellerman <ellerman@au1.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>
In-Reply-To: <4BF30C32.1020403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 02:52 PM, Brian King wrote:
> Is IRQF_NODELAY something specific to the RT kernel? I don't see it in mainline...

Yes, it basically says "don't make this handler threaded".

--
Darren

>
> -Brian
>
>
> On 05/18/2010 04:33 PM, dvhltc@linux.vnet.ibm.com wrote:
>> > From ad81664794e33d785f533c5edee37aaba20dd92d Mon Sep 17 00:00:00 2001
>> From: Darren Hart<dvhltc@us.ibm.com>
>> Date: Tue, 18 May 2010 11:07:13 -0700
>> Subject: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
>>
>> The underlying hardware is edge triggered but presented by XICS as level
>> triggered. The edge triggered interrupts are not reissued after masking. This
>> is not a problem in mainline which does not mask the interrupt (relying on the
>> EOI mechanism instead). The threaded interrupts in PREEMPT_RT do mask the
>> interrupt, and can lose interrupts that occurred while masked, resulting in a
>> hung ethernet interface.
>>
>> The receive handler simply calls napi_schedule(), as such, there is no
>> significant additional overhead in making this non-threaded, since we either
>> wakeup the threaded irq handler to call napi_schedule(), or just call
>> napi_schedule() directly to wakeup the softirqs.  As the receive handler is
>> lockless, there is no need to convert any of the ehea spinlock_t's to
>> atomic_spinlock_t's.
>>
>> Without this patch, a simple scp file copy loop would fail quickly (usually
>> seconds). We have over two hours of sustained scp activity with the patch
>> applied.
>>
>> Credit goes to Will Schmidt for lots of instrumentation and tracing which
>> clarified the scenario and to Thomas Gleixner for the incredibly simple
>> solution.
>>
>> Signed-off-by: Darren Hart<dvhltc@us.ibm.com>
>> Acked-by: Will Schmidt<will_schmidt@vnet.ibm.com>
>> Cc: Thomas Gleixner<tglx@linuxtronix.de>
>> Cc: Jan-Bernd Themann<themann@de.ibm.com>
>> Cc: Nivedita Singhvi<niv@us.ibm.com>
>> Cc: Brian King<bjking1@us.ibm.com>
>> Cc: Michael Ellerman<ellerman@au1.ibm.com>
>> Cc: Doug Maxey<doug.maxey@us.ibm.com>
>> ---
>>   drivers/net/ehea/ehea_main.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
>> index 977c3d3..2c53df2 100644
>> --- a/drivers/net/ehea/ehea_main.c
>> +++ b/drivers/net/ehea/ehea_main.c
>> @@ -1263,7 +1263,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
>>   			 "%s-queue%d", dev->name, i);
>>   		ret = ibmebus_request_irq(pr->eq->attr.ist1,
>>   					  ehea_recv_irq_handler,
>> -					  IRQF_DISABLED, pr->int_send_name,
>> +					  IRQF_DISABLED | IRQF_NODELAY, pr->int_send_name,
>>   					  pr);
>>   		if (ret) {
>>   			ehea_error("failed registering irq for ehea_queue "
>
>


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
