Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2D3Lsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:48:45 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:48579 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2D3Lsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:48:43 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiFzAGt7nk9V5qnhPGdsb2JhbABEsHIEgRoZAQEBAR4ZDSeCCQEBBAE6HCMQCAMOOBQlChqIGwkHuR0TiyGFC2MElX2GBo0n
X-IronPort-AV: E=Sophos;i="4.75,505,1330902000"; 
   d="scan'208";a="325799534"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 30 Apr 2012 13:53:02 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
Message-ID: <20120430115302.GA2847@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1204301032410.1856@pobox.suse.cz>
 <alpine.LNX.2.00.1204301043340.1856@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204301043340.1856@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > Just got the stacktrace on [1] though when running kernel with this 
> > patchset. The trace popped during shutdown, and the machine froze 
> > completely; I didn't have any kind of external console connected, so 
> > unfortunately I don't have the beginning of the whole thing.
> > 
> > I haven't been able to reproduce it so far. This was after several 
> > "parallel" plug/remove cycles of multiple HID devices driven by multiple 
> > different drivers.
> > 
> > I haven't performed any analysis what this might be yet.
> > 
> > [1] http://www.jikos.cz/jikos/junk/autoloading-trace.jpg
> 
> It actually seems to be spinlock lockup (due to the NMI trigger being 
> apparent at the very first line) on kbd_event_lock ...

Ah, yes. I take it you are talking about tty/vt/keyboard.c. So some
random keypress during shutdown triggers the event, which eventually
reaches input_pass_event(). From there on, the trace stays in the
mentioned driver. First kbd_event() gets called, which takes the lock
and goes on to, in turn, call kbd_keycode(), k_handler[2]() ==
k_spec(), fn_handler[9]() == fn_hold(), which goes on to call
stop_tty(). This function comes back to the driver, via con_stop(), as
vt_kbd_con_stop(), which in turn takes the same lock. So unless the
teardown of something in hid affects the choices made in the tty
driver, it appears this is a different problem. Or?

Henrik
