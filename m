Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2E3Vi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2E3Vi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:38:27 -0400
Date: Wed, 30 May 2012 14:38:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gao feng <gaofeng@cn.fujitsu.com>
cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        bsingharora@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Gao feng wrote:

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
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Nack, this type of thing was initially tried with cpusets when a thread 
was bound to a subset of nodes, i.e. only show the total amount of memory 
spanned by those nodes.

For your particular interest, this information is already available 
elsewhere: memory.limit_in_bytes and memory.usage_in_bytes and that should 
be the interface where this is attained via /proc/cgroups.

Why?  Because the information exported by /proc/meminfo is considered by 
applications to be static whereas the limit of a memcg may change without 
any knowledge of the application.  Applications which need to know the 
amount of memory they are constrained to are assuming that there are no 
other consumers of memory on the system and thus they should be written to 
understand memcg limits just like they should understand cpusets (through 
either /proc/cgroups or /proc/cpuset).
