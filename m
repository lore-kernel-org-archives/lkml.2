Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0EQEuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 00:50:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38233 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0EQEuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 00:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <201005142308.48386.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005142308.48386.rjw@sisk.pl>
Date: Sun, 16 May 2010 21:50:00 -0700
Message-ID: <AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/14 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday 14 May 2010, Arve Hjønnevåg wrote:
>> This patch series adds a suspend-block api that provides the same
>> functionality as the android wakelock api. This version has some
>> changes from, or requested by, Rafael. The most notable changes are:
>> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
>>   for statically allocated suspend blockers.
>> - suspend_blocker_destroy is now called suspend_blocker_unregister
>> - The user space mandatory _INIT ioctl has been replaced with an
>>   optional _SET_NAME ioctl.
>>
>> I kept the ack and reviewed by tags on two of the patches even though
>> there were a few cosmetic changes.
>
> Thanks for the patches, I think they are in a pretty good shape now.
>
> That said, I'd like the changelogs to be a bit more descriptive, at least for
> patch [1/8].  I think it should explain (in a few words) what the purpose of
> the feature is and what problems it solves that generally a combination of
> runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
> think we need that feature.
>

How about:

PM: Add opportunistic suspend support.

Adds a suspend block api that drivers can use to block opportunistic
suspend. This is needed to avoid losing wakeup events that occur
right after suspend is initiated.

Adds /sys/power/policy that selects the behaviour of /sys/power/state.
After setting the policy to opportunistic, writes to /sys/power/state
become non-blocking requests that specify which suspend state to enter
when no suspend blockers are active. A special state, "on", stops the
process by activating the "main" suspend blocker.

Opportunistic suspend is most useful on systems that cannot enter their
lowest power state from idle, but it is also useful on systems that enter
the same power state from idle and suspend. Periodic timers can cause
a significant power drain on these systems, and suspend will stop most
of this. Opportunistic suspend can also reduce the harm caused by apps
that never go idle.

> The changelog of patch [2/8] appears to be outdated, that needs to be fixed.
> Also, it would be nice to explain in the changelog what the interface is needed
> for (in terms of the problems that it helps to handle).
>

How about:

PM: suspend_block: Add driver to access suspend blockers from user-space

Add a misc device, "suspend_blocker", that allows user-space processes
to block auto suspend. Opening this device creates a suspend_blocker.
ioctls are provided to name this suspend_blocker, and to block and unblock
suspend. To delete the suspend_blocker, close the device.

For example, when select or poll indicates that input event are available, this
interface can be used to block suspend before reading those event. This allows
the input driver to release its suspend blocker as soon as the event queue is
empty.

-- 
Arve Hjønnevåg
