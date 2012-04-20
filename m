Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2DTJkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:40:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2DTJkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <1334852525-14950-1-git-send-email-apw@canonical.com>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
Date: Fri, 20 Apr 2012 10:40:35 +0100
Message-ID: <CAPM=9tzC5M-K-irN=Dw3Ai+2ExUj_vSCVYUj-qpmccHLAeaifA@mail.gmail.com>
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
From: Dave Airlie <airlied@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 5:22 PM, Andy Whitcroft <apw@canonical.com> wrote:
> We have been carrying a (rather poor) patch for an issue we identified in
> the DRM driver.  This issue is triggered when a DRM device is initialising
> and userspace attempts to open it, typically in response to the sysfs
> device added event.  Basically we allocate the minor numbers making
> the device available, and then call the drm load callback.  Until this
> completes the device is really not ready and these early opens typically
> lead to oopses.
>
> We have been using the following patch to avoid this by marking the minors
> as in error until the load method has completed.  This avoids the early
> open by simply erroring out the opens with EAGAIN.  Obviously we should
> be delaying the open until the load method complete.
>
> I include the existing patch for completness (it is not really ready for
> merging) to illustrate the issue.  I think it is logical that the wait
> should simply be delayed until the load has completed.  I am proposing
> to include a wait queue associated with the idr cache for the drm minors
> which we can use to allow open callers to wait_event_interruptible() on.
> I'll be putting together a prototype shortly and will follow up with it.
>
> Thoughts?

I've just revisited this, maybe I'm going insane but why does
drm_global_mutex not stop this?

drm_get_pci_dev takes drm_global_mutex before calling drm_fill_in_dev
and drm_get_minor.

Now the fops should be pointing at stub_open at this point, as we
won't have switched to the per device fops yet,
and one of the first things drm_stub_open does is take the
drm_global_mutex before doing the idr lookup.

So is the problem opening some sysfs or proc file early?

Dave.


>
> -apw
>
> Andy Whitcroft (1):
>  drm -- stop early access to drm devices
>
>  drivers/gpu/drm/drm_fops.c     |    8 ++++++--
>  drivers/gpu/drm/drm_pci.c      |    4 ++++
>  drivers/gpu/drm/drm_platform.c |    4 ++++
>  drivers/gpu/drm/drm_stub.c     |    2 +-
>  4 files changed, 15 insertions(+), 3 deletions(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
