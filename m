Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0KSPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:34:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:42314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab0KSPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:34:05 -0500
Message-ID: <4CE698C5.5060806@kernel.org>
Date: Fri, 19 Nov 2010 16:33:25 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kirill Korotaev <dev@parallels.com>
CC: Serge Hallyn <serge.hallyn@canonical.com>, Kapil Arya <kapil@ccs.neu.edu>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu> <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu> <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org> <20101117153902.GA1155@hallyn.com> <4CE3F8D1.10003@kernel.org> <20101119041045.GC24031@hallyn.com> <4CE683E1.6010500@kernel.org> <04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
In-Reply-To: <04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Nov 2010 15:33:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/19/2010 03:36 PM, Kirill Korotaev wrote:
> Can you imagine how many userland APIs are needed to make userspace C/R?
> 
> Do you really want APIs in user-space which allow to:
> - send signals with siginfo attached (kill() doesn't work...)

Doesn't rt_sigqueueinfo() already do this?

> - read inotify configuration

This would be nice even apart from CR.

> - insert SKB's into socket buffers

Can't we drain kernel buffers?  ie. Stop further writing and wait the
send-q to drop to zero.

> - setup all TCP/IP parameters for sockets

I _think_ most can be restored by talking to netfilter module.
Setting outgoing sequence number might be beneficial tho.

> - wait for AIO pending in other processes

I haven't looked at aio implementation for a while now but can't we
drain these upon checkpointing and just carry the completion status?
Also, if aio is what you're concerned about, I would say the problem
is mostly solved.

> - setting different statistics counters (like netdev stats etc.)
> and so on...

Why would this matter?

> For every small piece of functionality you will need to export ABI
> and maintain it forever.  It's thousands of APIs! And why the hell
> they are needed in user space at all?

I think it's actually quite the contrary.  Most things are already
visible to userland.  They _have_ to be and that's the reason why
userland implementation can already get most things working without
any change to the kernel with some amount of hackery.  To me in-kernel
CR seems to approach the problem from the exactly wrong direction -
rather than dealing with specific exceptions, it create a completely
new framework which is very foreign and not useful outside of CR.

Also, think about it.  Which one is better?  A kernel which can fully
show its ABI visible states to userland or one which dumps its
internal data structurs in binary blobs.  To me, the latter seems
multiple orders of magnitude uglier.

> BTW, HPC case you are talking about is probably the simplest
> one.

Yet, it is one of the the most important / relevant use cases.

> Last time I looked into it, IBM Meiosis c/r didn't even bother with
> tty's migration.  In OpenVZ we really do need much more then that
> like autofs/NFS support, preserve statistics, TTYs, etc. etc. etc.

Would it be impossible to preserve autofs/NFS and TTYs from userland?
Then, why so?  For statistics, I'm a bit lost.  Why does it matter and
even if it does would it justify putting the whole CR inside kernel?

Thank you.

-- 
tejun
