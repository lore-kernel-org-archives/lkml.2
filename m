Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1HJBd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:33:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34893 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1HJBd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <4E41D3FB.9080802@gmail.com>
References: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
	<4E41D3FB.9080802@gmail.com>
Date: Wed, 10 Aug 2011 10:33:28 +0900
Message-ID: <CAME+iuf=mNy=s16y6LFZ7MpFWFg26UxjTF64o6smtC3=WgERkw@mail.gmail.com>
Subject: Re: kernel panic with simple driver
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 9:42 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 10/08/11 10:16, Murali K. Vemuri wrote:
>>
>> Hello there,
>>
>> I have a small driver code with which I am randomly receiving kernel
>> panic. Can someone help me what is the mistake here?
>> The kernel panic is exactly caught to be at "add_timer (&my_timer) ".
>> I am able to get the print "Kicking off the timer" when the panic
>> happens.
>
> It helps to post the panic message. Its hard to debug problems without them.
>
> Where in add_timer is the panic occurring? It's only two lines, and one of
> those is a BUG_ON. Are you hitting that? The other line is a call to
> mod_timer and dereferences the timer pointer. Is the timer_list struct you
> are passing to add_timer sane?
>

Okay, have not been able to reproduce the panic yet after reading your
reply. More so, due to the "random" nature of the panic.
Nevertheless, the last time I observed the panic the LR was at
mod_timer() not on BUG_ON.
I will also add a sanity check for the timer_struct.

>> Also, I could not observe any specific pattern in which the panic
>> occurs. But it is purely random. So far I was able to reproduce the
>> panic thrice out of 100+ attempts.
>
> Do you have any concurrent access to the timer? If so you may be racing on
> the between the test of timer_pending and the call to timer_add. In general,
> I think you should call mod_timer rather than add_timer (see the
> documentation in kernel/timer.c).
>

There is no concurrent access to the timer. The design is that:
1.Driver provides an IOCTL for start / stop
2. when the driver receives START IOCTL, it toggles some GPIOs to ON / OFF.
3. the GPIOs will be ON for 500 MSec and OFF for 500 MSec.
4. Two successive START IOCTLs will not be honored.
5. There is only one application that uses these IOCTLs
6. When I receive a STOP IOCTL, I am doing :
if (timer_pending (&my_timer))
del_timer(&my_timer);

Once I capture the panic dump, I will share that too.

Thanks
Murali

> ~Ryan
>
>> In all other attempts, my_dev_ioctl is called correctly and works
>> correctly.
>>
>> struct timer_list my_timer;
>>
>> static int my_dev_ioctl(struct inode *inode, struct file *file,
>>                 unsigned int cmd, unsigned long arg)
>> {
>>     switch(cmd)
>>     {
>>         case MATCH_CASE:
>>             if (timer_pending (&my_timer))
>>             {
>>                 printk(KERN_ERR "Timer currently pending, not adding
>> any more\n");
>>             }
>>             else
>>             {
>>                 printk(KERN_ERR "Kicking off the timer\n");
>>                 add_timer(&my_timer);
>>             }
>>             break;
>>         default:
>>             break;
>>     }
>>     return 0;
>> }
>>
>> static struct miscdevice my_dummy_dev =
>> {
>>     .minor = MISC_DYNAMIC_MINOR,
>>     .name = "dummy_dev",
>>     .fops =&my_dev_fops,
>> };
>>
>> static int __init my_dev_init(void)
>> {
>>     /*initialize some GPIOs */
>>     init_timer (&my_timer);
>>     my_timer.data = 0;
>>     my_timer.expires = jiffies + msecs_to_jiffies(500);
>>     my_timer.function = ring_led_detect_timer;
>>     misc_register(&mbi5025_dev);
>> }
>> module_init(my_dev_init);
>>
>>
>> Thanks in advance
>> Murali
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
