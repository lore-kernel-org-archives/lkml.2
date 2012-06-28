Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2F1SaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:30:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49069 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2F1SaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:30:04 -0400
Date: Thu, 28 Jun 2012 11:29:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Zhouping Liu <zliu@redhat.com>,
        linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20120628182934.GD22641@google.com>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
 <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
 <20120627154827.GA4420@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
 <20120628123611.GA16042@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628123611.GA16042@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Jun 28, 2012 at 02:36:11PM +0200, Michal Hocko wrote:
> @@ -2726,6 +2726,9 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
>  	int err, ret = 0;
>  
>  	for (cft = cfts; cft->name[0] != '\0'; cft++) {
> +		if (subsys->cftype_enabled && !subsys->cftype_enabled(cft->name))
> +			continue;
> +
>  		if (is_add)
>  			err = cgroup_add_file(cgrp, subsys, cft);
>  		else

I hope we could avoid this dynamic decision.  That was one of the main
reasons behind doing the cftype thing.  It's better to be able to
"declare" these kind of things rather than being able to implement
fully flexible dynamic logic.  Too much flexibility often doesn't
achieve much while being a hindrance to evolution of code base (trying
to improve / simplify X - ooh... there's this single wacko corner case
YYY here which is really different from all other users).

really_do_swap_account can't change once booted, right?  Why not just
separate out memsw cfts into a separate array and call
cgroup_add_cftypes() from init path?  Can't we do that from
enable_swap_cgroup()?

Thanks.

-- 
tejun
