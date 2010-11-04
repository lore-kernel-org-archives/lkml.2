Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0KDOd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:33:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:37852 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab0KDOdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:33:24 -0400
Date: Thu, 4 Nov 2010 15:33:22 +0100
From: Marcus Meissner <meissner@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104143322.GL25118@suse.de>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104141104.GA31753@elte.hu>
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 03:11:04PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Marcus Meissner <meissner@suse.de> wrote:
> > 
> > > On Thu, Nov 04, 2010 at 12:46:48PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Marcus Meissner <meissner@suse.de> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > Making /proc/kallsyms readable only for root makes it harder for attackers to 
> > > > > write generic kernel exploits by removing one source of knowledge where things are 
> > > > > in the kernel.
> > > > 
> > > > Cc:-ed Linus - i think he argued in favor of such a patch in the past.
> > > > 
> > > > I generally agree with such patches (i have written some myself), but there's a few 
> > > > questions with this one, which make this limited change ineffective and which make 
> > > > it harder to implement a fuller patch that makes it truly harder to figure out the 
> > > > precise kernel build:
> > > > 
> > > >  - The real security obstruction effect is very small from this measure alone: the 
> > > >    overwhelming majority of our users are running distro kernels, so the Symbol.map 
> > > >    file (and hence 99% of /proc/kallsyms content) is well-known - unless we also 
> > > >    restrict 'uname -r' from nonprivileged users-ace. Hiding that might make sense - 
> > > >    but the two should be in one patch really.
> > > 
> > > Of course. System.map and others also need to turn to mode 400.
> > 
> > That is not what I meant, at all.
> > 
> > It's not the System.map _on the system_.
> > 
> > It's the SuSE or Fedora kernel rpm package with a System.map in it, which package 
> > the attacker can download from a hundred mirrors on the internet, based on 'uname 
> > -r' output.
> 
> For example, on a Fedora testbox i have this version info:
> 
>   $ uname -r
>   2.6.35.6-48.fc14.x86_64
> 
> Any attacker can download that rpm from:
> 
>   http://download.fedora.redhat.com/pub/fedora/linux/updates/14/x86_64/kernel-2.6.35.6-48.fc14.x86_64.rpm
> 
> And can extract the System.map from it, using rpm2cpio and cpio -i -d. That will 
> include all the symbol addresses - without the attacker having any access to the 
> System.map or /proc/kallsyms on this particular box.
> 
> I.e. on distro kernel installations (which comprise the _vast_ majority of our 
> userbase) your patch brings little security benefits.
> 
> What i suggested in later parts of my mail might provide more security: to sandbox 
> kernel version information from unprivileged user-space - if we decide that we want 
> to sandbox kernel version information ...
> 
> That is a big if, because it takes a considerable amount of work. Would be worth 
> trying it - but feel-good non-solutions that do not bring much improvement to the 
> majority of users IMHO hinder such efforts.

Hiding the OS version is really quite hard I think.

I mean the kernel could hide it from uname, but lsb_release,
/etc/redhat-release, /etc/SuSE-release etc still exist and then you
can still use the fixed address list table inside your exploit. But an
exploits needs to have such a list, making it harder to write.

If we avoid exploits being able to just do open("/boot/System.map") it would
make it a useful step harder for exploit writers.

(This will end up a arms race between us and the exploit toolkit writers of course,
but hopefully not a longer one than fixing all actual problems ;)


I also briefly thought about kernel ASLR, but my knowledge of the kernel
loading is too limited whether this is even possible or at all useful.

Ciao, Marcus
