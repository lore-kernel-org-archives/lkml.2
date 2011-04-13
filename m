Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab1DMIec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:34:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10158 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab1DMIe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:34:29 -0400
Date: Wed, 13 Apr 2011 10:34:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Natarajan Gurumoorthy <natg@google.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: Re: [lm-sensors] [PATCH v5 1/2] Use "request_muxed_region" in it87
  watchdog drivers
Message-ID: <20110413103409.47638b72@endymion.delvare>
In-Reply-To: <BANLkTikfuvvujTi6i2MUGOHgNLZCqcouJQ@mail.gmail.com>
References: <1302641290-30212-1-git-send-email-natg@google.com>
	<1302641387-30264-1-git-send-email-natg@google.com>
	<4DA547CD.60406@redhat.com>
	<BANLkTikfuvvujTi6i2MUGOHgNLZCqcouJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 01:05:33 -0700, Natarajan Gurumoorthy wrote:
> Hans,
>       Comments below
> 
> On Tue, Apr 12, 2011 at 11:50 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > You shouldn't (void) this, there is a reason you get a warning
> > otherwise! request_muxed_region can still fail if some other driver
> > has done a none muxed request_region on the same region, and in that
> > case you should not continue with accessing the io-ports.
> There are 3 it87 drivers and they all have to do the exact same
> sequence to put the chip into a mode where they can modify its state.
> The sequences involve non atomic sequences that write locations 0x2e
> and 0x2f. When they are done they write a different sequence to these
> 2 locations. The entry routine is superio_enter and exit is
> superio_exit. All the it87 drivers reserve these 2 locations before
> they start manipulating the chip. This macro will hold off requestors
> if the resource is busy because one of the other drivers is
> manipulating the chip. Once the  an it87 driver is done it calls
> superio_exit which will release the reservation on those 2 locations
> letting any other driver on the wait queue to now gain access two
> locations.
> 
> Please read code in kernel/resource.c function "__request_region".
> "request_muxed_region" turns on IORESOURCE_MUXED bit and that means
> that only  way an it87 driver will get back from a call to
> "request_muxed_region" is when it gets hold of the region.
> 
> The scenario you mention above can never happen.

Let me be straight clear, as apparently you have difficulties
understanding Hans's simple request:

You do not get to (void) the return of request_muxed_region(), period.
This is _not_ negotiable.

What other it87 drivers currently in the tree do or don't do is totally
irrelevant. There can be new it87 drivers added later, there can be
out-of-tree it87 drivers (including old copies of in-tree ones), and
there can be non-it87 drivers accessing the I/O ports (or at least
attempting to.) So the scenario mentioned by Hans can very well happen,
and you have to deal with it.

Thanks,
-- 
Jean Delvare
