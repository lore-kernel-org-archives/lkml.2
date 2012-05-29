Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2E2PHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:07:45 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37804 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753943Ab2E2PHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:07:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8_WCybAVM1k7rxZepbN1UGgOMwxqQGJwjDZumE.g_cKa7SU
 73ohm.1FqQ.3BaJoybzI6zb9Dp4pk1jrXbyV0Ht0D5puTm6pWbQtzTdZkcLI
 NSvO0V.UOK_tFyiFVcK5J628979R40almJpAIvJTnh6ec2QMweUaWxBWc_xo
 ITATXaYvltIqw_3ZpLPfkIUOlkM7PTKAvyA3dWtHhPN6pSJHqmGD_G.fuX5j
 jhC_94hdSB3hiVorDRdIJjeTvmhKnTxVpbU0Hf2ZGMyGNlRgD0wDNJtewtTb
 oDv3NpsR5MPl7s1_pXYDP_6gF0KBBNU5odsjskvzBEw3w6qk6f_7FeNheoHp
 0OfZXf12G9O29PGYfbBqBHzc4EpNV5DEOikcduzektzEw1glUMe_gJecAhpm
 vHPuVBk2XYtxTYJeziXu4GjLSC7UkXdoAZIge
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 10:07:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
In-Reply-To: <4FC3381C.9020608@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290955270.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz> <alpine.DEB.2.00.1205250933170.22597@router.home> <4FC3381C.9020608@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012, Glauber Costa wrote:

> > It would be best to merge these with my patchset to extract common code
> > from the allocators. The modifications of individual slab allocators would
> > then be not necessary anymore and it would save us a lot of work.
> >
> Some of them would not, some of them would still be. But also please note that
> the patches here that deal with differences between allocators are usually the
> low hanging fruits compared to the rest.
>
> I agree that long term it not only better, but inevitable, if we are going to
> merge both.
>
> But right now, I think we should agree with the implementation itself - so if
> you have any comments on how I am handling these, I'd be happy to hear. Then
> we can probably set up a tree that does both, or get your patches merged and
> I'll rebase, etc.

Just looked over the patchset and its quite intrusive. I have never been
fond of cgroups (IMHO hardware needs to be partitioned at physical
boundaries) so I have not too much insight into what is going on in that
area.

The idea to just duplicate the caches leads to some weird stuff like the
refcounting and the recovery of the arguments used during slab creation.

I think it may be simplest to only account for the pages used by a slab in
a memcg. That code could be added to the functions in the slab allocators
that interface with the page allocators. Those are not that performance
critical and would do not much harm.

If you need per object accounting then the cleanest solution would be to
duplicate the per node arrays per memcg (or only the statistics) and have
the kmem_cache structure only once in memory.

Its best if information is only in one place for design and for performance.
