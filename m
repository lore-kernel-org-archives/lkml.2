Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2FVOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:38:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40659 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2FVOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:38:36 -0400
Date: Fri, 22 Jun 2012 15:42:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: New tty ldisc lockup on 3.5-rc3
Message-ID: <20120622154219.779965bb@pyramind.ukuu.org.uk>
In-Reply-To: <1340373489.27031.40.camel@lappy>
References: <1340373489.27031.40.camel@lappy>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  242.702289]  [<ffffffff83696d15>] schedule+0x55/0x60
> [  242.702921]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
> [  242.703685]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0

These are all what I'd expect - the tty write is waiting to get access to
the ldisc

> [  242.735143]  [<ffffffff81107d52>] ? prepare_to_wait+0x72/0x80
> [  242.737060]  [<ffffffff81b29c50>] tty_ldisc_wait_idle+0x80/0xd0

And the hangup is waiting for the line discipline to idle so it can
complete a hangup triggered by vhangup in its syscall path. All seems
sane so far. The ldisc code is behaving as I'd expect, you may also have
a printk indicating who was waiting too long as we will log that, loop
and retry if it fails in wait fo idle for too long

The real question is "who has the reference" and none of your threads
show anyone who does. That would suggest you are looking for something
like a faulty error handling path in a driver or a buggy ldisc.

What ldisc is attached to the line when it fails ?

Alan

