Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0G0Gpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:45:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57334 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0G0Gp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:45:29 -0400
Date: Tue, 27 Jul 2010 08:45:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Francis Galiegue <fgaliegue@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Vadim Bendebury <vbendeb@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Cheng Renquan <crquan@gmail.com>, Trevor Keith <tsrk@tsrk.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC][PATCH] kconfig: implement select with values
Message-ID: <20100727064523.GA25872@merkur.ravnborg.org>
References: <20100720043706.3813715a.sfr@canb.auug.org.au> <20100726221717.GA22439@merkur.ravnborg.org> <AANLkTikP3nZd-LionO27vsinjXz=upKbDZeErSD4CAfz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikP3nZd-LionO27vsinjXz=upKbDZeErSD4CAfz@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Cute.  I didn't know this was possible.  I'll give it a try and see
> how it works for me.  Do override config options also pickup
> select/depends constraints applied by later definitions?  I think that
> would be necessary to kick out warnings when a defconfig selection
> isn't actually achievable.

kconfig allows one to add more properties to a config
symbol by defining the symbol again.

So:
config FOO
	bool
	prompt "foo prompt"
	default y
	help
	  Help text

Is the same as:
config FOO
	bool

config FOO
	prompt "foo prompt"

config FOO
	default y

config FOO
	help
	  help text

The abvoe four lines can be located in different files.

And likewise kconfig allows the same property to be
specified twice or more.

So it is OK to say:

config BAR
	tristate "bar prompt"
	default m
	default y

Here kconfig just picks the first default is see.

And the example in my original mail uses the feature
that we can specify several defaults - and kconfig uses the first.


For choices the same is possible but then you need to use
a named choice - something that no one does today in the kernel.

choice CHOICE_X86_CPU
	default M386

endchoice

Here we change the default to M386 which becomes the
selected if we use "alldefconfig".

[Note: It does not work until we use named choices in arch/x86/Kconfig.cpu]

> 
> > Now in the original suggestion of Linus he used:
> >
> >    KBUILD_KCONFIG=Mykconfig make allnoconfig
> >
> > And "allnoconfig" would make the modified defaults useless.
> >
> > But the soon-to-be-introduced alldefconfig is more sensible.
> >
> > alldefconfig uses default values for everything.
> 
> I basically used defconfig in the prototype that I posted.  I think it
> works well for me, and I've got it integrated into the build targets
> (just like Stephen's earlier patch) without having to do a
> KBUILD_KCONFIG trick.

"defconfig" with an empty file gives same config as "alldefconfig" so
it makes sense. But we wanted to drop the use of defconfig files
in favour of files with Kconfig syntax.
So alldefconfig is just a better fit here.

[The above btw. also makes "savedefconfig" less usefull].

	Sam

