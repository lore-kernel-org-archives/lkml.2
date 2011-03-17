Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1CQFhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:37:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:38970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1CQFhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:37:20 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Silence "ldm_validate_partition_table(): Disk read failed" when booting with "quiet"
Date: Thu, 17 Mar 2011 11:04:14 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jiri Kosina <trivial@kernel.org>,
        linux-ntfs-dev@lists.sourceforge.net,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Klaus Hartmann <Klaus.Hartmann@ts.fujitsu.com>,
        Andries Brouwer <aeb@cwi.nl>, linux-kernel@vger.kernel.org
References: <201101121633.48567.knikanth@suse.de> <201103151125.05809.knikanth@suse.de> <68B01298-2FC4-4BA3-B76D-50BABA32AC4E@cam.ac.uk>
In-Reply-To: <68B01298-2FC4-4BA3-B76D-50BABA32AC4E@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171104.15086.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Silence "ldm_validate_partition_table(): Disk read failed" when booting with "quiet"

When the kernel does partition detection, on certain configurations with
external fibre channel raid systems (e.g. clariion from EMC) the read
would fail. And "ldm_validate_partition_table(): Disk read failed"
messages are printed to the console.

But the failure to read is not a critical error. Now since the message
is flagged as KERN_CRIT, it gets printed even when booting with the
"quiet" kernel parameter. Fix it by using KERN_INFO, as the failure to
read here is not really an error.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Reported-by : Klaus Hartmann <Klaus.Hartmann@ts.fujitsu.com>
Signed-off-by: Anton Altaparmakov <aia21@cantab.net>

---

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index b10e354..ea648b9 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -565,7 +565,7 @@ static bool ldm_validate_partition_table(struct parsed_partitions *state)
 
 	data = read_part_sector(state, 0, &sect);
 	if (!data) {
-		ldm_crit ("Disk read failed.");
+		ldm_info ("Disk read failed.");
 		return false;
 	}
 
