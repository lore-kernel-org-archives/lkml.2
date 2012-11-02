Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901Ab2KBXrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:47:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37002 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab2KBXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:47:47 -0400
Date: Fri, 2 Nov 2012 23:52:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102235243.60dfa772@pyramind.ukuu.org.uk>
In-Reply-To: <20121102225912.GD27843@mtj.dyndns.org>
References: <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
	<20121102153530.483453c7@pyramind.ukuu.org.uk>
	<20121102164828.GA3823@mtj.dyndns.org>
	<20121102172145.184abfe3@pyramind.ukuu.org.uk>
	<20121102173022.GA27843@mtj.dyndns.org>
	<20121102201824.41b2516d@pyramind.ukuu.org.uk>
	<20121102202131.GE9169@htj.dyndns.org>
	<20121102204825.7e4bd641@pyramind.ukuu.org.uk>
	<20121102225912.GD27843@mtj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - giving people access to parts of disks
> 
> Are we gonna implement random range restriction inside a partition
> too?  If we want to check against partition ranges for allowed SG_IO
> commands, by all means, but it can easily be implemented as part of
> the fixed filter.

Really. Can your filter implement it only for certain commands, and only
for certain vendor specific commands ? Not really because your filter is
fixed - it has policy in kernel which is the wrong place for device
specific stuff.

And if you add it to the "fixed" policy how much code and ioctls is that
to specify ranges by command and pass partitions when they are device
mapper user space created mappings ? More code than the BPF interface and
more new APIs.

> > - allowing access to specific vendor specific commands on certain
> >   non-standard CD and DVD drives so they can be used for burning but you
> >   can't trash them
> 
> At this point, most burning commands are standardized, and optical
> drives are generally on the way out.  If you absolutely have to use
> some vendor specific commands, be root.

So that translates to me as "There is a good reason, but if your drive is
one of the awkward ones then f**k you go use root". Again policy in the
kernel just creates inflexibility and is the wrong place for it.

> > - giving end users minimal access to things like SMART but only on drives
> >   where it is safe
> 
> End users already have pretty good access to SMART data via udisks and
> it's way more flexible and intelligent than some in-kernel filter.

Thats a bit Gnome developer - "Our way or the highway". The point of
having a filter is that you put policy in user space. If you don't care
the default filter carries on just working, if you do care you can change
stuff with BPF.

> > - giving a user a SCSI disk or partition to play with but preventing them
> >   issuing weird ass commands that can disrupt other devices in the fabric
> >   (like drive to drive transfers, some kinds of resets, management
> >   commands)
> > - minimising the ability of a VM to do damage if compromised while
> >   maximising its raw access to a device
> 
> Maybe, I don't know.  It all sounds highly marginal to me.

If you are doing virtual machines it is far from marginal.

> For complex/intelligent access policies, kernel isn't the right place
> to do it anyway

So why are you arguing for kernel policies which is exactly what the
fixed ones are ? The BPF ones moves the policy to user space !

Alan
