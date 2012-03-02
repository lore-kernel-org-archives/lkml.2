Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2CBPyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:54:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36826 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab2CBPya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:54:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.129.36 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330702146.2611.1.camel@bwh-desktop>
References: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
	<1330702146.2611.1.camel@bwh-desktop>
Date: Fri, 2 Mar 2012 21:24:29 +0530
Message-ID: <CAOD=uF5ebyA-yd8T8nXd9vYRw1yvFKVQd9TmcBwMnxFs6enKvA@mail.gmail.com>
Subject: Re: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: jitendra.kalsaria@qlogic.com, ron.mercer@qlogic.com,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting following error :

"qla3xxx.c:3231 ql_adapter_initialize() error: calling
'spin_unlock_irqrestore()' with bogus flags"


In "ql_adapter_up"  locking and unlocking  are happening in proper
sequence and the interrupt
state saved in "hw_flags" is restored.

In "ql_adapter_initialize", first unlock is done by
"spin_unlock_irqrestore(&qdev->hw_lock, hw_flags)"
with "hw_flags = 0"   ("hw_flags" is local variable and initialized to
zero.),   which is as good as
spin_unlock_irq.


To avoid the above error and  for better performance
'spin_unlock_irqrestore()' can be replaced
with 'spin_unlock_irq()' and 'spin_lock_irqsave()' can be replaced by
'spin_lock_irq()' in "ql_adapter_initialize()"


regards
santosh

On Fri, Mar 2, 2012 at 8:59 PM, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Fri, 2012-03-02 at 20:39 +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> In 'ql_adapter_initialize'
>> the first call for 'spin_unlock_irqrestore()' is with hw_flags = 0,
>> which is as good as 'spin_unlock_irq()' (unconditional interrupt
>> enabling). If this is intended, then for better performance
>> 'spin_unlock_irqrestore()' can be replaced with 'spin_unlock_irq()'
>> and 'spin_lock_irqsave()' can be replaced by 'spin_lock_irq()
>
> Maybe you should make the same change in ql_adapter_up(), which is the
> caller that acquires this spinlock (and certainly shouldn't be called in
> IRQ context).
>
> Ben.
>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  drivers/net/ethernet/qlogic/qla3xxx.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
>> index d49f6da..8da3e41 100644
>> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
>> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
>> @@ -3017,7 +3017,6 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
>>               (void __iomem *)port_regs;
>>       u32 delay = 10;
>>       int status = 0;
>> -     unsigned long hw_flags = 0;
>>
>>       if (ql_mii_setup(qdev))
>>               return -1;
>> @@ -3228,9 +3227,9 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
>>               value = ql_read_page0_reg(qdev, &port_regs->portStatus);
>>               if (value & PORT_STATUS_IC)
>>                       break;
>> -             spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
>> +             spin_unlock_irq(&qdev->hw_lock);
>>               msleep(500);
>> -             spin_lock_irqsave(&qdev->hw_lock, hw_flags);
>> +             spin_lock_irq(&qdev->hw_lock);
>>       } while (--delay);
>>
>>       if (delay == 0) {
>
> --
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>
