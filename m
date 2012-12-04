Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2LDBrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:47:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:59222 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845Ab2LDBrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:47:02 -0500
Message-Id: <551d7117c59f82c9e176f333bee56c59f19c1fa9.1354501189.git.ecashin@coraid.com>
In-Reply-To: <cover.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/7] aoe: allow user to disable target failure timeout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:46:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, the aoe driver treats the value zero as special
for the aoe_deadsecs module parameter.  Normally, this value
specifies the number of seconds during which the driver will
continue to attempt retransmits to an unresponsive AoE target.
After aoe_deadsecs has elapsed, the aoe driver marks the aoe
device as "down" and fails all I/O.

The new meaning of an aoe_deadsecs of zero is for the driver to
retransmit commands indefinitely.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 Documentation/aoe/aoe.txt  |    4 +++-
 drivers/block/aoe/aoecmd.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/aoe/aoe.txt b/Documentation/aoe/aoe.txt
index bfc9cb1..c71487d 100644
--- a/Documentation/aoe/aoe.txt
+++ b/Documentation/aoe/aoe.txt
@@ -125,7 +125,9 @@ DRIVER OPTIONS
   The aoe_deadsecs module parameter determines the maximum number of
   seconds that the driver will wait for an AoE device to provide a
   response to an AoE command.  After aoe_deadsecs seconds have
-  elapsed, the AoE device will be marked as "down".
+  elapsed, the AoE device will be marked as "down".  A value of zero
+  is supported for testing purposes and makes the aoe driver keep
+  trying AoE commands forever.
 
   The aoe_maxout module parameter has a default of 128.  This is the
   maximum number of unresponded packets that will be sent to an AoE
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index da360f9..abf4ad2 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -812,7 +812,9 @@ rexmit_timer(ulong vp)
 		since = tsince_hr(f);
 		n = f->waited_total + since;
 		n /= USEC_PER_SEC;
-		if (n > aoe_deadsecs && !(f->flags & FFL_PROBE)) {
+		if (aoe_deadsecs
+		&& n > aoe_deadsecs
+		&& !(f->flags & FFL_PROBE)) {
 			/* Waited too long.  Device failure.
 			 * Hang all frames on first hash bucket for downdev
 			 * to clean up.
-- 
1.7.1

