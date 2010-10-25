Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0JYRKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:10:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab0JYRKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:10:51 -0400
Date: Mon, 25 Oct 2010 19:10:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025171022.GA29803@elte.hu>
References: <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025091913.GA17622@basil.fritz.box>
 <20101025111530.GA27659@elte.hu>
 <20101025123753.GB17622@basil.fritz.box>
 <20101025125531.GA6075@elte.hu>
 <20101025131127.GC17622@basil.fritz.box>
 <20101025134740.GA8888@elte.hu>
 <20101025151427.GD17622@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025151427.GD17622@basil.fritz.box>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> [...]
>
> They are really all quite different.

The differences in those tools do not seem natural. Those tools are mostly just 
different for difference's sake - which is sad.

They could also admittedly benefit from a proper build mechanism and other 
integration goodies. For example when building mce-inject i get:

  $ make
  Makefile:42: .depend: No such file or directory

When running the mce-inject tool it apparently hangs:

  $ ./mce-inject 

(it's waiting for stdin)
  
it does not recognize any of the standard arguments:

  $ ./mce-inject -h
  -h: No such file or directory
  $ ./mce-inject --help
  --help: No such file or directory
  $ 

That's rather user-unfriendly.

Also, that's all besides the point, exactly _why_ should bad tooling examples be 
justification for us to continue that bad example in kernel-space and to ignore good 
user-space tooling examples?

Also, my NAK is not really against your user-space tooling - my NAK is against the 
kernel bits.

> On merging them:
> 
> Well ok in theory one could have ras test1|test2|test3

It's a good first step to realize that.

> But you would end up like git and perf where you have lots of different tools just 
> linked into the same executable. [...]

... or LTP, which too is a suite of many tests.

For testing it's especially good to think in 'suites', as there are many repetitive 
components and people quite often tend to want to use all the tests when they are 
validating, certifying, debugging a particular piece of hardware.

> [...] Not really an advantage, would you agree on that?

If you only look at Git, perf and LTP as examples then them offering a consistent, 
integrated command, configuration and handling interface is _wildly_ advantageous.

There's a common help system, common documentation, common parameters, common 
workflow and a common philosophy behind those tools - and more. There's development 
process advantages as well: beyond sharing code via common libraries the developers 
cross much easier and generally advantages of economy of scale apply.

Note, i'm not telling you to follow those examples. I only point out that they exist 
and that we try to shape the kernel interfaces based on sane examples not based on 
insane examples.

> Ok i understand in the git/perf case there's also a common library, but at least 
> in the error injection case there isn't really.

There isnt really mostly because you are not making use of common facilities. That's 
my whole point. It's a bug, not a feature. You make this area flow apart into 
inconsistent utilities, there's no coherency.

Which is fine to me as long as you dont contaminate the kernel with that kind of 
incoherency ...

> Anyways if the request is to link everything into a single binary it could be 
> looked at, but I must admit I personally don't see any advantage from that.

Why do you limit the advantages of Git et al to 'linking into a single binary' 
artificially? It isnt the only or even main advantage.

( That claim isnt even true technically, perf for example supports and uses script
  extensions that are separate from the main binary. Git has similar helpers as well
  although it tends to integrate all core functionality. )

> Or you could have a single kernel inject interface with a bazillion modi and 
> different options that needs to be extended all the time to cover some new case. 
> Aka the ioctl multiplexer from hell. [...]

Why use an ioctl multiplexer from hell?

A proper system call or sysfs based approach should be used - that way the hierarchy 
and structure is achieved via a VFS namespace.

         CPU events would be under /sys/devices/system/cpu/cpu0/events/
     IO-APIC events would be under /sys/devices/system/ioapic/ioapic0/events/
   NUMA node events would be under /sys/devices/system/node/node0/events/
 PCI chipset events would be under /sys/devices/pci0000:00/events/

etc.

There would be a /sys/class/events/ iterator to find all events, etc.

There is no messy ioctl demux - just a clean hiearchy of hw structure, and event and 
hardware specific implementations of them (with a good deal of sane default 
behavior, as many events dont need special treatment).

The main 'global' property that is absolutely needed is event enumeration.

Regular event reporting is event 'output' - while injection is really event 'input' 
with custom handlers to make it trigger under the right circumstances, but it's 
essentially the same abstract model that stands behind them.

> [...] I don't think that's really an appealing alternative. It would work if all 
> the injections were very similar, but they are really not. They are all different.

If you are artificially limiting options to an insane solution then of course it 
looks all unappealing to you ...

How about not doing that and considering the model we outlined?

> Current way is to have own files in debugfs for each or put in other places where 
> it fits (e.g. madvise for in process injection)

As i mentioned it several times (and even in the previous mail) we are moving it to 
sysfs - several versions of patches have been posted.

So why are you pretending that debugfs is our main goal? It isnt.

> Is the problem that there is no cleanly defined place in debugfs for it? Maybe 
> could simply define a standard directory structure in debugfs?
> 
> I don't have a problem with that. Right now the approach was to put it into a 
> directory per subsystem, but perhaps there could be something better.

Right. A first good step would be to log all those ERST events via TRACE_EVENT() and 
map out any missing bits you may need to get them logged.

Another useful area would be to help out Ling Ming finish up the sysfs bits, and to 
have events attach to existing topologies that Linux enumerates already.

Another good place to help would be Boris and the RAS tool, which involves the 
definition of new events that cover all the relevant event sources, and the 
population of tools/edac/ with tooling. That too could grow APEI and ERST logging 
(and later, injection) awareness.

Yet another useful area would be to define injection capabilities to TRACE_EVENT() 
type of events.

> > Your refusal to even consider this possibility and to look at the EDAC/RAS 
> > patches that deal with this is puzzling to me.
> 
> What I find puzzling is that you really continue to ignore all the practical 
> details, and still nack other people's work without even trying to understand it.

If only you listed practical details then we could address them ...

But as long as you come up with vague objections there's little i can do but to 
point out crap when it happens later: when you ignore what i suggest and then post a 
messy solution a few months down the line.

> That's not really the old Ingo I used to know.

That comes with me being a maintainer i'm afraid, i'm more directly affected by bad 
patches so i object to them more frequently. I'm also kind of expected to do that.

Thanks,

	Ingo
