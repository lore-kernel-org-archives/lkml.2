Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1BUU4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:56:24 -0500
Received: from relay3.sgi.com ([192.48.152.1]:54869 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242Ab1BUU4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:56:22 -0500
Message-ID: <4D62D173.8040805@sgi.com>
Date: Mon, 21 Feb 2011 12:56:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] printk: Minimize time zero output
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024706.121740209@gulag1.americas.sgi.com> <alpine.DEB.2.00.1102191733220.27722@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102191733220.27722@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Rientjes wrote:
> On Fri, 18 Feb 2011, Mike Travis wrote:
> 
>> Reduce the length for time zero messages by only printing "[0] ".
>>
>> v2: updated to apply to x86-tip
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Jack Steiner <steiner@sgi.com>
>> Reviewed-by: Robin Holt <holt@sgi.com>
>> ---
>>  kernel/printk.c |   11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> --- linux.orig/kernel/printk.c
>> +++ linux/kernel/printk.c
>> @@ -735,9 +735,14 @@ static inline int printk_emit_time(void)
>>  	unsigned long microsec_rem;
>>  
>>  	t = cpu_clock(printk_cpu);
>> -	microsec_rem = do_div(t, 1000000000) / 1000;
>> -	tlen = sprintf(tbuf, "[%5lu.%06lu] ", (unsigned long)t, microsec_rem);
>> -
>> +	if (likely(t)) {
>> +		microsec_rem = do_div(t, 1000000000) / 1000;
>> +		tlen = sprintf(tbuf, "[%5lu.%06lu] ",
>> +					(unsigned long)t, microsec_rem);
> 
> The definition of microsec_rem can become local to this clause.

Ok.
> 
>> +	} else {
>> +		/* reduce byte count in log when time is zero */
>> +		tlen = sprintf(tbuf, "[0] ");
> 
> If we know the padding when cpu_clock() is non-zero, then why not make 
> sure the kernel log is aligned properly by using the same padding here?

I'm not sure I understand what you are asking.  The whole point of this
exercise is to remove bytes from the early log buffer so it does not
overflow.  What would you like me to change?

> 
>> +	}
>>  	for (tp = tbuf; tp < tbuf + tlen; tp++)
>>  		emit_log_char(*tp);
>>  
