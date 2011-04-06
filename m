Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1DFWXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:23:07 -0400
Received: from relay3.ukrpost.ua ([195.5.46.65]:54134 "EHLO relay3.ukrpost.ua"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756590Ab1DFWXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:23:05 -0400
X-Greylist: delayed 3541 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 18:23:05 EDT
X-MDAV-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 00:21:17 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 07 Apr 2011 00:21:16 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: George Kashperko <george@znau.edu.ua>
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
In-Reply-To: <BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Apr 2011 00:18:57 +0300
Message-Id: <1302124737.27258.7.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
> 
> The question is what amount of driver we will need to support at the same time.
> 

I guess (correct me please, Broadcom guys if I'm wrong) there are two
functions two-head w11 pci host and therefore 4 sliding windows, 2 per
each function.

You really was in need for core switching for PCI SSB hosts, but seem
all that stuff for PCI switching in current bcm80211/utils code is
rudimentary stuff left from PCI times when you was required to use
sliding window for chipcommon and pci bridge core access.

Have nice day,
George



