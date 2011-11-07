Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1KGXAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:00:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58301 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab1KGXAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:00:49 -0500
Date: Mon, 7 Nov 2011 23:01:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Davidlohr Bueso <dave@gnu.org>, Christoph Hellwig <hch@infradead.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107230135.62ee7aae@lxorguk.ukuu.org.uk>
In-Reply-To: <20111107143010.GA3630@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
	<20111107112952.GB25130@tango.0pointer.de>
	<1320675607.2330.0.camel@offworld>
	<20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
	<20111107143010.GA3630@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which is almost certainly not what you want to happen. Think about direct
> > rendering.
> 
> I don't see what direct rendering has to do with closing the security
> hole that /dev/shm currently is.

Direct render objects (like shared memory objects) are backed by shmfs,
so if you impose random limits on the shmfs you'll get weird graphics
happenings. You use a *lot* of shmfs objects when you are running 3D
gaming, enormous amounts for all your textures and the like.

The DRM case means you can't set tight limits on shmfs and expect to play
Warcraft.

> Uh? I am pretty sure we don't want to mount a private tmpfs for each
> user in /dev/shm and /tmp. If you have 500 users you'd have 500 tmpfs on

Oh I do. That would actually do something abut temporary file handling
which is a much much bigger issue than a DoS when people get it wrong.
It's a bit of Unix history that wants sorting out more than /usr
and /bin...

> /tmp and on /dev/shm. Despite that without some ugly namespace hackery

Only if they were all logged in

> you couldn't make them all appear in /tmp as /dev/shm without
> subdirectories. Don't forget that /dev/shm and /tmp are an established
> userspace API.

Don't forget there have been pam modules for doing per user /tmp/ for
years and years.

> Resource limits are exactly the API that makes sense here, because:

No because they are inherited process things and the exhaustion behaviour
is not standards defined. Christoph is right that this should be
implemnted via quota.

It might well be that your quota implementation is handled by a mount
option (sysfs just makes it more complex) and that

	mount blah -oquotaallusers=16G 

is how you set it up, but doing it via quota interfaces makes all sorts
of crap just work including warning users about quota limits.

Alan
