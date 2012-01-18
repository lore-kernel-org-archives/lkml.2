Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2ARI6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:58:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2ARI6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:58:05 -0500
Date: Wed, 18 Jan 2012 09:56:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118085620.GB2317@turtle.usersys.redhat.com>
References: <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <4F1442C5.70500@redhat.com>
 <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
 <20120117144644.GC3188@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:54:01PM -0800, David Rientjes wrote:
> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > index a421abd..73c2d39 100644
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -63,7 +63,7 @@ menu "Special HID drivers"
> >  config HID_A4TECH
> >         tristate "A4 tech mice" if EXPERT
> >         depends on USB_HID
> > -       default !EXPERT
> > +       default !EMBEDDED
> >         ---help---
> >         Support for A4 tech X5 and WOP-35 / Trust 450L mice.
> > 
> > and the other HID drivers...
> > 
> 
> Um, no, HID_A4TECH is still only configurable for CONFIG_EXPERT with this 
> patch.  Jerome's premise is that this should be configurable for 
> CONFIG_EMBEDDED instead.  Please read what he wrote.

Yes, you still need EXPERT to expose the option, but then EMBEDDED will
switch the default. You only need to set EMBEDDED=y to do that though,
that's what this little thing called "select" does.

> 
> When it's configurable only for CONFIG_EMBEDDED, then you can propose that 
> to the HID maintainers.  If they agree, then we don't care if users 
> currently with CONFIG_EXPERT=y and CONFIG_EMBEDDED=n lose the option, but 
> that needs to be handled on a case-by-case basis when breaking backwards 
> compatibility.

Why would you *EVER* want users that have CONFIG_EXPERT=y and
CONFIG_EMBEDDED=n to automatically, silently lose that option? IOW, why
was your patch, 6a108a14fa35, ever posted that way in the first place?!

Oh, so now we can break backwards compatibility for some cases? What is
the criteria for those cases? Let me guess at a few;

1. When there is a well documented transfer from old to new, possibly with
   a deprecation period.
2. To fix a bug where the documentation doesn't match the implementation,
   and the implementation is wrong. If users got used to that wrong
   implementation, then they're the ones at fault. The documentation
   was/is the contract. It would still be best to do something like (1)
   here, with a deprecation period, but depending on the case, that may
   not be necessary or desirable.
3. To restore sanity to the general kernel config options. Oh, wait,
   that's just (2) again.

> 
> > I guess it could be changed to 'if EXPERT || EMBEDDED', but at the moment
> > EMBEDDED selects EXPERT, so that's not currently necessary. I guess what's
> > above should be sufficient then. Oh, wait! That's exactly what this patch
> > does! And anybody who actually read it would have seen that.
> > 
> 
> One of many reasons why it's completely wrong, and is nacked.

Changing 'if EXPERT' to 'if EXPERT || EMBEDDED' for particular options is
*NOT* in the scope of this patch. Not doing it in this patch is not only
OK, but correct. Adding out-of-scope changes to patches is wrong.

> 
> > BTW, the HID maintainer, Jiri Kosina, is already on cc, since I cc'ed
> > every maintainer of the files that this patch touches.
> > 
> 
> That type of attitude is a great way for your patches to be lost in 
> oblivion, you can't expect everyone on the cc list to be actively reading 
> this thread.  I've considered not reading it myself since it's pretty 
> pointless.

What do you mean you've considered not reading this pointless thread? You
wrote it! All the nonsense comes from you. Besides the patch submission,
which fixes a real problem, this thread HAS been pointless, and wasted a
lot of my time.

> If you wish to submit kconfig patches for options that touch 
> specific subsystems, you'll need to separate them out and propose them to 
> the individual subsystem maintainers.

This patch is for the general kernel. It wouldn't make sense to break it
up for each subsystem. It actually wouldn't even be possible to merge
those patches separately without risking config breakage on bisections. I
mentioned that in the commit message.
