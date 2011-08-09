Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1HIJkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:40:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40452 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199Ab1HIJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:40:06 -0400
Date: Tue, 9 Aug 2011 10:43:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: fix possible null pointer in
 acm_tty_hangup
Message-ID: <20110809104323.412b6282@lxorguk.ukuu.org.uk>
In-Reply-To: <1312843100-1811-1-git-send-email-vpalatin@chromium.org>
References: <1312843100-1811-1-git-send-email-vpalatin@chromium.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Aug 2011 15:38:20 -0700
Vincent Palatin <vpalatin@chromium.org> wrote:

> Sometimes, acm_tty_hangup and acm_tty_close are called concurrently.
> This results in acm pointer being null in acm_tty_hangup and panics when
> it is dereferenced.

This is definitely not the way to attack the problem.

The tty port hangup and close logic will do all the needed locking and do
it right. The big problem here is touching tty->driver_data. If you have
a block of memory that is tied to the tty object lifetime it needs to get
destroyed when the tty object is destroyed not as close/hangup or you
still leave races.

Take a look at

	tty_port_close
	tty_port_hangup

and in particular for port internal sychronization of open/close/hangup
once only events at

	port->ops->activate
	port->ops->shutdown
	port->ops->destruct

and for a tty lifetime object

	tty->ops->shutdown

Alan
