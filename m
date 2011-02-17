Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1BQSxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:53:44 -0500
Received: from mail.perches.com ([173.55.12.10]:3715 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab1BQSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:53:39 -0500
Subject: Re: [PATCH] x86: combine printk()s in show_regs_common()
From: Joe Perches <joe@perches.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D5D535A0200007800032730@vpn.id2.novell.com>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 10:53:37 -0800
Message-ID: <1297968817.2856.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 15:56 +0000, Jan Beulich wrote:
> Printing a single character alone when there's an immediately following
> printk() is pretty pointless (and wasteful).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Perhaps better still to use just one printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/process.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..0f43771 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -103,20 +103,18 @@ void show_regs_common(void)
 
 	/* Board Name is optional */
 	board = dmi_get_system_info(DMI_BOARD_NAME);
+	if (!board)
+		board = "";
 
 	printk(KERN_CONT "\n");
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	printk(KERN_CONT " ");
-	printk(KERN_CONT "%s %s", vendor, product);
-	if (board) {
-		printk(KERN_CONT "/");
-		printk(KERN_CONT "%s", board);
-	}
-	printk(KERN_CONT "\n");
+	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
+	       current->pid, current->comm, print_tainted(),
+	       init_utsname()->release,
+	       (int)strcspn(init_utsname()->version, " "),
+	       init_utsname()->version,
+	       vendor, product,
+	       strlen(board) ? "/" : "",
+	       board);
 }
 
 void flush_thread(void)


