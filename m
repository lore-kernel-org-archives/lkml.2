Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2E2I0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:26:40 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54156 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2E2I0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:26:37 -0400
Message-ID: <4FC487B7.6090505@parallels.com>
Date: Tue, 29 May 2012 12:24:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>, <mhocko@suse.cz>,
        <bsingharora@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:56 AM, Gao feng wrote:
> cgroup and namespaces are used for creating containers but some of
> information is not isolated/virtualized. This patch is for isolating /proc/meminfo
> information per container, which uses memory cgroup. By this, top,free
> and other tools under container can work as expected(show container's
> usage) without changes.
>
> This patch is a trial to show memcg's info in /proc/meminfo if 'current'
> is under a memcg other than root.
>
> we show /proc/meminfo base on container's memory cgroup.
> because there are lots of info can't be provide by memcg, and
> the cmds such as top, free just use some entries of /proc/meminfo,
> we replace those entries by memory cgroup.
>
> if container has no memcg, we will show host's /proc/meminfo
> as before.
>
> there is no idea how to deal with Buffers,I just set it zero,
> It's strange if Buffers bigger than MemTotal.
>
> Signed-off-by: Gao feng<gaofeng@cn.fujitsu.com>

This is the very same problem that exists with CPU cgroup.
So I'll tell you what kind of resistance we faced, and why I sort of 
agree with it.

In summary, there is no guarantee that current wants to see this. This 
is true for containers environments, but doing this unconditionally can
break applications out there.

With cpu is easier to demonstrate, because you would still see all other 
tasks in the system (no pid namespaces used), but the tick figures won't 
match. But not only memory falls prey to the same issue,
but we really need a common solution to that.

A flag is too ugly, or mount options are too ugly, and when parenting is 
in place, hard to get right.

So I've seen a lot of people advocating we should just use a userspace 
filesystem that would bind mount that ontop of normal proc.

For instance: bind mount your special meminfo into /proc/meminfo inside 
a container. Reads of the later would redirect to the former, that would 
then assemble the proper results from the cgroup filesystem, and display it.

I do believe this is a more neutral way to go, and we have all the 
tools. It also does not risk breaking anything, since only people that 
want it would use it.

