Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2LAUGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:06:37 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:35351 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752783Ab2LAUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:06:36 -0500
Message-ID: <1354392383.2531.118.camel@thor>
Subject: Re: flush_to_ldisc accesses tty after free  (was: [PATCH 21/21]
 TTY: move tty buffers to tty_port)
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        alan@linux.intel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 01 Dec 2012 15:06:23 -0500
In-Reply-To: <1354373995.2531.48.camel@thor>
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

On Sat, 2012-12-01 at 09:59 -0500, Peter Hurley wrote:
....
> From instrumenting the tty_release() path, it's clear that tty_buffer
> work is still scheduled even after tty_release_ldisc() has run. For
> example, with this patch I get the warning below it.
> 
> [Further analysis to follow in subsequent mail...]

[ Please note: this analysis only refers to the pty driver. The
situation with hardware drivers has further complications.]

Firstly, this problem predates Jiri's changes; only because he was
cautious by checking the lifetime of the itty in flush_to_ldisc(), did
he uncover this existing problem.

One example of how it is possible for buffer work to be scheduled even
after tty_release_ldisc() stems from how tty_ldisc_halt() works (or
rather doesn't). (I've snipped out the relevant code from tty_ldisc.c
for annotation below.)

tty_ldisc_halt() has only 2 callers; tty_release_ldisc() and
tty_set_ldisc(). A 3rd code site -- tty_ldisc_hangup() -- has similar
logic.

The idea behind tty_ldisc_halt() is to prevent __future__ use of this
ldisc (since users are required to acquire an ldisc reference via
tty_ldisc_try() -- also below).  Annotations are mine.

----------------------------------

static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
{
	unsigned long flags;
	struct tty_ldisc *ld;

	/* this spin_lock is irrelevant to this discussion */
	spin_lock_irqsave(&tty_ldisc_lock, flags);
	ld = NULL;

	/*
	 * Atomically test if __new__ ldisc references are
	 * allowed. Please note, there can be any number of
	 * existing users (ie., outstanding references).
	 */
	if (test_bit(TTY_LDISC, &tty->flags))
		ld = get_ldisc(tty->ldisc);

	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
	return ld;
}

static int tty_ldisc_halt(struct tty_struct *tty)
{
	/* Prevent any __new__ ldisc references from being acquired. */

	clear_bit(TTY_LDISC, &tty->flags);

	/* Since __existing__ ldisc references can still schedule new
	 * buffer work (via tty_flip_buffer_push()), the cancellation
	 * below is pointless. The instant that cancellation completes
	 * an existing ldisc user can schedule new work.
	 *
	 * At a minimum, we must wait for all ldisc references **here**
	 * rather than **after** cancelling the work.
	 */

	return cancel_work_sync(&tty->buf.work);
}



**** A special note about locking *****

Locking around tty_ldisc_halt() ...
- does not prevent existing ldisc users from continuing to use the ldisc
- is unnecessary for the 3 'callers' because all 3 are trying to
accomplish the same goal by the same means
- can deadlock. Reference: https://lkml.org/lkml/2012/11/21/267

Regards,
Peter Hurley

