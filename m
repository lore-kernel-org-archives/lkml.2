Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab2DMCwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 22:52:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45475 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2DMCwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 22:52:35 -0400
Message-ID: <4F8794F3.5050503@gmail.com>
Date: Fri, 13 Apr 2012 10:52:35 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, davidel@xmailserver.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] eventfd: change int to __u64 in eventfd_signal()
References: <4f86a805.473f440a.2915.0cf3@mx.google.com> <20120412160912.ee326702.akpm@linux-foundation.org>
In-Reply-To: <20120412160912.ee326702.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 07:09 AM, Andrew Morton wrote:
> On Thu, 12 Apr 2012 18:01:20 +0800
> handai.szj@gmail.com wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> eventfd_ctx->count is an __u64 counter which is allowed to reach ULLONG_MAX.
>> Now eventfd_write() add an __u64 value to "count", but kernel side
>> eventfd_signal() only add an int value to it. So make them consistent here.
>>
>> ...
>>
>> --- a/fs/eventfd.c
>> +++ b/fs/eventfd.c
>> @@ -51,7 +51,7 @@ struct eventfd_ctx {
>>    *
>>    * -EINVAL    : The value of @n is negative.
>>    */
>> -int eventfd_signal(struct eventfd_ctx *ctx, int n)
>> +__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>>   {
>>   	unsigned long flags;
>>
>> @@ -59,7 +59,7 @@ int eventfd_signal(struct eventfd_ctx *ctx, int n)
>>   		return -EINVAL;
>>   	spin_lock_irqsave(&ctx->wqh.lock, flags);
>>   	if (ULLONG_MAX - ctx->count<  n)
>> -		n = (int) (ULLONG_MAX - ctx->count);
>> +		n = ULLONG_MAX - ctx->count;
>>   	ctx->count += n;
>>   	if (waitqueue_active(&ctx->wqh))
>>   		wake_up_locked_poll(&ctx->wqh, POLLIN);
> Changing `n' to an unsigned type makes the "if (n<  0)" test a no-op.
>
yeah, it's really not necessary. I slipped up..
> Every in-kernel caller of eventfd_signal() passes n=1.  All of them.
> Perhaps we can just remove that argument and hard-wire the +1
> assumption into eventfd_signal().
A userspace write(2) performing on an eventfd can pass an u64 value to
"count" and issue a wakeup, I think the kernel side can just be in 
accord with it.
Though all the current in-kernel callers just pass 1 to eventfd_signal(), it
doesn't mean there is no possibility of other usages in future. 
Actually, we're
considering to encode some usefully info to "count" and sent it to 
userspace. :-)

