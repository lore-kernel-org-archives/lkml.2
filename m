Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1HKBGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:06:50 -0400
Received: from infernal.debian.net ([87.230.26.131]:60654 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1HKBGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:06:48 -0400
Date: Thu, 11 Aug 2011 03:06:41 +0200
From: Andreas Bombe <andreas.bombe@mytum.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
Message-ID: <20110811010640.GA4186@amos.fritz.box>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
 <20110719003503.GA4138@amos.fritz.box>
 <4E3FE2D2.5020801@gmail.com>
 <20110810010933.GA4733@amos.fritz.box>
 <4E429907.6080000@gmail.com>
 <20110810180754.GB13832@bombe-desk.opditex>
 <4E42C998.1050208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E42C998.1050208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 08:10:32PM +0200, Jiri Slaby wrote:
> On 08/10/2011 08:07 PM, Andreas Bombe wrote:
> > On Wed, Aug 10, 2011 at 04:43:19PM +0200, Jiri Slaby wrote:
> >> On 08/10/2011 03:09 AM, Andreas Bombe wrote:
> >>> I did my simple test on ttyS0 again: "stty -F /dev/ttyS0 crtscts" then
> >>> "echo >/dev/ttyS0". I attached the gzipped sysrq-t list in case you need
> >>> the complete output. This is just the process while it is trying to
> >>> close the device (bash's internal echo):
> >>
> >> Hmm, perhaps obvious question. What is the port connected with? And with
> >> what cable? Is it null modem cable? Or at least with DTR-CTS connected?
> > 
> > Nothing is connected. After all, the whole point of this exercise is to
> > give the driver data to send which it can't get out so I can see whether
> > it blocks all tty operations system wide while trying to do the flush on
> > close.
> 
> But according to the trace, it waits only in its queue...
> 
> Well, could you turn on lockdep and dump sysrq-d when your echo is
> closing the port?

Ok, it still appears to be holding the big_tty_mutex. I ran /bin/echo so
that it actually shows up as "echo" here:

[  962.365574] SysRq : Show Locks Held
[  962.365580] 
[  962.365581] Showing all locks held in the system:
[  962.365599] 1 lock held by Xorg/1881:
[  962.365601]  #0:  (big_tty_mutex){+.+.+.}, at: [<ffffffff813d0013>] tty_lock+0x12/0x14
[  962.365624] 1 lock held by getty/2732:
[  962.365626]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365637] 1 lock held by getty/2733:
[  962.365639]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365647] 1 lock held by getty/2734:
[  962.365649]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365658] 1 lock held by getty/2735:
[  962.365660]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365679] 1 lock held by bash/2994:
[  962.365681]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365691] 1 lock held by bash/3326:
[  962.365692]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365701] 1 lock held by bash/3444:
[  962.365703]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365713] 1 lock held by bash/3793:
[  962.365715]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365725] 1 lock held by less/3899:
[  962.365727]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff81254fff>] n_tty_read+0x188/0x681
[  962.365735] 2 locks held by echo/4162:
[  962.365737]  #0:  (big_tty_mutex){+.+.+.}, at: [<ffffffff813d0013>] tty_lock+0x12/0x14
[  962.365746]  #1:  (&port->mutex){+.+.+.}, at: [<ffffffff81268b46>] uart_close+0x6c/0x243
[  962.365754] 
[  962.365756] =============================================
[  962.365757] 


Also, can you not reproduce it? I thought the "enable hardware handshake
on unconnected port and send" dance should be universal enough to work
for everyone. Everyone with a serial port somewhere in the system, that
is.

-- 
Andreas Bombe
