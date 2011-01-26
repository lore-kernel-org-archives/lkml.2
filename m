Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1AZPWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:22:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:54577 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1AZPWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:22:02 -0500
Date: Wed, 26 Jan 2011 16:21:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, stable@kernel.org
Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly
Message-ID: <20110126152158.GA4144@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
I am sorry but the patch which added swapaccount parameter is not
correct (we have discussed it https://lkml.org/lkml/2010/11/16/103).
I didn't get the way how __setup parameters are handled correctly.
The patch bellow fixes that.

I am CCing stable as well because the patch got into .37 kernel.

---
>From 144c2e8aed27d82d48217896ee1f58dbaa7f1f84 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 26 Jan 2011 14:12:41 +0100
Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly

__setup based kernel command line parameters handled in
obsolete_checksetup provides the parameter value including = (more
precisely everything right after the parameter name) so we have to check
for =0 resp. =1 here. If no value is given then we get an empty string
rather then NULL.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db76ef7..cea2be48 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5013,9 +5013,9 @@ struct cgroup_subsys mem_cgroup_subsys = {
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!s || !strcmp(s, "1"))
+	if (!(*s) || !strcmp(s, "=1"))
 		really_do_swap_account = 1;
-	else if (!strcmp(s, "0"))
+	else if (!strcmp(s, "=0"))
 		really_do_swap_account = 0;
 	return 1;
 }
@@ -5023,7 +5023,7 @@ __setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
-	enable_swap_account("0");
+	enable_swap_account("=0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);
-- 
1.7.2.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
