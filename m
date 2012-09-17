Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2IQLfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:35:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49942 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2IQLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <016401cd94ba$733937d0$59aba770$%jun@samsung.com>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
	<016401cd94ba$733937d0$59aba770$%jun@samsung.com>
Date: Mon, 17 Sep 2012 13:35:18 +0200
Message-ID: <CA+MoWDqR31XWPT+z9tozLpV6_G9yfUHjzReQmQOLvNJNi-pTnQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/mmc/host/dw_mmc.c: fix error return code
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: cjb@laptop.org, will.newton@imgtec.com, jh80.chung@samsung.com,
        kyungmin.park@samsung.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 11:54 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Monday, September 17, 2012, Peter Senna Tschudin <peter.senna@gmail.com> wrote:
>> From: Peter Senna Tschudin <peter.senna@gmail.com>
>>
>> Convert a nonnegative error return code to a negative one, as returned
>> elsewhere in the function.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> (
>> if@p1 (\(ret < 0\|ret != 0\))
>>  { ... return ret; }
>> |
>> ret@p1 = 0
>> )
>> ... when != ret = e1
>>     when != &ret
>> *if(...)
>> {
>>   ... when != ret = e2
>>       when forall
>>  return ret;
>> }
>> // </smpl>
>>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> ---
>>  drivers/mmc/host/dw_mmc.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 36f98c0..7ad5176 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -2039,8 +2039,10 @@ int dw_mci_probe(struct dw_mci *host)
>>       tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
>>       host->card_workqueue = alloc_workqueue("dw-mci-card",
>>                       WQ_MEM_RECLAIM | WQ_NON_REENTRANT, 1);
>> -     if (!host->card_workqueue)
>> +     if (!host->card_workqueue) {
>> +             err = -ENOMEM;
> ret is expected instead of err.
> err isn't defined.

I'm sorry. Somehow I did not compile for testing this one before
sending. I'll fix, test and resend.

>
> Thanks,
> Seungwon Jeon
>
>>               goto err_dmaunmap;
>> +     }
>>       INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>>       ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags, "dw-mci", host);
>>       if (ret)
>> --
>> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
