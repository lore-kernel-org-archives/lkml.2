Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab0FPPXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:23:07 -0400
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:5650 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab0FPPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:23:04 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 11:23:04 EDT
Authentication-Results: rtp-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskFAOCGGExAZnwN/2dsb2JhbACSWIwdcaYkmgmFGgQ
X-IronPort-AV: E=Sophos;i="4.53,426,1272844800"; 
   d="scan'208";a="122199740"
Date: Wed, 16 Jun 2010 16:13:31 +0100
From: Derek Fawcus <dfawcus@cisco.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
Message-ID: <20100616151331.GA11824@gpk-lds-007.cisco.com>
References: <E1OObIu-0004K2-3K@lirone.symas.net> <20100615202924.24446d28@lxorguk.ukuu.org.uk> <4C17DA85.40803@symas.com> <4C17E14F.5090908@symas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17E14F.5090908@symas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 01:23:43PM -0700, Howard Chu wrote:
> 
> Closest thing I've found so far is for HPUX 11i Version 2:
> http://docs.hp.com/en/B2355-90848docs/B2355-90848docs.pdf
> 
> TIOCREMOTE This ioctl puts the STREAMS pty in and out of Remote Mode. When

> TIOCSIGNAL This ioctl allows the master process to send a signal to the slave

> <<<<
> 
> TIOCREMOTE seems to be the SVR4 analogue to TIOCPKT without any of the useful parts; it doesn't include the prefix
> byte, so it doesn't provide any state change information.

TIOCREMOTE is also supported on BSDs.
A program I've been playing with on and off for a few years uses it (on solaris, FreeBSD, Darwin).

That in combination with turning off all output post processing,  and then regularly sampling the
status of the pty for the following generally works:

static int
internal_get_modes (int fd, int *modep)
{
        int modes = 0;

        if (tcgetattr(fd, &tty_mode) < 0)
                return 0;

        if (tty_mode.c_lflag & ICANON)
                modes |= MODE_CANON;
        else if (tty_mode.c_lflag & ISIG)
                modes |= MODE_CBREAK;
        else
                modes |= MODE_RAW;
        if (tty_mode.c_lflag & ECHO)
                modes |= MODE_ECHO;

        if (tty_mode.c_cc[VINTR] != vdisable) modes |= MODE_INTR;
        if (tty_mode.c_cc[VQUIT] != vdisable) modes |= MODE_QUIT;
        if (tty_mode.c_cc[VSUSP] != vdisable) modes |= MODE_SUSP;

        *modep = modes;

        return 1;
}

There is obviously a race condition in detecting the change in the above,  but usually this
is only an issue when starting/stopping certain curses apps,  and can be handled by the various
app redraw command.

Currently for Linux,  I disable echo before feeding characters to the pty,  then restore it
to its previous state.  So REMOTE mode would be useful.

Sending signals to the terminal group is different for BSD/solaris/Linux:

int master_signal_tcpgrp (int master_fd, unsigned signo)  // BSD
{
        return ioctl(master_fd, TIOCSIG, signo);
}

int master_signal_tcpgrp (int master_fd, unsigned signo)  // Linux
{
        pid_t tcpgrp;

        tcpgrp = tcgetpgrp(master_fd);
        if (tcpgrp == -1) {
                return -1;
        }

        return kill(-tcpgrp, signo);
}

int master_signal_tcpgrp (int master_fd, unsigned signo)  // SVR4
{
        return ioctl(master_fd, TIOCSIGNAL, signo);
}

Now for a notification type packet mode extension,  something which provided the
information extracted in the above set of MODE change indications would be useful,
since it would remove the race condition.  i.e. a completely different interpretation
of the packet when supplying the control info.

DF
