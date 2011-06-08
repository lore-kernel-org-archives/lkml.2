Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1FHCwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:52:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728Ab1FHCwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop> <1307003821.29297.77.camel@pasglop>
 <20110602110727.7343782b@lxorguk.ukuu.org.uk> <1307062574.29297.204.camel@pasglop>
 <1307081874.23876.14.camel@pasglop> <1307084189.23876.19.camel@pasglop>
 <BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com> <BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
 <BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Jun 2011 19:44:48 -0700
Message-ID: <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 7:24 AM, Guillaume Chazarain <guichaz@gmail.com> wrote:
>
> After reverting http://git.kernel.org/linus/a5660b4 "tty: fix endless
> work loop when the buffer fills up" I cannot reproduce the hangs on
> SMP anymore but it brings back the busy loop on UP.

Hmm. The n_tty layer has some rather distressing locking, and doesn't
lock "tty->receive_room" changes at all, for example (and uses
multiple locks for some other things).

It may well be that there is some SMP race there. The n_tty line
discipline has its own locking for its counts, and the tty buffer code
has its own locking, and "receive_room" kind o fends up being in the
middle between them.

The sad part is that the patch that made receive_buf() return the
amout of bytes received was actually trying to do the right thing, it
just did it entirely in the wrong way (re-introducing the crazy
re-arming of the workqueue from within itself, and using all the wrong
sign issues).

I'd love to get rid of receive_room entirely - and just letting the
tty line discipline handler say how much it actually received. in
other words, having receive_buf() just tell us how much it used, and
not looking at receive_room in the caller is absolutely the right
thing.

It just needs to be done properly.

                                  Linus
