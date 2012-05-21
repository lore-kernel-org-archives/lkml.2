Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2EUKim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:38:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46438 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168Ab2EUKil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:38:41 -0400
Date: Mon, 21 May 2012 11:38:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for 3.5
Message-ID: <20120521103837.GA4983@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6560ffd1ccd688152393dc7c35dbdcc33140633b:

  regmap: fix possible memory corruption in regmap_bulk_read() (2012-05-09 15:44:11 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.5

for you to fetch changes up to c948ef3ae71c18c1079333b65d6887ceb4577618:

  mfd: palmas PMIC device support Kconfig (2012-05-18 16:54:48 +0100)

----------------------------------------------------------------
regmap: Updates for 3.5

A surprisingly large series of updates for regmap this time, mostly due
to all the work Stephen Warren has done to add support for MMIO buses.
This wasn't really the target for the framework but it turns out that
there's a reasonable number of cases where it's very helpful to use the
register cache support to allow the register map to remain available
while the device is suspended.

- A MMIO bus implementation, contributed by Stephen Warren. Currently this
  is limited to 32 bit systems and native endian registers.
- Support for naming register maps, mainly intended for MMIO devices with
  multiple register banks. This was also contributed by Stephen Warren.
- Support for register striding, again contributed by Stephen Warren and
  mainly intended for use with MMIO as typically the registers will be a
  fixed size but byte addressed.
- irqdomain support for the generic regmap irq_chip, including support
  for dynamically allocate interrupt numbers.
- A function dev_get_regmap() which allows frameworks using regmap to
  obtain the regmap for a device from the struct device, making life a
  little simpler for them.
- Updates to regmap-irq to support more chips (contributed by Graeme
  Gregory) and to use irqdomains.
- Support for devices with 24 bit register addresses.

The striding support collided with all the topic branches so the
branches look a bit messy and eventually I just gave up.  There's also
the TI Palmas driver and a couple of other isolated MFD patches that
all depend on new regmap features so are being merged here.

----------------------------------------------------------------
Ashish Jangam (1):
      regmap: Converts group operation into single read write operations

Graeme Gregory (3):
      regmap: add support for non contiguous status to regmap-irq
      mfd: palmas PMIC device support
      mfd: palmas PMIC device support Kconfig

Marc Reilly (2):
      regmap: Add support for device with 24 data bits.
      regmap: Use pad_bits and reg_bits when determining register format.

Mark Brown (11):
      Merge branches 'regmap-core', 'regmap-mmio' and 'regmap-naming' into regmap-stride
      regmap: Cache single values read from the chip
      regmap: Devices using format_write don't support bulk operations
      regmap: Implement dev_get_regmap()
      Merge tag 'regmap-3.4' into regmap-stride
      mfd: da9052: Fix genirq abuse
      regmap: Pass back the allocated regmap IRQ controller data
      Merge branches 'regmap-core', 'regmap-stride', 'regmap-mmio' and 'regmap-irq' into regmap-next
      regmap: Convert regmap_irq to use irq_domain
      mfd: wm8994: Update to fully use irq_domain
      regmap: Fix typo in IRQ register striding

Stephen Warren (10):
      regmap: introduce explicit bus_context for bus callbacks
      regmap: introduce fast_io busses, and use a spinlock for them
      regmap: add MMIO bus support
      regmap: mmio: convert some error returns to BUG()
      regmap: mmio: remove some error checks now in the core
      regmap: validate regmap_raw_read/write val_len
      regmap: allow regmap instances to be named
      regmap: fix compilation when !CONFIG_DEBUG_FS
      regmap: implement register striding
      regmap: fix compile errors in regmap-irq.c due to stride changes

 drivers/base/regmap/Kconfig           |    3 +
 drivers/base/regmap/Makefile          |    1 +
 drivers/base/regmap/internal.h        |   26 +-
 drivers/base/regmap/regcache-lzo.c    |   11 +-
 drivers/base/regmap/regcache-rbtree.c |   44 +-
 drivers/base/regmap/regcache.c        |   34 +-
 drivers/base/regmap/regmap-debugfs.c  |   18 +-
 drivers/base/regmap/regmap-i2c.c      |   13 +-
 drivers/base/regmap/regmap-irq.c      |  184 ++-
 drivers/base/regmap/regmap-mmio.c     |  224 +++
 drivers/base/regmap/regmap-spi.c      |   13 +-
 drivers/base/regmap/regmap.c          |  276 +++-
 drivers/mfd/Kconfig                   |   13 +
 drivers/mfd/Makefile                  |    2 +
 drivers/mfd/da9052-core.c             |    8 +-
 drivers/mfd/palmas.c                  |  509 +++++++
 drivers/mfd/wm8994-irq.c              |    6 -
 include/linux/mfd/da9052/da9052.h     |    1 +
 include/linux/mfd/palmas.h            | 2620 +++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8994/core.h       |   12 +-
 include/linux/regmap.h                |   44 +-
 21 files changed, 3872 insertions(+), 190 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-mmio.c
 create mode 100644 drivers/mfd/palmas.c
 create mode 100644 include/linux/mfd/palmas.h

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuhsjAAoJEBus8iNuMP3daa0P/3Tgcqk5zzSpg64W1QDuv9VH
JP0qbpR0q/0dOL6mAfOSTxtfVhF8ubVNHqPP/OImePcWiiv4Rrv0ghpl9EiCtbOi
bxC3LCFkRRgiilOFpd1ppVIHSV2HBwUoLZNsZYPG2v8nhNNaXfY4SNJypn/xRuPA
9eq1Bz0O1bqFDKZItysl+CaA9mvfvZCzWRlI2YqmQvBwiPNBO5VaiObGMRqGDnoA
msUWd91J6kKP3uotdvTdcjRKcFFMb0Lp9M3QuoNJHPP6ixiQc+sa3FfT1Ng7/MUU
hDh0gFSjLrf1ASHSJcl+EN+CieVnRO/sZyQFPvDbnAbGigKZEXoe14+k0CgkKxCX
5KMlVyNB2RIigXwwiN5Je/jBTNa5+Wq1aSJhQH+vo0rV2nAwyUqyQnw7YW8lpO/K
1Vr08Q0NSQ5SyZwMdsdc43x49BIfyLKAjGpea2OeESvNmdin6kgQoVA1zYpCI/DT
bOvSFewVIRzvomiXkY/on/1m4McP341Bcpk5Z3h+lFaaILy7rv+6+kxWASi/PIHU
SXJjmg6c1fPXaxcCMgJtA0kQN2G4eHgD2fCNINmoGIep1WXJydlgWqaDOZMitWFW
V/taZdLjw7fhdDhFJvC8uNZ1OqvizK5M2+w0NuN1LjD1LWvyZ7Mpa3BX18X/bRme
s0rNlKDgkEV+Q6S/Li0j
=nD2b
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
