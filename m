Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2HRSuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:50:14 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:43926 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HRSuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:50:10 -0400
Date: Sat, 18 Aug 2012 20:49:24 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120818204924.3f61d4f5@neptune.home>
In-Reply-To: <20120818154828.0e992bfe@neptune.home>
References: <20120818144039.0356cc7c@neptune.home>
	<Pine.LNX.4.44L0.1208180913440.17394-100000@netrider.rowland.org>
	<20120818154828.0e992bfe@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 August 2012 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> One thing I just though about, how does usbhid handle the calls to
> usbhid_submit_report() when hid_hw_stop()/hid_hw_close() have already
> been called?
> I will attempt to see if it makes a difference to shortcut my
> usbhid_submit_report() calls from the point on I have called hid_hw_close()...

I don't know if I'm progressing or just drawing circles...

I included a check right before calling usbhid_submit_report() to prevent
calling it if hid_hw_close()/hid_hw_stop() has been called and that part
works as expected, just that at some moment it explodes on a NULL-pointer
dereference.

Initially I had usbhid_submit_report macro:
#define usbhid_submit_report(a, b, c) \
        do { \
                picolcd_debug_out_report(d, a, b); \
                usbhid_submit_report(a, b, c); \
        } while (0)

Now to make sure no new reports get submitted once hid_hw_stop()
was called I changed it to:
#define usbhid_submit_report(a, b, c) \
        do { \
                struct picolcd_data *d = hid_get_drvdata(a); \
                unsigned long flags; \
                picolcd_debug_out_report(d, a, b); \
                spin_lock_irqsave(&d->lock, flags); \
                if (!(d->status & PICOLCD_FAILED)) \
                        usbhid_submit_report(a, b, c); \
                else \
                        printk(KERN_INFO "Submitting report after hw_stop!\n"); \
                spin_unlock_irqrestore(&d->lock, flags); \
        } while (0)
with the printk() to spam dmesg :)


The NULL-pointer dereference I got inside picolcd_fb_deferred_io() was due
to me calling hid_set_drvdata(hdev, NULL) too early in remove(), fixed.


But with that fixed I still encounter the bad page, probably around
the time of hid_hw_stop(), though it always takes the HARD LOCK watchdog
to trigger for the trace to show (probably because or IRQ context):

It seems to happen during the bind/unbind following the unbind that
produces a
     hid-picolcd 0003:04D8:C002.0003: usb_submit_urb(out) failed: -1
either a BUG or even as reboot and happend between hid_hw_close() and
hid_hw_stop() though my extra printks seem to reduce probability of
bad things to happen.


[ 1217.643017] BUG: unable to handle kernel paging request at c7cb0000
[ 1217.643017] IP: [<c11e2be7>] _mmx_memcpy+0x27/0x16c
[ 1217.643017] *pde = 19078063 *pte = 07cb0161 
[ 1217.643017] Oops: 0003 [#1] 
[ 1217.643017] Modules linked in: hid_picolcd fb_sys_fops sysimgblt sysfillrect syscopyarea drm_kms_helper nfs3 nfs_acl nfs lockd sunrpc
[ 1217.643017] Pid: 0, comm: swapper Not tainted 3.6.0-rc2-jupiter-00008-gd3c2b0c-dirty #2 NVIDIA Corporation. nFORCE-MCP/MS-6373
[ 1217.643017] EIP: 0060:[<c11e2be7>] EFLAGS: 00010013 CPU: 0
[ 1217.643017] EIP is at _mmx_memcpy+0x27/0x16c
[ 1217.643017] EAX: dd40a000 EBX: dd6ea010 ECX: 035af77b EDX: d9108c80
[ 1217.643017] ESI: d9121c00 EDI: c7cb0000 EBP: dd40bebc ESP: dd40bea0
[ 1217.643017]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1217.643017] CR0: 8005003b CR2: c7cb0000 CR3: 1cf1c000 CR4: 000007d0
[ 1217.643017] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1217.643017] DR6: ffff0ff0 DR7: 00000400
[ 1217.643017] Process swapper (pid: 0, ti=dd40a000 task=c15d24c0 task.ti=c15c6000)
[ 1217.643017] Stack:
[ 1217.643017]  0d6d6d6f dd40beac c109bba4 c7c97080 dd6ea010 c7c97080 dceb3030 dd40bee4
[ 1217.643017]  c133b364 c7d40000 c7d40000 dd40bed4 dceb3030 d9108c80 dd6ea010 00000046
[ 1217.643017]  dceb3030 dd40bf04 c133bea0 0000d6d6 dbe901b0 fffffffe dbe901b0 fffffffe
[ 1217.643017] Call Trace:
[ 1217.643017]  [<c109bba4>] ? free_compound_page+0x14/0x20
[ 1217.643017]  [<c133b364>] hid_submit_out+0xa4/0x130
[ 1217.643017]  [<c133bea0>] hid_irq_out+0xa0/0x100
[ 1217.643017]  [<c12e425e>] usb_hcd_giveback_urb+0x4e/0x90
[ 1217.643017]  [<c12f9bd2>] finish_urb+0xb2/0xf0
[ 1217.643017]  [<c12fa8a8>] finish_unlinks+0x168/0x320
[ 1217.643017]  [<c12fc43f>] ohci_irq+0x27f/0x300
[ 1217.643017]  [<c1077790>] ? unmask_irq+0x20/0x20
[ 1217.643017]  [<c12e3ace>] usb_hcd_irq+0x1e/0x40
[ 1217.643017]  [<c107549d>] handle_irq_event_percpu+0x6d/0x1c0
[ 1217.643017]  [<c1077790>] ? unmask_irq+0x20/0x20
[ 1217.643017]  [<c1075618>] handle_irq_event+0x28/0x40
[ 1217.643017]  [<c107781a>] handle_fasteoi_irq+0x8a/0xe0
[ 1217.643017]  <IRQ> 
[ 1217.643017]  [<c1003e0a>] ? do_IRQ+0x3a/0xb0
[ 1217.643017]  [<c140c870>] ? common_interrupt+0x30/0x38
[ 1217.643017]  [<c1009028>] ? default_idle+0x68/0xd0
[ 1217.643017]  [<c1009a0f>] ? cpu_idle+0x8f/0xc0
[ 1217.643017]  [<c13ffe97>] ? rest_init+0x67/0x70
[ 1217.643017]  [<c161b8b8>] ? start_kernel+0x2a3/0x2aa
[ 1217.643017]  [<c161b3da>] ? repair_env_string+0x51/0x51
[ 1217.643017]  [<c161b28e>] ? i386_start_kernel+0x44/0x46
[ 1217.643017] Code: 90 90 90 90 55 89 e5 57 56 89 d6 53 83 ec 10 89 45 f0 89 4d e4 89 e0 25 00 e0 ff ff f7 40 14 00 ff ff 07 74 17 c1 e9 02 8b 7d f0 <f3> a5 8b 4d e4 83 e1 03 74 02 f3 a4 e9 27 01 00 00 8b 45 1
[ 1217.643017] EIP: [<c11e2be7>] _mmx_memcpy+0x27/0x16c SS:ESP 0068:dd40bea0
[ 1217.643017] CR2: 00000000c7cb0000
[ 1217.643017] ---[ end trace fbaa4c5261e1a846 ]---

Bruno
