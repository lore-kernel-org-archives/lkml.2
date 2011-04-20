Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1DTUYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:24:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55773 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab1DTUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mSl9g2o3AZaWbaRm89hYoDeJ5xmzcuLs8IJJ3LifCdsn/itCtGYzydWLvnvNVD0aPM
         sDwnJJqeUvg9g2PyeByg==
Date: Wed, 20 Apr 2011 13:24:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <johnstul@us.ibm.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <20110420093900.45F6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com>
References: <20110419094422.9375.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104191419470.510@chino.kir.corp.google.com> <20110420093900.45F6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, KOSAKI Motohiro wrote:

> > That was true a while ago, but you now need to protect every thread's 
> > ->comm with get_task_comm() or ensuring task_lock() is held to protect 
> > against /proc/pid/comm which can change other thread's ->comm.  That was 
> > different before when prctl(PR_SET_NAME) would only operate on current, so 
> > no lock was needed when reading current->comm.
> 
> Right. /proc/pid/comm is evil. We have to fix it. otherwise we need change
> all of current->comm user. It's very lots!
> 

Fixing it in this case would be removing it and only allowing it for 
current via the usual prctl() :)  The code was introduced in 4614a696bd1c 
(procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm) in 
December 2009 and seems to originally be meant for debugging.  We simply 
can't continue to let it modify any thread's ->comm unless we change the 
over 300 current->comm deferences in the kernel.

I'd prefer that we remove /proc/pid/comm entirely or at least prevent 
writing to it unless CONFIG_EXPERT.
