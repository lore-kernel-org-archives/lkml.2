Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0JLSQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:16:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:59717 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab0JLSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:16:18 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] V3 - atomic kernel mode setting for radeon, nouveau, plus fixes
Date: Tue, 12 Oct 2010 13:15:43 -0500
Message-Id: <1286907348-25817-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 12 Oct 2010 18:16:08.0939 (UTC) FILETIME=[8B16ABB0:01CB6A39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is new in patch set v3

  * Patch 3 - Per comment from Jesse Barnes change enter arg for
    mode_set_base_atomic() to be an enum
  * Patch 4 - Fixed a defect in the LUT save/restore where it should
    have used ctrc->gamma_size instead of the local size variable
  * Patch 5 - Context changes from the prior versions

---

What is new in patch set v2

  * patch 4 which was previously radeon specific was replaced with a
    generic patch to save and restore the LUT data for all drivers
  * minor white space cleanup vs checkpatch.pl in patches

---

The goal of this patch set is to add atomic kernel mode setting hooks
for the radeon and nouveau cards for the purpose of using kdb (the
kernel debug shell).

David Airlie had asked for more research into the gamma data
corruption after initially reviewing the patch that attempts to solve
the visible palette corruption after an atomic mode set operation.
The final conclusion was that other types of pallet corruption are
possible with the gamma data when using atomic mode setting so the
problem should be solved generically.

The mode_set_base_atomic() now receives and additional parameter to
note of the atomic mode set operation is an enter or exit such that a
driver can appropriately enable or disable hardware that will not work
in the polling context.

These patches have now passed the kgdb/kdb regression tests and are
deemed stable and ready for further integration and comment with the
hope of integrating the patches upstream.

Many thanks to Chris Ball for the contribution of the radeon and
nouveau hooks, as well as the time he spent helping debug the initial
LUT save and restore.

Thanks,
Jason.

---
The following changes since commit 29979aa8bd69becd94cbad59093807a417ce2a9e:
  Linus Torvalds (1):
        Merge branch 'rc-fixes' of git://git.kernel.org/.../mmarek/kbuild-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_dri

Chris Ball (3):
      drm/radeon/kms: Implement KDB debug hooks for radeon KMS.
      drm/nouveau/kms: Implement KDB debug hooks for nouveau KMS.
      drm/nouveau/kms: Avoid a hang entering KDB with VT accel on.

Jason Wessel (2):
      drm,kdb,kms: Add an enter argument to mode_set_base_atomic() API
      kdb,kms: Save and restore the LUT on atomic KMS enter/exit

 drivers/gpu/drm/drm_fb_helper.c             |   36 ++++++++-
 drivers/gpu/drm/i915/intel_display.c        |    5 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c     |    6 ++
 drivers/gpu/drm/nouveau/nv04_crtc.c         |   54 +++++++++++--
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   48 ++++++++---
 drivers/gpu/drm/radeon/atombios_crtc.c      |  117 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/radeon_fb.c          |    2 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   44 ++++++++---
 drivers/gpu/drm/radeon/radeon_mode.h        |   13 +++-
 include/drm/drm_crtc_helper.h               |    8 ++-
 10 files changed, 260 insertions(+), 73 deletions(-)
