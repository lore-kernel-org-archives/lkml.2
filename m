Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1FGJOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:14:43 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:59014 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1FGJOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:14:42 -0400
X-Authority-Analysis: v=1.1 cv=8mDY8c80ZOa76EOwICuS+E2YRQjxDgO9xqUnRMONc7w= c=1 sm=0 a=ibALSIuKlhcA:10 a=YEABEG9IpdAA:10 a=8nJEP1OIZ-IA:10 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=VwQbUJbxAAAA:8 a=wdqbj3hQivP4UFxjk70A:9 a=Hp5mx4Is19fMgi-cawYA:7 a=wPNLvfGTeEIA:10 a=x8gzFH9gYPwA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <4DEDEBFF.10907@cfl.rr.com>
Date: Tue, 07 Jun 2011 05:14:39 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Monica Puig-Pey <puigpeym@unican.es>
CC: markh@compro.net, Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es><4DEA1F22.6000603@unican.es><4DEA255				B.2050503@unican.es><4DECBE44.2070803@unican.es> 			<BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com> 		<4DECC0DF.8070209@unican.es> <4DED051A.6020702@compro.net> <4DEDE411.6010807@unican.es>
In-Reply-To: <4DEDE411.6010807@unican.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 04:40 AM, Monica Puig-Pey wrote:
> El 06/06/11 18:49, Mark Hounschell escribió:
>> On 06/06/2011 07:58 AM, Monica Puig-Pey wrote:
>>> El 06/06/11 13:54, Rolando Martins escribió:
>>>> Hi,
>>>> I use the following:
>>>>
>>>> PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
>>>> print $1; }' | xargs echo)
>>>> for i in $PIDs
>>>> do
>>>> ret=$(chrt -f -p 99 $i)
>>>> done
>>>>
>>>> This will change the kernel thread associated with an irq handler to
>>>> RT FIFO prio 99.
>>>> Just change the script to your specific interrupt.
>>>>
>>>> Hope it helps,
>>>> Rolando
>>>>
>>>> On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey<puigpeym@unican.es>
>>>> wrote:
>>>>> I am writing a driver which has one kernel thread associated with it.
>>>>> I want to change the priority of this thread, so that I can specify the
>>>>> order in which it is scheduled following an interrupt.
>>>>> I'm using:
>>>>>
>>>>> sched_setscheduler(struct task_struct *, int, struct sched_param *);
>>>>>
>>>>> but it doesn't work. I tried to change the priority from the
>>>>> init_module,
>>>>> and also from the Kernel Thread, but there is no way.
>>>>>
>>>>> Kernel version is 2.6.31-11-rt
>>>>>
>>>>> What do I call to change a kernel thread priority?
>>>>>
>>>>> Thanks you very much
>>>>>
>>>>> Mónica
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-rt-users" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>
>>>
>>> I need to change the priority from inside the driver, when creating the
>>> kernel thread.
>>> Your script is useful but it is done in user context,
>>> Any other help please?
>>
>> What I do is record the PID of the thread in the driver, then create an
>> IOCTL for your driver that user land can call that either returns the
>> PID so you can do it in user land, or cause the IOCTL code to do it in
>> the driver.
>>
>> The same can be done with the affinity of the IRQ if you record the IRQ
>> number.
>>
>> Mark
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> But I don't have de PID of my Kthread, I only have the task_struc * that
> gives me the function:
>
> struct task_struct *kthread_create(int (*threadfn)(void *data),
> void *data,
> const char namefmt[], ...)
>
> How could I get the PID, and which function should I use in the IOCTL
> (kernel context) for changing its priority?
>

The PID can be obtained from within the interrupt handler its self via 
current->pid.
Obviously an interrupt has to occur first but after one interrupt you have it.

Actually I had forgot how I handled this. Where I change the RT priority 
and cpu affinity is in what used to be called the Bottom Half and the IOCTL 
referred to above simply tells the BH to do it and with what values.

Regards
Mark



