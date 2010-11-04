Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0KDVxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:53:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0KDVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:53:18 -0400
Date: Thu, 4 Nov 2010 22:51:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101104215157.GA25128@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104212920.GA31256@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> On Thu, Nov 04, 2010 at 08:08:04PM +0100, Ingo Molnar wrote:
> > 
> > * Marcus Meissner <meissner@suse.de> wrote:
> > 
> > > > For example, on a Fedora testbox i have this version info:
> > > > 
> > > >   $ uname -r
> > > >   2.6.35.6-48.fc14.x86_64
> > > > 
> > > > Any attacker can download that rpm from:
> > > > 
> > > >   http://download.fedora.redhat.com/pub/fedora/linux/updates/14/x86_64/kernel-2.6.35.6-48.fc14.x86_64.rpm
> > > > 
> > > > And can extract the System.map from it, using rpm2cpio and cpio -i -d. That will 
> > > > include all the symbol addresses - without the attacker having any access to the 
> > > > System.map or /proc/kallsyms on this particular box.
> > > > 
> > > > I.e. on distro kernel installations (which comprise the _vast_ majority of our 
> > > > userbase) your patch brings little security benefits.
> > > > 
> > > > What i suggested in later parts of my mail might provide more security: to 
> > > > sandbox kernel version information from unprivileged user-space - if we decide 
> > > > that we want to sandbox kernel version information ...
> > > > 
> > > > That is a big if, because it takes a considerable amount of work. Would be worth 
> > > > trying it - but feel-good non-solutions that do not bring much improvement to 
> > > > the majority of users IMHO hinder such efforts.
> > > 
> > > Hiding the OS version is really quite hard I think.
> > 
> > Yes. Hard but it would be useful - especially if we start adding things like known 
> > exploit honeypots. Forcing attackers to probe the kernel by actually running a 
> > kernel exploit, and risking an alarm would be a very powerful security feature.
> > 
> > Removing version info will upset some tools/libraries that rely on kernel 
> > version information for quirks though.
> 
> Quite honnestly, it's the worst idea I've ever read to protect the kernel. Kernel 
> version is needed at many places, when building some code which relies on presence 
> of syscall X or Y depending on a version, etc... [...]

Actually that's not true, since we have a kernel ABI, and since there's many 
backports of newer kernel features into older kernels that it's generally not
needed nor meaningful to know the kernel version for syscalls.

Returning -ENOSYS is the general standard we use to communicate syscall 
capabilities.

In fact using kernel version to switch around library functionality is a bug i'd 
argue.

> [...] If our kernel is so buggy that we can only rely on its version to be kept 
> secret, then we have already failed.

That mischaracterises my suggestion rather heavily - which makes me suspect that you 
misunderstood it. Here's the relevant section of what i suggested here:

> > Hard but it would be useful - especially if we start adding things like known 
> > exploit honeypots. Forcing attackers to probe the kernel by actually running a 
> > kernel exploit, and risking an alarm would be a very powerful security feature.

An 'exploit honeypot' would be some small amount of 'detection' code for the 
exploitable pattern of parameters (most attacks come via ioctls so we can add 
detection for known holes without any performance hit), and the kernel would warn 
the sysadmin that an exploit attempt has occured.

The point is to make it riskier to run exploits - not to 'hide version because we 
are so buggy'. Unprivileged attackers wont be able to know whether a kernel is 
unpatched and wont know whether trying an actual exploit triggers a silent alarm or 
not.

I.e. i think the only true break-through in kernel security will be to add credible 
and substantial 'strike back' functionality - to increase the risks of detection 
(which necessiates the removal of the information whether a kernel is patched or 
not).

As i said it's hard - but it would be a rather break-through security feature for 
Linux. Not an 'arms race' thing where we just put obstruction in the road of 
attackers - but some real, unavoidable risk not detectable by attackers - running on 
most stock distro kernels. (so there would be a real economy of scale)

The kerneloops client could also collect exploit attempt stats.

Thanks,

	Ingo
