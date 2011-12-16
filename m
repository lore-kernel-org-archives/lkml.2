Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1LPGM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:12:26 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1LPGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:12:19 -0500
Date: Fri, 16 Dec 2011 01:09:59 -0500 (EST)
Message-Id: <20111216.010959.917434953281175910.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] fix sleeping while atomic problem in sock mem_cgroup.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324003070-6573-1-git-send-email-glommer@parallels.com>
References: <1324003070-6573-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 22:10:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 16 Dec 2011 06:37:50 +0400

> Since we can't scan the proto_list to initialize sock cgroups, as it
> holds a rwlock, and we also want to keep the code generic enough to
> avoid calling the initialization functions of protocols directly,
> I propose we keep the interested parties in a separate list. This list
> is protected by a mutex so we can sleep and do the necessary allocations.
> 
> Also fixes a reference problem found by Randy Dunlap's randconfig.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Two small changes please:

1) Add an appropriate prefix to your subject line indicating the subsystem
   being changed by this patch, "net: fix sleeping ..." would be appropriate
   in this case.

2) Put the ifdef'ery into the memcontrol.h header file, rather than sock.c,
   f.e. rename register_sock_cgroup to __register_sock_cgroup(), and
   unregister_sock_cgroup to __unregister_sock_cgroup.  Then create two
   helper inlines in memcontrolh:

	#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
	static inline void register_sock_cgroup(struct proto *prot)
	{
		if (prot->proto_cgroup != NULL)
			register_sock_cgroup(prot);
	}
	static inline void unregister_sock_cgroup(struct proto *prot)
	{
		if (prot->proto_cgroup != NULL)
			unregister_sock_cgroup(prot);
	}
	#else
	static inline void register_sock_cgroup(struct proto *prot)
	{
	}
	static inline void unregister_sock_cgroup(struct proto *prot)
	{
	}
	#endif

   Then call these helpers unconditionally in net/core/sock.c

   That way you don't need any ifdefs in that file at all.
