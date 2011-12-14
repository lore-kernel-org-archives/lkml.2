Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab1LNQEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:54 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:50677 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab1LNQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:46 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-7b-4ee8c91bc374
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH 4/4] edac: i5100 add documentation for fault injection
Date: Wed, 14 Dec 2011 17:04:30 +0100
Message-ID: <1323878670-26079-5-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the fault injection sysfs nodes supporting the
i5100 MC.

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 Documentation/edac.txt |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 249822c..6476d1b 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -869,3 +869,61 @@ exports one
    by the driver. Since, with udimm, this is counted by software, it is
    possible that some errors could be lost. With rdimm's, they displays the
    contents of the registers
+
+=======================================================================
+I5100 ERROR INJECTION USING EDAC APIs
+
+The i5100 MC has the ability to generate errors. The driver implements this
+functionality via some error injection nodes in sysfs under:
+
+ /sys/devices/system/edac/mc/mc?/
+
+   inject_channel:
+       Specifies what channel that will generate an error
+
+   inject_deviceptr1:
+   inject_deviceptr2:
+       Specifies what device location errors will be injected in. There
+       are two device pointers per channel and 18 locations on each device.
+
+   inject_hlinesel:
+       Specifies what part of the cacheline the eccmask is applied to
+        3 for both
+        2 for the highest
+        1 for the lowest
+
+   inject_eccmask1:
+   inject_eccmask2:
+       Specify what bits will have troubles,
+        bits 0:7  - XOR mask for transfer 0 (lower half cache line) or 2
+                   (upper half cache line).
+        bits 8:15 - XOR mask for transfer 1 (lower half cache line) or 3
+                   (upper half cache line).
+
+   inject_enable:
+       Injects one error when when something different than 0 is written.
+
+   All inject vars can be read. root permission is needed for write.
+
+   Datasheet states nothing on how to trigger an injection, experimentation
+   shows that a read is enough to detect the error. If the error is not
+   detected reinject it a few times by first disabling then enabling using
+   inject_enable. During testing the driver detected about 75% of the injected
+   errors, not sure why the driver don't see all injections.
+
+   For example, the following code will generate an CE error on channel 0:
+
+   echo 0 > /sys/devices/system/edac/mc/mc0/inject_channel
+   echo 0 > /sys/devices/system/edac/mc/mc0/inject_deviceptr1
+   echo 1 > /sys/devices/system/edac/mc/mc0/inject_hlinesel
+   echo 61440 > /sys/devices/system/edac/mc/mc0/inject_eccmask1
+   echo 1 >/sys/devices/system/edac/mc/mc0/inject_enable
+
+   The generated error message will look like:
+
+   CE chan 0, bank 0, rank 0, syndrome 0x29c5860f, cas 2920, ras 12235, csrow 0, label "DIMM0": correctable demand data ECC
+
+   If the injected error is not detected reinject it:
+
+   echo 0 >/sys/devices/system/edac/mc/mc0/inject_enable
+   echo 1 >/sys/devices/system/edac/mc/mc0/inject_enable
-- 
1.7.7.3

