Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab0I0RwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:52:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57834 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759155Ab0I0RwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:52:11 -0400
Date: Mon, 27 Sep 2010 19:15:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Powertop shows events/0 waking at high rate due to ptys
Message-ID: <20100927191536.1de29492@lxorguk.ukuu.org.uk>
In-Reply-To: <4CA0D660.3010804@goop.org>
References: <4CA0D660.3010804@goop.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 10:37:36 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>  Hi,
> 
> I noticed on one of my systems that powertop was showing events/0 waking
> at a high rate (~2000 times/sec, HZ=1000).  After a lot of tracing I
> found it was due to writes pending to ptys which hadn't been read.

Yes ptys will trigger this case while its there with a normal tty but
very hard to hit.

> problem; he reports that this wakeup behaviour is a regression compared
> to a 2.6.16 Debian kernel.

Be aware that you'll get misleading results to an extent with old
kernels. The old pty code is differently buggy and doesn't use the code
path in question at all.

With a non pty and care you can duplicate the problem on old kernels.

Really the line discipline should wake the work queue when it sets
tty->receive_room non-zero, but while only n_tty currently uses that
facility the existing code doesn't do it in any kind of race-free manner
and sometimes is only saved by the polling picking it up.

It's all really just a symptom of the fact that input and output buffers
shouldn't be attached to the tty in the first place but to a struct
representing the physical port. Fix that and the race conditions in
serial output go away, as do the potential crashes and this wakeup stuff
as well as a ton of locking in the irq/tx/rx paths. In several cases it
also saves you an entire copy.

Unfortunately while I got the tty port structures into lots of places
needed the job never gone done.

Alan
