Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab2K0KME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:12:04 -0500
Received: from thoth.sbs.de ([192.35.17.2]:17459 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab2K0KMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:01 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>
Subject: [PATCH v3 05/13] scripts/gdb: Add read_u16/32/64 helpers
Date: Tue, 27 Nov 2012 11:11:36 +0100
Message-Id: <17a31726a26035e8e984f8370551e3ed09fe90ba.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for reading integers from target memory buffers. Required
when caching the memory access is more efficient than reading individual
values via gdb.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index e3191c5..96f5e1c 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -73,3 +73,21 @@ def get_target_endianness():
 		else:
 			raise gdb.GdgError("unknown endianness '%s'" % endian)
 	return target_endianness
+
+def read_u16(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return ord(buffer[0]) + (ord(buffer[1]) << 8)
+	else:
+		return ord(buffer[1]) + (ord(buffer[0]) << 8)
+
+def read_u32(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+	else:
+		return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+
+def read_u64(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+	else:
+		return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
-- 
1.7.3.4

