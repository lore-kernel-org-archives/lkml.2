Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab1KRPaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:30:24 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35163 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757808Ab1KRPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:30:22 -0500
Message-ID: <4EC67A05.6000107@ti.com>
Date: Fri, 18 Nov 2011 21:00:13 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: oskar.andero@sonyericsson.com
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v3] input: add driver support for Sharp gp2ap002a00f proximity
 sensor
References: <1321349160-2931-1-git-send-email-oskar.andero@sonyericsson.com> <20111115094342.GD13157@core.coreip.homeip.net> <20111115125352.GA23767@caracas.corpusers.net> <20111115182909.GB6410@core.coreip.homeip.net> <20111116103705.GA14696@caracas.corpusers.net> <4EC39E7B.7020706@ti.com> <20111116121803.GB14696@caracas.corpusers.net> <20111117112219.GA14781@caracas.corpusers.net> <20111117214343.GB31479@core.coreip.homeip.net> <20111118094429.GA29713@caracas.corpusers.net>
In-Reply-To: <20111118094429.GA29713@caracas.corpusers.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 November 2011 03:14 PM, oskar.andero@sonyericsson.com wrote:
> On 22:43 Thu 17 Nov     , Dmitry Torokhov wrote:
>> On Thu, Nov 17, 2011 at 12:22:19PM +0100, oskar.andero@sonyericsson.com wrote:
>>> Hi Dmitry,
>>>
>>> On 13:18 Wed 16 Nov     , Oskar Andero wrote:
>>>> On 12:28 Wed 16 Nov     , Shubhrajyoti wrote:
>>>>> On Wednesday 16 November 2011 04:07 PM, oskar.andero@sonyericsson.com
>>>>> wrote:
>>>>>> On 19:29 Tue 15 Nov     , Dmitry Torokhov wrote:
>>>>>>> On Tue, Nov 15, 2011 at 01:53:52PM +0100, oskar.andero@sonyericsson.com wrote:
>>>>>>>> On 10:43 Tue 15 Nov     , Dmitry Torokhov wrote:
>>>>>>>>> On Tue, Nov 15, 2011 at 10:26:00AM +0100, oskar.andero@sonyericsson.com wrote:
>>>>>>>>>> From: Courtney Cavin <courtney.cavin@sonyericsson.com>
>>>>>>>>>> +
>>>>>>>>>> +#ifdef CONFIG_PM_SLEEP
>>>>>>>>>> +static int gp2a_suspend(struct device *dev)
>>>>>>>>>> +{
>>>>>>>>>> +	struct i2c_client *client = to_i2c_client(dev);
>>>>>>>>>> +	struct gp2a_data *dt = i2c_get_clientdata(client);
>>>>>>>>>> +	int error;
>>>>>>>>>> +
>>>>>>>>>> +	mutex_lock(&dt->device->mutex);
>>>>>>>>>> +
>>>>>>>>>> +	if (dt->device->users) {
>>>>>>>>>> +		if (device_may_wakeup(&client->dev)) {
>>>>>>>>>> +			enable_irq_wake(client->irq);
>>>>>>>>> I think this part should happen regardless of whether device has users,
>>>>>>>>> only non wakeup source case needs it.
>>>>>>>> Hmm.. why would one want to enable irq_wake when there are no users?
>>>>>>>> Wouldn't this cause the device to wakeup at every irq and report an
>>>>>>>> switch event that no one listens to?
>>>>>>> You are suspending the system and want to have this device as a wakeup
>>>>>>> source. Note: not wake up _device_ at every IRQ but wake up the whole
>>>>>>> _system_ when device generates an IRQ while system is asleep.
>>>>>>> It does not matter whether there are users for the events; you
>>>>>>> want the system to wake up.
>>>>>>>
>>>>>>> At least this is the usual semantics.
>>>>>> I see you point. However, the way we use the proximity sensor we can only wake up
>>>>>> the system when we have an application that is actually interested in the change.
>>>>>> This is for power save reasons.
>>>>>> If we use the "usual semantic", we would wake up the system at every proximity
>>>>>> detection regardlessly. For instance, I wouldn't want to wake up a cell phone laying
>>>>>> on the desk when I put my hand over it. That would hurt the battery time.
>>>>> Even in that case it shouldn't harm the power if no user is there the
>>>>> close would have been called
>>>>> and you should  be in the shut down mode? Am I missing something?
>>>> You are right - the chip will only generate interrupts when it's opened, so the case
>>>> I described shouldn't actually be a problem. However, does it make sense to enable irq_wake
>>>> for a device that will never generate interrupts?
>>> Do you have any input on my question above? My suggestion is to keep the code as it is,
>>> unless you see a reason for enabling wake_irq on an irq that will never happen.
>> So let me get it straight - with your particular device (as in phone)
>> you do not expect the sensor to be used as a wakeup source for the
>> system. If this is correct then it does not really matter what suspend
>> and resume callbacks are doing. Other devices using the same sensor
>> might have different requirements, including being a wakeup source for
>> the system.
> We use the sensor for wakeup source only if some application is listening
> for proximity events, i.e. has the sensor open at suspend.
>
> You are right - for me it doesn't really matter if we call enable_irq_wake()
> regardless of dt->device->users with the current implementation, but I don't
> see the reason for doing that when an irq will never occur in suspend.
I dont think it is true for drivers that need wakeup and are listening
and a
user initiated suspend happens.
> To have the chip wakeup the system without any users means we need to enable
> the chip in gp2a_suspend() I guess, which seems a bit strange, right?
> E.g. (in pseudo code):
>
> static int gp2a_suspend(struct device *dev)
> {
> 	if (device_may_wakeup(&client->dev)) {
> 		gp2a_enable(dt);
> 		enable_irq_wake(client->irq);
> 	} else if (dt->device->users) {
> 		gp2a_disable(dt);
> 	}
> }
>
> -Oskar

