Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0HITK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:10:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51641 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666Ab0HITK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:10:26 -0400
Date: Mon, 9 Aug 2010 20:24:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100809202453.26f242b3@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
References: <20100805213528.GA13794@kroah.com>
	<20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
	<AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
	<201008062158.46013.arnd@arndb.de>
	<20100806202228.GA6153@suse.de>
	<AANLkTinaQz22DAzrcvYREWAe9AFv8enC88Gu_9o_Ghg-@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With the new locking the BTM is held in place of the BKL, which
> effectivly means throughout open and close processing, which
> effectively means _all_ TTY open/closes are serialised throughout
> regardless of the length of the shutdown processing.  The EIO appears
> to be no longer returnable.

The specific case of waiting for queues to empty could be a slow one and
probably wants to addressed nicely. The other causes like memory
allocator waits are probably actually better the new way. What exactly is
an application supposed to do when it gets a -EIO on open, how does it
decide when to try again, when does it retry, how many aps get it right ?

In fact I don't think its unreasonable to treat an open without O_NDELAY
that blocks on a close flushing output from buffers as correct - unless
there is some specific POSIX reason why we cannot.

I'd venture we'd effective fix/hide/cover over a huge range of extremely
obscure and near untestable app failure cases/bugs by doing this.

Alan
