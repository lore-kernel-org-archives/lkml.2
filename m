Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0DMHcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0DMHcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:32:10 -0400
Message-ID: <4BC41ED0.3020807@redhat.com>
Date: Tue, 13 Apr 2010 15:35:44 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, Octavian Purdila <opurdila@ixiacom.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       penguin-kernel@I-love.SAKURA.ne.jp, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, ebiederm@xmission.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch 1/3] sysctl: refactor integer handling proc code
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain> <20100412100754.5302.99552.sendpatchset@localhost.localdomain> <20100413111814.GB4396@x200>
In-Reply-To: <20100413111814.GB4396@x200>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Apr 12, 2010 at 06:04:04AM -0400, Amerigo Wang wrote:
>> As we are about to add another integer handling proc function a little
>> bit of cleanup is in order: add a few helper functions to improve code
>> readability and decrease code duplication.
>>
>> In the process a bug is also fixed: if the user specifies a number
>> with more then 20 digits it will be interpreted as two integers
>> (e.g. 10000...13 will be interpreted as 100.... and 13).
> 
> ULONG_MAX is not 22 digits always.
> 
> The fix is to not rely on simple_strtoul()
> 
> I guess it's time to finally remove it. :-(


Or use strict_strtoul()?

> 
> Also, it's better to copy_from user stuff once.
> Without looking at non-trivial users, one page should be enough.

It seems that all proc code assumes that the input buffer will
not exceed one page size.


> 
>> Behavior for EFAULT handling was changed as well. Previous to this
>> patch, when an EFAULT error occurred in the middle of a write
>> operation, although some of the elements were set, that was not
>> acknowledged to the user (by shorting the write and returning the
>> number of bytes accepted). EFAULT is now treated just like any other
>> errors by acknowledging the amount of bytes accepted.
> 
>> +static int proc_skip_wspace(char __user **buf, size_t *size)
>> +{
>> +	char c;
>> +
>> +	while (*size) {
>> +		if (get_user(c, *buf))
>> +			return -EFAULT;
>> +		if (!isspace(c))
>> +			break;
>> +		(*size)--;
>> +		(*buf)++;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> yeah, copy_from_user once, so we won't have this.

Ok.

> 
>> +static bool isanyof(char c, const char *v, unsigned len)
> 
> A what?
> this is memchr()
> 

Hmm, right, it should be memchr(v, c, len).

Thanks!

