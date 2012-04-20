Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2DTU5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:57:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49792 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2DTU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:57:28 -0400
Date: Fri, 20 Apr 2012 22:00:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Emil Goode <emilgoode@gmail.com>
Cc: gregkh@linuxfoundation.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/tty: Use get_user instead of dereferencing user
 pointer
Message-ID: <20120420220010.0fa29bee@pyramind.ukuu.org.uk>
In-Reply-To: <1334937154-23037-1-git-send-email-emilgoode@gmail.com>
References: <1334937154-23037-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 17:52:34 +0200
Emil Goode <emilgoode@gmail.com> wrote:

> We should use the get_user macro instead of dereferencing user
> pointers directly.
> 
> This patch fixes the following sparse warning:
> drivers/tty/n_tty.c:1648:51: warning:
> 	dereference of noderef expression
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

So I gave it a five second glance and thought "must be a crazy newbie",
then I looked harder 8)

> I'm a newbie so please review carefully.
> Not sure if I should add error handling for the get_user call here.

You are correct, and it's been wrong for ages. You are also the first
person to my knowledge to actually dig into that sparse warning and fix
it!

>  		/* Turn single EOF into zero-length read */
>  		if (L_EXTPROC(tty) && tty->icanon && n == 1) {
> -			if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
> +			get_user(ch, b[n-1]);
> +			if (!tty->read_cnt && ch == EOF_CHAR(tty))
>  				n--;
>  		}

The real question is what this code should be doing. The only case it can
be triggered as far as I can see is:

User provides buffer one byte shorter than the size passed to the syscall
Data is copied and copy_to_user returns 1 byte uncopied
n ends up as one

At this point we can take this path. What I don't understand at this
point is what this code path is actually *supposed* to do.

I think it should be testing against the value of n before the n -=
retval, and also checking the data it copied *from* in kernel space, not
the user size. The user data might be changed by another thread.

First problem therefore is to figure out what this code is supposed to be
doing. However you are right that the code is incorrect, and if it was a
simple bug your fix would also be correct.

It's not simple however, so can anyone work out or remember wtf the code
should be doing ???

Alan
