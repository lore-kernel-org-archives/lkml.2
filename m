Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2JSJbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:31:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39228 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2JSJbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:31:35 -0400
Date: Fri, 19 Oct 2012 02:31:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
In-Reply-To: <50811903.9000105@parallels.com>
Message-ID: <alpine.DEB.2.00.1210190229450.26815@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <20121017151214.e3d2aa3b.akpm@linux-foundation.org> <507FC8E3.8020006@parallels.com> <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
 <50811903.9000105@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Glauber Costa wrote:

> >>> Do we actually need to test PF_KTHREAD when current->mm == NULL? 
> >>> Perhaps because of aio threads whcih temporarily adopt a userspace mm?
> >>
> >> I believe so. I remember I discussed this in the past with David
> >> Rientjes and he advised me to test for both.
> >>
> > 
> > PF_KTHREAD can do use_mm() to assume an ->mm but hopefully they aren't 
> > allocating slab while doing so.  Have you considered actually charging 
> > current->mm->owner for that memory, though, since the kthread will have 
> > freed the memory before unuse_mm() or otherwise have charged it on behalf 
> > of a user process, i.e. only exempting PF_KTHREAD?
> > 
> I always charge current->mm->owner.
> 

Yeah, I'm asking have you considered charging current->mm->owner for the 
memory when a kthread (current) assumes the mm of a user process via 
use_mm()?  It may free the memory before calling unuse_mm(), but it's also 
allocating the memory on behalf of a user so this exemption might be 
dangerous if use_mm() becomes more popular.  I don't think there's 
anything that prevents that charge, I'm just wondering if you considered 
doing it even for kthreads with an mm.
