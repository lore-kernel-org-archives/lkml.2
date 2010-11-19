Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0KSOnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:43:09 -0500
Received: from relay.parallels.com ([195.214.232.42]:48933 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0KSOnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:43:07 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 09:43:06 EST
From: Kirill Korotaev <dev@parallels.com>
To: Tejun Heo <tj@kernel.org>
CC: Serge Hallyn <serge.hallyn@canonical.com>, Kapil Arya <kapil@ccs.neu.edu>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Date: Fri, 19 Nov 2010 17:36:41 +0300
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Topic: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Index: AcuH9y5n1jV1drYSTfqSGoPD82CpoA==
Message-ID: <04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>
References: <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <20101106053204.GB12449@count0.beaverton.ibm.com>
 <20101106204008.GA31077@sundance.ccs.neu.edu>
 <4CD5D99A.8000402@cs.columbia.edu>
 <20101107184927.GF31077@sundance.ccs.neu.edu>
 <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org>
 <20101117153902.GA1155@hallyn.com> <4CE3F8D1.10003@kernel.org>
 <20101119041045.GC24031@hallyn.com> <4CE683E1.6010500@kernel.org>
In-Reply-To: <4CE683E1.6010500@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

Sorry for getting into the middle of the discussion, but...

Can you imagine how many userland APIs are needed to make userspace C/R?

Do you really want APIs in user-space which allow to:
- send signals with siginfo attached (kill() doesn't work...)
- read inotify configuration
- insert SKB's into socket buffers
- setup all TCP/IP parameters for sockets
- wait for AIO pending in other processes
- setting different statistics counters (like netdev stats etc.)
and so on...

For every small piece of functionality you will need to export ABI and maintain it forever.
It's thousands of APIs! And why the hell they are needed in user space at all?

BTW, HPC case you are talking about is probably the simplest one. Last time I looked into it, IBM Meiosis c/r 
didn't even bother with tty's migration. In OpenVZ we really do need much more then that like
autofs/NFS support, preserve statistics, TTYs, etc. etc. etc.

Thanks,
Kirill

On Nov 19, 2010, at 17:04 , Tejun Heo wrote:

> On 11/19/2010 05:10 AM, Serge Hallyn wrote:
>> Hey Tejun  :)
> 
> Hey, :-)
> 
>>> and in light of already working userland alternative and the
>> 
>> Here's where we disagree.  If you are right about a viable userland
>> alternative ('already working' isn't even a preqeq in my opinion,
>> so long as it is really viable), then I'm with you, but I'm not buying
>> it at this point.
>> 
>> Seriously.  Truly.  Honestly.  I am *not* looking for any extra kernel
>> work at this moment, if we can help it in any way.
> 
> What's so wrong with Gene's work?  Sure, it has some hacky aspects but
> let's fix those up.  To me, it sure looks like much saner and
> manageable approach than in-kernel CR.  We can add nested ptrace,
> CLONE_SET_PID (or whatever) in pidns, integrate it with various ns
> supports, add an ability to adjust brk, export inotify state via
> fdinfo and so on.
> 
> The thing is already working, the codebase of core part is fairly
> small and condor is contemplating integrating it, so at least some
> people in HPC segment think it's already viable.  Maybe the HPC
> cluster I'm currently sitting near is special case but people here
> really don't run very fancy stuff.  In most cases, they're fairly
> simple (from system POV) C programs reading/writing data and burning a
> _LOT_ of CPU cycles inbetween and admins here seem to think dmtcp
> integrated with condor would work well enough for them.
> 
> Sure, in-kernel CR has better or more reliable coverage now but by how
> much?  The basic things are already there in userland.  The tradeoff
> simply doesn't make any sense.  If it were a well separated self
> sustained feature, it probably would be able to get in, but it's all
> over the place and requires a completely new concept - the
> quasi-ABI'ish binary blob which would probably be portable across
> different kernel versions with some massaging.  I personally think the
> idea is fundamentally flawed (just go through the usual ABI!) but even
> if it were not it would require _MUCH_ stronger rationale than it
> currently has to be even considered for mainline inclusion.
> 
> Maybe it's just me but most of the arguments for in-kernel CR look
> very weak.  They're either about remote toy use cases or along the
> line that userland CR currently doesn't do everything kernel CR does
> (yet).  Even if it weren't for me, I frankly can't see how it would be
> included in mainline.
> 
> I think it would be best for everyone to improve userland CR.  A lot
> of knowdledge and experience gained through kernel CR would be
> applicable and won't go wasted.  Strong resistance against direction
> change certainly is understandable but IMHO pushing the current
> direction would only increase loss.  I of course could be completely
> wrong and might end up getting mails filled up with megabytes of "told
> you so" later, but, well, at this point, in-kernel CR already looks
> half dead to me.
> 
> Thank you.
> 
> -- 
> tejun
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

