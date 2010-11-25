Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0KYOHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:07:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49716 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752328Ab0KYOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:07:20 -0500
Date: Thu, 25 Nov 2010 14:03:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101125140354.27ffca55@lxorguk.ukuu.org.uk>
In-Reply-To: <20101125163035.3105747b@desktopvm.lvknet>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
	<20101124164329.75368d71@lxorguk.ukuu.org.uk>
	<20101125013812.0dc828ad@tornado.gnet>
	<20101124223600.5eb8476f@bob.linux.org.uk>
	<20101125163035.3105747b@desktopvm.lvknet>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Didn't know that current design is crap. :)

It's based on the old big kernel lock and it has lots of horrors when
used from interrupt paths as a result. A big chunk of it can in time I
think move to just having a per tty ldisc lock that covers all changes
etc, but we aren't there yet.

> Ok, I think I'll add a new waitqueue and a new bit (TTY_LDISC_NOREF)

We've got the wait queue already

My first guess would be something like

static struct tty_ldisc *tty_ldisc_irqget(struct tty_struct *tty)
{
        unsigned long flags;
        struct tty_ldisc *ld;
   
        spin_lock_irqsave(&tty_ldisc_lock, flags);
        ld = NULL;
        if (test_bit(TTY_LDISC, &tty->flags)) {
                ld = get_ldisc(tty->ldisc);
		WARN_ON(test_and_set_bit(TTY_LDISC_IRQ, &tty->flags));
	}
        spin_unlock_irqrestore(&tty_ldisc_lock, flags);
        return ld;
}

static struct tty_ldisc *tty_ldisc_irqput(struct tty_ldisc *ld)
{
	clear_bit(TTY_LDISC_IRQ, &tty->flags);
	tty_ldisc_put(ld);
}

(and I think you can then wait on tty_ldisc_idle for the flag to go clear
after clearing TTY_LDISC)

It might be better to make it a count of course in case there are later
multiple users of this ?

Alan

