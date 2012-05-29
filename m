Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2E2UVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 16:21:25 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:34650 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755737Ab2E2UVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 16:21:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4WqnXkEVM1lhuSgZ5ws2vWwpvpWTvXZZNFp3Z4qefuFn_CC
 _zTRBtodylDsxse9MX3ufDavx8Y3PrWogD8mqmosEuqq7reDU53a7WJgrVtz
 EndmBpqD1aYA1XMZd8BgwceopB1vmpsxQGYlYaO9f4c3k6mMl_bjr2.MYRl0
 c6KXeYBbGGpNLB9bBQLIJdAK3L0qW66hyE4jkgRDxLWaOCaaP5dZ_loFyx3A
 wcOcQYbnp2rPNFDqAjv.PG.cgzId5XddqQxt4w44ug1kwZvXc0edODa3xhqv
 reZSuMfxDgQ6gKDi.dXqW3t2EMISuGJE7QWSUg2LmirhShh7.hQICG8u47zZ
 iNGTPqR8zlksxPxdu3VKZx9MqtEwg7ylNx10xMYxMmECTmSY0ZhNYw3xXBj6
 U
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 15:21:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
In-Reply-To: <4FC52CC6.7020109@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291514090.2504@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com> <alpine.DEB.2.00.1205291454030.2504@router.home>
 <4FC52CC6.7020109@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Glauber Costa wrote:

> Well, I'd have to dive in the code a bit more, but that the impression that
> the documentation gives me, by saying:
>
> "Cpusets constrain the CPU and Memory placement of tasks to only
> the resources within a task's current cpuset."
>
> is that you can't allocate from a node outside that set. Is this correct?

Basically yes but there are exceptions (like slab queues etc). Look at the
hardwall stuff too that allows more exceptions for kernel allocations to
use memory from other nodes.

> So extrapolating this to memcg, the situation is as follows:
>
> * You can't use more memory than what you are assigned to.
> * In order to do that, you need to account the memory you are using
> * and to account the memory you are using, all objects in the page
>   must belong to you.

Cpusets work at the page boundary and they do not have the requirement you
are mentioning of all objects in the page having to belong to a certain
cpusets. Let that go and things become much easier.

> With a predictable enough workload, this is a recipe for working around the
> very protection we need to establish: one can DoS a physical box full of
> containers, by always allocating in someone else's pages, and pinning kernel
> memory down. Never releasing it, so the shrinkers are useless.

Sure you can construct hyperthetical cases like that. But then that is
true already of other container like logic in the kernel already.

> So I still believe that if a page is allocated to a cgroup, all the objects in
> there belong to it  - unless of course the sharing actually means something -
> and identifying this is just too complicated.

We have never worked container like logic like that in the kernel due to
the complicated logic you would have to put in. The requirement that all
objects in a page come from the same container is not necessary. If you
drop this notion then things become very easy and the patches will become
simple.
