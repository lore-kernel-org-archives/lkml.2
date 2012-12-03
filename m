Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2LCPQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:16:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2LCPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:16:03 -0500
Date: Mon, 3 Dec 2012 16:16:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121203151601.GA17093@dhcp22.suse.cz>
References: <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
 <20121130161923.GN29317@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130161923.GN29317@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 17:19:23, Michal Hocko wrote:
[...]
> The important question is why you see VM_FAULT_OOM and whether memcg
> charging failure can trigger that. I don not see how this could happen
> right now because __GFP_NORETRY is not used for user pages (except for
> THP which disable memcg OOM already), file backed page faults (aka
> __do_fault) use mem_cgroup_newpage_charge which doesn't disable OOM.
> This is a real head scratcher.

The following should print the traces when we hand over ENOMEM to the
caller. It should catch all charge paths (migration is not covered but
that one is not important here). If we don't see any traces from here
and there is still global OOM striking then there must be something else
to trigger this.
Could you test this with the patch which aims at fixing your deadlock,
please? I realise that this is a production environment but I do not see
anything relevant in the code.
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c8425b1..9e5b56b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2397,6 +2397,7 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	__WARN();
 	return -ENOMEM;
 bypass:
 	*ptr = NULL;

-- 
Michal Hocko
SUSE Labs
