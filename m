Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab0EEPLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:11:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760045Ab0EEPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:11:17 -0400
Date: Wed, 5 May 2010 08:08:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Resource limits interface proposal [was: pull request for writable
 limits]
In-Reply-To: <4BE160C6.90404@gmail.com>
Message-ID: <alpine.LFD.2.00.1005050757370.5478@i5.linux-foundation.org>
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200> <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org> <4BE160C6.90404@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 May 2010, Jiri Slaby wrote:
> 
> So I ended up with thinking about these possibilities:
> 
> 1) internal representation of limits will stay as is in signal_struct,
> i.e. long limits with infinity being ~0ul. This is the least intrusive
> solution. The new prlimit64 will convert rlimit64 to rlimit and pass
> down to do_prlimit. With setrlimit and getrilimit just as wrappers it
> will look like:
> prlimit64(pid, resource, new64, old64) ->
>     new = convert_to_rlim(new64)
>     tsk = find_task(pid)
>     do_prlimit(tsk, resource, new, old)
>     old64 = convert_to_rlim64(old)
> setrlimit(resource, rlim) ->
>     do_prlimit(current, resource, rlim, NULL)
> getrlimit(resource, rlim) ->
>     do_prlimit(current, resource, NULL, rlim)
> with appropriate copy_{from,to}_user. (And setrlimit+getrlimit will be
> scheduled for removal with all the compat crap around them.)

Yes, this sounds much better to me.

> It may also be that rlimit64 will contain flags like:
> #define RLIM64_CUR_INFINITY     0x00000001
> #define RLIM64_MAX_INFINITY     0x00000002
> struct rlimit64 {
>         __u64 rlim_cur;
>         __u64 rlim_max;
>         __u32 flags;
> };
> if I understood Alexey correctly to separate limits values from
> infinity? flags then will be converted to ~0ul when converting from
> rlimit64 to rlimit above too.

Ok, I'm not entirely sure we need to care specially about INFINITY, 
_especially_ since INF is really rather big in 64 bits. So to some degree, 
making things 64-bit is _less_ likely to make INFINITIES a problem.

It's also impossible to convert back and forth reliably unless you were to 
add this bit to the internal rlimit structure too. It sounds like a bad 
design to have

	prlimit64(-1, limit, &new, NULL);
	prlimit64(-1, limit, NULL, &old);

result in "old" containing something different than "new".

Of course, if there are 32-bit/64-bit issues, the above can _never_ give 
the same results for >= (1<<32) values, but that's a somewhat separate 
issue, and is directly tied to the word-size, not some new internal flag.

> The drawback is when a 32-bit user passes down a value >= (1 << 32),
> EINVAL shall occur.

I'd almost prefer to just turn them into RLIMIT_MAX. If somebody asks for 
a really huge limit that is bigger than the max we already have, doesn't 
RLIMIT_MAX sound like the right thing?

> 2) Introduce an rlimit lock and move every user to the rlimit helpers
> which appropriately lock the accesses. And making locking a nop when
> BITS_PER_LONG == 64. Then we can have rlimit64 in signal_struct and
> everything will happen on 64-bit limit values.

I think long-term we might want to do this, but not as a first stage. And 
if the 'infinity' flag makes sense, _and_ we decide that long-term we want 
to do this, then I'm not objecting to adding it now.

> Just a side note, we cannot use the rlimit64 name which is already
> reserved in glibc headers for limits handling.

What does the glibc 'struct rlimit64' look like? It's the structure name 
that matters, since the system call name would presumably be 'prlimit64()' 
due to the pid thing.

And if the glibc rlimit64 matches what we would use, I think we can decide 
to just re-use it.

		Linus
