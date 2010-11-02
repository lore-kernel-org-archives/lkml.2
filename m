Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0KBTeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:34:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0KBTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HPhu+vcQT5DWxpy104IDuz9Jpxy2LliEIESVIE6cCHc6H/9fzPW0X4wVA/iBH/fcON
         AUx95OXKiQa3We5JeHTA==
Date: Tue, 2 Nov 2010 12:34:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]oom-kill: direct hardware access processes should get
 bonus
In-Reply-To: <1288707894.19865.1.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011021228590.20105@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <alpine.DEB.2.00.1011012008160.9383@chino.kir.corp.google.com> <1288707894.19865.1.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010, Figo.zhang wrote:

> > Which applications are you referring to that cannot gracefully exit if 
> > killed?
> 
> like Xorg server, if xorg server be killed, the gnome desktop will be
> crashed.
> 

Right, but you didn't explicitly prohibit such applications from being 
killed, so that suggests that doing so may be inconvenient but doesn't 
incur something like corruption or data loss, which is what I would 
consider "unstable" or "inconsistent" state.

We're trying to avoid any additional heuristics from being introduced for 
specific usecases, even for Xorg.  That ensures that the heuristic remains 
as predictable as possible and frees a large amount of memory.  If Xorg is 
being killed first instead of a true memory hogger, then it seems like a 
forkbomb scenario instead; could you please post your kernel log so that 
we can diagnose that issue seperately?

> > CAP_SYS_RAWIO had a much more dramatic impact in the previous heuristic to 
> > such a point that it would often allow memory hogging tasks to elude the 
> > oom killer at the expense of innocent tasks.  I'm not sure this is the 
> > best way to go.
> 
> is it some experiments for demonstration the  CAP_SYS_RAWIO will elude
> the oom killer?
> 

The old heuristic would allow it to elude the oom killer because it would 
divide the score by four if a task had the capability, which is a much 
more drastic "bonus" than you suggest here.  That would reduce the score 
for the memory hogging task significantly enough that we killed tons of 
innocent tasks instead before eventually killing the task that was leaking 
memory but failed to be identified because it had CAP_SYS_RAWIO.  I'm 
trying to avoid any such repeats.
