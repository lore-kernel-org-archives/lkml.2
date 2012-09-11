Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2IKTNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:13:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2IKTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:13:31 -0400
Date: Tue, 11 Sep 2012 12:13:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Message-ID: <20120911191325.GU7677@google.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
 <20120911165953.GK7677@google.com>
 <504F7B65.9090603@redhat.com>
 <20120911182904.GS7677@google.com>
 <504F88CB.6030105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F88CB.6030105@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Tue, Sep 11, 2012 at 08:54:03PM +0200, Paolo Bonzini wrote:
> > On Tue, Sep 11, 2012 at 07:56:53PM +0200, Paolo Bonzini wrote:
> >> Understood; unfortunately, there is another major user of it
> >> (virtualization).  If you are passing "raw" LUNs down to a virtual
> >> machine, there's no possibility at all to use a properly encapsulated
> > 
> > Is there still command filtering issue when you're passing "raw" LUNs
> > down?
> 
> Yes, the passing down is just a userland program that gets SCSI
> commands from the guest, sends them via SG_IO, and passes back the
> result.  If the userland program is unprivileged (it usually is), then
> you go through the filter.

Could being able to bypass the filters for this "you own this LUN" be
a solution?  Or is it that we still need command filtering for
whatever reason?

> This is the userland for virtio-scsi (the kernel part of virtio-scsi is just
> a driver running in the guest).  It can run in two mode: it can do its own
> SCSI emulation, or it can just relay CDBs and their results.
> 
> It can (and does) use higher-level services if SCSI emulation is done in
> userland.  In that case, trim/discard can become a BLKDISCARD or a fallocate
> for example.  However, in this case userland doesn't do any emulation and in
> fact doesn't even need to know that this CDB is a discard.

Couldn't it intercept some of them - e.g. RWs and discards?  What's
the benifit / use case of doing pure bypass?  Would the benefits be
strong enough to justify whole bpf cdb filtering?

> Also, if it fails, there's no way to reconstruct the NAS's sense data to
> pass it back to the guest.  We do a limited amount of "making up" sense
> data (for example if a command is filtered, all we get is an errno value;
> and we say it was not recognized), but it should really be as simple
> and limited as possible.

Yeah, I agree losing sense data could suck but that alone doesn't seem
to be a very strong justification for the whole deal and there could
be different / smaller ways to solve the sense data problem.

> >> A generic filter (see
> >> http://article.gmane.org/gmane.linux.kernel/1312326 for a proposal)
> >> would be satisfactory for everyone, but it's also a major undertaking
> >> and so far I've not received a single comment about it.
> > 
> > Maybe I'm just not familiar with the problem space but I really hope
> > things don't come to that.
> 
> Why not? :)  (BTW it was suggested by Alan Cox, that's just my proposal for
> how to do it).  I think that it's a good idea, but it's a big bazooka for
> the smaller issue of supporting trim/discard.

I guess I mostly wanna know for sure that there's big / strong enough
targets for the big bazooka.  :)

> > Hmmm?  This was about discard, no?
> 
> One example of block layer interfaces that I want to add is BLKPING, so
> that you can see if the NAS is reachable.  Then SCSI emulation can map
> the "test unit ready" command to BLKPING.  There's a handful of such
> ioctls that would be useful, such as BLKDISCARD itself.

Can't you make use of the existing disk events mechanism for that?
Block layer already knows how to watch readiness of a device and tell
the userland about it via uevent.  Hooking to that shouldn't be too
difficult and I think probably is the right approach given that all
hotplug userland hotplug operations go through the same channel.

If you absoluately has to test it from userland, READ on the first
sector?  That essentially is what libata does for START_STOP although
it uses VERIFY instead of READ.  Given how partition code behaves, any
device which fails on READ on block0 isn't gonna work well with linux
anyway.

Thanks.

-- 
tejun
