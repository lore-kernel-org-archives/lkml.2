Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab2KCAOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:14:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37024 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2KCAOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:14:16 -0400
Date: Sat, 3 Nov 2012 00:19:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121103001905.6f894267@pyramind.ukuu.org.uk>
In-Reply-To: <20121102235811.GG27843@mtj.dyndns.org>
References: <5093DD5E.6030808@redhat.com>
	<20121102153530.483453c7@pyramind.ukuu.org.uk>
	<20121102164828.GA3823@mtj.dyndns.org>
	<20121102172145.184abfe3@pyramind.ukuu.org.uk>
	<20121102173022.GA27843@mtj.dyndns.org>
	<20121102201824.41b2516d@pyramind.ukuu.org.uk>
	<20121102202131.GE9169@htj.dyndns.org>
	<20121102204825.7e4bd641@pyramind.ukuu.org.uk>
	<20121102225912.GD27843@mtj.dyndns.org>
	<20121102235243.60dfa772@pyramind.ukuu.org.uk>
	<20121102235811.GG27843@mtj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012 16:58:11 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello, Alan.
> 
> On Fri, Nov 02, 2012 at 11:52:43PM +0000, Alan Cox wrote:
> > Really. Can your filter implement it only for certain commands, and only
> > for certain vendor specific commands ? Not really because your filter is
> > fixed - it has policy in kernel which is the wrong place for device
> > specific stuff.
> > 
> > And if you add it to the "fixed" policy how much code and ioctls is that
> > to specify ranges by command and pass partitions when they are device
> > mapper user space created mappings ? More code than the BPF interface and
> > more new APIs.
> 
> Hmmm?  You know which commands you're allowing.  You can definitely
> filter those commands for their ranges.  What ioctls?

How do you know what the rules are in kernel. If I'm locking you to fixed
mappings you have no idea in kernel what my user policy model is.

> > So that translates to me as "There is a good reason, but if your drive is
> > one of the awkward ones then f**k you go use root". Again policy in the
> > kernel just creates inflexibility and is the wrong place for it.
> 
> Yes, pretty much. 

Unfortunate and guaranteed to end up with problems not getting fixed
again - or having to redo the work a second time later on. Plus this is
but one example and you are blocking all the ones that haven't been
considered.

> > If you are doing virtual machines it is far from marginal.
> 
> Yeah, I agree VMs are the only one which isn't marginal, but then
> again, VMs can work reasonably well with far simpler mechanism.

I'm dying to see your "simpler mechanism" - I bet by the time you've
written the code it isn't simpler than calling the existing BPF logic.
Your kernel already has all the BPF stuff in it unless you are building
with no networking support so its essentially free.

The BPF execution is a call to sk_run_filter(). Is your mechanism simpler
than that ? It's also been closely audited.

> > > For complex/intelligent access policies, kernel isn't the right place
> > > to do it anyway
> > 
> > So why are you arguing for kernel policies which is exactly what the
> > fixed ones are ? The BPF ones moves the policy to user space !
> 
> No, it's doing something half-way inbetween in unnecessarily complex
> way when you can get by with much simpler mechanism.  We are stuck
> with the in-kernel whitelist for historical reasons (the proper way
> would be implementing burning service in userspace with proper
> integration with the rest of userland).  The in-kernel whitelist is

The burning service is one tiny example.

> broken for different classes of devices, so let's fix that in simple
> way and give userland a simple mechanism to solve the VM case.

Which you haven't done, because you've not provided a filter mechanism
that is flexible and takes policy from user space.
 
> It's unfortunate that we have this SG_IO filtering in kernel at all.
> Let's please not make it larger.

We have filtering because it is necessary. All you are doing is putting
off the inevitable by adding more kernel hack "one true kernel enforced
religion" policy and putting off the inevitable while adding APIs you'll
then have to maintain until the job is done right.

Ultimately policy has to be user space driven, adding more temporary
hacks is just a waste.

Alan
