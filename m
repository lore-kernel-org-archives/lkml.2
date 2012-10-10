Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2JJUu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:50:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2JJUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:50:24 -0400
Date: Wed, 10 Oct 2012 13:50:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] memcg: oom: fix totalpages calculation for
 swappiness==0
In-Reply-To: <20121010141142.GG23011@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1210101346010.31237@chino.kir.corp.google.com>
References: <20121010141142.GG23011@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Michal Hocko wrote:

> Hi,
> I am sending the patch below as an RFC because I am not entirely happy
> about myself and maybe somebody can come up with a different approach
> which would be less hackish.

I don't see this as hackish, if memory.swappiness limits access to swap 
then this shouldn't be factored into the calculation, and that's what your 
patch fixes.

The reason why the process with the largest rss isn't killed in this case 
is because all processes have CAP_SYS_ADMIN so they get a 3% bonus; when 
factoring swap into the calculation and subtracting 3% from the score in 
oom_badness(), they all end up having an internal score of 1 so they are 
all considered equal.  It appears like the cgroup_iter_next() iteration 
for memcg ooms does this in reverse order, which is actually helpful so it 
will select the task that is newer.

The only suggestion I have to make is specify this is for 
memory.swappiness in the patch title, otherwise:

Acked-by: David Rientjes <rientjes@google.com>
