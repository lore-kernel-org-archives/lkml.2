Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1BVOQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:16:19 -0500
Received: from perninha.conectiva.com.br ([187.115.55.249]:53398 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1BVOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:16:18 -0500
Subject: [PATCH] Power Manager suspend-hybrid warn on systemlog
From: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Conectiva
Date: Tue, 22 Feb 2011 11:16:15 -0300
Message-ID: <1298384175.8390.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3-1.1mdv2010.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not shure if it's a correct solution, or if it breaks something on a
specific situation. So I decided to send it to the list, to someone more
experienced if that code send their opinion. I realized that
pm-suspend-hybrid generates a warning on system log (at least in intel
arch):

WARNING: at mm/page_alloc.c:122 pm_restrict_gfp_mask+0x4e/0x50()
Call Trace:
[<c0150f12>] warn_slowpath_common+0x72/0xa0
[<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
[<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
[<c0150f62>] warn_slowpath_null+0x22/0x30
[<c01da71e>] pm_restrict_gfp_mask+0x4e/0x50
[<c018a822>] suspend_devices_and_enter+0x52/0x1d0
[<c015be25>] ? capable+0x15/0x50
[<c018fe30>] snapshot_ioctl+0x2b0/0x5c0
[<c017e3c2>] ? tick_dev_program_event+0x42/0x150
[<c018fb80>] ? snapshot_ioctl+0x0/0x5c0
[<c02269bd>] do_vfs_ioctl+0x8d/0x5b0
[<c029e216>] ? tomoyo_init_request_info+0x46/0x50
[<c029bceb>] ? tomoyo_path_number_perm+0x2b/0xe0
[<c017911d>] ? ktime_get_ts+0xed/0x120
[<c029dad7>] ? tomoyo_file_ioctl+0x17/0x20
[<c0226f47>] sys_ioctl+0x67/0x80
[<c010ae5f>] sysenter_do_call+0x12/0x28

So I put some debugs, and saw 2 sequential calls for
pm_restrict_gfp_mask (in hibernate) that the second call warns it. So I
removed it, and made some tests and seens to work without warn (suspend,
hybrid, hibernate). So my question is: is it safe to do that?
The "problem" was tested and occurs on 2.6.37 and 2.6.38-rc5.
---

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
--- a/kernel/power/suspend.c 2011-01-04 22:50:19.000000000 -0200
+++ b/kernel/power/suspend.c 2011-02-21 15:39:16.000000000 -0300
@@ -207,7 +207,6 @@
goto Close;
}
suspend_console();
- pm_restrict_gfp_mask();
suspend_test_start();
error = dpm_suspend_start(PMSG_SUSPEND);
if (error) { 

