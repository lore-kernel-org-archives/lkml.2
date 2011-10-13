Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1JMTse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:48:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1JMTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:48:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Thu, 13 Oct 2011 21:45:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: mark gross <markgross@thegnar.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132145.42270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is an ongoing discussion about possible ways to avoid some probles
related to suspend/hibernate interfaces, such as races with the handling
of wakeup events (in user space) and (destructive) interference with some
important system maintenance tasks (such as firmware updates).

It follows from this discussion that whatever the kernel has to offer in
this area is either too complicated to use in practice or inadequate for
other reasons.  The two use case examples given by John, that is the
firmware update problem (i.e. system suspend or hibernation should not
be allowed to happen while the system's firmware is being updated) and the
backup problem (i.e. is should be possible to wake up the system from
sleep in the middle of the night via a timer event, create a backup of it
and make it go to sleep again automatically when the backup is ready
without implementing the backup feature in a power manager) are quite
convincing to me, but also it seems to me that previous attempts to
address them go a bit too far in complexity.  For this reason, I thought
it might be a good idea to propose a simpler approach.  It is not bullet
proof, but it should be suitable to address at least those two issues.

First, to address the firmware update problem, I think we need a big
hammer switch allowing a root-owned process to disable/enable all
suspend/hibernate interfaces.  This is introduced by the first patch in
the form of a new sysfs attribute, /sys/power/sleep_mode, that can be
used to disable the suspend/hibernate functionality (it does that with
the help of the existing wakeup events detection mechanism).

Second, to address the backup problem, we need to allow user space
processes other than the suspend/hibernate process itself to prevent the
system from being put into sleep states.  A mechanism for that is introduced
by the second patch in the form of the /dev/sleepctl special device working
kind of like user space wakelocks on Android (although in a simplified
fashion).

More details are in the changelogs and (of course) in the code itself.

The patches haven't been tested (I had tested the first one, but then I made
some changes to it afterwards), so most likely there are some bugs in them,
but I didn't want to lose time on testing things that people may not like
in principle. :-)

Thanks,
Rafael

