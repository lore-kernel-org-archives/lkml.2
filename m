Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1DYVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:47:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1DYVrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:47:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Subject: Re: [PATCH] Power Manager suspend-hybrid warn on systemlog
Date: Mon, 25 Apr 2011 23:47:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <1298384175.8390.25.camel@localhost.localdomain> <20110405161616.GC1615@ucw.cz> <201104251258.04148.rjw@sisk.pl>
In-Reply-To: <201104251258.04148.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104252347.18955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 25, 2011, Rafael J. Wysocki wrote:
> On Tuesday, April 05, 2011, Pavel Machek wrote:
> > On Tue 2011-02-22 11:16:15, Alexandre Felipe Muller de Souza wrote:
> > > I'm not shure if it's a correct solution, or if it breaks something on a
> > > specific situation. So I decided to send it to the list, to someone more
> > > experienced if that code send their opinion. I realized that
> > > pm-suspend-hybrid generates a warning on system log (at least in intel
> > > arch):
> > 
> > cc: maintainers gets you faster response...
> > 
> > > WARNING: at mm/page_alloc.c:122 pm_restrict_gfp_mask+0x4e/0x50()
> > > Call Trace:
> > > [<c0150f12>] warn_slowpath_common+0x72/0xa0
> > > [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> > > [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> > > [<c0150f62>] warn_slowpath_null+0x22/0x30
> > > [<c01da71e>] pm_restrict_gfp_mask+0x4e/0x50
> > > [<c018a822>] suspend_devices_and_enter+0x52/0x1d0
> > > [<c015be25>] ? capable+0x15/0x50
> > > [<c018fe30>] snapshot_ioctl+0x2b0/0x5c0
> > > [<c017e3c2>] ? tick_dev_program_event+0x42/0x150
> > > [<c018fb80>] ? snapshot_ioctl+0x0/0x5c0
> > > [<c02269bd>] do_vfs_ioctl+0x8d/0x5b0
> > > [<c029e216>] ? tomoyo_init_request_info+0x46/0x50
> > > [<c029bceb>] ? tomoyo_path_number_perm+0x2b/0xe0
> > > [<c017911d>] ? ktime_get_ts+0xed/0x120
> > > [<c029dad7>] ? tomoyo_file_ioctl+0x17/0x20
> > > [<c0226f47>] sys_ioctl+0x67/0x80
> > > [<c010ae5f>] sysenter_do_call+0x12/0x28
> > > 
> > > So I put some debugs, and saw 2 sequential calls for
> > > pm_restrict_gfp_mask (in hibernate) that the second call warns it. So I
> > > removed it, and made some tests and seens to work without warn (suspend,
> > > hybrid, hibernate). So my question is: is it safe to do that?
> > > The "problem" was tested and occurs on 2.6.37 and 2.6.38-rc5.
> > > ---
> > > 
> > > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > > --- a/kernel/power/suspend.c 2011-01-04 22:50:19.000000000 -0200
> > > +++ b/kernel/power/suspend.c 2011-02-21 15:39:16.000000000 -0300
> > > @@ -207,7 +207,6 @@
> > > goto Close;
> > > }
> > > suspend_console();
> > > - pm_restrict_gfp_mask();
> > > suspend_test_start();
> > > error = dpm_suspend_start(PMSG_SUSPEND);
> > > if (error) { 
> > > 
> 
> The problem is real, but the fix is not the right one.
> 
> Alexandre, please check if the appended patch fixes the warning for you too.

Sorry, we actually shouldn't restore the GFP mask while the hibernate image
hasn't been saved yet, so your fix goes into the right direction, but the
pm_restrict_gfp_mask() is needed for the "pure" suspend-to-RAM case.

Please check if the appended patch works for you.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl

A warning is printed by pm_restrict_gfp_mask() while the
SNAPSHOT_S2RAM ioctl is being executed after creating a hibernation
image, because pm_restrict_gfp_mask() has been called once already
before the image creation and suspend_devices_and_enter() calls it
once again.  This happens after commit 452aa6999e6703ffbddd7f6ea124d3
(mm/pm: force GFP_NOIO during suspend/hibernation and resume).

To avoid this issue, move pm_restrict_gfp_mask() and
pm_restore_gfp_mask() from suspend_devices_and_enter() to its caller
in kernel/power/suspend.c.

Reported-by: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/suspend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -210,7 +210,6 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -227,7 +226,6 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
@@ -288,7 +286,9 @@ int enter_state(suspend_state_t state)
 		goto Finish;
 
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
+	pm_restore_gfp_mask();
 
  Finish:
 	pr_debug("PM: Finishing wakeup.\n");
