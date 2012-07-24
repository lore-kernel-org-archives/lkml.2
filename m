Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2GXVBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:01:36 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:41065 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2GXVBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:01:34 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 17:01:34 EDT
From: Peter Hurley <peter@hurleysoftware.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jul 2012 16:51:12 -0400
Subject: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
Thread-Topic: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to
 cleanup
Thread-Index: Ac1p3g9fI7rSAE5aRQ6VuJdRbiQR3g==
Message-ID: <1343163072.2229.5.camel@thor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  If BIOS maps all or most of the phys address space as write-back,
  regardless of the amount of actual RAM, then mtrr_cleanup may create
  superfluous MTRR entries, or may be unable to create an optimal map
  (or may use all MTRRs attempting to do so, thus making cleanup
  pointless). Ideally, WB MTRRs should not be used for physical memory
  addresses where memory does not exist (Intel SDM, Vol 3A, 11.11.2.1).

  For example, Dell Precision T5400 wkstn w/ rev. A04 BIOS constructs
  the following MTRR map for 10GB memory:
   kernel: [    0.000000] MTRR variable ranges enabled:
   kernel: [    0.000000]   0 base 0000000000 mask 2000000000 write-back
   kernel: [    0.000000]   1 base 00CFF00000 mask 3FFFF00000 uncachable
   kernel: [    0.000000]   2 base 00D0000000 mask 3FF0000000 uncachable
   kernel: [    0.000000]   3 base 00E0000000 mask 3FE0000000 uncachable
   kernel: [    0.000000]   4 base 1FF0000000 mask 3FF0000000 uncachable
   kernel: [    0.000000]   5 disabled
   kernel: [    0.000000]   6 disabled
   kernel: [    0.000000]   7 disabled
   kernel: [    0.000000] x86 PAT enabled: cpu 0 ......
   kernel: [    0.000000] original variable MTRRs
   kernel: [    0.000000] reg 0, base: 0GB, range: 128GB, type WB
   kernel: [    0.000000] reg 1, base: 3327MB, range: 1MB, type UC
   kernel: [    0.000000] reg 2, base: 3328MB, range: 256MB, type UC
   kernel: [    0.000000] reg 3, base: 3584MB, range: 512MB, type UC
   kernel: [    0.000000] reg 4, base: 130816MB, range: 256MB, type UC
   kernel: [    0.000000] total RAM covered: 130047M

  mtrr_cleanup cannot construct an optimal map for this configuration.
  Additionally, if the mtrr_gran_size/mtrr_chunk_size is specified,
  mtrr_cleanup will use all entries attempting to map the full 128GB
  phys address range.

  If a WB MTRR entry which maps phys addr range [0, > max_pfn) exists,
  constrain the entry to [0, roundup_pow_of_two(max_pfn) ) prior to
  generating potential solutions. The example MTRR map is optimized to:
   kernel: [    0.000000] New variable MTRRs
   kernel: [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
   kernel: [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
   kernel: [    0.000000] reg 2, base: 3GB, range: 256MB, type WB
   kernel: [    0.000000] reg 3, base: 3327MB, range: 1MB, type UC
   kernel: [    0.000000] reg 4, base: 4GB, range: 4GB, type WB
   kernel: [    0.000000] reg 5, base: 8GB, range: 8GB, type WB

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index bdda2e6..ee399c3 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -714,6 +714,16 @@ int __init mtrr_cleanup(unsigned address_bits)
 	if (mtrr_tom2)
 		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
 
+	/* Constrain a WB entry that maps entire phys addr space to max mem */
+	for (i = 0; i < num_var_ranges; i++) {
+		if (range_state[i].type == MTRR_TYPE_WRBACK &&
+		    range_state[i].base_pfn == 0 &&
+		    range_state[i].size_pfn > max_pfn) {
+			range_state[i].size_pfn = roundup_pow_of_two(max_pfn);
+			break;
+		}
+	}
+
 	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
 	 * [0, 1M) should always be covered by var mtrr with WB
-- 
1.7.5.4

