Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0EKWdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:33:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39674 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753581Ab0EKWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:33:53 -0400
Date: Tue, 11 May 2010 23:37:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel =?ISO-8859-14?B?R2z2Y2tuZXI=?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100511233742.61cf0a6b@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
	<AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
	<20100511062110.GB9644@core.coreip.homeip.net>
	<AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>
	<20100511063309.GC9644@core.coreip.homeip.net>
	<y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
	<1273608441.15067.1002.camel@calx>
	<AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
	<alpine.DEB.2.00.1005111520260.1500@router.home>
	<AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SPI transfer into a DMA safe buffer.  what is the exact API to
> dynamically allocate memory for the structure with this buffer
> embedded in it such that the start of the structure is cached aligned
> ?  creating a dedicated kmem cache may work, but it isnt a scalable
> solution if every SPI driver needs to create its own cache.

If you are embedding structures then one solution is to cheat a bit and
make the structure, compiler and existing kernel compile abuse do the
work. Something like

struct {
	void *except_where_prohibited;
	long boat;
	unsigned photograph;

	u8 pad[0] __cacheline_aligned;
}..

ought to do the trick providing you align the start of the object - which
should happen naturally with kmalloc or dma_* apis


