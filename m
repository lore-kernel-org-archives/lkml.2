Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IBWpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:45:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0IBWpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T4e1lQi1MDpyQORJmTL21igTuuevB6EKcHCJBX9e2ahtJ6EZYhYW+bkwwQzN0ijwaE
         OhS/4pnkDUzEOYIbqDLA==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1009021723460.1311-100000@iolanthe.rowland.org>
References: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com>
	<Pine.LNX.4.44L0.1009021723460.1311-100000@iolanthe.rowland.org>
Date: Thu, 2 Sep 2010 15:45:19 -0700
X-Google-Sender-Auth: 8yP4vZGfPftQL5ssDIpXUEAl9T0
Message-ID: <AANLkTin_-y2nsXhH+mXv=bku=WXO7VhfvknYwtLhURfv@mail.gmail.com>
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

On Thu, Sep 2, 2010 at 2:34 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 2 Sep 2010, Colin Cross wrote:
>
>> That would work, but I still don't see why it's better.  With either
>> of your changes, the power.completion variable is storing state, and
>> not just used for notification.  However, the exact meaning of that
>> state is unclear, especially during the transition from an aborted
>> suspend to resume, and the state is duplicating power.status.  Setting
>> it to complete in dpm_prepare is especially confusing, because at that
>> point nothing is completed, it hasn't even been started.
>
> The state being waited for varies from time to time and is only
> partially related to power.status.  Instead of using a completion I
> suppose we could have used a new "transition_complete" variable
> together with a waitqueue.  Would you prefer that?  It's effectively
> the same thing as a completion, but without the nice packaging already
> provided by the kernel.
No, that doesn't change anything.  What I'd prefer to see is a
wait_for_condition on the desired state of the parent.  As is,
power.completion means one thing during suspend (the device has
started, but not finished, suspending), and a different thing during
resume (the device has not finished resuming, and may not have started
resuming).  That difference is exactly what caused the bug - the
completion has to be set on init so that it is set before the device
starts suspend.

I'll send the complete_all on init patch, as it's the only way to fix
the problem given the current implementation of dpm_wait.
