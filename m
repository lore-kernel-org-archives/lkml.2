Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0J0Jev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:34:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50934 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651Ab0J0Jet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:34:49 -0400
Date: Wed, 27 Oct 2010 10:32:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: marui <m00150988@huawei.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        zihan@huawei.com, wangyeqi@huawei.com
Subject: Re: [PATCH] fix oops in usbserial_cleanup function
Message-ID: <20101027103247.38d88ece@lxorguk.ukuu.org.uk>
In-Reply-To: <00a801cb75a5$faf0a680$ba260b0a@china.huawei.com>
References: <fadccdfb103f0.103f0fadccdfb@huawei.com>
	<Pine.LNX.4.44L0.1010151009050.1603-100000@iolanthe.rowland.org>
	<20101015190913.GA8098@kroah.com>
	<00a801cb75a5$faf0a680$ba260b0a@china.huawei.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999651] serial_cleanup - port 5
> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999653] destroy_serial - (null)

So someone called destroy serial with serial->type->desc NULL

> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999654] return_serial
> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999671] BUG: unable to handle kernel NULL pointer dereference at (null)
> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999675] IP: [<(null)>] (null)

And serial->type->release NULL

> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999762]  [<fb877b40>] ? destroy_serial+0x80/0xd0 [usbserial]
> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999765]  [<fb877ac0>] ? destroy_serial+0x0/0xd0 [usbserial]
> Oct 27 00:20:10 linux-mec9 kernel: [ 6441.999770]  [<c03f351a>] ? kref_put+0x2a/0x60

Which came from the tty close (which will be after the hangup if you
pulled the card out with the modem in use). Kref leak perhaps ?

What driver is actually being used for the card itself ?

Alan
