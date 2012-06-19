Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2FSRvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:51:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36176 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2FSRvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:51:04 -0400
Date: Tue, 19 Jun 2012 18:54:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid
 recursive spinlocks
Message-ID: <20120619185432.30eb78c3@pyramind.ukuu.org.uk>
In-Reply-To: <4FE0B853.5060203@linux.intel.com>
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com>
	<CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
	<4FC90BAD.3080606@linux.intel.com>
	<4FCE8307.3050901@linux.intel.com>
	<CANKRQnj5mxHLprMt4VMMa7sCwLZb=PAktnVVD1MZVkkUG4eLoA@mail.gmail.com>
	<4FDFA09A.4030405@linux.intel.com>
	<20120619101447.74cbd9a1@pyramind.ukuu.org.uk>
	<4FE0B853.5060203@linux.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see, the oops_in_progress test right? My thinking was that the
> oops_in_progress was only relevant to the port.lock as that could be
> taken outside of the pch_uart driver, while the priv.lock is only used
> within the driver. But, as the oops uses the pch_console_write itself, I
> can see the recursive spinlock failure case there.

Until your driver crashes...

> As for the printk, it seems the 8250 driver would also suffer from that
> in the serial8250_console_write function on the port.lock, and it does
> not make any allowances for printk.

I think 8250 probably wants fixing too then!

> 
> I would like to hold the priv.lock for a smaller window, but ordering
> requires that I take it prior to the port.lock.
> 
> So I can test for oops_in_progress on the priv->lock too, but that won't
> address the printk issue. Is the oops the bigger concern?

the oops is the main one - a printk would have to be in driver as a
screwup, and you can force an oops on a stall so pick it up later

Alan
