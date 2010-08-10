Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0HJAOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:14:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:35107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab0HJAOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:14:40 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Aug 2010 10:14:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19552.39399.490494.51990@notabene.brown>
Subject: [REVISED PULL REQUEST] md updates for 2.6.36
X-Mailer: VM 8.1.0 under 22.3.1 (x86_64-pc-linux-gnu)
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: David Woodhouse <dwmw2@infradead.org>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 here is a revised pull request for md updates for 2.6.36.

 To the previous patches (which are unchanged) it adds some work by
 David Woodhouse which moves the RAID6 computations out of drivers/md/
 and places them in /lib so they can be used by other code -
 e.g. btrfs.
 The RAID6 code is completely unchanged (it was already accessed under
 the async-crypto interface so not changes are need to the API).  Only
 it's location and the fact that it can be a stand alone module
 (rather than being in the same module as the rest of md/raid6) has
 changed.

Thanks,
NeilBrown



The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-08-08 10:10:11 -0700)

are available in the git repository at:

  git://neil.brown.name/md for-linus

Dan Williams (1):
      md: move revalidate_disk() back outside open_mutex

David Woodhouse (3):
      md: Factor out RAID6 algorithms into lib/
      async_tx: Move ASYNC_RAID6_TEST option to crypto/async_tx/, fix dependencies
      Merge branch 'async' of macbook:git/btrfs-unstable

NeilBrown (22):
      md: reduce dependence on sysfs.
      md/raid5: factor out code for changing size of stripe cache.
      md/raid5: ensure we create a unique name for kmem_cache when mddev has no gendisk
      md: be more careful setting MD_CHANGE_CLEAN
      md: split out md_rdev_init
      md: export various start/stop interfaces
      md: add support for raising dm events.
      raid5: Don't set read-ahead when there is no queue
      md/raid5: export is_congested test
      md/raid5: add simple plugging infrastructure.
      md/plug: optionally use plugger to unplug an array during resync/recovery.
      md/raid5: export raid5 unplugging interface.
      md/bitmap: white space clean up and similar.
      md/bitmap: reduce dependence on sysfs.
      md/bitmap: clean up plugging calls.
      md/bitmap: optimise scanning of empty bitmaps.
      md/bitmap: prepare for storing write-intent-bitmap via dm-dirty-log.
      md/bitmap:  separate out loading a bitmap from initialising the structures.
      md/raid10: fix deadlock with unaligned read during resync
      md: fix another deadlock with removing sysfs attributes.
      md: clean up do_md_stop
      Merge git://git.infradead.org/users/dwmw2/libraid-2.6 into for-linus

 crypto/async_tx/Kconfig                      |   14 +
 drivers/md/Kconfig                           |   18 +-
 drivers/md/Makefile                          |   77 ----
 drivers/md/bitmap.c                          |  508 ++++++++++++++------------
 drivers/md/bitmap.h                          |    6 +
 drivers/md/md.c                              |  286 +++++++++------
 drivers/md/md.h                              |   55 +++-
 drivers/md/raid10.c                          |   18 +
 drivers/md/raid5.c                           |  168 +++++----
 drivers/md/raid5.h                           |    9 +-
 lib/Kconfig                                  |    3 +
 lib/Makefile                                 |    1 +
 lib/raid6/Makefile                           |   78 ++++
 {drivers/md => lib/raid6}/mktables.c         |    0
 {drivers/md => lib/raid6}/raid6algos.c       |    0
 {drivers/md => lib/raid6}/raid6altivec.uc    |    0
 {drivers/md => lib/raid6}/raid6int.uc        |    0
 {drivers/md => lib/raid6}/raid6mmx.c         |    0
 {drivers/md => lib/raid6}/raid6recov.c       |    0
 {drivers/md => lib/raid6}/raid6sse1.c        |    0
 {drivers/md => lib/raid6}/raid6sse2.c        |    0
 {drivers/md => lib/raid6}/raid6test/Makefile |    0
 {drivers/md => lib/raid6}/raid6test/test.c   |    0
 {drivers/md => lib/raid6}/raid6x86.h         |    0
 {drivers/md => lib/raid6}/unroll.awk         |    0
 25 files changed, 740 insertions(+), 501 deletions(-)
 create mode 100644 lib/raid6/Makefile
 rename {drivers/md => lib/raid6}/mktables.c (100%)
 rename {drivers/md => lib/raid6}/raid6algos.c (100%)
 rename {drivers/md => lib/raid6}/raid6altivec.uc (100%)
 rename {drivers/md => lib/raid6}/raid6int.uc (100%)
 rename {drivers/md => lib/raid6}/raid6mmx.c (100%)
 rename {drivers/md => lib/raid6}/raid6recov.c (100%)
 rename {drivers/md => lib/raid6}/raid6sse1.c (100%)
 rename {drivers/md => lib/raid6}/raid6sse2.c (100%)
 rename {drivers/md => lib/raid6}/raid6test/Makefile (100%)
 rename {drivers/md => lib/raid6}/raid6test/test.c (100%)
 rename {drivers/md => lib/raid6}/raid6x86.h (100%)
 rename {drivers/md => lib/raid6}/unroll.awk (100%)
