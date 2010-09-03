Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0ICEbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:31:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0ICEbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r6ZUNFvnOqcogBNMqH6E297LloIwNDYccbOH2qNX1bYmXmi/7NqsMwW90zdIBd6BOn
         wqos9rbr0vr3x4aJEbog==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1009022233030.19022-100000@netrider.rowland.org>
References: <AANLkTikug=+ztLCJbxYiyx1U_whLkQ9zsYvEMbV9JyJi@mail.gmail.com>
	<Pine.LNX.4.44L0.1009022233030.19022-100000@netrider.rowland.org>
Date: Thu, 2 Sep 2010 21:30:57 -0700
X-Google-Sender-Auth: qk3v85K4qqsFX674P28LQdBoh7k
Message-ID: <AANLkTindhyovNphyCfnSuqN8KogZ0APdWyL7T=vYHHPF@mail.gmail.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
From: Colin Cross <ccross@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 7:42 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 2 Sep 2010, Colin Cross wrote:
>
>> > Well, in fact that was used in one version of the patchset that introduced
>> > asynchronous suspend-resume, but it was rejected by Linus, because it was
>> > based on non-standard synchronization.  The Linus' argument, that I agreed
>> > with, was that standard snychronization constructs, such as locks or
>> > completions, were guaranteed to work accross different architectures and thus
>> > were simply _safer_ to use than open-coded synchronization that you seem to be
>> > preferring.
>> If I'm reading the right thread, that was using rwlocks, not
>> conditions.
>
> No, the thread talked about rwsems, not rwlocks.  And that's not what
> Linus didn't like -- indeed, using rwsems was his idea.  He didn't like
> non-standard open-coded synchronization.
>
>>  wait_on_condition looks just as cross-architecture as
>> completions, and is almost as simple.
>
> Do you mean wait_event?  It doesn't include the synchronization that
> completions have.
>
>> I look at it like this:  Are you waiting for something to complete, or
>> are you waiting for something to be in a specific state?  Completion
>> works great if you know that you will only want to wait after it
>> starts.  That's not true for an aborted suspend - you may call
>> dpm_wait on a device that has never started resuming, because it never
>> suspended.  You can use a completion, and make sure it's state is
>> right for all the corner cases, but at the end of the day that's not
>> what you mean.  What you mean is "wait on the device to be resumed",
>> and that's a condition, not a simple completion event.
>>
>> > Completions simply allowed us to get the desired behavior with the least
>> > effort and that's why we used them.
>> I'm happy with the end result, but I may submit a patch that converts
>> the completions to conditions for discussion.
>
> Be sure to add memory barriers at the appropriate places.  That's what
> Linus was complaining about in the earlier approach.

You're right, wait_event would be much worse.

I think there's another race condition during suspend.  If an
asynchronous device calls device_pm_wait_for_dev on a device that
hasn't had device_suspend called on it yet, power.completion will
still be set from initialization or the last time it completed resume,
and it won't wait.

Assuming that problem is fixed somehow, there's also a deadlock
possibility.  Consider 3 devices.  A, B, and C, registered in that
order.  A is async, and the suspend handler calls
device_pm_wait_for_dev(C).  B's suspend handler returns an error.  A's
suspend handler is now stuck waiting on C->power.completion, but
device_suspend(C) will never be called.

There are also an unhandled edge condition - what is the expected
behavior for a call to device_pm_wait_for_dev on a device if the
suspend handler for that device returns an error?  Currently, the
calling device will continue as if the target device had suspended.

What about splitting power.completion into two flags,
power.suspend_complete and power.resume_complete?
power.resume_complete is initialized to 1, because the devices start
resumed.  Clear power.suspend_complete for all devices at the
beginning of dpm_suspend, and clear power.resume_complete for any
device that is suspended at the beginning of dpm_resume.  The
semantics of each flag is then always clear.  Any time between the
beginning and end of dpm_suspend, waiting on any device's
power.suspend_complete will block until that device is in suspend.
Any time between the beginning and end of dpm_resume, waiting on
power.resume_complete will block IFF the device is suspended.

A solution to the 2nd and 3rd problems would still be needed - a way
to abort drivers that call device_pm_wait_for_dev when suspend is
aborted, and a return value to tell them the device being waited on is
not suspended.
