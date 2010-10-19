Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0JSCps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:45:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0JSCpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mU/XqFkGZvxsahepNpuhGRTOdBD2krz0sNGEaL3zYA4P3xxhkSIvm0mGFiyxiYeUOm
         AF8I9uDDV4NYGZ3FzV+gZUmOfhmhemGwvFl4xmjBuHvAajsuKESxdBO7D8L6FPNSpLt/
         hia5sgtT8mW/tgEE/Y+kaJmtZKWkoz/+nYIBo=
MIME-Version: 1.0
In-Reply-To: <20101019022413.GB30307@kroah.com>
References: <201009161632.59210.arnd@arndb.de>
	<201010181742.06678.arnd@arndb.de>
	<20101018184346.GD27089@kroah.com>
	<AANLkTin2KPNNXvwcWphhM-5qexB14FS7M7ezkCCYCZ2H@mail.gmail.com>
	<20101019004004.GB28380@kroah.com>
	<AANLkTi=ffaihP5-yNYFKAbAbX+XbRgWRXXfCZd4J3KwQ@mail.gmail.com>
	<20101019022413.GB30307@kroah.com>
Date: Tue, 19 Oct 2010 12:45:43 +1000
Message-ID: <AANLkTinv4VFpi=Jkc_5oyFgPbdLRg0ResJx9u9Puhm-7@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, codalist@telemann.coda.cs.cmu.edu,
        ksummit-2010-discuss@lists.linux-foundation.org,
        autofs@linux.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:24 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 19, 2010 at 10:57:43AM +1000, Dave Airlie wrote:
>> On Tue, Oct 19, 2010 at 10:40 AM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Oct 19, 2010 at 09:00:09AM +1000, Dave Airlie wrote:
>> >> On Tue, Oct 19, 2010 at 4:43 AM, Greg KH <greg@kroah.com> wrote:
>> >> > On Mon, Oct 18, 2010 at 05:42:06PM +0200, Arnd Bergmann wrote:
>> >> >>
>> >> >> Out of the remaining modules, I guess i810/i830, adfs, hpfs and ufs might end
>> >> >> up not getting fixed at all, we can either mark them non-SMP or move them
>> >> >> to drivers/staging once all the others are done.
>> >> >
>> >> > I recommend moving them to staging, and then retire them from there if
>> >> > no one steps up to maintain them.
>> >>
>> >> I think this sets a bad precedent, these drivers work fine. Removing
>> >> BKL from them is hard, and involves finding and booting hw that
>> >> developers don't have much time/interest in at the moment. Anyone who
>> >> has access to the i810 hw and has time to work out the locking has
>> >> more important things to be doing with modern hw, however it doesn't
>> >> mean we should just drop support for old drivers because they don't
>> >> have active maintainers. Removing the BKL from the kernel is a great
>> >> goal, but breaking userspace ABI by removing drivers isn't.
>> >
>> > Should we just restrict such drivers to only be able to build on UP
>> > machines with preempt disabled so that the BKL could be safely removed
>> > from them?
>> >
>> > Or what other idea do you have as to what could be done here?
>> >
>> > I do have access to this hardware, but its on an old single processor
>> > laptop, so any work that it would take to help do this development,
>> > really wouldn't be able to be tested to be valid at all.
>>
>> There is only very rare case where the i830 driver might get used with
>> SMP and really I think that case is in the don't care place, since if
>> you have that hw you probably should be using i915 on it anyways.
>
> So, there is no need for the i830 driver?  Can it just be removed
> because i915 works instead?

No because it provides a different userspace ABI to the i915 driver to
a different userspace X driver etc.

like I'm sure the intersection of this driver and reality are getting
quite limited, but its still a userspace ABI change and needs to be
treated as such. Xorg 6.7 and XFree86 4.3 were the last users of the
old driver/API.

>> So it really only leaves the problem case of what do distros do if we
>> mark things as BROKEN_ON_SMP, since no distro builds UP kernels and
>> when you boot the SMP kernels on UP they don't run as SMP so not
>> having the driver load on those is a problem. Maybe we just need some
>> sort of warn on smp if a smp unfriendly driver is loaded and we
>> transition to SMP mode. Though this sounds like either (a) something
>> we do now and I don't about it, (b) work.
>
> So you are saying that just because distros will never build such a
> thing, we should keep it building for SMP mode?  Why not prevent it from
> being built and if a distro really cares, then they will pony up the
> development to fix the driver up?

Distros build the driver now even it it didn't work on SMP it wouldn't
matter to the 99% of people who have this hw since it can't suppport
SMP except in some corner cases. So not building for SMP is the same
as just throwing it out of the kernel since most people don't run
kernel.org kernels, and shouldn't have to just to get a driver for
some piece of hardware that worked fine up until now.

Look at this from a user who has this hardware pov, it works for them
now with a distro kernel, us breaking it isn't going to help that user
or make any distro care, its just going to screw over the people who
are actually using it.

> In other words, if someone really cares, then they will do the work,
> otherwise why worry?  Especially as it seems that no one here is going
> to do it, right?

Well the thing is doing the work right is a non-trivial task and just
dropping support only screws the people using the hardware,
it doesn't place any burden on the distro developers to fix it up. If
people are really serious about making the BKL go away completely, I
think the onus should be on them to fix the drivers not on the users
who are using it, like I'm  guessing if this gets broken the bug will
end up in Novell or RH bugzilla in a year and nobody will ever see it.

Dave.
