Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab1EBNE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:04:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1EBNEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:04:55 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=80hgNzRN3JIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=07d9gI8wAAAA:8 a=wig0pkluvVJ5Rc9lS3IA:9 a=NqxgiAXzSqhcJQ37KogA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: 2.6.39-rc5-git2 boot crashs
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, tj@kernel.org
In-Reply-To: <BANLkTin=zhUfceHOg3i3BomYEa2kZm1cjQ@mail.gmail.com>
References: <web-516164730@zbackend1.aha.ru>
	 <BANLkTimda-mi2rjgnX0jqg7Pg-J6HSDb6w@mail.gmail.com>
	 <web-516277136@zbackend1.aha.ru>
	 <BANLkTin=zhUfceHOg3i3BomYEa2kZm1cjQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 02 May 2011 09:04:22 -0400
Message-ID: <1304341462.25414.2372.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-01 at 11:20 -0700, Linus Torvalds wrote:
> 2011/5/1 werner <w.landgraf@ru.ru>:

> So what I'd suggest you try to do is a "config bisect" to see exactly
> _what_ config option it is that makes things break. Steve Rostedt
> wrote a tool ("ktest") for this exact thing, but I'm not entirely sure
> that it will work for your situation. I've added Steve to the email
> participants, and I'd suggest you read up on it:
> 
>   http://lwn.net/Articles/414064/
> 
> would seem to be a good starting point.

Note, from his email he has:


> That successful slackware huge config is in the middle between the
> slackware smp config explained above which didnt boot, and between my
> normal everythingyes configuration which gave plenty problems.

Which, if I understand this correctly, is three different configs: A, B
and C and they have a relationship of A < B < C. Where A doesn't boot, B
does, and C boots with problems.

config-bisect can definitely find the issues between B and C, which I
think is a second issue. As for the problems of A and B it may not work
so well. This would require a "reverse bisect" as "config bisect" is
much like git bisect where it expects things to work then suddenly
break. The difference between git bisect and config bisect is that a
reverse wont work with config bisect (it might if you're lucky). That's
because git may have branches, but configs have nasty dependencies.

The way config bisect works to find a bad config (one if set will break
the kernel) is the following algorithm:

o You feed it a good config (does not have config that breaks the
kernel), and a config that breaks the kernel (contains a bad config).

again:

o It will select all the configs that are in both of the configs and
half of those configs that are in the difference of the two configs and
run make oldnoconfig on it. Because these configs can select other
configs or may depend on other configs not selected, it is possible that
we end up with the bad or good config again. So ktest does a diff on
this config to make sure it is different. If it is not then it will
select the other half instead. If it is also the same, then it will
select only one config at a time until it finds a config that is
different.

o runs the test
(you can add CONFIG_BISECT_TYPE = build, BISECT_MANUAL = 1, which will
just build the kernel and then wait for you to say if it was good or
bad. This is handy if you don't want to set up all the automation of
ktest and only want it to do the config bisect for you. Then you can
install and reboot the kernel and then tell ktest if it worked or not).
This still requires that the build machine to be on a separate box than
the test machine.

o If the test fails, it takes this config as the new bad config, and the
difference will be against this config and the good config.

o If the test passes, it believes all these configs that were selected
are good, and will permanently select them for the remainder of the
tests. We need to permanently select this configs because later configs
(and perhaps the bad config) may have dependencies on these configs.

o If there's no more configs to compare, then the last config to be
selected is the bad config, otherwise goto "again".


This works great when you have a bad config you are looking for. I've
used this 4 or 5 times already which had great results. But I do not
think it will help if there's a good config that makes the kernel work
again. If we select that config on the first pass, then all new configs
will contain this working config.


> 
> Of course, you could just try to do it manually too - just turn one
> subsystem at a time from a module in the working slackware config into
> a compiled-in thing, so that eventually you end up with the
> non-working "almost everything compiled in" case. And see which
> subsystem it is that causes problems.
> 
> And then when you find the subsystem that makes the problem re-appear,
> you'd need to go back and try each driver at a time.

I'm confused, as I thought the working config was between the two broken
configs he has. Maybe I just misunderstood.

-- Steve


