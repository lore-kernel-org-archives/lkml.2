Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab1ISXHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:07:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23858 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1ISXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:07:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=VBttUPMthj7z15/t5+Yb1y77N8DLLnAs8Dmek6Uj/yu11oNsnwnF2Ioz9eWslGiNU
	dmbOc9YwQlxn23dydgR7g==
Message-ID: <4E77CB30.3030509@google.com>
Date: Mon, 19 Sep 2011 16:07:28 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andi Kleen <andi@firstfloor.org>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316031196.5040.46.camel@twins> <m2fwjyg9fx.fsf@firstfloor.org> <1316076989.3045.8.camel@twins>
In-Reply-To: <1316076989.3045.8.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/11 01:56, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 13:23 -0700, Andi Kleen wrote:
>> Peter Zijlstra<a.p.zijlstra@chello.nl>  writes:
>>>
>>> Guys we should seriously trim back a lot of that code, not grow ever
>>> more and more. The sad fact is that if you build a kernel with
>>> cpu-cgroup support the context switch cost is more than double that of a
>>> kernel without, and then you haven't even started creating cgroups yet.
>>
>> That sounds indeed quite bad. Is it known why it is so costly?
>
> Mostly because all data structures grow and all code paths grow, some by
> quite a bit, its spread all over the place, lots of little cuts etc..
>
> pjt and I tried trimming some of the code paths with static_branch() but
> didn't really get anywhere.. need to get back to looking at this stuff
> sometime soon.

When I get some time I think I'm just going to post a patch[*] that 
merges the useful _field_ (usage, usage_percpu) from cpuacct into cpu 
since we are *already* doing the accounting on the entity level making 
this addition free.

At that point we could !CONFIG_CGROUP_CPUACCT by default and deprecate 
the beast without breaking ABI for those who really need it (either 
because their applications have hard-coded paths or because they really 
like cgroup user/sys time -- which we COULD duplicate into cpu but I'm 
inclined not to).

[*]: the only real caveat is how loudly people scream about the code 
duplication; I think it's worth it if it let's us kill cpuacct in the 
long run.

Another unrelated optimization on this path I have sitting around in 
patches/ to push at some point is keeping the left-most entity out of 
tree; since the worst case is an entity with a lower-vruntime comes 
along and we insert the previous left-most and the best case is we get 
to pick it without futzing with the rb-tree.  I think this was good for 
a percent or two when I hacked it together before.

Another idea I have kicking around for this path is the introduction of 
a link_entity which bridges over nr_running=1 chains (break it 
opportunistically when an element in the chain goes to nr_running=2). 
This one requires some pretty careful accounting around the breaking of 
a chain though so I'm not touching it until I get the new load tracking 
code out.  (Incidentally when I benchmarked it before LPC I had it 
working out to be a little more efficient than the current math good for 
~2-3% on pipe_test.)

- Paul
