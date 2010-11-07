Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0KGV4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:56:51 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:36189 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0KGV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:56:50 -0500
Message-ID: <4CD72150.9070705@cs.columbia.edu>
Date: Sun, 07 Nov 2010 16:59:44 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu> <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu>
In-Reply-To: <20101107184927.GF31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux containers mailing list]

On 11/07/2010 01:49 PM, Gene Cooperman wrote:

[snip]

> Matt had asked how we would handle inotify(), but I was getting swamped
> by all the questions.  There is a virtualization approach to inotify in which
> one puts wrappers around inotify_add_watch(), inotify_rm_watch() and
> friends in the same way as we wrap open() and could wrap close().
> One would then need to wrap read() (which we don't like to do, just

This sounds like reimplementation in userspace the very same logic
done by the kernel :)

> in case it could add significant overhead).  But if we consider kernel
> and userland virtualization together, then something similar to  TIOCSTI
> for ioctl would allow us to avoid wrapping read().

We could work to add ABIs and APIs for each and every possible piece
of state that affects userspace. And for each we'll argue forever
about the design and some time later regret that it wasn't designed
correctly :p

Even if that happens (which is very unlikely and unnecessary),
it will generate all the very same code in the kernel that Tejun
has been complaining about, and _more_. And we will still suffer
from issues such as lack of atomicity and being unable to do many
simple and advanced optimizations.

Or we could use linux-cr for that: do the c/r in the kernel,
keep the know-how in the kernel, expose (and commit to) a
per-kernel-version ABI (not vow to keep countless new individual
ABIs forever after getting them wrongly...), be able to do all
sorts of useful optimization and provide atomicity and guarantees
(see under "leak detection" in the OLS linux-cr paper). Also,
once the c/r infrastructure is in the kernel, it will be easy
(and encouraged) to support new =ly introduced features.

Finally, then we would use dmtcp as well as other tools on top
of the kernel-cr - and I'm looking forward to do that !

[snip]

>> Hmm... can you really c/r from userspace a process that was, at
>> checkpoint time, in a ptrace-stopped state at an arbitrary kernel
>> ptrace-hook ?  I strongly suspect the answer is "no", definitely
>> not unless you also virtualize and replicate the entire in-kernel
>> ptrace functionality in userspace,
>
> Let's try it and see.  If you write a program, we'll try it out in
> DMTCP (unstable branch) and see.  So far, checkpointing gdb sessions
> has worked well for us.  If there is something we don't cover, it will
> be helpful to both of us to find it, and analyze that case.

Try "strace bash" :)
I suspect it won't work - and for the reasons I described.

[snip]

>> (Now looking forward to discuss more details with dmtcp team on
>> Tuesday and on :)
>
> Also a very good point above, and I agree.  The offline discussion should
> be a better forum for putting this all into perspective.
>
> Thanks again for your thoughtful response,

Same here. Talk to you soon...

Oren.
