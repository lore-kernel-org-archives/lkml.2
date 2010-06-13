Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0FMTty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 15:49:54 -0400
Received: from thunk.org ([69.25.196.29]:36870 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab0FMTtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 15:49:53 -0400
Date: Sun, 13 Jun 2010 15:49:49 -0400
From: tytso@mit.edu
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Message-ID: <20100613194949.GC8055@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
 <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 06:23:45PM +1000, Dave Airlie wrote:
> 
> Its an output polling feature of KMS, however it shouldn't cause
> disruption elsewhere, but we are holding a mutex in there that there
> isn't a real need to hold, so I suspect I'll drop that.

> What GPU is it?

It's a Lenovo T400, with an Intel GPU:

(--) PCI:*(0:0:2:0) 8086:2a42:17aa:20e4 Intel Corporation Mobile 4 Series Chipse
t Integrated Graphics Controller rev 7, Mem @ 0xf4400000/4194304, 0xd0000000/268
435456, I/O @ 0x00001800/8

Why does KMS need to poll so frequently?  40 minutes of CPU time
accumulated in 4 hours of uptime translates to 16% of the CPU being
consumed by kslowd daemons, which seems... excessive.

I've seen upgraded the userspace to Ubuntu Lucid (from Karmic) and the
kernel to a post 2.6.35-rc2 (without the vt memory corruptor), and
after 4 days, 5 hours of uptime, and I'm seeing something better:

root      6390  4.7  0.0      0     0 ?        S<   Jun12  49:12 [kslowd001]
root      6784  2.4  0.0      0     0 ?        S<   Jun09 150:50 [kslowd003]
root     20047  2.7  0.0      0     0 ?        S<   Jun10 122:38 [kslowd002]
root     32324  4.6  0.0      0     0 ?        S<   Jun12  49:54 [kslowd000]

So that's 372 minutes of CPU time accumulated by kslowd in 6060
minutes, or about 6% of the CPU --- but part of tha time the laptop
was suspended --- and it still seems high.

I have the following patch which I'm going to install later tonight to
see if I can figure out if it really is drm_crtc_helper.c which is
really responsible for all of the kslowd time being burned, but an
examination of the source doesn't seem to show any other that I'm
using that would likely be using the slow workqueue.

						- Ted


commit bd69ab2e31a329ad9d660e23a1dc806ae0a3afbd
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 12 21:54:03 2010 -0400

    Add slow workqueue debuging for drm_crtc_helper.c

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 9b2a541..e536e80 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -860,6 +860,16 @@ static void output_poll_execute(struct slow_work *work)
 	}
 }
 
+#ifdef CONFIG_SLOW_WORK_DEBUG
+static void drm_op_desc(struct slow_work *work, struct seq_file *m)
+{
+	struct delayed_slow_work *delayed_work = container_of(work, struct delayed_slow_work, work);
+	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_slow_work);
+
+	seq_printf(m, "DRM_CRTC_HELPER: %s", dev->devname);
+}
+#endif
+
 void drm_kms_helper_poll_disable(struct drm_device *dev)
 {
 	if (!dev->mode_config.poll_enabled)
@@ -917,4 +927,7 @@ EXPORT_SYMBOL(drm_helper_hpd_irq_event);
 
 static struct slow_work_ops output_poll_ops = {
 	.execute = output_poll_execute,
+#ifdef CONFIG_SLOW_WORK_DEBUG
+	.desc = drm_op_desc,
+#endif
 };

