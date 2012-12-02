Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2LBT5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:57:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:42348 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753582Ab2LBT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:57:48 -0500
Message-ID: <1354478254.2531.161.camel@thor>
Subject: Re: flush_to_ldisc accesses tty after free  (was: [PATCH 21/21]
 TTY: move tty buffers to tty_port)
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        alan@linux.intel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        linux-serial <linux-serial@vger.kernel.org>
Date: Sun, 02 Dec 2012 14:57:34 -0500
In-Reply-To: <1354392383.2531.118.camel@thor>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
	 <1350592007-9216-22-git-send-email-jslaby@suse.cz>
	 <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz>
	 <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
	 <5091448D.3@suse.cz>
	 <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com>
	 <5093EC1B.2050800@suse.cz>
	 <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>
	 <5093F262.6000301@suse.cz> <50947B7B.8080601@gmail.com>
	 <50953E8D.9000504@suse.cz> <5095A384.5080205@gmail.com>
	 <5095BC6E.2010505@gmail.com> <1354046255.2444.10.camel@thor>
	 <50B946A9.9070306@gmail.com> <1354373995.2531.48.camel@thor>
	 <1354392383.2531.118.camel@thor>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[whoops... cc: linux-serial]

On Sat, 2012-12-01 at 15:06 -0500, Peter Hurley wrote:
> On Sat, 2012-12-01 at 09:59 -0500, Peter Hurley wrote:
> ....
> > From instrumenting the tty_release() path, it's clear that tty_buffer
> > work is still scheduled even after tty_release_ldisc() has run. For
> > example, with this patch I get the warning below it.
> > 
> > [Further analysis to follow in subsequent mail...]
> 
> [ Please note: this analysis only refers to the pty driver. The
> situation with hardware drivers has further complications.]
> 
> Firstly, this problem predates Jiri's changes; only because he was
> cautious by checking the lifetime of the itty in flush_to_ldisc(), did
> he uncover this existing problem.
> 
> One example of how it is possible for buffer work to be scheduled even
> after tty_release_ldisc() stems from how tty_ldisc_halt() works (or
> rather doesn't). (I've snipped out the relevant code from tty_ldisc.c
> for annotation below.)

Naturally, I found the least obvious problem first.

The more obvious problem is that the pty driver doesn't have an ldisc
reference to the 'other' tty when pty_write() is called. So doing the
tty_flip_buffer_push() has scheduled buffer work for a potentially
halted ldisc.

static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
{
	struct tty_struct *to = tty->link;	<==== this is the 'other' tty

	if (tty->stopped)
		return 0;

	if (c > 0) {
		/* Stuff the data into the input queue of the other end */
		c = tty_insert_flip_string(to, buf, c);
		/* And shovel */
		if (c) {
			tty_flip_buffer_push(to);
			tty_wakeup(tty);
		}
	}
	return c;
}

There are several possible ways to fix this:
1. Halt both ldiscs and ensure that both ldiscs have no outstanding
references before cancelling their work.
2. Claim an ldisc reference for the 'other' ldisc in things like
tty_write().
3. I'm sure there's other ways....

Regards,
Peter Hurley

