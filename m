Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1DFVIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:08:50 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53806 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab1DFVIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:08:48 -0400
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
In-Reply-To: <BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com> (sfid-20110406_230206_684163_663F35B6)
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <op.vtisojsk3ri7v4@arend-laptop>
	 <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	 <op.vti9ote53ri7v4@arend-laptop>
	 <BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
	 <BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
	 <1302123428.20093.6.camel@maggie>
	 <BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
	 (sfid-20110406_230206_684163_663F35B6)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 23:08:32 +0200
Message-ID: <1302124112.20093.11.camel@maggie>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 23:01 +0200, Rafał Miłecki wrote: 
> W dniu 6 kwietnia 2011 22:57 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Wed, 2011-04-06 at 22:42 +0200, Rafał Miłecki wrote:
> >> 2011/4/6 Rafał Miłecki <zajec5@gmail.com>:
> >> > If we want to have two drivers working on two (different) cores
> >> > simultaneously, we will have to add trivial mutex to group core
> >> > switching with core operation (read/write).
> >>
> >> With a little of work we could avoid switching and mutexes on no-host
> >> boards. MMIO is not limited to one core at once in such a case.
> >
> > I don't think that this is a problem at all.
> > All that magic does happen inside of the bus I/O handlers.
> > Just like SSB does it.
> > From a driver point of view, the I/O functions just need to
> > be atomic.
> >
> > For SSB it's not always 100% atomic, but we're always safe
> > due to some assumptions being made. But this is an SSB implementation
> > detail that is different from AXI. So don't look too closely
> > at the SSB implementation of the I/O functions. You certainly want
> > to implement them slightly differently in AXI. SSB currently doesn't
> > make use of the additional sliding windows, because they are not
> > available in the majority of SSB devices.
> >
> > The AXI bus subsystem will manage the sliding windows and the driver
> > doesn't know about the details.
> 
> Sure, I've meant mutex inside bcmai (or whatever name), not on the driver side!
> 
> In BCMAI:
> bcmai_read() {
> mutex_get();
> switch_core();
> ioread();
> mutex_release();
> }

Yeah that basically is the idea. But it's a little bit harder than that.
The problem is that the mutex cannot be taken in interrupt context.
A spinlock probably is a bit hairy, too, depending on how heavy
a core switch is on AXI.

On SSB we workaround this with some (dirty but working) assumptions.

On AXI you probably can do lockless I/O, if you use the two windows
(how many windows are there?) in a clever way to avoid core switching
completely after the system was initialized.

-- 
Greetings Michael.

