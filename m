Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2BABGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:06:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2BABGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:06:31 -0500
Date: Tue, 31 Jan 2012 19:06:25 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: radeon issues on MacBook Pro 8,2
Message-ID: <20120201010625.GK23667@ubuntu-macmini>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120119171808.GB23144@ubuntu-macmini>
 <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
 <20120119205317.GC23144@ubuntu-macmini>
 <20120120155318.GA8162@ubuntu-macmini>
 <CADnq5_NNpwsPoEP0_fzSJ9LQKfaHPJx90yObXKYHO39xLWM6sQ@mail.gmail.com>
 <20120120211214.GC8162@ubuntu-macmini>
 <CADnq5_NcZacne-VH-N7FQ5GQo8EbWNgi7WjeHxnJHciyaSeBvg@mail.gmail.com>
 <20120120230831.GA2292@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120230831.GA2292@ubuntu-macmini>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:08:31PM -0600, Seth Forshee wrote:
> > Can you track down who is calling the connector->detect() callbacks
> > during suspend and resume?
> 
> I got two different stack traces, see below.
> 
> And to slightly amend my statement above, I'm only seeing the wrong
> status returned on the suspend side of things. The status during resume
> always seems to be correct.
> 
>  Pid: 49, comm: kworker/0:2 Tainted: G         C O 3.2.0-10-generic #17-Ubuntu
>  Call Trace:
>   [<ffffffffa03f5e1e>] radeon_dp_detect+0x1de/0x230 [radeon]
>   [<ffffffffa014ac6d>] output_poll_execute+0xbd/0x1a0 [drm_kms_helper]
>   [<ffffffffa014abb0>] ? drm_helper_mode_fill_fb_struct+0x30/0x30 [drm_kms_helper]
>   [<ffffffff81083dca>] process_one_work+0x11a/0x480
>   [<ffffffff81084b74>] worker_thread+0x164/0x370
>   [<ffffffff81084a10>] ? manage_workers.isra.30+0x130/0x130
>   [<ffffffff810893cc>] kthread+0x8c/0xa0
>   [<ffffffff81660674>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089340>] ? flush_kthread_worker+0xa0/0xa0
>   [<ffffffff81660670>] ? gs_change+0x13/0x13
> 
>  Pid: 49, comm: kworker/0:2 Tainted: G         C O 3.2.0-10-generic #17-Ubuntu
>  Call Trace:
>   [<ffffffffa03f5e1e>] radeon_dp_detect+0x1de/0x230 [radeon]
>   [<ffffffffa014b6b3>] drm_helper_probe_single_connector_modes+0x2c3/0x380 [drm_kms_helper]
>   [<ffffffffa0149d42>] drm_fb_helper_hotplug_event+0xf2/0x150 [drm_kms_helper]
>   [<ffffffffa03fe8d5>] radeon_fb_output_poll_changed+0x15/0x20 [radeon]
>   [<ffffffffa03f7b65>] radeon_output_poll_changed+0x15/0x20 [radeon]
>   [<ffffffffa014ad40>] output_poll_execute+0x190/0x1a0 [drm_kms_helper]
>   [<ffffffffa014abb0>] ? drm_helper_mode_fill_fb_struct+0x30/0x30 [drm_kms_helper]
>   [<ffffffff81083dca>] process_one_work+0x11a/0x480
>   [<ffffffff81084b74>] worker_thread+0x164/0x370
>   [<ffffffff81084a10>] ? manage_workers.isra.30+0x130/0x130
>   [<ffffffff810893cc>] kthread+0x8c/0xa0
>   [<ffffffff81660674>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089340>] ? flush_kthread_worker+0xa0/0xa0
>   [<ffffffff81660670>] ? gs_change+0x13/0x13

>From these traces it looks like all that really needs to happen is to
disable the output polling during suspend. The following patch seems to
get rid of the problems I'm seeing. Does this look okay to you?


>From 0c01950f248c541198b7560793cf57c59b2c11f8 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Tue, 31 Jan 2012 15:37:02 -0600
Subject: [PATCH 1/1] drm/radeon/kms: disable output polling when suspended

Polling the outputs when the device is suspended can result in erroneous
status updates. Disable output polling during suspend to prevent this
from happening.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index cec51a5..49f7cb7 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -883,6 +883,8 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
+	drm_kms_helper_poll_disable(dev);
+
 	/* turn off display hw */
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
@@ -972,6 +974,8 @@ int radeon_resume_kms(struct drm_device *dev)
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
 	}
+
+	drm_kms_helper_poll_enable(dev);
 	return 0;
 }
 
-- 
1.7.8.3

