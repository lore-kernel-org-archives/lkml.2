Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0JCQmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:42:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55317 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0JCQmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:42:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20100930221351.682772535@linutronix.de>
Date: Sun, 03 Oct 2010 09:41:49 -0700
In-Reply-To: <20100930221351.682772535@linutronix.de> (Thomas Gleixner's
	message of "Thu, 30 Sep 2010 23:14:27 -0000")
Message-ID: <m1wrpzfctu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [patch 00/47] Sparse irq rework
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> The following patch series cleans up and mostly reimplements the core
> sparse irq implementation and sanitizes the most complex (ab)user:
> arch/x86

Overall this patchset looks pretty sane, but I don't see a clear picture
of what everything is going to look like when the dust settles.

> The series is based on the previous rework of irq chip functions which
> is available at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core
>
> A combined throwaway git repository with all the following patches on top of
> tip/irq/core is available at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-sparse-irq.git
>
> The overall changes are (full changelog below):
>     56 files changed, 1229 insertions(+), 1682 deletions(-)
>
> The series consists of 3 parts:
>
>     - cleanup of kernel/irq code and implementation of new allocator
>     - conversion of x86 to new irq_chip functions and new allocator
>     - trivial cleanup of the remaining users and removal of the old stuff
>
> It's fully bisectable and survived a night of testing in my testfarm.
>
> There are two bugfix patches (1/47, 2/47), which resulted of staring
> at that maze for way too long. They are targeted for mainline urgent,
> but I left them in the queue to avoid further churn.
>
>
> Rationale:
> ----------
>
> The current sparse_irq allocator has several short comings due to
> failures in the design or the lack of it:
>
>  - Requires iteration over the number of active irqs to find a free slot
>    Some architectures have grown their own workarounds for this.
>
>  - Freeing of irq descriptors is not possible
>
>  - Racy between create_irq_nr and destroy_irq plugged by horrible
>    callbacks
>
>  - Migration of active irq descriptors is not possible

I believe you have distored the design when aiming for migration
of active irq descriptors (which you have not even implemented yet).

How do you plan to remove the radix tree lookup from the irq
handling path?

On x86 the obvious implementation is to store a pointer to the irq_desc
in our 256 entry per cpu tables.  Please implement this and see how
it affects the design.  The code is pretty trivial.

>From what I can see of your migration plan it seems incompatible with
removing the radix tree look up in the path to generic_handle_irq().

>  - No bulk allocation of irq ranges

Where is that a short coming?

> Aside of that the sparse irq design failure caused that we sprinkled
> irq_desc references all over the place outside of kernel/irq/. That
> makes it extremly hard to do the core changes which are necessary to
> do further cleanups and improvements like he migration of active irq
> descriptors. The arch code needs only to know about the irq chip and
> the data associated with the irq. The irq descriptor itself is solely
> a core code data structure.

If by core you mean arch code irq handling code certainly and
msi fits that bill.

> The reason is that with the non sparse code access to the irq data was
> just array pointer math and most code (aside of the old __do_IRQ()
> users) used the provided accessor functions.
>
> With sparse it requires a radix tree lookup, which casued performance
> problems. Instead of tackling the problem at the chip function level
> and handing down a pointer to the associated data instead of an irq
> number, the low level code acquired a reference to irq_desc and
> populated that all over the place. Yeah, it's easier than doing a full
> cleanup and a sensible migration path, but the resulting mess is just
> disgusting.
>
> The previous chip functions series on which this series is based is
> addressing this issue on the chip level side by handing down the
> associated interrupt data instead of the interruut number. The x86
> cleanup is making use of it.

And always handing down the data structure so you can do the same
thing with sparse irq enabled or not is a much needed code cleanup.


> New implementation:
> -------------------
>
> I've implemented a sane allocator which fixes the above short comings
> (though migration of active descriptors still needs a full tree wide
> cleanup of the direct and mostly unlocked access to irq_desc).
>
> The new allocator still uses a radix_tree, but uses a bitmap for
> keeping track of allocated irq numbers. That results in:

I don't know that I have a problem with this but I do have a problem
with using a bitmap.  A lot of the kernels irq usage has been distored
because we use a compact array, that we cannot grow over time.  Using a
bitmap here essentially removes 90% of the point of sparse irq.  The
ability to remove a hard coded NR_IRQS from the kernel.

>  - Fast lookup of a free slot
>
>  - The removal of disposed descriptors (destroy_irq())
>
>  - Prevents the create/destroy race
>
>  - Bulk (de)allocation of consecutive irq ranges
>
>  - Migration of life descriptors after further cleanups

You should be able to do all of that by walking your radix tree in the
sparse irq case.


> Full conversion and clean up of x86:
> ------------------------------------
>
> I spent quite a time to come up with a sane and splitable concept,
> which does not reach out into drivers/pci/[msi|ht|dmar] and whatever.
>
> But that's simply impossible because everything is twisted together
> mainly by optimization hacks done over time. (i.e. handing down
> irq_desc to low level msi functions instead of irq_desc.msi_desc would
> have kept the mess confined to x86).

Those files provide the genirq irq chip implementation especially
drivers/pci/msi.c.  Of course they will do what every other irq_chip
implementation does to get access to data.  There is an unpleasant
difference between which generic irq data field htirq.c uses and msi.c
which may be worth cleaning up.  But otherwise I don't see any
fundamental problems.

The big difference is those are the irq controllers that we have code
for that is not necessarily architecture specific.

> So I went there and started to convert stuff piece by piece in x86 and
> added the drivers/pci/* fixes as separate patches along the way. Not
> nice, but it turned out to be the only way which avoided even more
> churn.

You should be able to convert msi.c and company directly to using
irq_data immediately following your previous patchset shouldn't you.
Perhaps with two flavors of helper functions during the transition
to passing irq_data everywhere.

I don't see any code in the msi code is arch specific or sparse irq
specific.

> Further work:
> -------------
>
>  - Cleanup the irq_desc references all over the tree, which should become
>    easier after the remaining __do_IRQ() users are gone.
>
>  - Implement migration of active irq descriptors
>
>  - Implement node bound late allocation of low level irq vectors which
>    solves an existing (SGI) problem on large machines.
>
>
> How to merge:
> -------------
>
> It needs:
>
>    - ack to the new allocator design
>
>    - ack to merge the whole arch/!x86 and driver related cleanups
>      along with the core changes and the x86 cleanup


Eric
