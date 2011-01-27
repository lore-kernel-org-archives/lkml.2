Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1A0IX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:23:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab1A0IX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:23:27 -0500
Date: Thu, 27 Jan 2011 09:23:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, stable@kernel.org
Subject: Re: [PATCH] memsw: handle swapaccount kernel parameter correctly
Message-ID: <20110127082320.GA15500@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
 <20110126140618.8e09cd23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126140618.8e09cd23.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-01-11 14:06:18, Andrew Morton wrote:
> On Wed, 26 Jan 2011 16:21:58 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > I am sorry but the patch which added swapaccount parameter is not
> > correct (we have discussed it https://lkml.org/lkml/2010/11/16/103).
> > I didn't get the way how __setup parameters are handled correctly.
> > The patch bellow fixes that.
> > 
> > I am CCing stable as well because the patch got into .37 kernel.
> > 
> > ---
> > >From 144c2e8aed27d82d48217896ee1f58dbaa7f1f84 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Wed, 26 Jan 2011 14:12:41 +0100
> > Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly
> > 
> > __setup based kernel command line parameters handled in
> > obsolete_checksetup provides the parameter value including = (more
> > precisely everything right after the parameter name) so we have to check
> > for =0 resp. =1 here. If no value is given then we get an empty string
> > rather then NULL.
> 
> This doesn't provide a description of the bug which just got fixed.
> 
> From reading the code I think the current behaviour is
> 
> "swapaccount": works OK

Not really because the original test was !s || s="1" but as I am writing
in the commit message we are getting an empty string rather than NULL in
no parameter value case..
So noswapaccount is actually the only thing that is working.

> "noswapaccount": works OK
> "swapaccount=0": doesn't do anything
> "swapaccount=1": doesn't do anything
> 
> but I might be wrong about that.  Please send a changelog update to
> clarify all this.

Sorry for not being specific enough. What about somthing like this:
---
>From 317dec3d13ef7f11e8f2699331bc32fcd6a8ea0e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 26 Jan 2011 14:12:41 +0100
Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly

__setup based kernel command line parameters handlers which are handled in
obsolete_checksetup are provided with the parameter value including =
(more precisely everything right after the parameter name).

This means that the current implementation of swapaccount[=1|0] doesn't
work at all because if there is a value for the parameter then we are
testing for "0" resp. "1" but we are getting "=0" resp. "=1" and if
there is no parameter value we are getting an empty string rather than
NULL.

The original noswapccount parameter, which doesn't care about the value,
works correctly.

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
