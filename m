Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763231Ab2KBRQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:16:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36557 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763146Ab2KBRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:16:46 -0400
Date: Fri, 2 Nov 2012 17:21:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102172145.184abfe3@pyramind.ukuu.org.uk>
In-Reply-To: <20121102164828.GA3823@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
	<1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
	<20121102153530.483453c7@pyramind.ukuu.org.uk>
	<20121102164828.GA3823@mtj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not a good model. Any removal of filters and passing them to a task
> > should be explicit. The behaviour really ought to be to permit the
> > intentional setting of explicit filters then passing them, not touch the
> > default behaviour.
> 
> Yeah, well, then I guess it'll have to be a separate ioctl to switch
> SG_IO for !root users.


My first thought would be to have the basic behaviour as


allowed 	IFF	passes user filter
		&&	CAP_SYS_RAWIO || passes 'root' filter


that allows untrusted to also push unprivileged filters for their own
purposes (consider things like exokernel experiments or just trying to
ensure a raw disk emulation doesn't go wrong). The default user feature
would be 'allow anything'.

then add a way to 'set' the root filter only if you have CAP_SYS_RAWIO
with the default 'root' filter being the current hardcoded filter.

That also means that a normal app running as superuser for some reason
would set its user filter and any accidentally inherited descriptors will
be less dangerous as the are today. It also means a CAP_SYS_RAWIO capable
app can still use filters itself as good programming practise.

It effectively means you have to deliberately and intentionally set up an
'inherited' extra rights case.

Alan
