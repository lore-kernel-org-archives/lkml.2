Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab2HORJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:09:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37572 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2HORJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <201208141450.23453.marek.vasut@gmail.com>
References: <CAEB7QLAJXkK6NDPVDi36n_U_X_DGh5niHJhH6FpqBUZFmXQ2Xg@mail.gmail.com>
	<1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<201208141450.23453.marek.vasut@gmail.com>
Date: Wed, 15 Aug 2012 19:09:05 +0200
Message-ID: <CAEB7QLCgUJzq+7nqDoBLp8hRpKXAxhajPFnMEZ82MfzesUqZ6A@mail.gmail.com>
Subject: Re: [PATCH 1/1] [RFC] uartclk from serial_core exposed to sysfs
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek,

On Tue, Aug 14, 2012 at 2:50 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Dear Tomas Hlavacek,
>
>> +static ssize_t get_attr_uartclk(struct device *dev,
>> +             struct device_attribute *attr, char *buf)
>> +{
>> +     int ret;
>> +
>> +     struct uart_state *state = (struct uart_state *)(dev_get_drvdata(dev));
>
> You don't need this cast here.

Yes, you are right. Thanks.

>
>> +     mutex_lock(&state->port.mutex);
>> +     ret = snprintf(buf, PAGE_SIZE, "%d\n", state->uart_port->uartclk);
>
> Do you really need such a large buffer (PAGE_SIZE) ?

Well no, but I believe that I get the buffer of length equal to
PAGE_SIZE anyway. Documentation/filesystems/sysfs.txt says so on line
179.

>
>> +     mutex_unlock(&state->port.mutex);
>> +     return ret;
>> +}
>> +
>> +static ssize_t set_attr_uartclk(struct device *dev,
>> +             struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +     struct uart_state *state = (struct uart_state *)(dev_get_drvdata(dev));
>> +     unsigned int val;
>> +     int ret;
>> +
>> +     ret = kstrtouint(buf, 10, &val);
>> +     if (ret)
>> +             return ret;
>> +
>> +     mutex_lock(&state->port.mutex);
>> +
>> +     /*
>> +      * Check value: baud_base has to be more than 9600
>> +      * and uartclock = baud_base * 16 .
>> +      */
>> +     if (val >= 153600)
>> +             state->uart_port->uartclk = val;
>
> This magic value here would use some documentation.

OK. Do you think this would be sufficient comment?:

/*
 * Check value: baud_base does not make sense to be set below 9600
 * and since uartclock = (baud_base * 16) it has to be equal or greater than
 * 9600 * 16 = 153600.
 */

PATCHv2 follows.

Tomas


-- 
Tomáš Hlaváček <tmshlvck@gmail.com>
