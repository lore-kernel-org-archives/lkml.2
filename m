Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1EIChN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:37:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35576 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1EIChL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:37:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 9 May 2011 11:30:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] memcg: reclaim memory from node in round-robin
Message-Id: <20110509113031.fa4263df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110509112215.3ACD.A69D9226@jp.fujitsu.com>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<20110509112215.3ACD.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 May 2011 11:20:31 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > I changed the logic a little and add a filter for skipping nodes.
> > With large NUMA, tasks may under cpuset or mempolicy and the usage of memory
> > can be unbalanced. So, I think a filter is required.
> > 
> > ==
> > Now, memory cgroup's direct reclaim frees memory from the current node.
> > But this has some troubles. In usual, when a set of threads works in
> > cooperative way, they are tend to on the same node. So, if they hit
> > limits under memcg, it will reclaim memory from themselves, it may be
> > active working set.
> > 
> > For example, assume 2 node system which has Node 0 and Node 1
> > and a memcg which has 1G limit. After some work, file cacne remains and
> > and usages are
> >    Node 0:  1M
> >    Node 1:  998M.
> > 
> > and run an application on Node 0, it will eats its foot before freeing
> > unnecessary file caches.
> > 
> > This patch adds round-robin for NUMA and adds equal pressure to each
> > node. When using cpuset's spread memory feature, this will work very well.
> 
> Looks nice. And it would be more nice if global reclaim has the same feature.
> Do you have a plan to do it?
> 

Hmm, IIUC, at allocating memory for file-cache, we may be able to avoid starting
from current node. But, isn't it be a feature of cpuset ? 
If cpuset.memory_spread_page==1 and a page for file is allocated from a node in
round-robin, and memory reclaim runs in such manner (using node-only zonelist
fallabck).

Do you mean the kernel should have a knob for allowing non-local allocation for
file caches even without cpuset ?

Thanks,
-Kame



