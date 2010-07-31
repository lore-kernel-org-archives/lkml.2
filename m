Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GaIj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 04:39:57 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:44813 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0GaIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 04:39:55 -0400
Message-ID: <4C53E157.8080102@bfs.de>
Date: Sat, 31 Jul 2010 10:39:51 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <peterhuewe@gmx.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] staging: panel: check put_user() return value
References: <1280488123-20859-1-git-send-email-segooon@gmail.com> <20100730211544.GH19782@1wt.eu>
In-Reply-To: <20100730211544.GH19782@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Willy Tarreau schrieb:
> On Fri, Jul 30, 2010 at 03:08:42PM +0400, Kulikov Vasiliy wrote:
>> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
>> index f58da32..57f4946 100644
>> --- a/drivers/staging/panel/panel.c
>> +++ b/drivers/staging/panel/panel.c
>> @@ -1589,25 +1589,30 @@ void lcd_init(void)
>>  static ssize_t keypad_read(struct file *file,
>>  			   char *buf, size_t count, loff_t *ppos)
>>  {
>> -
>> +	int buflen = keypad_buflen;
>>  	unsigned i = *ppos;
>>  	char *tmp = buf;
>> +	int start = keypad_start;
>>  
>> -	if (keypad_buflen == 0) {
>> +	if (buflen == 0) {
>>  		if (file->f_flags & O_NONBLOCK)
>>  			return -EAGAIN;
>>  
>>  		interruptible_sleep_on(&keypad_read_wait);
>>  		if (signal_pending(current))
>>  			return -EINTR;
>> +		buflen = keypad_buflen;
>>  	}
> 
> Not sure what the intent was here, I think you're re-adjusting
> the buffer's length in case something else was read. But then
> I don't understand why buflen it not simply assigned after the
> if() block.
> 
> The rest below looks fine otherwise.
> 
>>  
>> -	for (; count-- > 0 && (keypad_buflen > 0);
>> -	     ++i, ++tmp, --keypad_buflen) {
>> -		put_user(keypad_buffer[keypad_start], tmp);
>> -		keypad_start = (keypad_start + 1) % KEYPAD_BUFFER;
>> +	for (; count-- > 0 && (buflen > 0);
>> +	     ++i, ++tmp, --buflen) {
>> +		if (put_user(keypad_buffer[start], tmp))
>> +			return -EFAULT;
>> +		start = (start + 1) % KEYPAD_BUFFER;
>>  	}
>>  	*ppos = i;
>> +	keypad_buflen = buflen;
>> +	keypad_start = start;
>>  
>>  	return tmp - buf;
>>  }
> 
> 

IMHO opinion the for() construct breaks the rule of "no surprise please".
perhaps a while() would improve readability.

just my two cents,
re,
 wh




