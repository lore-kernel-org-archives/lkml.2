Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004Ab2KBX6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:58:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759695Ab2KBX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:58:16 -0400
Date: Fri, 2 Nov 2012 16:58:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102235811.GG27843@mtj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102235243.60dfa772@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Fri, Nov 02, 2012 at 11:52:43PM +0000, Alan Cox wrote:
> Really. Can your filter implement it only for certain commands, and only
> for certain vendor specific commands ? Not really because your filter is
> fixed - it has policy in kernel which is the wrong place for device
> specific stuff.
> 
> And if you add it to the "fixed" policy how much code and ioctls is that
> to specify ranges by command and pass partitions when they are device
> mapper user space created mappings ? More code than the BPF interface and
> more new APIs.

Hmmm?  You know which commands you're allowing.  You can definitely
filter those commands for their ranges.  What ioctls?

> > At this point, most burning commands are standardized, and optical
> > drives are generally on the way out.  If you absolutely have to use
> > some vendor specific commands, be root.
> 
> So that translates to me as "There is a good reason, but if your drive is
> one of the awkward ones then f**k you go use root". Again policy in the
> kernel just creates inflexibility and is the wrong place for it.

Yes, pretty much.  I don't think it's unreasonable for this one.  It's
not like we aim for ultimate flexibility all the time.  Everything is
a trade-off.  BPF filter for vendor-specific CD/DVD burning commands
seems way off to me, especially these days.

> > > - giving end users minimal access to things like SMART but only on drives
> > >   where it is safe
> > 
> > End users already have pretty good access to SMART data via udisks and
> > it's way more flexible and intelligent than some in-kernel filter.
> 
> Thats a bit Gnome developer - "Our way or the highway". The point of
> having a filter is that you put policy in user space. If you don't care
> the default filter carries on just working, if you do care you can change
> stuff with BPF.

We already have it implemented in userspace and it works well.
Actually it works better than anything we can do in kernel (e.g. how
is the kernel gonna know who's logged in front of the machine has
physical access to the hardware?).  What's the justification
duplicating it worse in kernel?

> > Maybe, I don't know.  It all sounds highly marginal to me.
> 
> If you are doing virtual machines it is far from marginal.

Yeah, I agree VMs are the only one which isn't marginal, but then
again, VMs can work reasonably well with far simpler mechanism.

> > For complex/intelligent access policies, kernel isn't the right place
> > to do it anyway
> 
> So why are you arguing for kernel policies which is exactly what the
> fixed ones are ? The BPF ones moves the policy to user space !

No, it's doing something half-way inbetween in unnecessarily complex
way when you can get by with much simpler mechanism.  We are stuck
with the in-kernel whitelist for historical reasons (the proper way
would be implementing burning service in userspace with proper
integration with the rest of userland).  The in-kernel whitelist is
broken for different classes of devices, so let's fix that in simple
way and give userland a simple mechanism to solve the VM case.

It's unfortunate that we have this SG_IO filtering in kernel at all.
Let's please not make it larger.

Thanks.

-- 
tejun
