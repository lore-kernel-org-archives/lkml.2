Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0DWQJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:09:05 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:41847 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757901Ab0DWQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:09:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hIu5r/I2stwbM75nSk1oZMxFTPOXesFXTueSY8V9ACD1+96m50U49U7ucvH79kbnbn5QO+ooLO6PRG8Se1s1SnL2epWP8BPEoSR3X1ngKWUGpGm7+InPQt9kZvDA/p6R;
Date: Fri, 23 Apr 2010 09:08:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, eric@anholt.net,
       Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Subject: Re: i915_do_wait_request BUG: unable to handle kernel NULL pointer
  dereference at (null)
Message-ID: <20100423090857.728960b7@virtuousgeek.org>
In-Reply-To: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com>
References: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 12:24:25 +0200
Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> Hi
> 
> Just tried to boot current vanilla upstream kernel - and got pretty ugly  oops.
> Here is serial console catch after X-startup:
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa035de81>] i915_do_wait_request+0x101/0x4f0 [i915]
> PGD 139649067 PUD 133b5a067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/virtual/backlight/acpi_video0/actual_brightness
> CPU 0
> Modules linked in: xt_tcpudp bridge stp llc autofs4 sunrpc ipv6
> ipt_REJECT xt_physdev xt_state ]
> 

Here's the fix I'm testing now.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 7f52cc1..ef3d91d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1793,7 +1793,7 @@ i915_get_gem_seqno(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	if (IS_I965G(dev))
+	if (HAS_PIPE_CONTROL(dev))
 		return ((volatile u32 *)(dev_priv->seqno_page))[0];
 	else
 		return READ_HWSP(dev_priv, I915_GEM_HWS_INDEX);
