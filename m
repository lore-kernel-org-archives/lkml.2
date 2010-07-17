Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab0GQKIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:08:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49096 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab0GQKIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DUE9Rh7FV7mPC+AAlnTUCDYBJZla5HdOTKZ8JUtHH5JXwXoUwagZRbZja3+3/tLSvd
         sh6E9V1f5H2vtkzBluoZvFgmoepnC2183Wm/e6va2DcmXspGTpgonpVjIbCZXPOA+1F0
         EPfSsKyDtbG+LHrJfkNDR1ni5aX9GRo/u+bmo=
MIME-Version: 1.0
In-Reply-To: <1279299010-4723-1-git-send-email-bebarino@gmail.com>
References: <1279299010-4723-1-git-send-email-bebarino@gmail.com>
Date: Sat, 17 Jul 2010 12:08:37 +0200
Message-ID: <AANLkTinuIWwFVVe09YkhXDYjVCvB5i-_RN00Hb2BWd5i@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Fix lockdep warning in rt2x00lib_probe_dev()
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stephen Boyd <bebarino@gmail.com>
Cc: users@rt2x00.serialmonkey.com, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 6:50 PM, Stephen Boyd <bebarino@gmail.com> wrote:
> The rt2x00dev->intf_work workqueue is never initialized when a driver is
> probed for a non-existent device (in this case rt2500usb). On such a
> path we call rt2x00lib_remove_dev() to free any resources initialized
> during the probe before we use INIT_WORK to initialize the workqueue.
> This causes lockdep to get confused since the lock used in the workqueue
> hasn't been initialized yet but is now being acquired during
> cancel_work_sync() called by rt2x00lib_remove_dev().
>
> Fix this by initializing the workqueue first before we attempt to probe
> the device. This should make lockdep happy and avoid breaking any
> assumptions about how the library cleans up after a probe fails.
>
> phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 2027, comm: modprobe Not tainted 2.6.35-rc5+ #60
> Call Trace:
>  [<ffffffff8105fe59>] register_lock_class+0x152/0x31f
>  [<ffffffff81344a00>] ? usb_control_msg+0xd5/0x111
>  [<ffffffff81061bde>] __lock_acquire+0xce/0xcf4
>  [<ffffffff8105f6fd>] ? trace_hardirqs_off+0xd/0xf
>  [<ffffffff81492aef>] ?  _raw_spin_unlock_irqrestore+0x33/0x41
>  [<ffffffff810628d5>] lock_acquire+0xd1/0xf7
>  [<ffffffff8104f037>] ? __cancel_work_timer+0x99/0x17e
>  [<ffffffff8104f06e>] __cancel_work_timer+0xd0/0x17e
>  [<ffffffff8104f037>] ? __cancel_work_timer+0x99/0x17e
>  [<ffffffff8104f136>] cancel_work_sync+0xb/0xd
>  [<ffffffffa0096675>] rt2x00lib_remove_dev+0x25/0xb0 [rt2x00lib]
>  [<ffffffffa0096bf7>] rt2x00lib_probe_dev+0x380/0x3ed [rt2x00lib]
>  [<ffffffff811d78a7>] ? __raw_spin_lock_init+0x31/0x52
>  [<ffffffffa00bbd2c>] ? T.676+0xe/0x10 [rt2x00usb]
>  [<ffffffffa00bbe4f>] rt2x00usb_probe+0x121/0x15e [rt2x00usb]
>  [<ffffffff813468bd>] usb_probe_interface+0x151/0x19e
>  [<ffffffff812ea08e>] driver_probe_device+0xa7/0x136
>  [<ffffffff812ea167>] __driver_attach+0x4a/0x66
>  [<ffffffff812ea11d>] ? __driver_attach+0x0/0x66
>  [<ffffffff812e96ca>] bus_for_each_dev+0x54/0x89
>  [<ffffffff812e9efd>] driver_attach+0x19/0x1b
>  [<ffffffff812e9b64>] bus_add_driver+0xb4/0x204
>  [<ffffffff812ea41b>] driver_register+0x98/0x109
>  [<ffffffff813465dd>] usb_register_driver+0xb2/0x173
>  [<ffffffffa00ca000>] ? rt2500usb_init+0x0/0x20 [rt2500usb]
>  [<ffffffffa00ca01e>] rt2500usb_init+0x1e/0x20 [rt2500usb]
>  [<ffffffff81000203>] do_one_initcall+0x6d/0x17a
>  [<ffffffff8106cae8>] sys_init_module+0x9c/0x1e0
>  [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b
>
> Signed-off-by: Stephen Boyd <bebarino@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
