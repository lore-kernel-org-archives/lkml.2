Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1KFTP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:15:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1KFTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:24 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 00/13] pwrite/pread rework
Date: Sun,  6 Nov 2011 20:13:47 +0100
Message-Id: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've finally managed to clean up my pwrite/pread rework. Major changes since the
first submission:
- fixed a bunch of bugs, some of them discovered by the intel-gpu-tools gem test
  suite
- extracted the clflush helper into common drm code as suggested by Chris
  Wilson.
- extended the prefault helpers in pagemap.h instead of rolling our own. Also
  add a patch to not prefault for writes (which change the userspace memory)
  before we're committed to the write. Both address issues raised by Keith
  Packard.

Why this is cool stuff:
- fixes the spurious -EFAULTS when handing in a pointer to a gem gtt mappings.
  See https://bugs.freedesktop.org/show_bug.cgi?id=38115
- Kills a bunch of code by dropping the practically useless ranged cpu read
  domain tracking and integrating the slow paths into the fast paths.
- Fixes pwrite/pread to use snooped cpu access on llc machines, hereby decently
  speeding up microbenchmarks.
- Paves the way for further clever tricks to reduce pressure on the mappable gtt
  area.

Reviews and comments highly welcome.

Yours, Daniel

Daniel Vetter (13):
  drm/i915: fall through pwrite_gtt_slow to the shmem slow path
  drm/i915: rewrite shmem_pwrite_slow to use copy_from_user
  drm/i915: rewrite shmem_pread_slow to use copy_to_user
  drm/i915: merge shmem_pwrite slow&fast-path
  drm/i915: merge shmem_pread slow&fast-path
  drm: add helper to clflush a virtual address range
  drm/i915: move clflushing into shmem_pread
  drm/i915: kill ranged cpu read domain support
  drm/i915: don't use gtt_pwrite on LLC cached objects
  drm/i915: don't call shmem_read_mapping unnecessarily
  mm: extend prefault helpers to fault in more than PAGE_SIZE
  drm/i915: drop gtt slowpath
  drm/i915: don't clobber userspace memory before commiting to the
    pread

 drivers/gpu/drm/drm_cache.c     |   23 ++
 drivers/gpu/drm/i915/i915_drv.h |    7 -
 drivers/gpu/drm/i915/i915_gem.c |  824 +++++++++++----------------------------
 include/drm/drmP.h              |    1 +
 include/linux/pagemap.h         |   28 +-
 5 files changed, 273 insertions(+), 610 deletions(-)

-- 
1.7.6.4

