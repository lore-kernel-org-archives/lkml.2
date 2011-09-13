Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab1IMWGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:06:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1IMWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:06:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=AQOZae7lKmvVkFv24rDfBubowibybfhRD8fje+VntGeEZcqIAltHJoI1iryvpui32
	csYeC3mSsFgbzXrtAE33g==
Date: Tue, 13 Sep 2011 15:06:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@suse.de>, Paul Menage <paul@paulmenage.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] cpusets: avoid looping when storing to mems_allowed if
 one node remains set
In-Reply-To: <4E6EDA2B.9090507@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1109131503520.11120@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1109090313130.23841@chino.kir.corp.google.com> <4E6EDA2B.9090507@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011, Miao Xie wrote:

> This patch is dangerous if the task has a bind memory policy that was set
> to be neither MPOL_F_STATIC_NODES nor MPOL_F_RELATIVE_NODES, because the
> memory policy use node_remap() to rebind the allowed nodes, but node_remap()
> may make the old mask and the new mask nonoverlapping. So at this condition,
> the task may also see an empty node mask.
> 

The vast majority of cpuset users are not going to have mempolicies at 
all, the cpuset itself is the only policy they need to take advantage of 
the NUMA locality of their machine.  I'd be find with checking for 
!tsk->mempolicy in this exception as well since we already hold 
task_lock(tsk), but I think the real fix would be to make sure that an 
empty nodemask is never returned by mempolicies.  Something like ensuring 
that if the preferred node is MAX_NUMNODES (since it is determined by 
using first_node() over a possibly racing empty nodemask) that the first 
online node is returned during the race and that 
node_states[N_HIGH_MEMORY] is returned if an MPOL_BIND or MPOL_INTERLEAVE 
mask is empty.  Thoughts?
