Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2ESBoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:44:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab2ESBoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMh1VQ5BAybLEzVLqL2cOQe2CJ8CgbK+5-R4sH4iG0Kvog@mail.gmail.com>
References: <20120515154333.6659.66479.sendpatchset@w520> <201205162205.09082.rjw@sisk.pl>
 <CAOesGMjgBWxjAvMpcxWsJf7n3q90sGhccUSgfGxJQA+tfDZBHw@mail.gmail.com>
 <201205170037.34305.rjw@sisk.pl> <CAOesGMi8LPO=AFSshC8UyCmBB3hG38YKHWnHmcNCnLvgR2xcTw@mail.gmail.com>
 <20120518225625.28C643E07C8@localhost> <CAOesGMh1VQ5BAybLEzVLqL2cOQe2CJ8CgbK+5-R4sH4iG0Kvog@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 19:44:01 -0600
X-Google-Sender-Auth: 3Iud6fY0kdyB9yEshQH593vc1LY
Message-ID: <CACxGe6uNgE6Xdx965fSi8ezVts7FFiW6kuBbyEGJXkRD4eoP6Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
To: Olof Johansson <olof@lixom.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, lethal@linux-sh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 7:18 PM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, May 18, 2012 at 3:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, 16 May 2012 15:54:16 -0700, Olof Johansson <olof@lixom.net> wrote:
>>> On Wed, May 16, 2012 at 3:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > On Thursday, May 17, 2012, Olof Johansson wrote:
>>> >> On Wed, May 16, 2012 at 1:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> >> > On Wednesday, May 16, 2012, Linus Walleij wrote:
>>> >> >> On Wed, May 16, 2012 at 12:15 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>> >> >>
>>> >> >> > Do you guys have any preferences how to merge this?
>>> >> >> >
>>> >> >> > Can I include it together with the EMEV2 SoC bits perhaps? That may be
>>> >> >> > easy so we can keep track of the platform data header file dependency.
>>> >> >>
>>> >> >> For ux500 I made a special "gpio and pins" branch and sent through ARM SoC.
>>> >> >
>>> >> > The problem is we have a patch depending on the $subject one in the EMEV2
>>> >> > series and it would be better to keep them both together if that's not
>>> >> > a big deal.
>>> >>
>>> >> Dependencies are fine, as long as they are not circular. You can
>>> >> either pull in the gpio/pins branch into the EMEV2 branch, or base it
>>> >> on it.
>>> >
>>> > I guess I'll try to merge the gpio/pins into the EMEV2 branch.
>>>
>>> By the way, I should have mentioned that if the dependencies are only
>>> for building and not for context when applying patches, then it's
>>> sufficient to let us know in the pull request so we merge the branches
>>> in the right order when sending to Linus (so we maintain
>>> bisectability).
>>
>> Really?  I don't think that works. The actually commit point will
>> always be unbuildable regardless of the merge order in mainline.  If
>> there is a dependency then the dependency must be merged into the
>> working branch before applying the commit.
>
> Not if the prerequisite commit sits in a branch that is merged before
> the dependent commit.
>
> A git bisect should never end up in a situation where the second
> commit is included but the first is not. Either that, or I have
> completely misunderstood how it works.
>
> Of course, this assumes that the dependency is one-way, and not mutual.

I think either you've misunderstood, or I've misunderstood you.  Sooo,
let's trot out an example:

Consider the following:

Mainline (git log --oneline --graph)
* cc88978 C
* 3fcf8cf B
* ecc927b A

Branch X:
* a3152ba X1
* 3fcf8cf B
* ecc927b A

Branch Y:
* 7ebda88 Y1
* 3fcf8cf B
* ecc927b A

Commits A and B are common on all three branches.  Mainline has an
additional commit 'C', X has X1 and Y has Y1.  Now; let's say commit
Y1 actually depends on commit X1, and let's say the merge order
reflects that.  Mainline will now look like:

*   602fa8f E: Merge branch 'Y'
|\
| * 7ebda88 Y1
* |   14697ca D: Merge branch 'X'
|\ \
| * | a3152ba X1
| |/
* | cc88978 C
|/
* 3fcf8cf B
* ecc927b A

Right?  Now if we do a git bisect:
$ git bisect bad
You need to start by "git bisect start"
Do you want me to do it for you [Y/n]? y
(master|BISECTING) ~/test/gittry$ git bisect bad HEAD
(master|BISECTING) ~/test/gittry$ git bisect good ecc927b
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[a3152ba87f16b1b319869d0920e414a70cdaf2d9] X1
((a3152ba...)|BISECTING) ~/test/gittry$ git bisect good
Bisecting: 1 revision left to test after this (roughly 1 step)
[14697cab82f0ea655d0f8ee10f57f197fe69acb8] D: Merge branch 'X'
((14697ca...)|BISECTING) ~/test/gittry$ git bisect good
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[7ebda88aec6eeeda8e9264de3f22df5ac86d3c70] Y1
((7ebda88...)|BISECTING) ~/test/gittry$ git log --oneline
7ebda88 Y1
3fcf8cf B
ecc927b A

See?  Y1 shows up without the X1 parent.  With git, there is never a
straight line history, so every commit must be fully built on top of
all the commits it needs.  (And did I understand what you were trying
to describe correctly?)

g.
