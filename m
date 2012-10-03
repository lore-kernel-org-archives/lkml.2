Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2JCTZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:25:39 -0400
Received: from mxout1.idt.com ([157.165.5.25]:40747 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2JCTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:25:37 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 0/5] rapidio: patches to support multiple master ports
Date: Wed,  3 Oct 2012 15:18:38 -0400
Message-Id: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches provides modifications targeting support of multiple
RapidIO master port (mport) devices on a CPU-side of RapidIO-capable board.
While the RapidIO subsystem code has definitions suitable for
multi-controller/multi-net support, the existing implementation cannot be
considered ready for multiple mport configurations.   

=========== NOTES: =============
a) The patches below do not address RapidIO side view of multiport processing
elements defined in Part 6 of RapidIO spec Rev.2.1 (section 6.4.1).
These devices have Base Device ID CSR (0x60) and Component Tag CSR (0x6C) shared
by all SRIO ports. For example, Freescale's P4080, P3041 and P5020 have a
dual-port SRIO controller implemented according the specification.
Enumeration/discovery of such devices from RapidIO side may require
device-specific fixups.
b) Devices referenced above may also require implementation specific code to setup
a host device ID for mport device. These operations are not addressed by patches
in this package. 
=================================

Details about provided patches:

1. Fix blocking wait for discovery ready

While it does not happen on PowerPC based platforms, there is possibility of
stalled CPU warning dump on x86 based platforms that run RapidIO discovery
process if they wait too long for being enumerated.
Currently users can avoid it by disabling the soft-lockup detector using
"nosoftlockup" kernel parameter OR by ensuring that enumeration is completed
before soft-lockup is detected.

This patch eliminates blocking wait and keeps a scheduler running.
It also is required for patch 3 below which introduces asynchronous discovery
process.

2. Use device lists handling on per-net basis

This patch allows to correctly support multiple RapidIO nets and resolves possible
issues caused by using single global list of devices during RapidIO system
enumeration/discovery. The most common sign of existing issue is incorrect
contents of switch routing tables in systems with multiple mport controllers
while single-port configuration performs as expected.

The patch does not eliminate the global RapidIO device list but changes some
routines in enumeration/discovery to use per-net device lists instead. This way
compatibility with upper layer RIO routines is preserved.
 
3. Run discovery as an asynchronous process

This patch modifies RapidIO initialization routine to asynchronously run the
discovery process for each corresponding mport. This allows having an arbitrary
order of enumerating and discovering mports without creating a deadlock situation
if an enumerator port was registered after a discovering one.

On boards with multiple discovering mports it also eliminates order dependency
between mports and may reduce total time of RapidIO subsystem initialization.

Making netID matching to mportID ensures consistent netID assignment in
multiport RapidIO systems with asynchronous discovery process (global counter
implementation is affected by race between threads).

4. Rework RIONET to support multiple RIO master ports

In the current version of the driver rionet_probe() has comment
"XXX Make multi-net safe". Now it is a good time to address this comment.

This patch makes RIONET driver multi-net safe/capable by introducing per-net
lists of RapidIO network peers. It also enables to register network adapters for
all available mport devices.

5. Add destination ID allocation mechanism

The patch replaces a single global destination ID counter with per-net allocation
mechanism to allow independent destID management for each available RapidIO
network. Using bitmap based mechanism instead of counters allows destination ID
release and reuse in systems that support hot-swap.


Alexandre Bounine (5):
  rapidio: fix blocking wait for discovery ready
  rapidio: use device lists handling on per-net basis
  rapidio: run discovery as an asynchronous process
  rapidio/rionet: rework to support multiple RIO master ports
  rapidio: add destination ID allocation mechanism

 drivers/net/rionet.c       |  133 ++++++++++---------
 drivers/rapidio/rio-scan.c |  326 +++++++++++++++++++++++++++++--------------
 drivers/rapidio/rio.c      |   51 +++++++-
 include/linux/rio.h        |   10 ++
 4 files changed, 349 insertions(+), 171 deletions(-)

-- 
1.7.8.4
