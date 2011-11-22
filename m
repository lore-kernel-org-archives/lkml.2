Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1KVCIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:08:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1KVCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:08:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 22 Nov 2011 11:07:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: David Miller <davem@davemloft.net>, <jbottomley@parallels.com>,
        <eric.dumazet@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <paul@paulmenage.org>, <lizf@cn.fujitsu.com>,
        <linux-mm@kvack.org>, <devel@openvz.org>, <kirill@shutemov.name>,
        <gthelen@google.com>
Subject: Re: [Devel] Re: [PATCH v5 00/10] per-cgroup tcp memory pressure
Message-Id: <20111122110707.377ff8ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EC6B457.4010502@parallels.com>
References: <1320679595-21074-1-git-send-email-glommer@parallels.com>
	<4EBAC04F.1010901@parallels.com>
	<1321381632.3021.57.camel@dabdike.int.hansenpartnership.com>
	<20111117.163501.1963137869848419475.davem@davemloft.net>
	<4EC6B457.4010502@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 17:39:03 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 11/17/2011 07:35 PM, David Miller wrote:
> > TCP specific stuff in mm/memcontrol.c, at best that's not nice at all.
> 
> How crucial is that? Thing is that as far as I am concerned, all the 
> memcg people really want the inner layout of struct mem_cgroup to be 
> private to memcontrol.c 

This is just because memcg is just related to memory management and I don't
want it be wide spreaded, 'struct mem_cgroup' has been changed often.

But I don't like to have TCP code in memcgroup.c.

New idea is welcome.

> This means that at some point, we need to have
> at least a wrapper in memcontrol.c that is able to calculate the offset
> of the tcp structure, and since most functions are actually quite 
> simple, that would just make us do more function calls.
> 
> Well, an alternative to that would be to use a void pointer in the newly 
> added struct cg_proto to an already parsed memcg-related field
> (in this case tcp_memcontrol), that would be passed to the functions
> instead of the whole memcg structure. Do you think this would be 
> preferable ?
> 
like this ?

struct mem_cgroup_sub_controls {
	struct mem_cgroup *mem;
	union {
		struct tcp_mem_control tcp;
	} data;
};
/* for loosely coupled controls for memcg */
struct memcg_sub_controls_function
{
	struct memcg_sub_controls	(*create)(struct mem_cgroup *);
	struct memcg_sub_controls	(*destroy)(struct mem_cgroup *);
}

int register_memcg_sub_controls(char *name, 
		struct memcg_sub_controls_function *abis);


struct mem_cgroup {
	.....
	.....
	/* Root memcg will have no sub_controls! */
	struct memcg_sub_controls	*sub_controls[NR_MEMCG_SUB_CONTROLS];
}


Maybe some functions should be exported. 

Thanks,
-Kame


