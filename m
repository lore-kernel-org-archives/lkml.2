Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2KVTAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:00:15 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45019 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab2KVTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:00:06 -0500
Message-ID: <50ADC015.7080503@ilyx.ru>
Date: Thu, 22 Nov 2012 10:03:01 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: andrew mcgregor <andrew.mcgregor@alliedtelesis.co.nz>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
References: <50AD43DB.4030800@ilyx.ru> <20121121213037.154306da@pyramind.ukuu.org.uk> <50AD4A01.7060500@ilyx.ru> <50AE2CE30200003600026B9A@gwia.alliedtelesyn.co.nz> <50ADAA26.7080103@ilyx.ru>
In-Reply-To: <50ADAA26.7080103@ilyx.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.11.2012 8:29, Ilya Zykov wrote:
> On 22.11.2012 4:47, andrew mcgregor wrote:
>>
>>
>>>>> On 11/22/2012 at 10:39 AM, in message <50AD4A01.7060500@ilyx.ru>,
>>>>> Ilya Zykov
>> <ilya@ilyx.ru> wrote:
>>> On 22.11.2012 1:30, Alan Cox wrote:
>>>>> Function reset_buffer_flags() also invoked during the
>>>>> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
>>>>> and throttled driver too. If we don't unthrottle driver, we can get
>>>>> forever throttled driver, because after request, we will have
>>>>> empty buffers and throttled driver and there is no place to unthrottle
>>> driver.
>>>>> It simple reproduce with "pty" pair then one side sleep on
>>>>> tty->write_wait,
>>>>> and other side do ioctl(...,TCFLSH,..). Then there is no place to do
>>> writers wake up.
>>>>
>>>>
>>>> So instead of revertng it why not just fix it ? Just add an argument to
>>>> the reset_buffer_flags function to indicate if unthrottling is
>>>> permitted.
>>>>
>>>> Alan
>>>>
>>> Because in my opinion, unthrottling permitted always, except release
>>> last filp (tty->count == 0)
>>
>> Maybe so, but the patch was there in the first place to resolve an
>> actual observed bug, where a driver would lock up.  So the behaviour
>> needs preserved.
>>
>> Andrew
>>
>
> Maybe it was wrong driver, unfortunately, I didn't find full information
> about this bug. As an example, if driver indirectly call
> reset_buffer_flags() in driver's close() function it will be before
> decrement last (tty->count).
>
>

Particularly, many drivers and 'serial_core.c' use tty_ldisc_flush() in
own close() function. tty_ldisc_flush() call reset_buffer_flags() 
indirectly.
I think is wrong way use tty_ldisc_flush() in driver's close() function, 
because tty layer 'tty_release()' call  tty_ldisc_release() after 
decremented (tty->count), and clear all buffers.
We don't care about this in driver. And call ldisc's function.


