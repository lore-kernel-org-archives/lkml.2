Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1JYJyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:54:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58319 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001Ab1JYJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:54:51 -0400
Date: Tue, 25 Oct 2011 11:54:48 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for 3.2
Message-ID: <20111025095447.GE31508@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these updates for the regmap API for 3.2.  In terms of the
core API the major features for the API itself are:

 - Porting over of the ASoC register cache infrastructure so it can be
   shared with more subsystems.
 - Support for a wider range of SPI register formats.
 - Debugfs and tracepoint code to support driver development.

plus a bunch of driver updates converting drivers over to the API which
depend on the core changes - the diffstat for the wm831x driver isn't
great because it adds descriptions of the registers to make the cache
and debug infrastructure much more useful, the amount of code has shrunk
but we've now got more data.

There's one patch converting the wm831x driver to use the register cache
code which hasn't hit -next due to Stephen Rothwell's holiday - it a one
line patch which has been percolating in my tree for a while and all the
users of this driver in tree are boards I maintain.

As the pull request is against 3.1-rc1 there's a couple of small bugfix
patches in here which you've already pulled into 3.1, I'm not sure if
there's a sensible way to deal with show those in the pull request other
than doing a merge up of 3.1?

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://opensource.wolfsonmicro.com/regmap.git for-linus

Dimitris Papastamos (19):
      regmap: Introduce caching support
      regmap: Add the indexed cache support
      regmap: Add the rbtree cache support
      regmap: Add the LZO cache support
      regmap: Add the regcache_sync trace event
      regmap: Incorporate the regcache core into regmap
      regmap: Remove redundant member `word_size' from regcache_rbtree_node
      regmap: Fix signed/unsigned comparison
      regmap: Implement generic syncing functionality
      regmap: Fix regcache_sync generic implementation
      regmap: Modify map->cache_bypass directly
      regmap: Grab the lock in regcache_cache_only()
      regmap: Make _regmap_write() global
      regmap: Lock the sync path, ensure we use the lockless _regmap_write()
      regmap: Save/restore the bypass state upon syncing
      regmap: Implement regcache_cache_bypass helper function
      regmap: Ensure we scream if we enable cache bypass/only at the same time
      regmap: Optimize the lookup path to use binary search
      regmap: Fix doc comment

Lars-Peter Clausen (4):
      regmap: Add support for device specific write and read flag masks.
      regmap: Make debugfs stubs static inline
      regmap: regcache_rbtree_{set,get}_register: Use regcache_{set,get}_val
      regmap: rbtree-cache: Move cached rbnode handling into lookup function

Mark Brown (48):
      regmap: Fix bulk reads
      regmap: Add kerneldoc for struct regmap_config
      regmap: Allow devices to specify which registers are accessible
      regmap: Add precious registers to the driver interface
      regmap: Just send the buffer directly for single register writes
      Merge branches 'regmap-linus' and 'regmap-interface' into regmap-next
      regmap: Add basic tracepoints
      regmap: Implement writable register checks
      regmap: Use a local header for API internals
      regmap: Provide register map dump via debugfs
      regmap: Skip precious registers when dumping registers via debugfs
      regmap: Fix kerneldoc errors for regmap
      Merge branch 'regmap-interface' into regmap-next
      regmap: Use int rather than size_t for lengths when logging blocks
      regmap: Fix type of field width specifiers for x86_64
      regmap: Remove unused type and list fields from bus interface
      Merge branch 'regmap-linus' into regmap-next
      regmap: Add functions to check for access on registers
      regmap: Share some of the debugfs infrastructure ready for more files
      regmap: Provide access information via debugfs
      regmap: Allow drivers to specify register defaults
      Merge branch 'regmap-interface' into regmap-next
      mfd: Convert WM831x to use regmap API
      mfd: Provide regmap register access info from wm831x driver
      mfd: Use device ID matching for WM831x SPI driver
      mfd: Convert WM8994 to use new register map API
      mfd: Convert WM8400 to regmap API
      Merge branch 'regmap-mfd' into regmap-next
      regmap: Remove bitrotted module_put()s
      Merge branch 'regmap-linus' into regmap-next
      regmap: Remove redundant owner field from the bus type struct
      regmap: Include the last register in debugfs output
      regmap: Provide device read and write map interface for merging
      Merge branch 'regmap-interface' into regmap-next
      regmap: A cache type of _NONE behaves like a bypassed cache
      regmap: Prototype regcache_sync()
      regmap: Allow drivers to control cache_only flag
      mfd: Support software initiated shutdown of WM831x PMICs
      regmap: Fix lock used for regcache_cache_only()
      regmap: Fix apostrophe usage
      regmap: Use bsearch() to search the register defaults
      regmap: Return a sensible error code if we fail to read the cache
      regmap: Warn on raw I/O as well as bulk reads that bypass cache
      regmap: Allow rbtree to cache zero default values
      regmap: Ensure rbtree syncs registers set to zero properly
      regmap: Allow caches for devices with no defaults
      regmap: Support some block operations on cached devices
      mfd: Enable rbtree cache for wm831x devices

Stephen Warren (1):
      regmap: Specify a module license

 drivers/base/regmap/Kconfig            |    2 +
 drivers/base/regmap/Makefile           |    3 +-
 drivers/base/regmap/internal.h         |  128 ++++++++++
 drivers/base/regmap/regcache-indexed.c |   64 +++++
 drivers/base/regmap/regcache-lzo.c     |  361 ++++++++++++++++++++++++++
 drivers/base/regmap/regcache-rbtree.c  |  345 +++++++++++++++++++++++++
 drivers/base/regmap/regcache.c         |  401 +++++++++++++++++++++++++++++
 drivers/base/regmap/regmap-debugfs.c   |  209 +++++++++++++++
 drivers/base/regmap/regmap-i2c.c       |    3 +-
 drivers/base/regmap/regmap-spi.c       |    4 +-
 drivers/base/regmap/regmap.c           |  228 +++++++++++++----
 drivers/mfd/Kconfig                    |    3 +
 drivers/mfd/wm831x-core.c              |  437 ++++++++++++++++++++++++++++----
 drivers/mfd/wm831x-i2c.c               |   76 ++----
 drivers/mfd/wm831x-spi.c               |  204 +++------------
 drivers/mfd/wm8400-core.c              |  106 ++------
 drivers/mfd/wm8994-core.c              |  178 +++-----------
 include/linux/mfd/wm831x/core.h        |   12 +-
 include/linux/mfd/wm831x/pdata.h       |    3 +
 include/linux/mfd/wm8400-private.h     |    7 +-
 include/linux/mfd/wm8994/core.h        |    9 +-
 include/linux/regmap.h                 |   79 ++++++-
 include/trace/events/regmap.h          |  136 ++++++++++
 23 files changed, 2426 insertions(+), 572 deletions(-)
 create mode 100644 drivers/base/regmap/internal.h
 create mode 100644 drivers/base/regmap/regcache-indexed.c
 create mode 100644 drivers/base/regmap/regcache-lzo.c
 create mode 100644 drivers/base/regmap/regcache-rbtree.c
 create mode 100644 drivers/base/regmap/regcache.c
 create mode 100644 drivers/base/regmap/regmap-debugfs.c
 create mode 100644 include/trace/events/regmap.h
