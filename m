Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2D3Lzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:55:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab2D3Lzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:55:52 -0400
Date: Mon, 30 Apr 2012 13:55:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
In-Reply-To: <20120430115302.GA2847@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1204301350540.1856@pobox.suse.cz>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204301032410.1856@pobox.suse.cz> <alpine.LNX.2.00.1204301043340.1856@pobox.suse.cz> <20120430115302.GA2847@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Henrik Rydberg wrote:

> > > Just got the stacktrace on [1] though when running kernel with this 
> > > patchset. The trace popped during shutdown, and the machine froze 
> > > completely; I didn't have any kind of external console connected, so 
> > > unfortunately I don't have the beginning of the whole thing.
> > > 
> > > I haven't been able to reproduce it so far. This was after several 
> > > "parallel" plug/remove cycles of multiple HID devices driven by multiple 
> > > different drivers.
> > > 
> > > I haven't performed any analysis what this might be yet.
> > > 
> > > [1] http://www.jikos.cz/jikos/junk/autoloading-trace.jpg
> > 
> > It actually seems to be spinlock lockup (due to the NMI trigger being 
> > apparent at the very first line) on kbd_event_lock ...
> 
> Ah, yes. I take it you are talking about tty/vt/keyboard.c. So some
> random keypress during shutdown triggers the event, which eventually
> reaches input_pass_event(). From there on, the trace stays in the
> mentioned driver. First kbd_event() gets called, which takes the lock
> and goes on to, in turn, call kbd_keycode(), k_handler[2]() ==
> k_spec(), fn_handler[9]() == fn_hold(), which goes on to call
> stop_tty(). This function comes back to the driver, via con_stop(), as
> vt_kbd_con_stop(), which in turn takes the same lock. So unless the
> teardown of something in hid affects the choices made in the tty
> driver, it appears this is a different problem. Or?

I just came to the same conclusion a few minutes ago ... i.e. this is 
likely unrelated to the patchset and I just triggered it by pure 
coincidence on the patched kernel.

I will keep looking into it a little bit more. Dmitry, any immediate ideas 
by any chance?

Otherwise the series seems indeed fine and if I don't come across anything 
substantial once I am done with the review, I am considering pushing it 
for -next (I still have to look at quirks propagation Nikolai pointed 
out).

Thanks,

-- 
Jiri Kosina
SUSE Labs
