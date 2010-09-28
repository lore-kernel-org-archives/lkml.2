Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0I1R7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:59:51 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:34036 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0I1R7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:59:50 -0400
Subject: [RFC] Online firmware upgrade in non-embedded systems
From: Ben Hutchings <bhutchings@solarflare.com>
To: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Cc: sf-linux-drivers <linux-net-drivers@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 28 Sep 2010 18:59:47 +0100
Message-ID: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2010 17:59:50.0166 (UTC) FILETIME=[F1E94360:01CB5F36]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17670.005
X-TM-AS-Result: No--29.340900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network and disk controllers normally have at least some firmware in
flash to support their use as boot devices.  Solarflare's current
network adapters can have as many as 4 distinct firmware partitions: one
for each PHY, one for the management CPU and one for net-boot.  Any or
all of these may need to be updated in the field, to fix bugs or to add
features.  (Furthermore, the net-boot firmware is based on gPXE and is
therefore modifiable by any user.)

Currently the sfc network driver is optionally combined with an MTD
driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
configuration partitions in flash.  This works nicely in kernels with
MTD enabled, but since MTD is mainly used in embedded systems with
on-board flash it is often disabled in distribution kernels and custom
kernels alike.  This leaves users of sfc unable to upgrade firmware
without rebuilding the kernel or booting some other distribution.  The
lack of widespread MTD support is a regular cause of support requests.

There are two main alternatives I'm aware of:

- Use the ethtool ETHTOOL_SEEPROM command with multiple magic numbers
for different partitions. bnx2x does something a little like this for
PHY firmware upgrades. The ethtool core passes in a page at a time so
this won't work well with flash block sizes greater than PAGE_SIZE.

- Use the ethtool ETHTOOL_FLASHDEV command. It's intended for precisely
this purpose, but the driver is supposed to implement it using
request_firmware(). That seems to require any firmware update program to
integrate with udev or to copy firmware images under /lib/firmware even
though they are one-time updates. That doesn't make a lot of sense to
me. Am I missing something?

Of course these are both specific to network devices; it seems deisrable
to have a more general convention for online firmware upgrades.  MTDs
clearly are more generally applicable, and pretty much every computer
does have flash storage for firmware and boot configuration, so perhaps
it should be treated as more of a standard feature?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

