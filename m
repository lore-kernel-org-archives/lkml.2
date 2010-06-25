Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0FYL6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:58:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42375 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0FYL6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eaLx4xnwQPhS2mIxBIKF8w9pdFCr6AR4oMRrRR/8MtTF6prEVjpIw1pnGLX24XiaDt
         lAJjPByOx6yzZEd5KPPb8e25MbJL38wjDJAJS/EBa3yqILmBIABLoc7vowvL7VgNxYgw
         HOn/37dIsPVQxkJgC9wS854h684Lv/fkZjGfA=
MIME-Version: 1.0
In-Reply-To: <1277458245.32034.96.camel@twins>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	<1277361352.1875.838.camel@laptop>
	<1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
	<1277452110.22715.2116.camel@twins>
	<1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
	<1277458245.32034.96.camel@twins>
Date: Fri, 25 Jun 2010 19:58:49 +0800
Message-ID: <AANLkTimiq2K6v_OhCajiktj6HzqikMZRuc8p4PK6SPjq@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq_work
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 5:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > You can always miss an NMI since it can always happen before the
>> > callback gets done, and allowing another enqueue before the callback is
>> > complete is asking for trouble.
>>
>> If we move entry->next = NULL before entry->func(entry), we will not
>> miss the NMI. Can you show how to miss it in this way?
>
> <NMI>
>  ...
>  irq_work_queue(&my_work, func);
>  ...
> <EOI>
> <IPI>
>  irq_work_run()
>
>  <NMI>
>    irq_work_queue(&my_work, func); <FAIL>
>  <EOI>
>
>   my_func.next = NULL;

entry->func() should follows here. You can collect all information
(maybe some data in a ring buffer) from NMI handler in entry->func().
But if you place entry->NULL after entry->func(), you will really lose
a NMI notification and the information from NMI handler.

> <EOI>

> Really not that hard. Now imagine wrapping irq_work in some state and
> you reusing the state while the function is still running..

So I suggest to use another flag to signify the function is running to
distinguish.

Best Regards,
Huang Ying
