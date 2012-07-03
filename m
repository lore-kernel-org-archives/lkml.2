Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab2GCSp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:45:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab2GCSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:45:55 -0400
Date: Tue, 3 Jul 2012 20:45:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
Message-ID: <20120703184551.GL11413@one.firstfloor.org>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com> <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com> <alpine.LNX.2.00.1207031953570.17304@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207031953570.17304@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 07:57:15PM +0200, Jiri Kosina wrote:
> On Tue, 3 Jul 2012, Linus Torvalds wrote:
> 
> > > Ok, here's the dmesg output that I get:
> > >
> > > [    0.714316] floppy0: lock_fdc: -1 (out of 8)
> > 
> > Ok, thanks. That -1 definitely explains the long delay. It's using
> > "drive=-1" because it has no actual drive number, just the
> > *controller* number.
> > 
> > And the backtrace shows what's going on too: it's the
> > 
> >   user_reset_fdc(-1, FD_RESET_ALWAYS, false);
> > 
> > that passes in -1 as the floppy controller number.
> > 
> > Ugh.
> > 
> > It looks like the code meant for -1 to mean "regular delay"
> > (current_reqD), and -2 to mean MAXTIMEOUT. For some reason the "-1"
> > logic has gotten screwed.
> 
> I am still trying to understand the exact situation.
> 
> Andi, do I understand you correctly that even if you revert 070ad7e793dc 
> on top of current Linus' tree, you are still seeing the 20 second delay 
> inside the initcall?

Correct. Here's the debug output with just reverted (without Linus
patch):

[    2.489559] calling  floppy_init+0x0/0xe46 @ 1
[    2.504363] floppy0: lock_fdc: -1 (out of 8)
[    2.504410] floppy0: reschedule timeout lock fdc
[   22.498784] floppy0: reschedule timeout do wakeup
[   22.498811] floppy0: no floppy controllers found
[   22.498944] initcall floppy_init+0x0/0xe46 returned -19 after
19577158 usecs

