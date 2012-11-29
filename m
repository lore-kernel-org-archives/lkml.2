Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2K2Ntx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:49:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45939 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2K2Ntv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:49:51 -0500
Date: Thu, 29 Nov 2012 13:54:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Xiaobing Tu <xiaobing.tu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Alek Du <alek.du@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Correct tty buffer flushing.
Message-ID: <20121129135418.4237e7f8@pyramind.ukuu.org.uk>
In-Reply-To: <50B6A652.9000107@ilyx.ru>
References: <50B55A93.4090900@ilyx.ru>
	<50B6A652.9000107@ilyx.ru>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 6c9b7cd..4f02f9c 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty)
>  {
>  	struct tty_buffer *thead;
>  
> -	while ((thead = tty->buf.head) != NULL) {
> -		tty->buf.head = thead->next;
> -		tty_buffer_free(tty, thead);
> +	if (tty->buf.head == NULL)
> +		return;
> +	while ((thead = tty->buf.head->next) != NULL) {
> +		tty_buffer_free(tty, tty->buf.head);
> +		tty->buf.head = thead;

This part of the change seems to have no effect at all. There are no
locks held so there is nothing guaranteeing how the other processors
views of the order of operations will be affected.

Alan
