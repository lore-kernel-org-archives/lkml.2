Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0IFJEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:04:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56026 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0IFJD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:03:58 -0400
Message-ID: <018601cb4da2$6d903880$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com> <20100829184904.GC26209@core.coreip.homeip.net> <017e01cb4b53$45925da0$LocalHost@wipblrx0099946> <20100903163438.GB2200@core.coreip.homeip.net>
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Date: Mon, 6 Sep 2010 14:33:51 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
x-mimeole: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> Hi Hemanth,
> 
> On Fri, Sep 03, 2010 at 04:02:11PM +0530, Hemanth V wrote:
>> >
>> >
>> >Do not like repeated release of resources in main and error path... Can
>> >we do it like:
>> >
>> >...
>> >disable_irq();
>> >error = cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
>> >if (!error) {
>> >/* Settling time delay required after mode change */
>> >msleep(CMA3000_SETDELAY);
>> >}
>> >enable_irq();
>> >out:
>> >mutex_unlock();
>> >return error ? error : count;
>> 
>> I am thinking I can just add the below statement, and should be able to
>> remove repeated release.
>> 
>> return error ? error : count;
>> 
> 
> That would make us sleep for CMA3000_SETDELAY even in case of failure...
> ... But that should be OK.

I suppose it should not sleep if its the modified code segment as below

        error = CMA3000_SET(data, CMA3000_CTRL, ctrl, "ctrl");
        if (error < 0)
                goto err_op3_failed;

        /* Settling time delay required after mode change */
        msleep(CMA3000_SETDELAY);

err_op3_failed:
        enable_irq(data->client->irq);
err_op2_failed:
        mutex_unlock(&data->mutex);
err_op1_failed:
        return (error ? error : count);


> 
>> >>+
>> >>+ if (data->client->irq) {
>> >>+ ret = request_threaded_irq(data->client->irq, NULL,
>> >>+ cma3000_thread_irq,
>> >>+ irqflags | IRQF_ONESHOT,
>> >>+ data->client->name, data);
>> >>+
>> >>+ if (ret < 0) {
>> >>+ dev_err(&data->client->dev,
>> >>+ "request_threaded_irq failed\n");
>> >>+ goto err_op1_failed;
>> >>+ }
>> >>+ }
>> >
>> >What is the utility of the driver when there is no IRQ line?
>> 
>> Not sure I fully understand your comments.
>> Currently probe would return a failure.
>> 
> 
> You have a check for data->client->irq != 0 and finish probe() with
> success in case it is 0. The question is what is the use of the
> device/driver combo in case when data->client->irq == 0?

Yes agreed, will add a error scenario when data->client->irq == 0


