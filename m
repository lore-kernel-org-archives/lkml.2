Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2HGSr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:47:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2HGSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:47:55 -0400
Message-ID: <502162D7.9090809@canonical.com>
Date: Tue, 07 Aug 2012 20:47:51 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>, rob.clark@linaro.org
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        patches@linaro.org
Subject: Re: [PATCH 1/3] dma-fence: dma-buf synchronization (v7)
References: <20120807175330.18745.81293.stgit@patser.local>
In-Reply-To: <20120807175330.18745.81293.stgit@patser.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-08-12 19:53, Maarten Lankhorst schreef:
> A dma-fence can be attached to a buffer which is being filled or consumed
> by hw, to allow userspace to pass the buffer without waiting to another
> device.  For example, userspace can call page_flip ioctl to display the
> next frame of graphics after kicking the GPU but while the GPU is still
> rendering.  The display device sharing the buffer with the GPU would
> attach a callback to get notified when the GPU's rendering-complete IRQ
> fires, to update the scan-out address of the display, without having to
> wake up userspace.

I implemented this for intel and debugged it with intel <-> nouveau
interaction. Unfortunately the nouveau patches aren't ready at this point,
but the git repo I'm using is available at:

http://cgit.freedesktop.org/~mlankhorst/linux/

It has the patch series and a sample implementation for intel, based on
drm-intel-next tree.

I tried to keep it deadlock and race condition free as much as possible,
but locking gets complicated enough that if I'm unlucky something might
have slipped through regardless.

Especially the locking in i915_gem_reset_requests, is screwed up.
This shows what a real PITA it is to abort callbacks prematurely while
keeping everything stable. As such, aborting requests should only be done
in exceptional circumstances, in this case hardware died and things are
already locked up anyhow..

~Maarten

