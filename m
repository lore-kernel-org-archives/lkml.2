Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1BPAYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:01 -0500
Received: from kroah.org ([198.145.64.141]:49518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab1BPAXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.457084778@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [203/272] memsw: handle swapaccount kernel parameter correctly
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit fceda1bf498677501befc7da72fd2e4de7f18466 upstream.

__setup based kernel command line parameters handlers which are handled in
obsolete_checksetup are provided with the parameter value including =
(more precisely everything right after the parameter name).

This means that the current implementation of swapaccount[=1|0] doesn't
work at all because if there is a value for the parameter then we are
testing for "0" resp.  "1" but we are getting "=0" resp.  "=1" and if
there is no parameter value we are getting an empty string rather than
NULL.

The original noswapccount parameter, which doesn't care about the value,
works correctly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4930,9 +4930,9 @@ struct cgroup_subsys mem_cgroup_subsys =
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
@@ -4940,7 +4940,7 @@ __setup("swapaccount", enable_swap_accou
 
 static int __init disable_swap_account(char *s)
 {
-	enable_swap_account("0");
+	enable_swap_account("=0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);


