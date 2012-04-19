Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2DSQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:22:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab2DSQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:22:10 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andy Whitcroft <apw@canonical.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] [RFC] DRM locking issues during early open
Date: Thu, 19 Apr 2012 17:22:04 +0100
Message-Id: <1334852525-14950-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been carrying a (rather poor) patch for an issue we identified in
the DRM driver.  This issue is triggered when a DRM device is initialising
and userspace attempts to open it, typically in response to the sysfs
device added event.  Basically we allocate the minor numbers making
the device available, and then call the drm load callback.  Until this
completes the device is really not ready and these early opens typically
lead to oopses.

We have been using the following patch to avoid this by marking the minors
as in error until the load method has completed.  This avoids the early
open by simply erroring out the opens with EAGAIN.  Obviously we should
be delaying the open until the load method complete.

I include the existing patch for completness (it is not really ready for
merging) to illustrate the issue.  I think it is logical that the wait
should simply be delayed until the load has completed.  I am proposing
to include a wait queue associated with the idr cache for the drm minors
which we can use to allow open callers to wait_event_interruptible() on.
I'll be putting together a prototype shortly and will follow up with it.

Thoughts?

-apw

Andy Whitcroft (1):
  drm -- stop early access to drm devices

 drivers/gpu/drm/drm_fops.c     |    8 ++++++--
 drivers/gpu/drm/drm_pci.c      |    4 ++++
 drivers/gpu/drm/drm_platform.c |    4 ++++
 drivers/gpu/drm/drm_stub.c     |    2 +-
 4 files changed, 15 insertions(+), 3 deletions(-)

-- 
1.7.9.5

