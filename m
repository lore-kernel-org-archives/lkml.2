Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0G1Ck0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:40:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45940 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0G1CkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:40:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Jul 2010 11:35:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7][memcg] cgroup arbitarary ID allocation
Message-Id: <20100728113529.f086716d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100728023027.GD12642@redhat.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165417.dacbe199.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728023027.GD12642@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 22:30:27 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> > Index: mmotm-2.6.35-0719/Documentation/cgroups/cgroups.txt
> > ===================================================================
> > --- mmotm-2.6.35-0719.orig/Documentation/cgroups/cgroups.txt
> > +++ mmotm-2.6.35-0719/Documentation/cgroups/cgroups.txt
> > @@ -621,6 +621,15 @@ and root cgroup. Currently this will onl
> >  the default hierarchy (which never has sub-cgroups) and a hierarchy
> >  that is being created/destroyed (and hence has no sub-cgroups).
> >  
> > +void custom_id(struct cgroup_subsys *ss, struct cgroup *cgrp)
> > +
> > +Called at assigning a new ID to cgroup subsystem state struct. This
> > +is called when ss->use_id == true. If this function is not provided,
> > +a new ID is automatically assigned. If you enable ss->use_id,
> > +you can use css_lookup()  and css_get_next() to access "css" objects
> > +via IDs.
> > +
> 
> Couple of lines to explain why a subsystem would like to assign its
> own ids and not be happy with generic cgroup assigned id be helpful.
> In this case, I think you are using this id as index into array
> and want to control the index, hence you seem to be doing it.
> 
> But I am not sure again why do you want to control index?
> 

Now, the subsystem allocation/id-allocation order is

	->create()
	alloc_id.

Otherwise "id" of memory cgroup is just determined by the place in virtual-indexed
array. 
As
	memcg =	mem_cgroup_base + id

This "id" is determined at create().

If "id" is determined regardless of memory cgroup's placement, it's of no use.
My original design of css_id() allocates id in create() but it was moved to
generic part. So, this is expected change in my plan.

We have 2 choices.
	id = alloc_id()
	create(id)
or
	this patch.

Both are okay for me. But alloc id before create() may add some ugly rollback.

Thanks,
-Kame

