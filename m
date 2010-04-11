Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0DKTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 15:16:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:14160 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0DKTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 15:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=SJH65PhpfGsnaswVgqi7aaB6wK2tT7ojoILG1uluRJqZgZL/fbu7cbLKpSTtmS2bSs
         SJfa+PZ9BWZL71dOhv4wGJtTi70GI+bcxxBnDORIepmTgEjWEmSp9cJN8UqgqpJwUSeh
         83CsjKfyY9iuGgjum08n4LgpkVbXgp/5ARtxE=
From: Michal Nazarewicz <mina86@mina86.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/8] fs/timerfd.c: make use of wait_event_interruptible_locked_irq()
References: <cover.1270835924.git.mina86@mina86.com>
	<3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
	<e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
	<alpine.LFD.2.00.1004111618000.32352@localhost.localdomain>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sun, 11 Apr 2010 21:16:17 +0200
In-Reply-To: <alpine.LFD.2.00.1004111618000.32352@localhost.localdomain>
	(Thomas Gleixner's message of "Sun, 11 Apr 2010 16:31:50 +0200
	(CEST)")
Message-ID: <87ochplrzy.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 9 Apr 2010, Michal Nazarewicz wrote:
>> diff --git a/fs/timerfd.c b/fs/timerfd.c
>> index 1bfc95a..4d2c371 100644
>> --- a/fs/timerfd.c
>> +++ b/fs/timerfd.c
>> @@ -109,31 +109,13 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>>  	struct timerfd_ctx *ctx = file->private_data;
>>  	ssize_t res;
>>  	u64 ticks = 0;
>> -	DECLARE_WAITQUEUE(wait, current);
>>  
>>  	if (count < sizeof(ticks))
>>  		return -EINVAL;
>>  	spin_lock_irq(&ctx->wqh.lock);
>>  	res = -EAGAIN;
>> -	if (!ctx->ticks && !(file->f_flags & O_NONBLOCK)) {
>> -		__add_wait_queue(&ctx->wqh, &wait);
>> -		for (res = 0;;) {
>> -			set_current_state(TASK_INTERRUPTIBLE);
>> -			if (ctx->ticks) {
>> -				res = 0;
>> -				break;
>> -			}
>> -			if (signal_pending(current)) {
>> -				res = -ERESTARTSYS;
>> -				break;
>> -			}
>> -			spin_unlock_irq(&ctx->wqh.lock);
>> -			schedule();
>> -			spin_lock_irq(&ctx->wqh.lock);
>> -		}
>> -		__remove_wait_queue(&ctx->wqh, &wait);
>> -		__set_current_state(TASK_RUNNING);
>> -	}
>> +	if (!(file->f_flags & O_NONBLOCK))
>> +		wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);

Thomas Gleixner <tglx@linutronix.de> writes:
> With this change we return -EAGAIN instead of -ERESTARTSYS when the
> wait got interrupted by a signal. That means instead of restarting the
> syscall we return -EAGAIN to user space.

Stupid mistake, the following should fix it:

+		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);

Sorry about that.

I'll resubmit an updated patchset by the end of the week.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
