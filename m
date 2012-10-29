Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2J2QZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:25:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58229 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2J2QYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:24:44 -0400
Date: Mon, 29 Oct 2012 16:29:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Guillaume Juan <guillaume.juan@sagemcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: prevent crash due to dereferencing NULL gsm->tty
Message-ID: <20121029162947.6270b4da@pyramind.ukuu.org.uk>
In-Reply-To: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com>
References: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012 10:11:45 +0200
Guillaume Juan <guillaume.juan@sagemcom.com> wrote:

> From: Guillaume Juan <guillaume.juan@sagemcom.com>
> 
> If gsm->tty happens to be NULL in gsmld_output, avoid crashing the kernel (the crash is replaced by a warning dump).

More important is fixing the bug completely. I agree there is a bug I
don't think your fix is sufficient however.


You no longer set dlci->dead before doing the dlci release so what stops
a SABM from the other end racing this ?

Also moving the gsm_dlci_release seems to have no value at all because
there is no locking in the code concerned so viewed from any other thread
you've changed nothing but timings. Yes its probably way harder to hit.

I can see two ways of tackling it both of which basically come down to
the same thing. In gsmld_detach_gsm after the gsm_cleanup_mux we need to

- be sure the thing cannot re-open
- wait until all the DLCIs are dead

then do the tty_kref_put and gsm->tty = NULL

Thoughts ?

Alan
