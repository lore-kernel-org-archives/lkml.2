Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2GEUck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:32:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51743 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2GEUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:32:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6763"; a="205421750"
X-IronPort-AV: E=Sophos;i="4.77,531,1336374000"; 
   d="scan'208";a="159938992"
Date: Thu, 5 Jul 2012 13:32:35 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>, <664461@bugs.debian.org>,
        "axst@users.sourceforge.net" <axst@users.sourceforge.net>,
        nic-devel <nic-devel@qualcomm.com>, <linux-kernel@vger.kernel.org>,
        Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>
Subject: Re: [squeeze] atl1c: AR8152: "transmit queue 0 timed out" and
 network is unusable until reset
Message-ID: <20120705203235.GE11228@tux>
References: <alpine.DEB.2.00.1204122237590.26390@flora>
 <20120412205649.GC2904@burratino>
 <alpine.DEB.2.00.1204181155550.26390@flora>
 <20120418184224.GJ28058@burratino>
 <alpine.DEB.2.00.1205092147260.20626@flora>
 <20120509221617.GA4730@burratino>
 <157393863283F442885425D2C454285623D663D1@nasanexd02a.na.qualcomm.com>
 <1336624111.8274.377.camel@deadeye>
 <20120704174653.GA5962@burratino>
 <20120704181614.GB6039@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120704181614.GB6039@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 01:16:14PM -0500, Jonathan Nieder wrote:
> Jonathan Nieder wrote:
> > Luis R. Rodriguez wrote:
> 
> >> FWIW we already provide daily backports of code through compat-wireless.
> >> compat-wireless will eventually be changed to "compat-drivers" to reflect
> >> that it has drivers backported other than 802.11. We also have stable releases
> >> of the Linux kernel backported for use on older releases.
> >
> > I looked at the relevant repositories and am afraid I am too dim to
> > see how to use them.
> 
> Ok, it's becoming a little clearer now.  Is the appropriate procedure
> something like this?
> 
>   git clone git://github.com/mcgrof/compat.git
>   git clone git://github.com/mcgrof/compat-wireless.git

git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

>   cd compat-wireless
>   git checkout linux-3.0.y
>   GIT_COMPAT_TREE=$(pwd)/compat/

this ones always assumes $HOME/compat so if you have it there
already there is no need to specify this variable.

>   NEXT_TREE=/path/to/src/linux
>   GIT_TREE=/path/to/linux/repo
>   export GIT_TREE GIT_COMPAT_TREE
Nope,

export GIT_TREE=/home/foo/linux-stable.git

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

I use Greg's linux-stable.git so I can use all the
extra version stable kernels, but on top of that I have
a remote set up to also pull in Linus' junk:

[remote "linus"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = git://github.com/torvalds/linux.git

So I just do this on linux-stable:

git fetch linus
git reset --hard origin

Then I get reset --hard v3.5-rc5 given that Linus will typically
have a delta on top of the latest RC.

>   scripts/gen-stable-release.sh <some appropriate arguments>

The arguments allows you to specify which delta you want to
suck in, if at all.

http://wireless.kernel.org/en/users/Download/stable/#Legend
http://wireless.kernel.org/en/users/Download/stable/#Additional_patches_to_stable_releases

> And then this will not generate a list of patches but just a patched
> source code tree with appropriate #ifdefs to make the code build
> against old kernels.

#ifdef'ing around code to provide kernel backporting is a strategy
of the stone age. We have taken a slightly different approach, we
have stuffed as much into a module / headers: compat.git so that the
code can remain as pristine as possible. This also means that you can
backport *more* subsystems with less effort and I've proven this through
a graph which shows the overhead cost of backporting a new subsystem
once you have a lot of code within a shared compat module:

https://docs.google.com/presentation/d/1axVNEGwKZjnzG1ocdd289WMqPxzJ3qfMv70ghGcnUKc/edit

The only #ifdef crap needed really would then just be things that *cannot* be
backported through a module / headers. In turn we've been discovering that some
of this #ifdef'able stuff actually can be represented also using SmPL and that
this SmPL actually represents collateral evolutions of the Linux kernel.  So
the patches/ directory represents just this: collateral evolutions of the Linux
kernel. I've started to formally document this slowly.  The first one is the
patch with 4 digits:

patches/0001-netdev_ops.patch

Jesper Andersen however has written a tool called spdiff which I intend
on using to extract SmPL *from* a patch file ! What this means is if
one collateral evolution *which could not be backported through compat.git*
is backported for *two drivers* it means that we can backport that collateral
evolution for *all drivers*. Furthermore if we design collateral evolutions
on the Linux kernel *with* SmPL it means we also can backport that respective
collateral evolution with the *inverse* of SmPL !

> That sounds useful.

How about with all the other junk I just mentioned ? :)

I should mention that stable releases are  already made:

http://wireless.kernel.org/en/users/Download/stable/

But surely you can also just make your own as well. The stable releases
also are test compiled accross 21 kernels, and soon, thanks to Ozan's
GSoC project I hope we'll have video backported as well.

  Luis
