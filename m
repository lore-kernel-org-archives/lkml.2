Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0KOOdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:33:19 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48075 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab0KOOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:33:18 -0500
Subject: Re: SCSI TMF processing; tag allocation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Luben Tuikov <ltuikov@yahoo.com>,
        Greg KH <greg@kroah.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <4CE0FD24.4030000@fusionio.com>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
	 <20101113123750.GF18258@parisc-linux.org>  <4CE0FD24.4030000@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 08:33:15 -0600
Message-ID: <1289831595.2233.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 10:28 +0100, Jens Axboe wrote:
> >> Third, and most importantly, tags should form an increasing sequence and should not be reused until all other tags after it and before it have been reused. This for example can be accomplished if one were to use
> >> find_next_zero_bit() with non-zero "offset", it being the last allocated
> >> tag in a modulo the number of tags manner. That is, find_next_zero_bit()
> >> could wrap as well as starting from an offset or the caller could implement
> >> that via two calls to this function, in blk_queue_start_tag().
> 
> Care to explain your reasoning? For starvation issues? At least I'm not
> aware of any correctness issues in that regard, but doing tag cycling in
> this fashion seems like a good idea just to prevent starvation alone by
> an ill behaving device.

Right, it's the clock algorithm to prevent tag starvation.  If you have
hands representing the first and last tag and they're never allowed to
cross, the device can't starve any tag for too long because eventually
it will be the only outstanding command.

It's not the only algorithm however.  Banging down an ordered tag every
200 or so commands has exactly the same effect.  In fact the clock
algorithm was what the 53c700 driver used (before it was converted to
generic tags) and the ordered tag what aic7xxx uses.

Realistically, tag starvation isn't really a problem.  It was a known
issue for 80s era hardware.  I've got some of the oldest drives on the
planet and I didn't see a problem when the clock algorithm was removed
from 53c700.

James


