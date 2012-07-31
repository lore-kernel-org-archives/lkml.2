Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2GaH0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:26:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59421 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2GaH0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120730213656.0a9f6d30@neptune.home>
References: <20120730213656.0a9f6d30@neptune.home>
Date: Tue, 31 Jul 2012 09:26:07 +0200
Message-ID: <CANq1E4Tb1Er+O54rN3OteMXqeXAXDr4Z-dvY+RQxZW_NdAfifw@mail.gmail.com>
Subject: Re: [PATCH 0/7] HID: picoLCD updates
From: David Herrmann <dh.herrmann@googlemail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Jaya Kumar <jayalk@intworks.biz>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno

On Mon, Jul 30, 2012 at 9:36 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi,
>
> This series updates picoLCD driver:
> - split the driver functions into separate files which get included
>   depending on Kconfig selection
>   (implementation for CIR using RC_CORE will follow later)
> - drop private framebuffer refcounting in favor of refcounting added
>   to fb_info some time ago
> - fix various bugs issues
> - disabled firmware version checking in probe() as it does not work
>   anymore since commit 4ea5454203d991ec85264f64f89ca8855fce69b0
>   [HID: Fix race condition between driver core and ll-driver]
>
> Note: I still get weird behavior on quick unbind/bind sequences
> issued via sysfs (CONFIG_SMP=n system) that are triggered by framebuffer
> support and apparently more specifically fb_defio part of it.
>
> Unfortunately I'm out of ideas as to how to track down the problem which
> shows either as SLAB corruption (detected with SLUB debugging, e.g.
>
> [ 6383.521833] =============================================================================
> [ 6383.530020] BUG kmalloc-64 (Not tainted): Object already free
> [ 6383.530020] -----------------------------------------------------------------------------
> [ 6383.530020]
> [ 6383.530020] INFO: Slab 0xdde0ea20 objects=51 used=40 fp=0xcef516e0 flags=0x40000080
> [ 6383.530020] INFO: Object 0xcef51190 @offset=400 fp=0xcef51f50
> [ 6383.530020]
> [ 6383.530020] Bytes b4 cef51180: cc cc cc cc d0 12 f5 ce 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
> [ 6383.530020] Object cef51190: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 6383.530020] Object cef511a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 6383.530020] Object cef511b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 6383.530020] Object cef511c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> [ 6383.530020] Redzone cef511d0: bb bb bb bb                                      ....
> [ 6383.530020] Padding cef511d8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> [ 6383.530020] Pid: 1922, comm: bash Not tainted 3.5.0-jupiter-00003-g8d858b1-dirty #2
> [ 6383.530020] Call Trace:
> [ 6383.530020]  [<c10bd3cc>] print_trailer+0x11c/0x130
> [ 6383.530020]  [<c10bd415>] object_err+0x35/0x40
> [ 6383.530020]  [<c10be809>] free_debug_processing+0x99/0x200
> [ 6383.530020]  [<c10bf77e>] __slab_free+0x2e/0x280
> [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> [ 6383.530020]  [<c1322870>] ? __usbhid_submit_report+0xc0/0x3c0
> [ 6383.530020]  [<c10bfbda>] ? kfree+0xfa/0x110
> [ 6383.530020]  [<de932aa4>] ? picolcd_debug_out_report+0x8c4/0x8e0 [hid_picolcd]
> [ 6383.530020]  [<c10bfbda>] kfree+0xfa/0x110
> [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> [ 6383.530020]  [<c1322284>] ? hid_submit_out+0xa4/0x120
> [ 6383.530020]  [<c1322284>] hid_submit_out+0xa4/0x120
> [ 6383.530020]  [<c1322908>] __usbhid_submit_report+0x158/0x3c0
> [ 6383.530020]  [<c1322c2b>] usbhid_submit_report+0x1b/0x30
> [ 6383.530020]  [<de930789>] picolcd_fb_reset+0xb9/0x180 [hid_picolcd]
> [ 6383.530020]  [<de930f1d>] picolcd_init_framebuffer+0x20d/0x2e0 [hid_picolcd]
> [ 6383.530020]  [<de92fb9c>] picolcd_probe+0x3cc/0x580 [hid_picolcd]
> [ 6383.530020]  [<c1319147>] hid_device_probe+0x67/0xf0
> [ 6383.530020]  [<c1282f97>] ? driver_sysfs_add+0x57/0x80
> [ 6383.530020]  [<c128329d>] driver_probe_device+0xbd/0x1c0
> [ 6383.530020]  [<c1318a1b>] ? hid_match_device+0x7b/0x90
> [ 6383.530020]  [<c12821e5>] driver_bind+0x75/0xd0
> [ 6383.530020]  [<c1282170>] ? driver_unbind+0x90/0x90
> [ 6383.530020]  [<c12818b7>] drv_attr_store+0x27/0x30
> [ 6383.530020]  [<c1114aec>] sysfs_write_file+0xac/0xf0
> [ 6383.530020]  [<c10c794c>] vfs_write+0x9c/0x130
> [ 6383.530020]  [<c10d4a1f>] ? sys_dup3+0x11f/0x160
> [ 6383.530020]  [<c1114a40>] ? sysfs_poll+0x90/0x90
> [ 6383.530020]  [<c10c7bbd>] sys_write+0x3d/0x70
> [ 6383.530020]  [<c13f2557>] sysenter_do_call+0x12/0x26
> [ 6383.530020] FIX kmalloc-64: Object at 0xcef51190 not freed
>
> or worse spontaneous reboot of the system without any trace on netconsole or
> serial console.
>
> echo $devid > bind; echo $devid > unbind
> or
> echo $devid > bind; echo $devid > unbind; sleep 0.2; echo $devid > bind; echo $devid > unbind
>
> is sufficient to trigger the above issue while waiting a few seconds between bind and unbind
> shows no sign of trouble.
>
> Suggestions as to how to debug this and fix it are welcome!

This is not directly related to this patchset, but did you fix the
locking issue with hid-core? It is still on my todo-list but I haven't
gotten around fixing it, yet. However, I plan on fixing it this
summer, but if picolcd does not require it, it's probably not worth
the work.

Regards
David
