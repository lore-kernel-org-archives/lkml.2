Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2CCJb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 04:31:29 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55063 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2CCJb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 04:31:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.129.36 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120302.161332.2236794166581618113.davem@davemloft.net>
References: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
	<1330702146.2611.1.camel@bwh-desktop>
	<CAOD=uF5ebyA-yd8T8nXd9vYRw1yvFKVQd9TmcBwMnxFs6enKvA@mail.gmail.com>
	<20120302.161332.2236794166581618113.davem@davemloft.net>
Date: Sat, 3 Mar 2012 15:01:25 +0530
Message-ID: <CAOD=uF54P9iZF=gtk6W=53T+857udZbbH_zVfOrDHBUCo=Fh9Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, jitendra.kalsaria@qlogic.com,
        ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 2:43 AM, David Miller <davem@davemloft.net> wrote:
> From: santosh prasad nayak <santoshprasadnayak@gmail.com>
> Date: Fri, 2 Mar 2012 21:24:29 +0530
>
>> In "ql_adapter_initialize", first unlock is done by
>> "spin_unlock_irqrestore(&qdev->hw_lock, hw_flags)"
>> with "hw_flags = 0"   ("hw_flags" is local variable and initialized to
>> zero.),   which is as good as
>> spin_unlock_irq.
>
> You must never pass to irqrestore anything other than a hw_flags
> value given by irqsave or similar.

David,

Thats what my point is.

The function call is as follow:

ql_adapter_up()
{
         .....
   spin_lock_irqsave(&qdev->hw_lock, hw_flags);
            .....
    err = ql_adapter_initialize(qdev);
             .....
   spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
            ......
}

ql_adapter_initialize()
{
    unsigned long hw_flags = 0;   // D
        .......
   spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);  // A
   msleep(500);                                                         // B
   spin_lock_irqsave(&qdev->hw_lock, hw_flags);        // C
        .....
}

In ql_adapter_initialize, at A,
'spin_unlock_irqrestore'  is called with "hw_flags = 0",
which is as good as spin_unlock_irq().

Static analyzer is showing it as "Error : bogus hw_flags",
which is true. Because "hw_flags" is initialized to zero at D
and the same  "hw_flags" is used to restore IRQ at A.

If intention of the developer is to unlock and enable IRQ
at A then we can use "spin_unlock_irq()"  which will
remove the static analyzer error and also give better
performance.


Regards
Santosh



> You may not assume anything about what values hw_flags takes on nor
> what those values might mean, they are architecture specific so
> you may not just set it to zero and assume that does anything in
> particular.
