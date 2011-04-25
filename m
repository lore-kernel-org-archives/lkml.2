Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab1DYUZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:13 -0400
Received: from 1wt.eu ([62.212.114.60]:34490 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363Ab1DYUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:09 -0400
Message-Id: <20110425200237.901633040@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Stuart Hayes <stuart_hayes@yahoo.com>,
        Doug Warzecha <douglas_warzecha@dell.com>,
        Chuck Ebbert <cebbert@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 113/173] dcdbas: force SMI to happen when expected
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/dcdbas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -267,8 +267,10 @@ int dcdbas_smi_request(struct smi_cmd *s
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


