Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1CYX6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:58:45 -0400
Received: from kroah.org ([198.145.64.141]:48961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933060Ab1CYX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:38 2011
Message-Id: <20110325235638.875516896@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:56:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stuart Hayes <stuart_hayes@yahoo.com>,
        Doug Warzecha <douglas_warzecha@dell.com>,
        Chuck Ebbert <cebbert@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [23/23] dcdbas: force SMI to happen when expected
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=dcdbas-force-smi-to-happen-when-expected.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


