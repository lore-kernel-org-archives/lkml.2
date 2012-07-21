Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2GUObX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 10:31:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51478 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab2GUObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 10:31:22 -0400
X-Sasl-enc: srXJ/HqMohmpUViBXG0pjquDWv7sSYTYdUPcT2GLvHu9 1342881081
Date: Sat, 21 Jul 2012 11:31:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and
 delay_off)
Message-ID: <20120721143116.GA3426@khazad-dum.debian.net>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
 <20120721040816.GA7313@kroah.com>
 <1342856010.21788.47.camel@ted>
 <CAMbhsRREVcqf+pnamY62wGcd2mBif8W8_CRXdJQCQvL14Dy3Eg@mail.gmail.com>
 <1342869707.21788.50.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342869707.21788.50.camel@ted>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2012, Richard Purdie wrote:
> On Sat, 2012-07-21 at 01:26 -0700, Colin Cross wrote:
> > On Sat, Jul 21, 2012 at 12:33 AM, Richard Purdie
> > <richard.purdie@linuxfoundation.org> wrote:
> > > On Fri, 2012-07-20 at 21:08 -0700, Greg KH wrote:
> > >> On Fri, Jul 20, 2012 at 05:46:14PM -0700, Colin Cross wrote:
> > >> > I'm trying to use the standard ledtrig-timer.c code to handle led
> > >> > blinking for notifications on an Android device, and I'm hitting some
> > >> > issues with setting permissions on the dynamically created delay_on
> > >> > and delay_off attributes.  For most sysfs files, we have userspace
> > >> > uevent parser that watches for device add notifications and
> > >> > chowns/chmods attributes.  This doesn't work for delay_on and
> > >> > delay_off, because they are created later, when "timer" is written to
> > >> > the trigger attribute.  There is no uevent when the new files are
> > >> > created, and sysfs doesn't support inotify, so I don't see any way to
> > >> > receive an event to set the permissions.  This issue exists any time
> > >> > that device_create_file is called after device_add.
> > >> >
> > >> > What is the appropriate way to get an event to set the permissions?
> > >> > Add inotify support for sysfs file creation?  Send a KOBJ_CHANGE
> > >> > uevent in device_create_file?
> > >>
> > >> No.
> > >>
> > >> > Send a KOBJ_CHANGE uevent from the driver after calling
> > >> > device_create_file?
> > >>
> > >> Yes.

...

> > Blinking is already effectively a core feature.  It is implemented in
> > led-core.c so it can be used by other triggers besides timer, it's
> > state is stored in the led_classdev structure, not in the trigger
> > data, and the only thing left in ledtrig-timer.c is the sysfs files.
> 
> Having the attributes present all the time leads to some nasty questions
> like how the on/off delays interact with things like say a network
> activity trigger. Not all triggers are going to respect these delay
> values and I can imagine a whole new set of nasty bug reports with no
> easy solutions if this change is made...

Agreed.  Let's just fix this properly and issue KOBJ_CHANGE when any sysfs
attributes are added or removed to an already registered LED class, please?
It is the proper thing to do, and it is a valid fix for all trigger types.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
