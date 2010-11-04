Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0KDWfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:35:51 -0400
Received: from 1wt.eu ([62.212.114.60]:46944 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0KDWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:35:49 -0400
Date: Thu, 4 Nov 2010 23:35:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104223526.GC31236@1wt.eu>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104215157.GA25128@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 10:51:57PM +0100, Ingo Molnar wrote:
> > Quite honnestly, it's the worst idea I've ever read to protect the kernel. Kernel 
> > version is needed at many places, when building some code which relies on presence 
> > of syscall X or Y depending on a version, etc... [...]
> 
> Actually that's not true, since we have a kernel ABI, and since there's many 
> backports of newer kernel features into older kernels that it's generally not
> needed nor meaningful to know the kernel version for syscalls.
> 
> Returning -ENOSYS is the general standard we use to communicate syscall 
> capabilities.
> 
> In fact using kernel version to switch around library functionality is a bug i'd 
> argue.

I'm sorry Ingo, but I still don't agree. We've had several versions of epoll,
several (some even buggy) versions of splice() which cannot even be detected
without checking the kernel release. And those are just two that immediately
come to my mind. If we've been providing a version for the last 19 years, it
surely had some valid uses.

> > [...] If our kernel is so buggy that we can only rely on its version to be kept 
> > secret, then we have already failed.
> 
> That mischaracterises my suggestion rather heavily - which makes me suspect that you 
> misunderstood it. Here's the relevant section of what i suggested here:
> 
> > > Hard but it would be useful - especially if we start adding things like known 
> > > exploit honeypots. Forcing attackers to probe the kernel by actually running a 
> > > kernel exploit, and risking an alarm would be a very powerful security feature.

I have read it, but this does not require hiding the kernel version. You can
still keep your honey pots if you want (provided that they don't slow down
normal syscall path) and log suspect attempts. But if you're hiding the version,
those tricks will be used by valid programs too.

> An 'exploit honeypot' would be some small amount of 'detection' code for the 
> exploitable pattern of parameters (most attacks come via ioctls so we can add 
> detection for known holes without any performance hit), and the kernel would warn 
> the sysadmin that an exploit attempt has occured.

If we pollute the ioctl code with all the CVEs we have accumulated over the
years, I bet we'd get a performance hit and will probably introduce new bugs
due to the harder to maintain code.

> The point is to make it riskier to run exploits - not to 'hide version because we 
> are so buggy'. Unprivileged attackers wont be able to know whether a kernel is 
> unpatched and wont know whether trying an actual exploit triggers a silent alarm or 
> not.

In my opinion, hiding the distro-specific part of the version should not cause
too much harm, but still I find this useless.

You see, I've used the vmsplice exploit at one place. Do you know how I did ?
$ cat /etc/redhat-release

Then I opened the box and installed the DVD showing the same version on a
spare PC to experiment with it. Once I got the exploit to reliably work without
crashing the kernel nor leaving traces, I dared launching it on the target
machine and it worked. Uname -r was not involved there. I simply relied on
the fact that updating a distro is a pain at many places and that it's very
rare to find an updated one because of that, so they remain with the shipped
kernel for months if not years, and sometimes even because some product
vendors say "my product supports Red Hat kernel 2.6.18-128xxx" so they don't
want to risk losing the support because they don't understand anything to
versioning.

So if we make fixes easier to install, we'd probably have less issues with
unfixed code than if we try to pretend they're not vulnerable by hiding the
version.

> I.e. i think the only true break-through in kernel security will be to add credible 
> and substantial 'strike back' functionality - to increase the risks of detection 
> (which necessiates the removal of the information whether a kernel is patched or 
> not).
> 
> As i said it's hard - but it would be a rather break-through security feature for 
> Linux.

It requires hiding so many things for providing so little protection that I
really don't believe in it at all. Simply checking the system uptime the
last most date of /boot generally tells you precise info about the last
udpate.

> Not an 'arms race' thing where we just put obstruction in the road of 
> attackers - but some real, unavoidable risk not detectable by attackers - running on 
> most stock distro kernels. (so there would be a real economy of scale)
> 
> The kerneloops client could also collect exploit attempt stats.

Well, in my opinion, either the attacker is remote and you can already get
many info, or he's local and has time to precisely qualify the environment
in order not to leave the slightest trace. The rule is simple : if you don't
trust your local users, remain up to date. One day lag once and you lose.

Regards,
Willy

