Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab2FELMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:12:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44534 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2FELMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:12:18 -0400
Date: Tue, 5 Jun 2012 12:15:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Karel Zak <kzak@redhat.com>
Cc: Richard Weinberger <richard@nod.at>, jslaby@suse.cz,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, alan@linux.intel.com
Subject: Re: um: TTY fixes (?)
Message-ID: <20120605121532.366a6526@pyramind.ukuu.org.uk>
In-Reply-To: <20120605104125.GA14536@x2.net.home>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<20120604221731.5e378fc2@pyramind.ukuu.org.uk>
	<4FCD4161.7060409@nod.at>
	<20120605104125.GA14536@x2.net.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  open_tty() closes all the old file descriptors after tty open:

It needs to close them before.
> 
>     vhangup();
>     ...
> 	fd = open(tty, O_RDWR | O_NONBLOCK);
>     ...
> 
> 	flags = fcntl(fd, F_GETFL);
> 	flags &= ~O_NONBLOCK;
> 	fcntl(fd, F_SETFL, flags);
> 
> 	for (i = 0; i < fd; i++)
> 		close(i);
> 	for (i = 0; i < 3; i++)
> 		if (fd != i)
> 			dup2(fd, i);
> 	if (fd >= 3)
> 		close(fd);
> 
> we use this for pretty long time (17+ years).
> 
> > If I add:
> >         fclose(stdin);
> >         fclose(stdout);
> >         fclose(stderr);
> > before the call to vhangup() login works like charm. :-)
> > 
> > Karel, what do you think?
> 
>  It's probably no problem to close all the file descriptors before
>  vhangup(), but it would be nice to know why we need this change after
>  20 years :-)

Because we want to actually fix the standards (and security) violation
that means it has happened to work on the console for 20 years.

Actually I'd prefer a clever solution which can spot all the fds are the
same process so we can keep compatibility but I've not found a sensible
way to do that.

Alan
