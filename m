Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1KDQOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:14:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34073 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab1KDQOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:14:37 -0400
Date: Fri, 4 Nov 2011 09:14:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Watts <akwatts@ymail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111104161431.GZ4417@google.com>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
 <20111104134347.GA2480@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104134347.GA2480@zeus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing David Airlie and dri-devel)

Hello, the original thread can be read from

  http://thread.gmane.org/gmane.linux.kernel/1209587

Full sysrq-t output at

  http://article.gmane.org/gmane.linux.kernel/1211256

So, the problem is that after a seemingly unreated update to input
serio driver (convert to use workqueue), X seems to lock up
sporadically across suspend/resume cycles.

I went through the full sysrq-t output but couldn't spot anything
suspicious w/ anything else.  No worker is stuck and nobody is waiting
for flush to finish.

Stack trace for X follows.

> X               S f499b944  5800  1652   1651 0x00400080
>  f499b9a8 00003086 00000000 f499b944 c100d4a4 00000000 00000000 f499b958
>  00000000 f499b9a8 f5173140 d7857c56 00000057 f5173140 d8b69880 00000057
>  00000001 00000000 f499b9b4 c104dd89 000f4240 00000000 00000000 f499ba68
> Call Trace:
>  [<c1291301>] ttm_bo_wait_unreserved+0x5f/0x106
>  [<c129145f>] ttm_bo_reserve_locked+0xb7/0xe1
>  [<c1292c27>] ttm_bo_reserve+0x26/0x95
>  [<c12c3c97>] radeon_crtc_do_set_base+0xbd/0x6d2
>  [<c12c42e7>] radeon_crtc_set_base+0x1b/0x1d
>  [<c12c430d>] radeon_crtc_mode_set+0x24/0xdd7
>  [<c1279c57>] drm_crtc_helper_set_mode+0x32c/0x48b
>  [<c1279e2f>] drm_helper_resume_force_mode+0x79/0x23e
>  [<c12ace10>] radeon_gpu_reset+0x84/0x98
>  [<c12c0838>] radeon_fence_wait+0x2d1/0x311
>  [<c12c0e37>] radeon_sync_obj_wait+0xc/0xe
>  [<c12908be>] ttm_bo_wait+0xa1/0x108
>  [<c12d6e7b>] radeon_gem_wait_idle_ioctl+0x76/0xc4
>  [<c127e62e>] drm_ioctl+0x1c2/0x42c
>  [<c10e288e>] do_vfs_ioctl+0x79/0x54b
>  [<c10e2dcb>] sys_ioctl+0x6b/0x70
>  [<c1593813>] sysenter_do_call+0x12/0x22

Do you guys have any ideas what's going on?  It seems to be waiting
for bo->reserved to go zero.  Is it possible that someone there is
forgetting to properly kick a work item after resume causing the wait
to stall?

Andrew, can you please kill the X server after the hang and see
whether that brings the system back?  I think sshd should still work
and if not you can write a script to kill the X server after 30secs
after resume (and kill that script if resume succeeds).

Thank you.

-- 
tejun
