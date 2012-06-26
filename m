Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab2FZFYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:24:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45150 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab2FZFYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:24:02 -0400
Date: Mon, 25 Jun 2012 22:23:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
In-Reply-To: <20120625162158.cde295bf.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1206252212370.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625182907.GF3869@google.com> <4FE8E7EB.2020804@parallels.com> <20120625162158.cde295bf.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Andrew Morton wrote:

> > >>   	 */
> > >>   	bool use_hierarchy;
> > >> -	bool kmem_accounted;
> > >> +	/*
> > >> +	 * bit0: accounted by this cgroup
> > >> +	 * bit1: accounted by a parent.
> > >> +	 */
> > >> +	volatile unsigned long kmem_accounted;
> > >
> > > Is the volatile declaration really necessary?  Why is it necessary?
> > > Why no comment explaining it?
> > 
> > Seems to be required by set_bit and friends. gcc will complain if it is 
> > not volatile (take a look at the bit function headers)
> 
> That would be a broken gcc.  We run test_bit()/set_bit() and friends
> against plain old `unsigned long' in thousands of places.  There's
> nothing special about this one!
> 

No version of gcc would complain about this, even with 4.6 and later with 
-fstrict-volatile-bitfields, it's a qualifier that determines whether or 
not the access to memory is the exact size of the bitfield and aligned to 
its natural boundary.  If the type isn't qualified as such then it's 
simply going to compile to access the native word size of the 
architecture.  No special consideration is needed for a member of 
struct mem_cgroup.
