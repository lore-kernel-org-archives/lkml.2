Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2A0Luh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:50:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45669 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2A0Lue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:50:34 -0500
Date: Fri, 27 Jan 2012 11:51:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        stian@nixia.no, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
Message-ID: <20120127115143.1943336b@pyramind.ukuu.org.uk>
In-Reply-To: <CAFLxGvzth1m=iUmXbU2WyGrw0i8441d2nKLjH=mY_f1O-hkKPQ@mail.gmail.com>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
	<58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
	<CAFLxGvzsg71gtyPEtOAVnS-DtozYzqgoGNK-ZJRvBfq1mf3Oug@mail.gmail.com>
	<CAFLxGvzffs=uSjxogdWtk_gqoJHPnmgQSLw9WaZRr_be=J5cgw@mail.gmail.com>
	<20120127010838.GA27899@suse.de>
	<CAPXgP12Bj1K3j5HL1=GTj=xEC+oWgB7VFeQL_Pg23fCevTQAcw@mail.gmail.com>
	<CAFLxGvzth1m=iUmXbU2WyGrw0i8441d2nKLjH=mY_f1O-hkKPQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> UML's console driver (arch/um/drivers/line.c) implements tty_operations.
> The crash happens because the tty subsystem calls the driver's close()
> function and later
> write_room() or chars_in_buffer().
> 
> write_room() and chars_in_buffer() fail badly because close() already
> cleaned up the driver's private data...

You don't want to do that.

> Greg, is UML's assumption wrong that after closing the tty no call to
> write_room() or chars_in_buffer() can happen?
> I have no idea why systemd is able to trigger this, UML's console
> driver is old and has always worked quite well.

It's always been untrue but it's even more untrue nowdays. The tty layer
objects are refcounted, and the code has had significant rewrites. line.c
hidden away in uml hasn't been updated.

I added a comment about 3 years ago pointing out another older change
that was needed and that wasn't acted on either..

Take a look at how all the other tty drivers use tty_port, how the ioctls
have been supposed to work for the past few years and the callback
changes, then use them.

tty_port will actually do most of the hard work for you.

Alan

