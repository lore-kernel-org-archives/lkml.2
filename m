Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2KVUSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:18:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65070 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2KVUR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:17:56 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121122185416.GA13169@shrek.podlesie.net>
References: <20121122185416.GA13169@shrek.podlesie.net>
Date: Thu, 22 Nov 2012 21:17:54 +0100
Message-ID: <CAKMK7uGBSwBeW=hCJi1sZgahQQSKdSy8K=i+M53hF3vDuNzDDQ@mail.gmail.com>
Subject: Re: i915: black screen after blank when LID is closed on Linux >= 3.1
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: dri-devel@lists.freedestop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the report. Now this smells like something which could take
a bit longer to track down, so can you please file this on
bugs.freedesktop.org against DRM -> DRI/Intel to ensure that we dont'
loose track of it?

A few questions and things to test below.

On Thu, Nov 22, 2012 at 7:54 PM, Krzysztof Mazur <krzysiek@podlesie.net> wrote:
> since Linux 3.1 I'm having some problems with i915 driver on HP nc6120
> with 915GM chipset. The display goes black after the kernel tries to
> blank screen while LID is closed (see steps to reproduce to more detailed
> description).
>
> Currently I'm using Linux 3.7-rc6 with KMS enabled and disabled ACPI
> video by something equivalent to (without it the LID, and the whole
> ACPI, does not work):

Can you be more specific about what does not work? Do the lid events
no longer function, or is something else broken?

