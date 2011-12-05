Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1LEVZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:25:31 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59213 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab1LEVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:25:29 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/2] PM / Usermodehelper: Fix freezer failures due to racy
 usermodehelper_is_disabled()
To: gregkh@suse.de
Cc: dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl, kay.sievers@vrfy.org,
        jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 06 Dec 2011 02:55:16 +0530
Message-ID: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120521-9574-0000-0000-00000069F3EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, Boris and Rafael,

I am revisiting the microcode vs freezer issue with this patchset, with
a much better solution this time (hopefully), since now I am attacking
the root cause of the problem (a race in usermodehelpers), in order
to solve the issue I reported earlier in:
http://thread.gmane.org/gmane.linux.kernel/1198291/focus=1200591

:-)

Btw, Rafael, using PM notifiers for mutual exclusion from freezer (like we
did in CPU hotplug case), for x86 microcode driver wouldn't work out, since
there is no guarantee that our callback will get registered before freezing
starts, since the module init code itself needs to be mutexed from the freezer.
And the callback registration would also have to happen from the init code
itself! (we didn't have this problem in CPU hotplug case).

And since Boris pointed out several times that in real world, microcode won't
be applied all that often, I decided to focus on the root-cause and leave
the microcode driver alone :-)

---
Commit a144c6a (PM: Print a warning if firmware is requested when tasks
are frozen) introduced usermodehelper_is_disabled() to warn and exit
immediately if firmware is requested when usermodehelpers are disabled.

However, it is racy. Consider the following scenario, currently used in
drivers/base/firmware_class.c:

...
if (usermodehelper_is_disabled())
        goto out;

/* Do actual work */
...

out:
        return err;

Nothing prevents someone from disabling usermodehelpers just after the
check in the 'if' condition, which means that it is quite possible to try
doing the "actual work" with usermodehelpers disabled, leading to undesirable
consequences.

In particular, this race condition in _request_firmware() causes task
freezing failures whenever suspend/hibernation is in progress because, it
wrongly waits to get the firmware/microcode image from userspace when actually
the usermodehelpers are disabled or userspace has been frozen. Some of the
example scenarios that cause freezing failures due to this race are those
that depend on userspace via request_firmware(), such as x86 microcode module
initialization and microcode image reload.

Previous discussions about this issue can be found at:
http://thread.gmane.org/gmane.linux.kernel/1198291/focus=1200591

This patchset adds proper synchronization to fix this issue.

It is to be noted that this patchset fixes the freezing failures but doesn't
remove the warnings. IOW, it does not attempt to add explicit synchronization
to x86 microcode driver to avoid requesting microcode image at inopportune
moments. Because, the warnings were introduced to highlight such cases, in
the first place. And we need not silence the warnings, since we take care
of the *real* problem (freezing failure) and hence, after that, the warnings
are pretty harmless anyway.

--
 Srivatsa S. Bhat (2):
      PM / Usermodehelper: Introduce reference counting to solve usermodehelper_disabled race
      PM / request_firmware(): Use the refcounting solution to fix the race


  drivers/base/firmware_class.c |    3 ++
 include/linux/kmod.h          |    2 +
 kernel/kmod.c                 |   74 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 78 insertions(+), 1 deletions(-)


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

