Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2EaFC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:02:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EaFC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:02:26 -0400
Date: Wed, 30 May 2012 22:02:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <4FC6D881.4090706@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com>
 <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:

> > It's not just a memcg issue, it would also be a cpusets issue.
> 
> I think you can add cpuset.meminfo.
> 

It's simple to find the same information by reading the per-node meminfo 
files in sysfs for each of the allowed cpuset mems.  This is why this 
approach has been nacked in the past, specifically by Paul Jackson when he 
implemented cpusets.

The bottomline is that /proc/meminfo is one of many global resource state 
interfaces and doesn't imply that every thread has access to the full 
resources.  It never has.  It's very simple for another thread to consume 
a large amount of memory as soon as your read() of /proc/meminfo completes 
and then that information is completely bogus.  We also don't want to 
virtualize every single global resource state interface, it would be never 
ending.

Applications that administer memory cgroups or cpusets can get this 
information very easily, each application within those memory cgroups or 
cpusets does not need it and should not rely on it: it provides no 
guarantee about future usage nor notifies the application when the amount 
of free memory changes.
