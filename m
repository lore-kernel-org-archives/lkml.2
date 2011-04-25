Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab1DYK5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:57:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48053 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334Ab1DYK5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:57:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Subject: Re: [PATCH] Power Manager suspend-hybrid warn on systemlog
Date: Mon, 25 Apr 2011 12:58:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1298384175.8390.25.camel@localhost.localdomain> <20110405161616.GC1615@ucw.cz>
In-Reply-To: <20110405161616.GC1615@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104251258.04148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 05, 2011, Pavel Machek wrote:
> On Tue 2011-02-22 11:16:15, Alexandre Felipe Muller de Souza wrote:
> > I'm not shure if it's a correct solution, or if it breaks something on a
> > specific situation. So I decided to send it to the list, to someone more
> > experienced if that code send their opinion. I realized that
> > pm-suspend-hybrid generates a warning on system log (at least in intel
> > arch):
> 
> cc: maintainers gets you faster response...
> 
> > WARNING: at mm/page_alloc.c:122 pm_restrict_gfp_mask+0x4e/0x50()
> > Call Trace:
> > [<c0150f12>] warn_slowpath_common+0x72/0xa0
> > [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> > [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> > [<c0150f62>] warn_slowpath_null+0x22/0x30
> > [<c01da71e>] pm_restrict_gfp_mask+0x4e/0x50
> > [<c018a822>] suspend_devices_and_enter+0x52/0x1d0
> > [<c015be25>] ? capable+0x15/0x50
> > [<c018fe30>] snapshot_ioctl+0x2b0/0x5c0
> > [<c017e3c2>] ? tick_dev_program_event+0x42/0x150
> > [<c018fb80>] ? snapshot_ioctl+0x0/0x5c0
> > [<c02269bd>] do_vfs_ioctl+0x8d/0x5b0
> > [<c029e216>] ? tomoyo_init_request_info+0x46/0x50
> > [<c029bceb>] ? tomoyo_path_number_perm+0x2b/0xe0
> > [<c017911d>] ? ktime_get_ts+0xed/0x120
> > [<c029dad7>] ? tomoyo_file_ioctl+0x17/0x20
> > [<c0226f47>] sys_ioctl+0x67/0x80
> > [<c010ae5f>] sysenter_do_call+0x12/0x28
> > 
> > So I put some debugs, and saw 2 sequential calls for
> > pm_restrict_gfp_mask (in hibernate) that the second call warns it. So I
> > removed it, and made some tests and seens to work without warn (suspend,
> > hybrid, hibernate). So my question is: is it safe to do that?
> > The "problem" was tested and occurs on 2.6.37 and 2.6.38-rc5.
> > ---
> > 
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > --- a/kernel/power/suspend.c 2011-01-04 22:50:19.000000000 -0200
> > +++ b/kernel/power/suspend.c 2011-02-21 15:39:16.000000000 -0300
> > @@ -207,7 +207,6 @@
> > goto Close;
> > }
> > suspend_console();
> > - pm_restrict_gfp_mask();
> > suspend_test_start();
> > error = dpm_suspend_start(PMSG_SUSPEND);
> > if (error) { 
> > 

The problem is real, but the fix is not the right one.

Alexandre, please check if the appended patch fixes the warning for you too.

Thanks,
Rafael


---
 kernel/power/user.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
@@ -378,6 +378,7 @@ static long snapshot_ioctl(struct file *
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
 		 */
+		pm_restore_gfp_mask();
 		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
 		break;
 
