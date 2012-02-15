Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2BOExd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:53:33 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15962 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab2BOExc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:53:32 -0500
Message-ID: <4F3B3A14.7000305@parallels.com>
Date: Wed, 15 Feb 2012 08:52:36 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [patch 0/4] Resending, c/r series v2
References: <20120213164822.227219834@openvz.org> <20120214145136.fa400757.akpm@linux-foundation.org>
In-Reply-To: <20120214145136.fa400757.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 02:51 AM, Andrew Morton wrote:
> On Mon, 13 Feb 2012 20:48:22 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> Hi, this series hopefully in a good shape
>>
>>  - sys_kcmp now depends on CONFIG_CHECKPOINT_RESTORE
>>
>>  - the extension of /proc/pid/stat now done against
>>    linux-next/master
>>
>> Please letme know if I've missed something.
> 
> Thus far our (my) approach has been to trickle the c/r support code
> into mainline as it is developed.  Under the assumption that the end
> result will be acceptable and useful kernel code.
> 
> I'm afraid that I'm losing confidence in that approach.  We have this
> patchset, we have Stanislav's "IPC: checkpoint/restore in userspace
> enhancements" (which apparently needs to get more complex to support
> LSM context c/r).  I simply *don't know* what additional patchsets are
> expected.  And from what you told me it sounds like networking support
> is at a very early stage and I fear for what the end result of that
> will look like.

I understand. But there was a confidence that nobody wanted the c/r stuff to 
be the "one big kernel subsystem", but it should rather be "a bunch of small 
API-s for what is required". The amount of code for the initial C/R attempt was
~100 patches. The amount of code to support our user-space C/R implementation
*only* is ~10 and the feature-set of both is already comparable.


As far as the networking is concerned -- we will not require any additional
patches to implement the basic netns configuration migration (ip can show and
re-configure all we need about routing, interfaces, devices, etc. and the
iptables-save/iptables-restore will handle 99.9% of the netfilter part). For
what we currently need is the ability to explore sockets queues, but currently
this doesn't turn out to be a lot of code -- I have 60-lines patch for unix
sockets and Tejun showed the way how to do the same with TCP using 130 lines
of code. UDP won't require anything, its queues can be silently dropped. The
recent 50 patches with *_diag stuff doesn't count, because it works not for C/R
only, the ss tool can benefit from 100% of the added functionality (this, btw, 
shows that not every piece of code we add for C/R is for C/R *only*).

> So I don't feel that I can continue feeding these things into mainline
> until someone can convince me that we won't have a nasty mess (and/or
> an unsufficiently useful feature) at the end of the project.

Isn't the CONFIG_CHECKPOINT_RESTORE option turned off by default enough?

> The traditional approach is to develop the feature out-of-tree until it
> is "finished".  That's a lot more hackwork for you guys and it leads to
> a poorer feature - this approach inevitably has a lower level of review
> and inhibits code rework.

That's why we started sending patches early.

> An alternative is for me to buffer the patches in my tree until it is
> all sufficiently finished.  That also is more work for your team, but
> it will produce better code, because of additional review and code
> rework resulting from that review.
> 
> I don't know how many patches that would end up being (this is part of
> the problem!) nor how long they would be carried for.

Neither do I :(

> So.  Please talk to me.  How long is this all going to take, and what
> will the final result look like?

The Big Intermediate Result we're trying to achieve is -- take a basic
OpenVZ or LXC container based on e.g. rhel6 template and make sure we can
checkpoint and restore it without breaking one.


The More-or-less Finished state of the project would be when it's able to
do all the stuff that the OpenVZ's implementation can. The list of major
features which are yet absent in the CRIU and for which we will require the
kernel support includes

* shared kernel objects (this thread)
* tcp connection
* pty stuff
* sysvipc
* iterative working set migration

The latter one is an ability to find out which pages processes use and catch
when they change data on them. I planned to discuss this on LSF, but we can
start earlier if you want.

Other currently missing stuff is quite minor or doesn't require any new things
form the kernel like signalfd-s or netfilter.


The Ultimate Goal is hard to describe because we have the variety of ideas
about what the CRIU can do including such things as checkpointing desktop apps'
with their xserver state or live-migrating parts of a multi-process app from
one box to another.


Thanks,
Pavel
