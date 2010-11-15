Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0KOKED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:04:03 -0500
Received: from smtp-out.google.com ([74.125.121.35]:3289 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0KOKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=a55rjhfty+bShtomMj2eZOlo7iP557I+1aLUxKfMLEdFyzDdGqJc7ausbf4set2BKU
         AyGPQbrJJ0vPeSUzOxpQ==
Date: Mon, 15 Nov 2010 02:03:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <20101115095446.BF00.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011150159330.2986@chino.kir.corp.google.com>
References: <20101112104140.DFFF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141322590.22262@chino.kir.corp.google.com> <20101115095446.BF00.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:

> > I think in cases of heuristics like this where we obviously want to give 
> > some bonus to CAP_SYS_ADMIN that there is consistency with other bonuses 
> > given elsewhere in the kernel.
> 
> Keep comparision apple to apple. vm_enough_memory() account _virtual_ memory.
> oom-killer try to free _physical_ memory. It's unrelated.
> 

It's not unrelated, the LSM function gives an arbitrary 3% bonus to 
CAP_SYS_ADMIN.  Such threads should also be preferred in the oom killer 
over other threads since they tend to be more important but not an overly 
drastic bias such that they don't get killed when using an egregious 
amount of memory.  So in selecting a small percentage of memory that tends 
to be a significant bias but not overwhelming, I went with the 3% found 
elsewhere in the kernel.  __vm_enough_memory() doesn't have that 
preference for any scientifically calculated reason, it's a heuristic just 
like oom_badness().

> > > CAP_SYS_RAWIO mean the process has a direct hardware access privilege
> > > (eg X.org, RDB). and then, killing it might makes system crash.
> > > 
> > 
> > Then you would want to explicitly filter these tasks from oom kill just as 
> > OOM_SCORE_ADJ_MIN works rather than giving them a memory quantity bonus.
> 
> No. Why does userland recover your mistake?
> 

You just said killing any CAP_SYS_RAWIO task may make the system crash, so 
presuming that you don't want the system to crash, you are suggesting we 
should make these threads completely immune?  That's never been the case 
(and isn't for oom_kill_allocating_task, either), so there's no history 
you can draw from to support your argument.
