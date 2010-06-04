Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab0FDEti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:49:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39828 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab0FDEtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:49:36 -0400
Date: Fri, 4 Jun 2010 14:49:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (rr tree
 related)
Message-Id: <20100604144933.86b3f2a8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

kernel/module.c: In function 'post_relocation':
kernel/module.c:2526: error: 'struct module' has no member named 'percpu_size'

Caused by commit fc77407bc287ed250f9355fda435df5f78b45885 ("module:
simplify per-cpu handling a little").

This build has CONFIG_SMP not set ... I applied the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 4 Jun 2010 14:41:21 +1000
Subject: [PATCH] module: don't reference percpu stuff in UP

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 69a3f12..da0213a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2523,7 +2523,9 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
 	/* Copy relocated percpu area over. */
+#ifdef CONFIG_SMP
 	percpu_modcopy(mod, info->orig_percpu, mod->percpu_size);
+#endif
 
 	/* Setup kallsyms-specific fields. */
 	add_kallsyms(mod, info);
-- 
1.7.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
