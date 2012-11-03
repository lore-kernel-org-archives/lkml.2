Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467Ab2KCArR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:47:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37065 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab2KCArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:47:14 -0400
Date: Sat, 3 Nov 2012 00:52:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121103005210.1f66b568@pyramind.ukuu.org.uk>
In-Reply-To: <20121103002328.GI27843@mtj.dyndns.org>
References: <20121102164828.GA3823@mtj.dyndns.org>
	<20121102172145.184abfe3@pyramind.ukuu.org.uk>
	<20121102173022.GA27843@mtj.dyndns.org>
	<20121102201824.41b2516d@pyramind.ukuu.org.uk>
	<20121102202131.GE9169@htj.dyndns.org>
	<20121102204825.7e4bd641@pyramind.ukuu.org.uk>
	<20121102225912.GD27843@mtj.dyndns.org>
	<20121102235243.60dfa772@pyramind.ukuu.org.uk>
	<20121102235811.GG27843@mtj.dyndns.org>
	<20121103001905.6f894267@pyramind.ukuu.org.uk>
	<20121103002328.GI27843@mtj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, my first response was whether you mean to add arbitrary range
> filtering for standard read/writes too.  If you're not gonna do that

Thats relevant for /dev/sd but not /dev/sg. Now it might be the sane
thing to do is to support BPF filters on /dev/sg only ?

> But we should't add features for the ones which haven't been
> considered.  Unless you can actually justify with actual use cases,
> it's just hand waving.

The CD writer one isn't but you tried to dismiss that too. 

> The suggested mechanism is just having a switch to allow all SG_IO
> commands and pass it to the hypervisor.  There's no filtering in
> kernel at all.

That requires you have a very trusted hypervisor, that to me is a
weaker model because it increases the probability that a hack on a
guest of a cloud becomes a hack of the cloud itself at least in terms of
quiet data theft from other guests. It's still a minor risk because
you've got to break the guest then break the hypervisor from guest
virtual ring 0, but the hypervisor is a large target,

For a lot of cases being able to do the filtering in the hypervisor makes
sense and I don't have a problem with that except that you do need to
enforce CAP_SYS_RAWIO on the process setting the flags or you break the
kernel capability model. For a hypervisor guest flipping flags at boot
thats not a big deal.

> > We have filtering because it is necessary. All you are doing is putting
> > off the inevitable by adding more kernel hack "one true kernel enforced
> > religion" policy and putting off the inevitable while adding APIs you'll
> > then have to maintain until the job is done right.
> > 
> > Ultimately policy has to be user space driven, adding more temporary
> > hacks is just a waste.
> 
> Exactly, let's provide a turn-off switch for in-kernel filtering and
> let userland drive any appropriate access policy on it.  Let's please
> stay away from doing deep packet inspecting on SG_IO commands.

And you've left stuff like CD burning broken still despite people pointing
out for years that sorting out the filtering would fix it.

> I don't think we're disagreeing on the principle.  It's just that
> we're drawing different where the line lies between mechanisms and
> policies.

On the CD burning case and on generality I think we are disagreeing in
principle. Which isn't to say there is a right answer and one of us is an
idiot, just that there are things to consider carefully here.

IMHO you are hacking kernel policy by a magic flag to support a specific
problem case, not fixing the problem. The question is whether the problem
needs fixing 8)

Alan
