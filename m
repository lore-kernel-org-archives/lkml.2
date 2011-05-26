Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab1EZVAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:00:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1EZVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:00:14 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=v1vRyZxt8XHty9geEIUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
	 <1306440288.3857.9.camel@gandalf.stny.rr.com>
	 <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
	 <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 17:00:12 -0400
Message-ID: <1306443612.3857.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 13:33 -0700, David Rientjes wrote:
> On Thu, 26 May 2011, Vaibhav Nagarnaik wrote:
> 

> 
> Not sure that's true, this is allocating with kzalloc_node(GFP_KERNEL), 
> correct?  If current is oom killed, it will have access to all memory 
> reserves which will increase the liklihood that the allocation will 
> succeed before handling the SIGKILL.

Actually it uses get_free_page()

> 
> > This API is now being used in other parts of kernel too, where it knows
> > that the allocation could cause OOM.
> > 
> 
> What's wrong with using __GFP_NORETRY to avoid oom killing entirely and 

I have no problem with NORETRY.

> then failing the ring buffer memory allocation?  Seems like a better 
> solution than relying on the oom killer, since there may be other threads 
> with a max oom_score_adj as well that would appear in the tasklist first 
> and get killed unnecessarily.  Is there some ring buffer code that can't 
> handle failing allocations appropriately?

The ring buffer code can handle failed allocations just fine, and will
free up the pages it allocated before a full success. It allocates the
pages one at a time and adds it to a list. After all pages it wants to
allocate has successfully been allocated, it then applies them to the
ring buffer. If it fails an allocation, all pages are freed that were
not added to the ring buffer yet.

But the issue is, if the process increasing the size of the ring buffer
causes the oom, it will not handle the SIGKILL until after the ring
buffer has finished allocating. Now, if it failed to allocate, then we
are fine, but if it does not fail, but now we start killing processes,
then we may be in trouble.

I like the NORETRY better. But then, would this mean that if we have a
lot of cached filesystems, we wont be able to extend the ring buffer?

I'm thinking the oom killer used here got lucky. As it killed this task,
we were still out of memory, and the ring buffer failed to get the
memory it needed and freed up everything that it previously allocated,
and returned. Then the process calling this function would be killed by
the OOM. Ideally, the process shouldn't be killed and the ring buffer
just returned -ENOMEM to the user.

-- Steve


