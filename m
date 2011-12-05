Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1LEJ4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:56:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53741 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1LEJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:56:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Dec 2011 18:51:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>,
        <eric.dumazet@gmail.com>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v7 00/10] Request for Inclusion: per-cgroup tcp memory
 pressure
Message-Id: <20111205185108.099f393e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EDC8A5F.8040402@parallels.com>
References: <1322611021-1730-1-git-send-email-glommer@parallels.com>
	<20111130111152.6b1c7366.kamezawa.hiroyu@jp.fujitsu.com>
	<4ED91318.1030803@parallels.com>
	<20111205110619.ecc538a0.kamezawa.hiroyu@jp.fujitsu.com>
	<4EDC8A5F.8040402@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 07:09:51 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 12/05/2011 12:06 AM, KAMEZAWA Hiroyuki wrote:
> > On Fri, 2 Dec 2011 16:04:08 -0200
> > Glauber Costa<glommer@parallels.com>  wrote:
> >
> >> On 11/30/2011 12:11 AM, KAMEZAWA Hiroyuki wrote:
> >>> On Tue, 29 Nov 2011 21:56:51 -0200
> >>> Glauber Costa<glommer@parallels.com>   wrote:
> >>>
> >>>> Hi,
> >>>>
> >>>> This patchset implements per-cgroup tcp memory pressure controls. It did not change
> >>>> significantly since last submission: rather, it just merges the comments Kame had.
> >>>> Most of them are style-related and/or Documentation, but there are two real bugs he
> >>>> managed to spot (thanks)
> >>>>
> >>>> Please let me know if there is anything else I should address.
> >>>>
> >>>
> >>> After reading all codes again, I feel some strange. Could you clarify ?
> >>>
> >>> Here.
> >>> ==
> >>> +void sock_update_memcg(struct sock *sk)
> >>> +{
> >>> +	/* right now a socket spends its whole life in the same cgroup */
> >>> +	if (sk->sk_cgrp) {
> >>> +		WARN_ON(1);
> >>> +		return;
> >>> +	}
> >>> +	if (static_branch(&memcg_socket_limit_enabled)) {
> >>> +		struct mem_cgroup *memcg;
> >>> +
> >>> +		BUG_ON(!sk->sk_prot->proto_cgroup);
> >>> +
> >>> +		rcu_read_lock();
> >>> +		memcg = mem_cgroup_from_task(current);
> >>> +		if (!mem_cgroup_is_root(memcg))
> >>> +			sk->sk_cgrp = sk->sk_prot->proto_cgroup(memcg);
> >>> +		rcu_read_unlock();
> >>> ==
> >>>
> >>> sk->sk_cgrp is set to a memcg without any reference count.
> >>>
> >>> Then, no check for preventing rmdir() and freeing memcgroup.
> >>>
> >>> Is there some css_get() or mem_cgroup_get() somewhere ?
> >>>
> >>
> >> There were a css_get in the first version of this patchset. It was
> >> removed, however, because it was deemed anti-intuitive to prevent rmdir,
> >> since we can't know which sockets are blocking it, or do anything about
> >> it. Or did I misunderstand something ?
> >>
> >
> > Maybe I misuderstood. Thank you. Ok, there is no css_get/put and
> > rmdir() is allowed. But, hmm....what's guarding threads from stale
> > pointer access ?
> >
> > Does a memory cgroup which is pointed by sk->sk_cgrp always exist ?
> >
> If I am not mistaken, yes, it will. (Ok, right now it won't)
> 
> Reason is a cgroup can't be removed if it is empty.
> To make it empty, you need to move the tasks away.
> 
> So the sockets will be moved away as well when you do it. So right now 
> they are not, so it would then probably be better to increase a 
> reference count with a comment saying that it is temporary.
> 

I'm sorry if I misunderstand.

At task exit, __fput() will be called against file descriptors, yes.
__fput() calles f_op->release() => inet_release() => tcp_close().

But TCP socket may be alive after task exit until it gets down to 
protocol close. For example, until the all message in send buffer
is acked, socket and tcp connection will not be disappear.

In short, socket's lifetime is different from it's task's. 
So, there may be sockets which are not belongs to any task.



Thanks,
-Kame













