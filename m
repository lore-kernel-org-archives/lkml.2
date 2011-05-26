Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab1EZUdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:33:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1EZUdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=w+CdguNtcLNKnAf2ouWble6p1gVNWzIkD7chPB/yx1nwlov71n7yHDQlfD/7TJkQed
         lsca9Q5J3U6vVzVMmozQ==
Date: Thu, 26 May 2011 13:33:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
In-Reply-To: <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com> <1306440288.3857.9.camel@gandalf.stny.rr.com> <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Vaibhav Nagarnaik wrote:

> > Hmm, have you tried this in practice? Yes we may kill the "echo" command
> > but it doesn't stop the ring buffer from being allocated, and thus
> > killing the echo command may not be enough, and those critical processes
> > that you are trying to protect will be killed next.
> >
> 
> Yes I did try this and found that it works as we intend it to. When
> oom-killer is invoked, it picks the process which has lowest
> oom_score_adj and kills it or one of its children.

s/lowest/highest/

> When the process is
> getting killed, any memory allocation from it would be returned -ENOMEM,
> which gets handled in our allocation process and we free up previously
> allocated memory.
> 

Not sure that's true, this is allocating with kzalloc_node(GFP_KERNEL), 
correct?  If current is oom killed, it will have access to all memory 
reserves which will increase the liklihood that the allocation will 
succeed before handling the SIGKILL.

> This API is now being used in other parts of kernel too, where it knows
> that the allocation could cause OOM.
> 

What's wrong with using __GFP_NORETRY to avoid oom killing entirely and 
then failing the ring buffer memory allocation?  Seems like a better 
solution than relying on the oom killer, since there may be other threads 
with a max oom_score_adj as well that would appear in the tasklist first 
and get killed unnecessarily.  Is there some ring buffer code that can't 
handle failing allocations appropriately?
