Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1AME1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:27:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40275 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1AME1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c+tQypTbsO6SSLm0Yoi+gPCl9HY/GhjH5lvW+KUC4fmlQSi5JqGZ+gCwEAkTrXzefJ
         TS5UKncHpZRj4z8KtFuHVD66Ic9TSxKzxh+3LD5FIZvqAq14KER9owgSbHmgkyqjMZq9
         AU/CBGN56QHFGBFRJJmdUmtzUkKk4c748jGHQ=
MIME-Version: 1.0
In-Reply-To: <1294890910.15025.75.camel@heimdal.trondhjem.org>
References: <29345.1294861630@jrobl>
	<1294862680.2971.51.camel@heimdal.trondhjem.org>
	<AANLkTik-AdWpPqmR5TSCuijGwe3XLXm=HYVdUOhK3dDT@mail.gmail.com>
	<1294890910.15025.75.camel@heimdal.trondhjem.org>
Date: Thu, 13 Jan 2011 15:27:39 +1100
Message-ID: <AANLkTin2Z35vhbEou7U_FE0rSmL7zpfBRBeYtTPucwpC@mail.gmail.com>
Subject: Re: vfs-scale, chroot
From: Nick Piggin <npiggin@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 2:55 PM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
> On Thu, 2011-01-13 at 12:25 +1100, Nick Piggin wrote:
>> On Thu, Jan 13, 2011 at 7:04 AM, Trond Myklebust
>> <Trond.Myklebust@netapp.com> wrote:
>>
>> > BTW, Nick: Given that some filesystems such as NFS are _always_ going to
>> > reject LOOKUP_RCU,
>>
>> That's not very optimistic of you... why is that a given, my I ask?
>> Or do you just mean as-in the current code?
>
> In the current code, the ECHILD is unconditional, so adding the
> unlikely() is clearly pre-empting the reality on the ground.

Sure, I just hoped you didn't mean NFS can not be converted
to use it in future. nfs in particular is one of the more "difficult"
implementations I would like to see able to use rcu-walk.


> In the longer run, we can convert the NFS d_revalidate() to accept
> LOOKUP_RCU in the case where we believe we can trust the cache without
> having to issue an RPC call. That will mainly be in the case where we
> hold an NFSv4 delegation, or where we believe the parent directory mtime
> has not changed. However that is not something I'm going to have the
> cycles to do in this merge window. I assume there will be other
> filesystems whose maintainers have similar constraints.

Sure. And in the cases where lookup cannot be satisfied from RAM, the
filesystem simply should not be deployed for path-lookup performance
critical (in terms of CPU cycles) applications. It's a nice self-confirming
loop for the rcu-walk performance tradeoff.


> However, even if we were to make these changes, then we're not going to
> be accepting LOOKUP_RCU in the 99.999% case that is usually a
> requirement for unlikely() to be an acceptable optimisation. For a
> number of common workload, directories change all the time, and in NFS,
> that inevitably means we need to revalidate their contents with an RPC
> call (unless we happen to hold an NFSv4 delegation).

99.999%, no. 1 out of every 100 000 operations? That means that
if a correct branch annotation reduces 0.1 cycles (being pessimistic),
then an incorrect one costs 10000 cycles more than if the annotation
had not existed (on the order of 100 cache misses or 500 branch
mispredicts). That is totally out of proportion.

It really depends on a lot of things.

Branch annotation tends not to kill dynamic branch prediction hardware,
rather it should provide a default so that the hardware defaults to the
more common path if the branch is not in the history.

The main impact is moving uncommon case out of icache. This does
cost a bit of code and an extra unconditional branch when it is wrong.

I would say it is more between the order of 90%-99% (ie. order of 0.1s
of cycles improvement in the correct case, and 1s or 10s of added in
the incorrect case).


>> The annotations really help to reduce icache penalty of added
>> complexity which is why I like them, but I'm happy to remove them
>> where they don't make sense of course.
>
> You are adding overhead to existing common paths by doubling the calls
> to d_revalidate() in ways which afaics will break branch prediction
> (first setting, then clearing LOOKUP_RCU).

Well it should be set once, and clear for the rest of the path walk, so only
a dumb bimodal predictor would break, but without going into details, I'm
not denying that path walking is suboptimal for rcu-walk incapable
filesystems.


> You can at least try not to
> maximise that impact by adding further branch prediction impediments.

There is simply even more code, more branches, more loads, etc for
unconverted filesystems as well. The goal was to *first* minimise the cost
of rcu-walk, *then* minimise the cost of ref-walk.

So if we're looking at micro optimising performance for specific filesystems
and re tuning some of my assumptions based on real world cases, I would
like to wait for filesystems to be converted.

Yes that leaves 2.6.38 a tiny bit slower for unconverted filesystems, but it
really shouldn't be a big deal. If you desperately care about a few cycles
here, (I applaud you but) then convert to rcu-walk and it will blow your
mind.

I am not abandoning your plight :) The fact is that I did spend a long time
looking at profiles and assembly for rcu-walk converted cases, and only on
a very particular set of workloads. So I am really keen to re tune some of
those assumptions as we see how things get used in the real world, I
just don't know if it is worth redoing before fs developers get a bit of time
to explore how rcu-walk might work.
