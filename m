Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1HJAmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:42:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58080 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1HJAml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:42:41 -0400
Message-ID: <4E41D3FB.9080802@gmail.com>
Date: Wed, 10 Aug 2011 10:42:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic with simple driver
References: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
In-Reply-To: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 10:16, Murali K. Vemuri wrote:
> Hello there,
>
> I have a small driver code with which I am randomly receiving kernel
> panic. Can someone help me what is the mistake here?
> The kernel panic is exactly caught to be at "add_timer (&my_timer) ".
> I am able to get the print "Kicking off the timer" when the panic
> happens.

It helps to post the panic message. Its hard to debug problems without them.

Where in add_timer is the panic occurring? It's only two lines, and one 
of those is a BUG_ON. Are you hitting that? The other line is a call to 
mod_timer and dereferences the timer pointer. Is the timer_list struct 
you are passing to add_timer sane?

> Also, I could not observe any specific pattern in which the panic
> occurs. But it is purely random. So far I was able to reproduce the
> panic thrice out of 100+ attempts.

Do you have any concurrent access to the timer? If so you may be racing 
on the between the test of timer_pending and the call to timer_add. In 
general, I think you should call mod_timer rather than add_timer (see 
the documentation in kernel/timer.c).

~Ryan

> In all other attempts, my_dev_ioctl is called correctly and works correctly.
>
> struct timer_list my_timer;
>
> static int my_dev_ioctl(struct inode *inode, struct file *file,
>                  unsigned int cmd, unsigned long arg)
> {
>      switch(cmd)
>      {
>          case MATCH_CASE:
>              if (timer_pending (&my_timer))
>              {
>                  printk(KERN_ERR "Timer currently pending, not adding
> any more\n");
>              }
>              else
>              {
>                  printk(KERN_ERR "Kicking off the timer\n");
>                  add_timer(&my_timer);
>              }
>              break;
>          default:
>              break;
>      }
>      return 0;
> }
>
> static struct miscdevice my_dummy_dev =
> {
>      .minor = MISC_DYNAMIC_MINOR,
>      .name = "dummy_dev",
>      .fops =&my_dev_fops,
> };
>
> static int __init my_dev_init(void)
> {
>      /*initialize some GPIOs */
>      init_timer (&my_timer);
>      my_timer.data = 0;
>      my_timer.expires = jiffies + msecs_to_jiffies(500);
>      my_timer.function = ring_led_detect_timer;
>      misc_register(&mbi5025_dev);
> }
> module_init(my_dev_init);
>
>
> Thanks in advance
> Murali
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

