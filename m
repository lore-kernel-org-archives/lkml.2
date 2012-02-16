Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2BPMEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:04:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58625 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2BPMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:04:52 -0500
MIME-Version: 1.0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] extend prefault helpers to fault in more than PAGE_SIZE
Date: Thu, 16 Feb 2012 13:01:35 +0100
Message-Id: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

drm/i915 has write/read paths to upload/download data to/from gpu buffer
objects. For a bunch of reasons we have special fastpaths with decent setup
costs, so when we fall back to the slow-path we don't fully recover to the
fastest fast-path when grabbing our locks again. This is also in parts due to
that we have multiple fallbacks to slower paths, so control-flow in our code
would get really ugly.

As part of a larger rewrite and re-tuning of these functions we've noticed that
the prefault helpers in pagemap.h only prefault up to PAGE_SIZE because that's
all the other users need. The follow-up patch extends this to abritary sizes so
that we can fully exploit our special fastpaths in more cases (we typically see
reads and writes of a few pages up to a few mb).

I'd like to get this in for 3.4. There's no functional dependency between this
patch and the drm/i915 rework (only performance effects), so this can go in
through -mm without causing merge issues.

If this or something similar isn't acceptable, plan B is to hand-roll these 2
functions in drm/i915. But I don't like nih these things in driver code much.

Comments highly welcome.

Yours, Daniel

For reference, the drm/i915 read/write rework is avaialable at:

http://cgit.freedesktop.org/~danvet/drm/log/?h=pwrite-pread

Unfortunately cgit.fd.o is currently on hiatus.

Daniel Vetter (1):
  mm: extend prefault helpers to fault in more than PAGE_SIZE

 include/linux/pagemap.h |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.7.7.5

