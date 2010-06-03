Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0FCUGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:06:53 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37082 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0FCUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cQZ1Ql0NdXfUZuWNtIAlIerZ1MOUvsnVEB3DIz5RH+gXdjMr8I86eR7GuIl1vvTGsd
         TOsKbZK7XQ+Z0cxmfWT5dwNj44mlgm5nMasJ9Q0P+5oy9XTJwxSZRBOPNeklIg3zQuSw
         4BICreIKfWwFqXGMW01p+nwZ5yqV6RTZw04uU=
Date: Thu, 3 Jun 2010 22:06:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make save_stack_address()
	!CONFIG_FRAME_POINTER friendly
Message-ID: <20100603200655.GE5234@nowhere>
References: <20100603193239.GA31530@redhat.com> <4C080850.1090907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C080850.1090907@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:53:52PM -0700, Arjan van de Ven wrote:
> On 6/3/2010 12:32 PM, Oleg Nesterov wrote:
>> If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
>> non-reliable addresses on stack, this is all we have if dump_trace(bp)
>> is called with the wrong or zero bp.
>>
>> For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.
>>
>> This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
>> it reverts 1650743c "x86: don't save unreliable stack trace entries".
>>    
>
> would be nice if there was a compile time thing to detect if frame  
> pointers are on ratehr than an ifdef.


I wanted to suggest that too, but since only one place got the ifdef
after the second patch.

But yeah, something like this could be reused:


	if (reliable_frame_pointer(reliable))
		return ...;



> you're now also changing the rules; until now, you would ALWAYS get a  
> backtrace without noise....
> now that's changing quite a bit. How are various tools (like perf and  
> sysprof) going to cope with that?



perf and sysprof have their own stacktrace ops, so they aren't affected.
I think the rest is /proc/pid/task, lockdep, latencytop, ftrace, kmemleak,
etc...

For the kernel parts it's in fact desired.
And with ftrace we are changing some rules, but this is desired too, without
frame pointers we would have nothing anyway. And it's quite easy to
find out a stacktrace is not entirely reliable at a glance.

