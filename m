Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab0GGVko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:40:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab0GGVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 00/18] VFS: turn no_llseek into the default
Date: Wed,  7 Jul 2010 23:40:02 +0200
Message-Id: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:1HZyHmU6j9bwEMImUCrNQsd8cQpuwr1GXaR7FRz93e6
 Af8dATefqvDJlWSLdRPQH+RUdq0YT9ChYNDjk4i07cPltpjNVO
 j4l5q6EYLwuiHgHaxnVX9Ad1KxnFyNxG9Dt21SjMlGIileWmUg
 XBQjsMwYvtYxCprmF2+m9RsMa5bxKSJv9ZZcYofYV00ynkyIFW
 PD5Yb85KD7DIqqqbGitSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I promised to Christoph Hellwig, this series
changes the default action for sys_llseek from
the traditional default_llseek to no_llseek,
disallowing users to seek files without a seek
operation, which is much more logical.

At the same time, this series makes it obvious
that the remaining users of the now explicitly
used default_llseek function do not require
the big kernel lock and we can consequently
replace it with i_mutex.

The bulk of the necessary changes is adding
a .llseek pointer to each and every
file_operation in the kernel using a coccinelle
semantic patch (patch 16 here). The semantic
patch only changes those cases that it can
prove to have an obviously correct replacement
operation, see the patch description for the
detailed rules it uses.

The remaining patches here are for the cases
that the semantic patch did not have an answer
for or that it did not find because it was
hidden in macros or in unexpected coding style.

I am confident that I have covered all users
in the current mainline kernel, but new
file_operations are already part of linux-next,
so the same semantic patch needs to be applied
to those.

The diffstat below intentionally covers only
the changes I did manually, leaving out patch
16.

	Arnd

Arnd Bergmann (18):
  drm: use noop_llseek
  net/wireless: use generic_file_llseek in debugfs
  lkdtm: use generic_file_llseek in debugfs
  ib/qib: use generic_file_llseek
  arm/omap: use generic_file_llseek in iommu_debug
  spufs: use llseek in all file operations
  staging: use llseek in all file operations
  selinux: use generic_file_llseek
  tracing: use generic_file_llseek for debugfs
  ibmasmfs: use generic_file_llseek
  oprofile: make event buffer nonseekable
  raw: use explicit llseek file operations
  ima: use generic_file_llseek for securityfs
  irda/irnet: use noop_llseek
  viotape: use noop_llseek
  llseek: automatically add .llseek fop
  vfs: don't use BKL in default_llseek
  vfs: make no_llseek the default

 Documentation/DocBook/drm.tmpl               |    1 
 arch/arm/plat-omap/iommu-debug.c             |    2 
 arch/powerpc/platforms/cell/spufs/file.c     |   24 ++++++++--
 drivers/char/raw.c                           |    2 
 drivers/char/viotape.c                       |    1 
 drivers/gpu/drm/i810/i810_drv.c              |    1 
 drivers/gpu/drm/i830/i830_drv.c              |    1 
 drivers/gpu/drm/i915/i915_drv.c              |    1 
 drivers/gpu/drm/mga/mga_drv.c                |    1 
 drivers/gpu/drm/nouveau/nouveau_drv.c        |    1 
 drivers/gpu/drm/r128/r128_drv.c              |    1 
 drivers/gpu/drm/radeon/radeon_drv.c          |    1 
 drivers/gpu/drm/savage/savage_drv.c          |    1 
 drivers/gpu/drm/sis/sis_drv.c                |    1 
 drivers/gpu/drm/tdfx/tdfx_drv.c              |    1 
 drivers/gpu/drm/via/via_drv.c                |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |    1 
 drivers/infiniband/hw/qib/qib_fs.c           |   18 +++----
 drivers/misc/ibmasm/ibmasmfs.c               |    4 +
 drivers/misc/iwmc3200top/debugfs.c           |    3 +
 drivers/misc/lkdtm.c                         |    9 +++
 drivers/net/wireless/b43/debugfs.c           |    1 
 drivers/net/wireless/b43legacy/debugfs.c     |    1 
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    3 +
 drivers/net/wireless/libertas/debugfs.c      |    1 
 drivers/net/wireless/rt2x00/rt2x00debug.c    |    1 
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    2 
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |    2 
 drivers/oprofile/event_buffer.c              |    3 -
 drivers/staging/msm/mdp4_debugfs.c           |   10 ----
 drivers/staging/panel/panel.c                |    3 -
 fs/read_write.c                              |    5 --
 kernel/trace/trace.c                         |   15 ++++++
 net/irda/irnet/irnet_ppp.h                   |    1 
 net/mac80211/debugfs.c                       |    2 
 net/mac80211/debugfs_key.c                   |    2 
 net/mac80211/debugfs_netdev.c                |    1 
 net/mac80211/debugfs_sta.c                   |    2 
 net/wireless/debugfs.c                       |    1 
 security/integrity/ima/ima_fs.c              |    9 ++-
 security/selinux/selinuxfs.c                 |   16 ++++++
 41 files changed, 129 insertions(+), 28 deletions(-)

