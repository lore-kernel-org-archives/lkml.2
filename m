Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2ECV1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:27:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43292 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab2ECV1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:27:19 -0400
MIME-Version: 1.0
In-Reply-To: <201205031528.12743.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201204262352.43254.rjw@sisk.pl>
	<CAMP5Xgfur0Pj2agG9zRcdfPxENnhPvK+00n23tbVGvP0PwKnTQ@mail.gmail.com>
	<201205031528.12743.rjw@sisk.pl>
Date: Thu, 3 May 2012 14:27:18 -0700
Message-ID: <CAMP5XgeXGWcWwQ77DctoWQy0BEPLAQdbSjHANbHu76M+xZzR-w@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 6:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, May 03, 2012, Arve Hjønnevåg wrote:
>> On Thu, Apr 26, 2012 at 2:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> ...
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > Subject: PM / Sleep: Implement opportunistic sleep, v2
>> >
>> > Introduce a mechanism by which the kernel can trigger global
>> > transitions to a sleep state chosen by user space if there are no
>> > active wakeup sources.
>> >
>> > It consists of a new sysfs attribute, /sys/power/autosleep, that
>> > can be written one of the strings returned by reads from
>> > /sys/power/state, an ordered workqueue and a work item carrying out
>> > the "suspend" operations.  If a string representing the system's
>> > sleep state is written to /sys/power/autosleep, the work item
>> > triggering transitions to that state is queued up and it requeues
>> > itself after every execution until user space writes "off" to
>> > /sys/power/autosleep.
>> >
>>
>> This does not work. Writing something other than "off" disabled auto
>> suspend for me.
>
> My bad, sorry about that.
>
>> ...
>> > +static ssize_t autosleep_store(struct kobject *kobj,
>> > +                              struct kobj_attribute *attr,
>> > +                              const char *buf, size_t n)
>> > +{
>> > +       suspend_state_t state = decode_state(buf, n);
>> > +       int error;
>> > +
>> > +       if (state == PM_SUSPEND_ON
>> > +           && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
>> > +               return -EINVAL;
>>
>> Did you mean:
>>       if (state == PM_SUSPEND_ON
>>           && strcmp(buf, "off") && strcmp(buf, "off\n"))
>>               return -EINVAL;
>
>
> Yes, I did.
>
> I'll add the following as an incremental patch on top of the series.
>
> Thanks,
> Rafael
>
> ---
>  kernel/power/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/kernel/power/main.c
> ===================================================================
> --- linux.orig/kernel/power/main.c
> +++ linux/kernel/power/main.c
> @@ -422,7 +422,7 @@ static ssize_t autosleep_store(struct ko
>        int error;
>
>        if (state == PM_SUSPEND_ON
> -           && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
> +           && strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4))
>                return -EINVAL;
>
>        error = pm_autosleep_set_state(state);

You still use strncmp here, so anything that starts with "off" is
allowed (and the second strncmp is redundant).

-- 
Arve Hjønnevåg
