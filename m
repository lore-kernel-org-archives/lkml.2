Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1CYIp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:45:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41335 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1CYIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:45:24 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them self registered
Date: Fri, 25 Mar 2011 16:48:46 +0800
Message-Id: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are what the patch set does.

* Remove .probe and .remove hooks from sdhci-pltfm.c and make it be
  a pure common helper function providers.
* Add .probe and .remove hooks for sdhci pltfm drivers sdhci-cns3xxx,
  sdhci-dove, sdhci-tegra, and sdhci-esdhc-imx to make them self
  registered with calling helper functions created above.
* Migrate the use of sdhci_of_host and sdhci_of_data to
  sdhci_pltfm_host and sdhci_pltfm_data, so that OF version host and
  data structure works can be saved, and pltfm version works for both
  cases.
* Add OF common helper stuff into sdhci-pltfm.c, and make OF version
  sdhci drivers sdhci-of-esdhc and sdhci-of-hlwd become self
  registered as well, so that sdhci-of-core.c and sdhci-of.h can be
  removed.
* Consolidate the OF and pltfm esdhc drivers into one with sharing
  the same pair of .probe and .remove hooks.  As a result,
  sdhci-esdhc-imx.c and sdhci-of-esdhc.c go away, while
  sdhci-esdhc.c comes in and works for both MPCxxx and i.MX.
* Eliminate include/linux/mmc/sdhci-pltfm.h with moving stuff into
  drivers/mmc/host/sdhci-pltfm.h.

And the benefits we gain from the changes are:

* Get the sdhci device driver follow the Linux trend that driver
  makes the registration by its own.
* sdhci-pltfm.c becomes simple and clean as it only has common helper
  stuff there now.
* All sdhci device specific things are going back its own driver.
* The dt and non-dt drivers are consolidated to use the same pair of
  .probe and .remove hooks.
* SDHCI driver for Freescale eSDHC controller found on both MPCxxx
  and i.MX platforms is consolidated to use the same one .probe
  function.

The patch set works against the tree below, and was only tested on
i.mx51 babbage board, all other targets were build tested.

  git://git.secretlab.ca/git/linux-2.6.git devicetree/test

Comments are welcomed and appreciated.

Regards,
Shawn

PS: The first patch is a squashing of the patch set below, which was
posted for review a few days back.

  [PATCH 0/5] make sdhci device drivers self registered

Some patches in this series are relatively large, involving more
changes than expected, I chose to not split considering they are
logically integral, and doing so can reduce the patch quantity much,
and make bisect much easier.  But sorry for that it makes reviewers'
life harder.

Shawn Guo (5):
      mmc: sdhci: make sdhci-pltfm device drivers self registered
      mmc: sdhci: eliminate sdhci_of_host and sdhci_of_data
      mmc: sdhci: make sdhci-of device drivers self registered
      mmc: sdhci: consolidate sdhci-of-esdhc and sdhci-esdhc-imx
      mmc: sdhci: merge two sdhci-pltfm.h into one

 drivers/mmc/host/Kconfig           |   71 ++++---
 drivers/mmc/host/Makefile          |   17 +-
 drivers/mmc/host/sdhci-cns3xxx.c   |   68 ++++++-
 drivers/mmc/host/sdhci-dove.c      |   69 ++++++-
 drivers/mmc/host/sdhci-esdhc-imx.c |  149 -------------
 drivers/mmc/host/sdhci-esdhc.c     |  412 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-of-core.c   |  247 ---------------------
 drivers/mmc/host/sdhci-of-esdhc.c  |   89 --------
 drivers/mmc/host/sdhci-of-hlwd.c   |   89 +++++++-
 drivers/mmc/host/sdhci-of.h        |   42 ----
 drivers/mmc/host/sdhci-pltfm.c     |  251 +++++++++-------------
 drivers/mmc/host/sdhci-pltfm.h     |   36 +++-
 drivers/mmc/host/sdhci-tegra.c     |  187 ++++++++++-------
 include/linux/mmc/sdhci-pltfm.h    |   35 ---
 14 files changed, 912 insertions(+), 850 deletions(-)
