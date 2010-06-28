Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0F1LMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:12:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0F1LMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:12:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic network.
Date: Mon, 28 Jun 2010 13:12:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006261316.12816.arnd@arndb.de> <4C2783AD.3010403@tilera.com>
In-Reply-To: <4C2783AD.3010403@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281312.16391.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19qf/pcAL+tXThYLw3CZprqycjBPQINnypcZSB
 rJU5tigHwjpKJDZ7eSYhZOPJmgOHy1Wc/c2bcMfH8OuomeX2tp
 jamrJUGQBhev3z8clm6Qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 June 2010, Chris Metcalf wrote:
> On 6/26/2010 7:16 AM, Arnd Bergmann wrote:
> > On Friday 25 June 2010, Chris Metcalf wrote:
> > The character device looks much better than the proc file. I still
> > think a system call would be a more appropriate abstraction here,
> > but the two are equivalent after all.
> >   
> 
> I'm going to argue for a character device, though.  There are a few
> reasons why I prefer it:
> 
> 1. It allows a straightforward model for adding additional types of
> "device" like this in the future.  It would be natural to support
> multiple minor numbers, perhaps with different ones having different "is
> the cpumask valid?" criteria.  Our next release will have two user
> networks, and a notion of userspace IPIs, all of which fit the life
> cycle of "create nonoverlapping cpumask, bind to cpu via affinity,
> activate, deactivate".  You could imagine passing constants to the
> syscall you propose, but it feels like it's just turning into a device
> switch at that point.

Many system calls have flags for things like this, I don't think
this is a strong argument in favor of a device.

> 2. You can easily imagine multiple classes of users, where different
> classes are allowed to use different resources -- perhaps one user
> network reserved for root, one for some privileged group, while the
> userspace IPI network is available to anyone.  Or something different. 
> We don't really know all the use cases yet, and having user/group
> permissions built into the model seems like it may be helpful.

Ok.

When you get to this complexity though, it may be worthwhile to
integrate into the cgroups subsystem, which might already provide
some of this. Have you looked into this?

> 3. More subjectively -- the user dynamic networks have a "devicey" feel
> to me.  Normal open-source code never has to deal with these things; you
> only use them if your program is ready to open them up somehow, then
> read and write data to them, which feels like a device kind of
> abstraction (even though the reading and writing is via GPRs, not
> iomem).  And the userspace IPI stuff will be done by mapping IOMEM into
> process space and poking at it, once you've registered on the "userspace
> IPI" device, so again it has a kind of devicey feel to it.
>
> I don't think it would be strictly wrong to use a syscall, and you say
> the two are interchangeable at a high level, but I think character
> devices fit a bit better.

Fair enough. This is purely subjective, so while it feels like it
should be a syscall to me, you will have to maintain it in the end
and it sounds like you have thought this through more than I have.

I just wanted to make sure you didn't just use the character device
because it was easier to convert from the proc file than it would
have been to use a better alternative.

> > It seems strange that you need this. Why does linux/list.h
> > depend on asm/processor.h?
> >   
> 
> <linux/list.h> -> <linux/poison.h> -> <linux/prefetch.h> ->
> <asm/processor.h>.  There doesn't seem to be any good way around this. 
> I could, I suppose, use an opaque "struct list_head;" declaration in
> <asm/processor.h>, then create one with kmalloc on demand, but that
> seemed like overkill, so I embed the made-up version here, then validate
> it as a BUILD_BUG_ON() to be the same size as a real list_head.  I never
> actually use the "hardwall_list" structure directly.

We could break the dependency by turning prefetch_range into a macro
or an extern function. There is only one user, and it's in a staging
driver, so the impact would be minimal.

> >> +/*
> >> + * Guard changes to the hardwall data structures.
> >> + * This could be finer grained (e.g. one lock for the list of hardwall
> >> + * rectangles, then separate embedded locks for each one's list of tasks),
> >> + * but there are subtle correctness issues when trying to start with
> >> + * a task's "hardwall" pointer and lock the correct rectangle's embedded
> >> + * lock in the presence of a simultaneous deactivation, so it seems
> >> + * easier to have a single lock, given that none of these data
> >> + * structures are touched very frequently during normal operation.
> >> + */
> >> +static DEFINE_SPINLOCK(hardwall_lock);
> >>     
> > I think instead of making the lock more fine-grained, a better optimization
> > might be to use RCU to protect the updates. AFAICT, the updates to the
> > structure are rare but you need to read it a lot.
> >   
> 
> Actually, we neither read nor write the list very much.  We take the
> lock when a new hardwall is created or a new process enables user
> network access, but these are both "once per process lifetime" events
> typically.  After that, the user process is just granted direct hardware
> access when it is context switched in (based on a non-NULL hardwall_info
> pointer) and that's it.  So the big spinlock approach is actually good
> from a simplicity point of view.

Yes, if there is no contention, a spinlock is fine.

> >> +#ifdef CONFIG_COMPAT
> >> +static long hardwall_compat_ioctl(struct file *file,
> >> +				  unsigned int a, unsigned long b)
> >> +{
> >> +	/* Sign-extend the argument so it can be used as a pointer. */
> >> +	return hardwall_ioctl(file, a, (int)(long)b);
> >> +}
> >> +#endif
> >>     
> > Better use compat_ptr(b) instead of the manual cast.
> >   
> 
> Yes, although hardwall_ioctl() wants an unsigned long, so it would have
> to be "(unsigned long)compat_ptr(b)", so it's not obviously better
> (certainly less succinct!).  But I concur that it's slightly less
> obscure :-)

Most importantly, it's architecture independent. A lot of drivers do this
and I still think that we should eventually get a 

long generic_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	if (file->f_ops->unlocked_ioctl)
		return file->f_ops->unlocked_ioctl(file, cmd,
					(unsigned long)compat_ptr(arg));
	return -ENOTTY;
}

Once we have killed off the last fops->ioctl() user, I'll try to
come up with a semantic patch to convert all drivers with a trivial
compat_ioctl function to this.

	Arnd
