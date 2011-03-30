Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab1C3VJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965229Ab1C3VJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238913"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stuart_hayes@yahoo.com, douglas_warzecha@dell.com, ak@linux.intel.com,
        cebbert@redhat.com, jkosina@suse.cz, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [242/275] dcdbas: force SMI to happen when expected
Message-Id: <20110330210808.823D93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stuart Hayes <stuart_hayes@yahoo.com>

commit dd65c736d1b5312c80c88a64bf521db4959eded5 upstream.

The dcdbas driver can do an I/O write to cause a SMI to occur.  The SMI handler
looks at certain registers and memory locations, so the SMI needs to happen
immediately.  On some systems I/O writes are posted, though, causing the SMI to
happen well after the "outb" occurred, which causes random failures.  Following
the "outb" with an "inb" forces the write to go through even if it is posted.

Signed-off-by: Stuart Hayes <stuart_hayes@yahoo.com>
Acked-by: Doug Warzecha <douglas_warzecha@dell.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/dcdbas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/firmware/dcdbas.c
===================================================================
--- linux-2.6.35.y.orig/drivers/firmware/dcdbas.c	2011-03-29 22:50:16.283841755 -0700
+++ linux-2.6.35.y/drivers/firmware/dcdbas.c	2011-03-29 23:03:03.249217032 -0700
@@ -268,8 +268,10 @@
 	}
 
 	/* generate SMI */
+	/* inb to force posted write through and make SMI happen now */
 	asm volatile (
-		"outb %b0,%w1"
+		"outb %b0,%w1\n"
+		"inb %w1"
 		: /* no output args */
 		: "a" (smi_cmd->command_code),
 		  "d" (smi_cmd->command_address),