>
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 0230cb6..40e060b 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1782,6 +1797,10 @@ static int __init intel_opregion_present(void)
>  int acpi_video_register(void)
>  {
>         int result = 0;
> +       return -ENODEV;
>         if (register_count) {
>                 /*
>                  * if the function of acpi_video_register is already called,
>
> I also tested this kernel with merged
> git://people.freedesktop.org/~danvet/drm-intel drm-intel-next.
>
> Steps to reproduce:
> 1. $ setterm -blank 1
> 2. close LID
> 3. sleep 90
> 4. open LID
> 5. press key
> 6. close LID
>
> nothing happens here, the screen is still turned on, should be turned off
>
> 7. open LID
>
> backlight is on, but screen is black, but some artifacts are visible so
> LCD is probably turned off, and the display is not usable anymore
>
>
> I have bisected this problem and it's introduced by commit
> 120eced9efe7fdb5123db4ea47e9adee9b66284e
> (drm/i915: Set crtc DPMS mode to ON in intel_crtc_mode_set).
>
> In Linux 3.1 to 3.6 I've been using following workaround:
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 2163818..51ebb77 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -6000,10 +6000,12 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
>                                               x, y, old_fb);
>         drm_vblank_post_modeset(dev, pipe);
>
> +#if 0
>         if (ret)
>                 intel_crtc->dpms_mode = DRM_MODE_DPMS_OFF;
>         else
>                 intel_crtc->dpms_mode = DRM_MODE_DPMS_ON;
> +#endif
>
>         return ret;
>  }

Since a dpms ioctl call tends to follow a modeset, this likely only
results in that dpms call enabling the hw again. Can you please add
drm.debug=0xe to your kernel cmdline and boot into a 3.6 with this
hack applied, reproduce the issue and the attach the complete dmesg?

The below WARNs from 3.7 support that, we've simply improved the
code's ability to detect such problems. Can you please boot into a
kernel with the latest drm-intel-next-queued branch merged in, but no
other patches applied. Again please append drm.debug=0xe and then
attach the complete dmesg after you've reproduced the issue.

Please also compile your kernels with CONFIG_PRINTK_TIME=y, the
timestamps in dmesg help a lot in figuring things out.

Yours, Daniel

>
> Thanks,
>
> Krzysiek
>
> ---
> # lspci -v
> ...
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03) (prog-if 00 [VGA controller])
>         Subsystem: Hewlett-Packard Company NX6110/NC6120
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at d0400000 (32-bit, non-prefetchable) [size=512K]
>         I/O ports at 7000 [size=8]
>         Memory at c0000000 (32-bit, prefetchable) [size=256M]
>         Memory at d0480000 (32-bit, non-prefetchable) [size=256K]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [d0] Power Management version 2
>         Kernel driver in use: i915
>
> 00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
>         Subsystem: Hewlett-Packard Company NX6110/NC6120
>         Flags: bus master, fast devsel, latency 0
>         Memory at d0500000 (32-bit, non-prefetchable) [size=512K]
>         Capabilities: [d0] Power Management version 2
>
> $ dmesg
> ...
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3588 intel_modeset_check_state+0x612/0x640()
> Hardware name: NC6120(EK094ES)
> active connector not linked to encoder
> Pid: 420, comm: kworker/0:2 Not tainted 3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<8032336f>] ? acpi_lid_open+0x25/0x3e
>  [<8039962d>] ? intel_lid_notify+0x8d/0xb0
>  [<80151fb2>] ? notifier_call_chain+0x42/0x60
>  [<801522b4>] ? __blocking_notifier_call_chain+0x44/0x60
>  [<801522e7>] ? blocking_notifier_call_chain+0x17/0x20
>  [<80322e2a>] ? acpi_lid_send_state+0x7e/0xa2
>  [<80322e92>] ? acpi_button_notify+0x2f/0xae
>  [<8030511b>] ? acpi_device_notify+0xf/0x11
>  [<8030f5eb>] ? acpi_ev_notify_dispatch+0x2b/0x40
>  [<80302f08>] ? acpi_os_execute_deferred+0x18/0x21
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80302ef0>] ? acpi_os_wait_events_complete+0x14/0x14
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687cc ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3590 intel_modeset_check_state+0x5ef/0x640()
> Hardware name: NC6120(EK094ES)
> encoder->connectors_active not set
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<8032336f>] ? acpi_lid_open+0x25/0x3e
>  [<8039962d>] ? intel_lid_notify+0x8d/0xb0
>  [<80151fb2>] ? notifier_call_chain+0x42/0x60
>  [<801522b4>] ? __blocking_notifier_call_chain+0x44/0x60
>  [<801522e7>] ? blocking_notifier_call_chain+0x17/0x20
>  [<80322e2a>] ? acpi_lid_send_state+0x7e/0xa2
>  [<80322e92>] ? acpi_button_notify+0x2f/0xae
>  [<8030511b>] ? acpi_device_notify+0xf/0x11
>  [<8030f5eb>] ? acpi_ev_notify_dispatch+0x2b/0x40
>  [<80302f08>] ? acpi_os_execute_deferred+0x18/0x21
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80302ef0>] ? acpi_os_wait_events_complete+0x14/0x14
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687cd ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3594 intel_modeset_check_state+0x5a9/0x640()
> Hardware name: NC6120(EK094ES)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80131269>] ? warn_slowpath_null+0x19/0x20
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<8039962d>] ? intel_lid_notify+0x8d/0xb0
>  [<80151fb2>] ? notifier_call_chain+0x42/0x60
>  [<801522b4>] ? __blocking_notifier_call_chain+0x44/0x60
>  [<801522e7>] ? blocking_notifier_call_chain+0x17/0x20
>  [<80322e2a>] ? acpi_lid_send_state+0x7e/0xa2
>  [<80322e92>] ? acpi_button_notify+0x2f/0xae
>  [<8030511b>] ? acpi_device_notify+0xf/0x11
>  [<8030f5eb>] ? acpi_ev_notify_dispatch+0x2b/0x40
>  [<80302f08>] ? acpi_os_execute_deferred+0x18/0x21
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80302ef0>] ? acpi_os_wait_events_complete+0x14/0x14
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687ce ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:6968 intel_modeset_check_state+0x4c8/0x640()
> Hardware name: NC6120(EK094ES)
> encoder's hw state doesn't match sw tracking (expected 0, found 1)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<8039962d>] ? intel_lid_notify+0x8d/0xb0
>  [<80151fb2>] ? notifier_call_chain+0x42/0x60
>  [<801522b4>] ? __blocking_notifier_call_chain+0x44/0x60
>  [<801522e7>] ? blocking_notifier_call_chain+0x17/0x20
>  [<80322e2a>] ? acpi_lid_send_state+0x7e/0xa2
>  [<80322e92>] ? acpi_button_notify+0x2f/0xae
>  [<8030511b>] ? acpi_device_notify+0xf/0x11
>  [<8030f5eb>] ? acpi_ev_notify_dispatch+0x2b/0x40
>  [<80302f08>] ? acpi_os_execute_deferred+0x18/0x21
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80302ef0>] ? acpi_os_wait_events_complete+0x14/0x14
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687cf ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:1225 assert_pipe+0x95/0xa0()
> Hardware name: NC6120(EK094ES)
> pipe A assertion failure (expected off, current on)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80394a4e>] ? intel_modeset_check_state+0x39e/0x640
>  [<8039962d>] ? intel_lid_notify+0x8d/0xb0
>  [<80151fb2>] ? notifier_call_chain+0x42/0x60
>  [<801522b4>] ? __blocking_notifier_call_chain+0x44/0x60
>  [<801522e7>] ? blocking_notifier_call_chain+0x17/0x20
>  [<80322e2a>] ? acpi_lid_send_state+0x7e/0xa2
>  [<80322e92>] ? acpi_button_notify+0x2f/0xae
>  [<8030511b>] ? acpi_device_notify+0xf/0x11
>  [<8030f5eb>] ? acpi_ev_notify_dispatch+0x2b/0x40
>  [<80302f08>] ? acpi_os_execute_deferred+0x18/0x21
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80302ef0>] ? acpi_os_wait_events_complete+0x14/0x14
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d0 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3588 intel_modeset_check_state+0x612/0x640()
> Hardware name: NC6120(EK094ES)
> active connector not linked to encoder
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80393728>] ? intel_crtc_update_dpms+0x78/0x90
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d1 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3590 intel_modeset_check_state+0x5ef/0x640()
> Hardware name: NC6120(EK094ES)
> encoder->connectors_active not set
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80393728>] ? intel_crtc_update_dpms+0x78/0x90
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d2 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3594 intel_modeset_check_state+0x5a9/0x640()
> Hardware name: NC6120(EK094ES)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80131269>] ? warn_slowpath_null+0x19/0x20
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80393728>] ? intel_crtc_update_dpms+0x78/0x90
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d3 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:6968 intel_modeset_check_state+0x4c8/0x640()
> Hardware name: NC6120(EK094ES)
> encoder's hw state doesn't match sw tracking (expected 0, found 1)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d4 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:1225 assert_pipe+0x95/0xa0()
> Hardware name: NC6120(EK094ES)
> pipe A assertion failure (expected off, current on)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80394a4e>] ? intel_modeset_check_state+0x39e/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d5 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3588 intel_modeset_check_state+0x612/0x640()
> Hardware name: NC6120(EK094ES)
> active connector not linked to encoder
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394cc2>] ? intel_modeset_check_state+0x612/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d6 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3590 intel_modeset_check_state+0x5ef/0x640()
> Hardware name: NC6120(EK094ES)
> encoder->connectors_active not set
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394c9f>] ? intel_modeset_check_state+0x5ef/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d7 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:3594 intel_modeset_check_state+0x5a9/0x640()
> Hardware name: NC6120(EK094ES)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<80131269>] ? warn_slowpath_null+0x19/0x20
>  [<80394c59>] ? intel_modeset_check_state+0x5a9/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d8 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:6968 intel_modeset_check_state+0x4c8/0x640()
> Hardware name: NC6120(EK094ES)
> encoder's hw state doesn't match sw tracking (expected 0, found 1)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<80394b78>] ? intel_modeset_check_state+0x4c8/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687d9 ]---
> ------------[ cut here ]------------
> WARNING: at /home/krzysiek/src/linux-2.6/drivers/gpu/drm/i915/intel_display.c:1225 assert_pipe+0x95/0xa0()
> Hardware name: NC6120(EK094ES)
> pipe A assertion failure (expected off, current on)
> Pid: 420, comm: kworker/0:2 Tainted: G        W    3.7.0-rc6-00003-gddba8b4 #83
> Call Trace:
>  [<80131173>] ? warn_slowpath_common+0x73/0xb0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80131203>] ? warn_slowpath_fmt+0x33/0x40
>  [<8038e0d5>] ? assert_pipe+0x95/0xa0
>  [<80394a4e>] ? intel_modeset_check_state+0x39e/0x640
>  [<803570d7>] ? drm_fb_helper_dpms.isra.11+0x77/0xc0
>  [<8035755d>] ? drm_fb_helper_blank+0x4d/0x70
>  [<802f2f04>] ? fb_blank+0x44/0xb0
>  [<802fba09>] ? fbcon_blank+0x1d9/0x2d0
>  [<802314b2>] ? flush_commit_list+0x562/0x620
>  [<8014683a>] ? __queue_delayed_work+0xaa/0x140
>  [<801581c9>] ? dequeue_task_fair+0x29/0x1a0
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344ad5>] ? do_unblank_screen+0x95/0x1b0
>  [<80344ffc>] ? console_callback+0xec/0x110
>  [<80147224>] ? process_one_work+0x104/0x380
>  [<8013d963>] ? internal_add_timer+0x13/0x40
>  [<80344f10>] ? poke_blanked_console+0xb0/0xb0
>  [<80147797>] ? worker_thread+0x107/0x3a0
>  [<80147690>] ? rescuer_thread+0x1c0/0x1c0
>  [<8014bd7c>] ? kthread+0x8c/0xa0
>  [<806097b7>] ? ret_from_kernel_thread+0x1b/0x28
>  [<8014bcf0>] ? __kthread_parkme+0x60/0x60
> ---[ end trace 2fa112e1a3f687da ]---



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
