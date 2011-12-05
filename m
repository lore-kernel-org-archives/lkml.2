Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1LECDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:03:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44109 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1LECDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:03:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Dec 2011 11:01:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>,
        <eric.dumazet@gmail.com>, <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Subject: Re: [PATCH v7 04/10] tcp memory pressure controls
Message-Id: <20111205110158.8a2e270f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4ED91188.6030503@parallels.com>
References: <1322611021-1730-1-git-send-email-glommer@parallels.com>
	<1322611021-1730-5-git-send-email-glommer@parallels.com>
	<20111130104943.d9b210ee.kamezawa.hiroyu@jp.fujitsu.com>
	<4ED91188.6030503@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011 15:57:28 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 11/29/2011 11:49 PM, KAMEZAWA Hiroyuki wrote:
> >
> >> -static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
> >> +struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
> >>   {
> >>   	return container_of(cgroup_subsys_state(cont,
> >>   				mem_cgroup_subsys_id), struct mem_cgroup,
> >> @@ -4717,14 +4732,27 @@ static int register_kmem_files(struct cgroup *cont, struct cgroup_subsys *ss)
> >>
> >>   	ret = cgroup_add_files(cont, ss, kmem_cgroup_files,
> >>   			       ARRAY_SIZE(kmem_cgroup_files));
> >> +
> >> +	if (!ret)
> >> +		ret = mem_cgroup_sockets_init(cont, ss);
> >>   	return ret;
> >>   };
> >
> > You does initizalication here. The reason what I think is
> > 1. 'proto_list' is not available at createion of root cgroup and
> >      you need to delay set up until mounting.
> >
> > If so, please add comment or find another way.
> > This seems not very clean to me.
> 
> Yes, we do can run into some ordering issues. A part of the 
> initialization can be done earlier. But I preferred to move it all later
> instead of creating two functions for it. But I can change that if you 
> want, no big deal.
> 

Hmm. please add comments about the 'issue'. It will help readers.


> >> +	tcp->tcp_prot_mem[0] = sysctl_tcp_mem[0];
> >> +	tcp->tcp_prot_mem[1] = sysctl_tcp_mem[1];
> >> +	tcp->tcp_prot_mem[2] = sysctl_tcp_mem[2];
> >> +	tcp->tcp_memory_pressure = 0;
> >
> > Question:
> >
> > Is this value will be updated when an admin chages sysctl ?
> 
> yes.
> 
> > I guess, this value is set at system init script or some which may
> > happen later than mounting cgroup.
> > I don't like to write a guideline 'please set sysctl val before
> > mounting cgroup'
> 
> Agreed.
> 
> This code is in patch 6 (together with the limiting):
> 
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +       rcu_read_lock();
> +       memcg = mem_cgroup_from_task(current);
> +
> +       tcp_prot_mem(memcg, vec[0], 0);
> +       tcp_prot_mem(memcg, vec[1], 1);
> +       tcp_prot_mem(memcg, vec[2], 2);
> +       rcu_read_unlock();
> +#endif
> 
> tcp_prot_mem is just a wrapper around the assignment so we can access 
> memcg's inner fields.
> 


Ok. sysctl and cgroup are updated at the same time.
thank you.
-Kame

