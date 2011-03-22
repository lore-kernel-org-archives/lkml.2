Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1CVSFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:05:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54385 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752100Ab1CVSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:05:27 -0400
Date: Tue, 22 Mar 2011 18:05:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Toby Gray <toby.gray@realvnc.com>
Cc: Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110322180545.54df2fa0@lxorguk.ukuu.org.uk>
In-Reply-To: <4D88ADFB.10206@realvnc.com>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
	<1300730698-17099-1-git-send-email-toby.gray@realvnc.com>
	<20110322100526.GB21343@localhost>
	<4D88ADFB.10206@realvnc.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a mechanism preventing a different thread from running 
> n_tty_read between n_tty_receive_buf finding receive_room to be below 
> the threshold and tty_throttle being called? If not then isn't there a 
> race condition when the following happens:

n_tty_receive is single threaded and is going to get run in preference to
user threads.

>          1. n_tty_receive_buf fills up the buffer so that the free space 
> is below TTY_THRESHOLD_THROTTLE
>          2. n_tty_receive_buf comes to the check at the end and decide 
> that it needs to call tty_throttle
>          3. Thread rescheduling happens and a different thread runs 
> n_tty_read which empties the buffer
>          4. After emptying the buffer n_tty_read calls tty_unthrottle, 
> which does nothing as the throttling bit isn't set
>          5. The n_tty_receive_buf thread is executed again, calling 
> tty_throttle, causing throttling, but with an empty buffer.
> 
> Or have I not understood a complexity in the interactions within n_tty.c?

Looks possible - historically it would have been safe but not any more.
The scenario I think would have to be two thread of execution in parallel
on two processors at the same moment and with near perfect timing but I
don't see why it can't happen.

Alan
