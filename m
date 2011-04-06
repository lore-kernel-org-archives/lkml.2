Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1DFVVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:21:24 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34972 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab1DFVVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:21:23 -0400
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com> (sfid-20110406_231255_603822_1FED7627)
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <op.vtisojsk3ri7v4@arend-laptop>
	 <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	 <op.vti9ote53ri7v4@arend-laptop>
	 <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
	 <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
	 <1302123428.20093.6.camel@maggie>
	 <BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
	 <1302124112.20093.11.camel@maggie>
	 <BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
	 (sfid-20110406_231255_603822_1FED7627)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 23:20:46 +0200
Message-ID: <1302124846.20093.16.camel@maggie>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 23:12 +0200, Rafał Miłecki wrote: 
> W dniu 6 kwietnia 2011 23:08 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Wed, 2011-04-06 at 23:01 +0200, Rafał Miłecki wrote:
> >> W dniu 6 kwietnia 2011 22:57 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> >> > On Wed, 2011-04-06 at 22:42 +0200, Rafał Miłecki wrote:
> >> >> 2011/4/6 Rafał Miłecki <zajec5@gmail.com>:
> >> >> > If we want to have two drivers working on two (different) cores
> >> >> > simultaneously, we will have to add trivial mutex to group core
> >> >> > switching with core operation (read/write).
> >> >>
> >> >> With a little of work we could avoid switching and mutexes on no-host
> >> >> boards. MMIO is not limited to one core at once in such a case.
> >> >
> >> > I don't think that this is a problem at all.
> >> > All that magic does happen inside of the bus I/O handlers.
> >> > Just like SSB does it.
> >> > From a driver point of view, the I/O functions just need to
> >> > be atomic.
> >> >
> >> > For SSB it's not always 100% atomic, but we're always safe
> >> > due to some assumptions being made. But this is an SSB implementation
> >> > detail that is different from AXI. So don't look too closely
> >> > at the SSB implementation of the I/O functions. You certainly want
> >> > to implement them slightly differently in AXI. SSB currently doesn't
> >> > make use of the additional sliding windows, because they are not
> >> > available in the majority of SSB devices.
> >> >
> >> > The AXI bus subsystem will manage the sliding windows and the driver
> >> > doesn't know about the details.
> >>
> >> Sure, I've meant mutex inside bcmai (or whatever name), not on the driver side!
> >>
> >> In BCMAI:
> >> bcmai_read() {
> >> mutex_get();
> >> switch_core();
> >> ioread();
> >> mutex_release();
> >> }
> >
> > Yeah that basically is the idea. But it's a little bit harder than that.
> > The problem is that the mutex cannot be taken in interrupt context.
> > A spinlock probably is a bit hairy, too, depending on how heavy
> > a core switch is on AXI.
> >
> > On SSB we workaround this with some (dirty but working) assumptions.
> >
> > On AXI you probably can do lockless I/O, if you use the two windows
> > (how many windows are there?) in a clever way to avoid core switching
> > completely after the system was initialized.
> 
> We have 2 windows. I didn't try this, but let's assume they have no
> limitations. We can use first window for one driver only, second
> driver for second driver only. That gives us 2 drivers simultaneously
> working drivers. No driver need to reset core really often (and not
> inside interrupt context) so we will switch driver's window to agent
> (from core) only at init/reset.

On SSB one major assumption is that on non-embedded no coreswitch will
happen after init. (On embedded, the I/O accesses are safe anyway,
because all cores are always mapped).

> The question is what amount of driver we will need to support at the same time.

I guess (guess!) that the answer will be similar to SSB:
On non-embedded after init only one core is accessed: The wireless core.
And on embedded cores are accessed in random order. But it's safe
because the MMIO is always mapped.
Does this also apply to AXI?
Even if we would need to access two cores after init (wireless and
chipcommon, perhaps), we would use the two windows to survive without
an actual core switch while running.

-- 
Greetings Michael.

