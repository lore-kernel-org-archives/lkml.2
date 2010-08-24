Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0HXCBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:01:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52946 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0HXCBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:01:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 10:54:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH] memcg: use ID in page_cgroup
Message-Id: <20100824105405.abf226e6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100824101425.2dc25773.nishimura@mxp.nes.nec.co.jp>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820190132.43684862.kamezawa.hiroyu@jp.fujitsu.com>
	<20100823143237.b7822ffc.nishimura@mxp.nes.nec.co.jp>
	<20100824085243.8dd3c8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20100824101425.2dc25773.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 10:14:25 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > > @@ -723,6 +729,11 @@ static inline bool mem_cgroup_is_root(st
> > > >  	return (mem == root_mem_cgroup);
> > > >  }
> > > >  
> > > > +static inline bool mem_cgroup_is_rootid(unsigned short id)
> > > > +{
> > > > +	return (id == 1);
> > > > +}
> > > > +
> > > It might be better to add
> > > 
> > > 	BUG_ON(newid->id != 1)
> > > 
> > > in cgroup.c::cgroup_init_idr().
> > > 
> > 
> > Why ??
> > 
> Just to make sure that the root css has id==1. mem_cgroup_is_rootid() make
> use of the fact.
> I'm sorry if I miss something.
> 

Hmm. The function allocating ID does

4530 static struct css_id *get_new_cssid(struct cgroup_subsys *ss, int depth)
4531 {
==
4546         spin_lock(&ss->id_lock);
4547         /* Don't use 0. allocates an ID of 1-65535 */
4548         error = idr_get_new_above(&ss->idr, newid, 1, &myid);
4549         spin_unlock(&ss->id_lock);
==

and allocates ID above "1", always.

Adding BUG_ON(newid->id != 1) will mean that we doubt the bitmap function and
consider possibility that new->id == 0.

But, we're 100% sure that it never happens.

I don't think adding a comment is a right thing to do.

Thanks,
-Kame

