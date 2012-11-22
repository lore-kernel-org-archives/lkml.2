Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2KVTAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:00:12 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45018 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab2KVTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:00:06 -0500
Message-ID: <50ADC7B5.7010206@ilyx.ru>
Date: Thu, 22 Nov 2012 10:35:33 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: andrew mcgregor <andrew.mcgregor@alliedtelesis.co.nz>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
References: <50AD43DB.4030800@ilyx.ru> <20121121213037.154306da@pyramind.ukuu.org.uk> <50AD4A01.7060500@ilyx.ru> <50AE2CE30200003600026B9A@gwia.alliedtelesyn.co.nz> <50ADAA26.7080103@ilyx.ru> <50AE6E050200003600026BD7@gwia.alliedtelesyn.co.nz>
In-Reply-To: <50AE6E050200003600026BD7@gwia.alliedtelesyn.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.11.2012 9:25, andrew mcgregor wrote:
>
>
>>>> On 11/22/2012 at 05:29 PM, in message <50ADAA26.7080103@ilyx.ru>, Ilya Zykov
> <ilya@ilyx.ru> wrote:
>> On 22.11.2012 4:47, andrew mcgregor wrote:
>>>
>>>
>>>>>> On 11/22/2012 at 10:39 AM, in message <50AD4A01.7060500@ilyx.ru>, Ilya Zykov
>>> <ilya@ilyx.ru> wrote:
>>>> On 22.11.2012 1:30, Alan Cox wrote:
>>>>>> Function reset_buffer_flags() also invoked during the
>>>>>> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
>>>>>> and throttled driver too. If we don't unthrottle driver, we can get
>>>>>> forever throttled driver, because after request, we will have
>>>>>> empty buffers and throttled driver and there is no place to unthrottle
>>>> driver.
>>>>>> It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
>>>>>> and other side do ioctl(...,TCFLSH,..). Then there is no place to do
>>>> writers wake up.
>>>>>
>>>>>
>>>>> So instead of revertng it why not just fix it ? Just add an argument to
>>>>> the reset_buffer_flags function to indicate if unthrottling is permitted.
>>>>>
>>>>> Alan
>>>>>
>>>> Because in my opinion, unthrottling permitted always, except release
>>>> last filp (tty->count == 0)
>>>
>>> Maybe so, but the patch was there in the first place to resolve an actual
>> observed bug, where a driver would lock up.  So the behaviour needs
>> preserved.
>>>
>>> Andrew
>>>
>>
>> Maybe it was wrong driver, unfortunately, I didn't find full information
>> about this bug. As an example, if driver indirectly call
>> reset_buffer_flags() in driver's close() function it will be before
>> decrement last (tty->count).
>
> Well, the driver in question was just 8250.c, so you should be able to see that the original condition can exist.
>
> Here's the commit message again:
>
> tty: fix "IRQ45: nobody cared"
>
> Unthrottling the TTY during close ends up enabling interrupts
> on a device not on the active list, which will never have the
> interrupts cleared.  Doctor, it hurts when I do this.
>
>>>> On 6/2/2011 at 01:56 AM, in message <20110601145608.3e586e16@bob.linux.org.uk>, Alan Cox <alan@linux.intel.com> wrote:
>> On Wed, 01 Jun 2011 10:34:07 +1200
>> "andrew mcgregor" <andrew.mcgregor@alliedtelesis.co.nz> wrote:
>>> The LKML message
>>> http://kerneltrap.org/mailarchive/linux-kernel/2010/2/25/4541847from
>>> February doesn't seem to have been resolved since.  We struck the
>>> issue, and the patch below (against 2.6.32) fixes it.  Should I
>>> supply a patch against 3.0.0rc?
>>
>> I think that would be sensible. I don't actually see how you hit it as
>> the IRQ ought to be masked by then but it's certainly wrong for n_tty
>> to be calling into check_unthrottle at that point.
>>
>> So yes please send a patch with a suitable Signed-off-by: line to
>> linux-serial and cc GregKH <greg@kroah.com> as well.
>>
>> Alan
>
> Signed-off-by: Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> What part of this no longer applies?  I'm happy enough if you can prove that this can't happen any more, but otherwise the fix should remain.
>
> Andrew

This patch must help for 8250.c

diff --git a/drivers/tty/serial/serial_core.c 
b/drivers/tty/serial/serial_core.c
index a21dc8e..2e197c3 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1288,8 +1288,6 @@ static void uart_close(struct tty_struct *tty, 
struct file *filp)
         uart_shutdown(tty, state);
         uart_flush_buffer(tty);

-       tty_ldisc_flush(tty);
-
         tty_port_tty_set(port, NULL);
         spin_lock_irqsave(&port->lock, flags);
         tty->closing = 0;

