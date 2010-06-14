Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0FNLtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:49:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0FNLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:49:09 -0400
Date: Mon, 14 Jun 2010 13:49:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nils Carlson <nils.carlson@ludd.ltu.se>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100614114906.GG17092@basil.fritz.box>
References: <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519064619.GA30320@aftab> <20100519070919.GA9618@elte.hu> <50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50689ECC-A371-4923-BEBE-1A5A7E5B9D3B@ludd.ltu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just left the above for reference. How would this affect other
> aspects of EDAC such as the error injection, the sysfs
> entries that (in most cases) reflect the layout of dimm's, and

Some of this can be probably retained, about the way EDAC
e.g. represents layout is quite unsuitable too. It includes
a lot of internal implementation details that in some cases
you can't even get anymore on modern design. Something
with a proper abstract interface is better.  EDAC never had this.

Also the biggest problem is still that EDAC doesn't
give you any silk screen labels, so unless you 
have motherboard schemantics the layout it presents
is fairly useless -- you still don't know which DIMM
to exchange. So in theory EDAC looks great, but in practice ...

On a lot of modern systems I checked DMI
seems reasonably accurate in terms of layout, so I suspect they can 
be handled with this. For others probably
still need some special driver, but one 
with a proper interface.

For error injection: some modern systems support this
though ACPI EINJ which has an separate non EDAC 
interface. For others I've been simply using some scripts
that twiddle the bits from user space. You can do that
with a shell script. If it was staying in the kernel
it could be probably moved into a proper error injection
framework that is not arbitarily tied to memory.
Lots of different devices have error injection
support and exposing some of that a in a general
frame work would likely make sense.

Anyways the old EDAC drivers for this are not going
away, you can still use them. The interesting
question though is how to properly define the interface
for new hardware.

> allow the setting of scrub rate? If we're just talking about

I never quite saw the point of that one, but yes
there's no replacement for this anywhere else.

Normally scrub rate can be simply set in the BIOS,
is that not good enough? Is there a use case for
changing it dynamically? 

Note that modern hardware typically has demand scrubbing
anyways, that is when there is an error it automatically
scrubs.

> replacing all instances of printk (when logging single bit
> errors) with perf events, I don't really see that as a problem.

I don't think perf is the right tool for this, the semantics
are mostly unsuitable (it hasn't been designed as a error reporting
tool, but as a performance tool and performance events are quite
different from errors) and it doesn't provide most of the infrastructure
needed for it anyways.

> But EDAC is much more than that today...

Well it's a hodge podge of quite a lot of odd bits.
I'm not sure "more" is the right word.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
