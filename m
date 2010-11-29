Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0K2NxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:53:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:33956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2NxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:53:00 -0500
Message-ID: <4CF3B02B.3030500@kernel.org>
Date: Mon, 29 Nov 2010 14:52:43 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 11/14] ptrace: make group stop notification reliable	against
 ptrace
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-12-git-send-email-tj@kernel.org> <20101128203000.GD12896@redhat.com>
In-Reply-To: <20101128203000.GD12896@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Nov 2010 13:52:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/28/2010 09:30 PM, Oleg Nesterov wrote:
> On 11/26, Tejun Heo wrote:
>>
>> Group stop notifications are unreliable if one or more tasks of the
>> task group are being ptraced.  If a ptraced task ends up finishing a
>> group stop, the notification is sent to the ptracer and the real
>> parent never gets notified.
> 
> Yes. I do not even know if this is bug or not, but certainly I agree,
> this doesn't look very nice.
> 
>>  	if (likely(!task_ptrace(current))) {
>> +		bool do_notify = false;
>> +
>> +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
>> +			sig->flags &= ~SIGNAL_NOTIFY_STOP;
>> +			do_notify = true;
>> +		}
>> +
>>  		spin_unlock_irq(&current->sighand->siglock);
>>
>> -		if (notify) {
>> +		if (do_notify) {
>>  			read_lock(&tasklist_lock);
>> -			do_notify_parent_cldstop(current, notify);
>> +			do_notify_parent_cldstop(current, CLD_STOPPED);
> 
> This can race with ptrace_attach() in between.
> 
> IOW, this notification can go to the new tracer anyway.

Hmmm, okay, we should hold both locks when checking for notification
to remove that race, or we can just tell do_notify_parent_cldstop()
which parent to use.

-- 
tejun
