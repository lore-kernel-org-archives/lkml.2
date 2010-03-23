Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab0CWEEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:04:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60129 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab0CWEEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:04:48 -0400
Date: Tue, 23 Mar 2010 15:04:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: build failure after merge of the kgdb tree
Message-Id: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

After merging the kgdb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

kernel/debug/kdb/kdb_main.c: In function 'kdb_sr':
kernel/debug/kdb/kdb_main.c:1822: error: '__sysrq_enabled' undeclared (first use in this function)

Caused by commit ab28988df9667f8dd70c7434c8ca463beb00b300 ("kdb: core for
kgdb back end (1 of 2)") from the kgdb tree interacting with commit
edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("") fromInput: implement SysRq
as a separate input handler the input tree.

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Mar 2010 14:45:22 +1100
Subject: [PATCH] kgdb: update for sysrq handling change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/debug/kdb/kdb_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f1f9309..bad8e63 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1819,10 +1819,8 @@ static int kdb_sr(int argc, const char **argv)
 {
 	if (argc != 1)
 		return KDB_ARGCOUNT;
-	if (!__sysrq_enabled) {
-		kdb_printf("Auto activating sysrq\n");
-		__sysrq_enabled = 1;
-	}
+
+	sysrq_toggle_support(1);
 
 	kdb_trap_printk++;
 	handle_sysrq(*argv[1], NULL);
-- 
1.7.0.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
