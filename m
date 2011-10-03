Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1JCJQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:16:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55363 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1JCJPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110927174523.GA12600@electric-eye.fr.zoreil.com>
References: <1316261666-28555-1-git-send-email-kth3321@gmail.com>
	<CAOkfWjcHxh60D9KvxLfgL0tw9XdPyDN9xr7q+9V+nM6B6g8tDA@mail.gmail.com>
	<20110927174523.GA12600@electric-eye.fr.zoreil.com>
Date: Mon, 3 Oct 2011 18:15:54 +0900
Message-ID: <CAOkfWjfujtrFLd8HFLVC_jAQ98o8BkZNg0zGSbceFoTt9Cw6fg@mail.gmail.com>
Subject: Re: [PATCH] w5300: add WIZnet W5300 Ethernet driver
From: Taehun Kim <kth3321@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/28 Francois Romieu <romieu@fr.zoreil.com>:

>> +/* Opening channels of W5300 */
>> +static int
>> +w5300_open(struct wiz_private *wp, u32 type)
>
> Name it w5300_channel_open or more adequately w5300_channel_0_open
> as it is hardwired to channel 0 ?

The W5300 Ethernet function is only available in channel 0. The other channels
(1~7) is used hardwired TCP/IP stack.
I was limited to the Ethernet function in this driver because hardwired TCP/IP
stack to use the TCP/IP stack in linux kernel be modified.

>> +     int s;
>> +
>> +     isr = w5300_read(wp, IR);
>> +
>> +     /* Completing all interrupts at a time. */
>> +     while (isr) {
>> +             w5300_write(wp, IR, isr);
>> +
>> +             /* Finding the channel to create the interrupt */
>> +             s = find_first_bit(&isr, sizeof(u16));
>> +             ssr = w5300_read(wp, Sn_IR(s));
>> +             /* socket interrupt is cleared. */
>> +             w5300_write(wp, Sn_IR(s), ssr);
>> +             DPRINTK("%s: ISR = %X, SSR = %X, s = %X\n",
>> +                     __func__, isr, ssr, s);
>> +             if (likely(!s)) {
>> +                     if (ssr & Sn_IR_RECV) {
>> +                             /* De-activation of interrupt */
>> +                             w5300_interrupt_disable(wp, 0);
>> +                             /* Receiving by polling method */
>> +                             napi_schedule(&wp->napi);
>> +                     }
>> +             }
>> +
>> +             /* Is there any interrupt to be processed? */
>> +             isr = w5300_read(wp, IR);
>> +     }
>> +
>> +     return IRQ_HANDLED;
>
> The hardware implementation is supposed to enforce that the 'while' is
> always entered, right ?
>

If isr is 0, it is to ensure that the W5300 is received an interrupt responses.
You mean that there is a need to the loop exit routine. right?

Thank you for your detailed feedback.

I will rewrite the driver code by applied your feedback. When the work is
completed, I will suggest the rewritten driver code to this thread.

Thank you.

T.K.
