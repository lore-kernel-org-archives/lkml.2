Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2KBPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:31:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36330 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2KBPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:31:08 -0400
Date: Fri, 2 Nov 2012 15:35:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102153530.483453c7@pyramind.ukuu.org.uk>
In-Reply-To: <5093DD5E.6030808@redhat.com>
References: <20121025180045.GL11442@htj.dyndns.org>
	<1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 15:49:02 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 31/10/2012 22:22, Tejun Heo ha scritto:
> > Hello, Paolo.
> > 
> > On Thu, Oct 25, 2012 at 02:35:20PM -0400, Paolo Bonzini wrote:
> >>> Disabling filters if opened by root and tranfering via SCM_RIGHTS
> >>> would be the simplest interface-wise (there's no new interface at
> >>> all).  Would that be too dangerous security-wise?
> >>
> >> That would be a change with respect to what we have now.  After
> >> transferring a root-opened (better: CAP_SYS_RAWIO-opened) file
> >> descriptor to an unprivileged process your SG_IO commands get
> >> filtered.  So a ioctl is needed if you want to rely on SCM_RIGHTS.
> > 
> > Yeah, I get that it's a behavior change, but would that be a problem?
> 
> Worse, it's a potential security hole because previously you'd get
> filtering and now you wouldn't.
> 
> Considering that SCM_RIGHTS is usually used to transfer a file
> descriptor from a privileged process to an unprivileged one, I'd be very
> worried of that.

In other contexts you inherit file handles via exec and having a "root
opened so its special" model is bad. Historically it led to things like
the rlogin/rsh hacks on SunOS and friends where a program run by the rsh
daemon got a root opened socket as its stdin/out and could issue ifconfig
ioctls on it at will.

Not a good model. Any removal of filters and passing them to a task
should be explicit. The behaviour really ought to be to permit the
intentional setting of explicit filters then passing them, not touch the
default behaviour.

Alan
