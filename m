Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2CSHG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:06:59 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41241 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CSHG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:06:57 -0400
Message-ID: <4F66DAFE.7060304@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 12:36:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        skannan@codeaurora.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <4F62E841.70405@linux.vnet.ibm.com> <201203162123.44927.rjw@sisk.pl> <201203162214.42553.chunkeey@googlemail.com>
In-Reply-To: <201203162214.42553.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031907-5564-0000-0000-000001DE0546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 02:44 AM, Christian Lamparter wrote:

>> That's fine by me.
>>
>> If no one objects, I'll apply it.
> 
> Congrats on that nice, long and "obvious" explanation. Really,
> what do you mean by the "end of resume"? As far as I know it
> is NOT "after" all ->resume calls have finished, in fact the
> usermodehelper is still disabled during ->complete! Maybe a
> hint about "after/before function X() has finished/starts" 
> 


Unfortunately, it appears that you missed the context implied in my comment.
Probably you thought that we were referring only to device suspend and
resume. But actually we were talking about the entire system suspend and
resume, in which device suspend and resume is just one part.

I thought that point was quite clear from the words used in the comment:
"It is wrong to request firmware... system is suspended... So check if the
system is in a state which is unsuitable...". Moreover the comment also
mentions the freezing of tasks etc, which are not part of device suspend
and resume, and (hence) was another indication that we were talking of
suspend/resume at a higher level - the entire suspend/resume sequence, not
just a part of it.

With this clarified, I am pretty sure the comment will make more sense.
Also, the part of the code where usermodehelpers are disabled/enabled during
suspend/resume sequence is also pretty straightforward, and matches perfectly
with what I described in the comment:

kernel/power/suspend.c (or hibernate.c for hibernation sequence):

static int suspend_prepare(void)
{
	...
	pm_notifier_call_chain(PM_SUSPEND_PREPARE);
	...
	usermodehelper_disable();
	...
	suspend_freeze_processes();
	...
}

static void suspend_finish(void)
{
        suspend_thaw_processes();
        usermodehelper_enable();
        pm_notifier_call_chain(PM_POST_SUSPEND);
	...
}

int enter_state(suspend_state_t state)
{
	...
        pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
	suspend_prepare();
	...
        pr_debug("PM: Entering %s sleep\n", pm_states[state]);
	...
	suspend_devices_and_enter(state);
	...
 Finish:
        pr_debug("PM: Finishing wakeup.\n");
        suspend_finish();
	...
}

[Anyway, this comment patch is probably moot at the moment, with Rafael's
new patches...]


> Regards,
> 	Chr
>>> ---
>>>
>>>  drivers/base/firmware_class.c |   16 ++++++++++++++++
>>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>> index 6c9387d..9199e3e 100644
>>> --- a/drivers/base/firmware_class.c
>>> +++ b/drivers/base/firmware_class.c
>>> @@ -535,6 +535,22 @@ static int _request_firmware(const struct firmware **firmware_p,
>>>  
>>>  	read_lock_usermodehelper();
>>>  
>>> +	/*
>>> +	 * It is wrong to request firmware when the system is suspended,
>>> +	 * because it simply won't work. Also, it can cause races with
>>> +	 * the freezer, leading to freezing failures. Worse than that,
>>> +	 * it may even cause a user space process to run when we think
>>> +	 * we have frozen the user space! - and that can lead to all kinds
>>> +	 * of interesting breakage..
>>> +	 *
>>> +	 * So check if the system is in a state which is unsuitable for
>>> +	 * requesting firmware (because it is suspended or not yet fully
>>> +	 * resumed) and bail out early if needed.
>>> +	 * Usermodehelpers are disabled at the beginning of suspend, before
>>> +	 * freezing tasks and re-enabled only towards the end of resume, after
>>> +	 * thawing tasks, when it is safe. So all we need to do here is ensure
>>> +	 * that we don't request firmware when usermodehelpers are disabled.
>>> +	 */
>>>  	if (WARN_ON(usermodehelper_is_disabled())) {
>>>  		dev_err(device, "firmware: %s will not be loaded\n", name);
>>>  		retval = -EBUSY;
> 


