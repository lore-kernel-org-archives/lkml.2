Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0KCBaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:30:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34422 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0KCBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=DfuyPg9XW0TsAIdirFm56br5hR4wGlDTak2+dEtxgUWvXxmDdo+idNyiikU8B/pPL
	LBozXPjo6XrDm5Teau3wg==
Subject: [PATCH v1 04/12] sys-rq: Add option to soft dump
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:29:49 -0700
Message-ID: <20101103012948.4641.40943.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very useful to provide some means to force the kernel logs to make it out
via the kmsg_oops implementations on the console.  Add a new option 'Y' to
sysrq to allow dumping of logs to kmsg_dumper drivers.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/char/sysrq.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ef31bb8..888efc5 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -41,6 +41,7 @@
 #include <linux/oom.h>
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op = {
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
 
+static void sysrq_handle_softdump(int key)
+{
+	kmsg_dump(KMSG_DUMP_SOFT, NULL);
+}
+static struct sysrq_key_op sysrq_softdump_op = {
+	.handler	= sysrq_handle_softdump,
+	.help_msg	= "soft-dump(Y)",
+	.action_msg	= "Trigger a soft dump",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
@@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	/* x: May be registered on ppc/powerpc for xmon */
 	NULL,				/* x */
 	/* y: May be registered on sparc64 for global register dump */
-	NULL,				/* y */
+	&sysrq_softdump_op,		/* y */
 	&sysrq_ftrace_dump_op,		/* z */
 };
 

