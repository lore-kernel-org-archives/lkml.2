Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0ELBLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:11:12 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:39009 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0ELBLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:11:10 -0400
MIME-Version: 1.0
In-Reply-To: <87632vhbs8.fsf@deeprootsystems.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <87wrvl5479.fsf@deeprootsystems.com>
	 <87632vhbs8.fsf@deeprootsystems.com>
Date: Tue, 11 May 2010 18:11:09 -0700
Message-ID: <AANLkTikJV-wQX9xh8mRVptebJBctcRrQaUls-IGDhQar@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/10 Kevin Hilman <khilman@deeprootsystems.com>:
> Hello,
>
> I think many folks are still confused about exactly the problem being
> solved by this series as well as mixed up between opportunistic
> suspend and suspend blockers.  Also, how this series impatcs the rest
> of the kernel (especially PM-aware drivers and subsystems) has caused
> a bit of confusion.
>
> To help with the confusion, I think a much clearer description of the
> problem being solved and the proposed solution is needed.
>
> To that end, I created a starting point for that below which
> summarizes how I understand the problem and the proposed solution, but
> of course this should be filled out in more detail and updated as part
> of the documentation that goes with this series.
>
> Hope this helps improve the understanding of this feature,
>
> Kevin
>
>
>
> Table of Contents
> =================
> 1 Problem Statement
> 2 Solution: Opportunistic suspend
>    2.1 When to use a suspend blocker
>    2.2 Usage in PM aware drivers
>
>
> 1 Problem Statement
> ~~~~~~~~~~~~~~~~~~~~
>
> Want to to hit deep power state, even when the system is not actually
> idle.
>
> Why?
>
> - some hardware is not capable of deep power states in idle
> - difficulty getting userspace and/or kernel to be idle

There are two parts to this. Suspend freezes tasks that don't idle at
all, and it stops the monotonic clock which in turn stops tasks that
do (frequent) periodic work.

>
> 2 Solution: Opportunistic suspend
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Create an additional "idle path" which has new rules for determining
> idleness.  When this new "idle" is reached, trigger full-system
> suspend.  Since a suspend is triggered whenever the opportunity
> arises, this is called opportunistic suspend.
>
> The new rules for making the idleness decision are simple:
>
> 1.  system may suspend if and only if no suspend blockers are held
>
> 2.1 When to use a suspend blocker
> ==================================
>
> [A list of reasons why suspend blockers might be used would be very
>  helpful here.]
>
> - ensure wakeup events propagate to userspace (e.g. keypad example in doc)
>
> - screen is on
>
> - someone mentioned "Google use cases"
>  (would be nice to hear about more of these)

Most uses of suspend blockers are in some way tied to a potential
wakeup event. We use (a) suspend blocker(s) to make sure the event
propagates to the code that will handle the event, and that code then
uses another suspend blocker while it handles the event.

Some examples:

The battery monitor on Nexus One uses a periodic alarm to wake up the
system. The alarm driver will block suspend so the timer can fire, and
the battery monitor will block suspend while reading the battery
status and changing the charge mode.

Phone rings: We use a few suspend blockers to process the low level
message from the modem which end up returning a message on a tty. The
last step in the kernel currently uses a wakelock with a timeout since
we have not modified the tty layer to block suspend. The user space
ril process then blocks suspend while it handles this message.

USB: We get a (wakeup) message from the modem that there is power on
the usb connector and we block suspend while we detect what is
connected. If we are connected to a USB host, we block suspend and
turn on the usb interface.

>
> 2.2 Usage in PM aware drivers
> ==============================
>
> [An example of how a driver already using runtime PM would use
>  a suspend blocker would also be helpful.
>

An audio driver can block suspend while audio is playing. We don't
currently use the runtime pm framework since this is new, but we do
runtime pm by turning off clocks and power when the device is
inactive.

-- 
Arve Hjønnevåg
