Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1ANJEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:04:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1ANJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=FCN1zVk0GK1gp49lq2zoK2b0LIPFtc7mGoN3ozUw+Kb1IGTtU+J3Uf5/uTTTo54D2e
         3bslAmjUg4tRmUX9qcpyWuyueCabeiy+md0gRbdBViAY9p10z+BR487oPCzCqktVMYLl
         imCUMLRV4JQNeOqD2lKrpDPoVPpKJxmWivwl8=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com> <4D2EDBE4.3060608@hitachi.com>
	<m34o9c8ual.fsf@gmail.com> <4D2FC17D.5010203@hitachi.com>
Date: Fri, 14 Jan 2011 10:03:53 +0100
In-Reply-To: <4D2FC17D.5010203@hitachi.com> (Masami Hiramatsu's message of
	"Fri, 14 Jan 2011 12:22:37 +0900")
Message-ID: <m3tyhb6eme.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:

> (2011/01/14 4:42), Franck Bui-Huu wrote:

[...]

>> Well, for consistency, I thought that the additional information
>> (given inside angle brackets) should always be the same: a full path
>> and an absolute line number which clearly identify which source file
>> perf-probe is listing.
>
> No, that is NOT an additional information. That indicates from where
> those lines are started

But this indication is currently not enough, it's too ambiguous to be
usefull:

        <schedule:10>

there might be several 'schedule()' functions inside the kernel, also we
don't know which kernel tree is used.

BTW, if there're several 'do_something' functions defined inside the
kernel, what is the behaviour of:

  $ perf probe do_something

Does it set a probe to all 'do_something' functions ? I don't think it's
documented.

> , and also gives you a hint how you can specify the actual probe
> point. For example,
>
> $ perf probe -L schedule:10
> <schedule:10>
>      10         rq = cpu_rq(cpu);
>      11         rcu_note_context_switch(cpu);
>      12         prev = rq->curr;
>
> this indicates the lines started from 10th line of schedule(), and

but I'm not sure it's really usefull since you've asked for it when
invoking perf-probe so it seems to be redundant.

> if you want to put a new event on "prev = rq->curr;" line, you just
> need to say "perf probe schedule:12"

yes and this patch doesn't change that, does it ?

> $ perf probe -L kernel/sched.c:4077
> </home/mhiramat/ksrc/linux-2.6-tip/kernel/sched.c:4077>
>    4077         rq = cpu_rq(cpu);
>    4078         rcu_note_context_switch(cpu);
>    4079         prev = rq->curr;
>
> And this also gives you a hint to say (just copy & paste)

No copy & paste in my case, I just reuse the shell history. This is the
reason why I didn't understand your suggestion.

So to get back to my initial suggestion and with this patch applied:

   $ perf probe -L schedule:10-15
   </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3823>
        10         rq = cpu_rq(cpu);
        11         rcu_note_context_switch(cpu);
        12         prev = rq->curr;
        13         switch_count = &prev->nivcsw;
            
        15         release_kernel_lock(prev);

I know exactly which bit of code I'm looking at, and to put a probe I
can still simply do (without any copy and paste):

    $ perf probe schedule:12

I still use the function name of the probe and the relative line number
showed by perf-probe.

For probe specified by filename:

    $ perf probe -L kernel/sched.c:3823-3826
    </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3823>
       3823         rq = cpu_rq(cpu);
       3824         rcu_note_context_switch(cpu);
       3825         prev = rq->curr;
       3826         switch_count = &prev->nivcsw;

now to set a probe, I would do:

    $ perf probe kernel/sched.c:3825

I still use the linenum showed by perf-probe, and the additional
information is always consistent and still usefull since it shows which
tree perf-probe is using.

But if you think it should be used to hint for a probe point syntax,
(you'll probably use copy & paste since it uses absolute path name),
then this patch is wrong.

Thanks
-- 
		Franck
