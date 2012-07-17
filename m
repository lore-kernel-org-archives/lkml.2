Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2GQJpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2GQJpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:45:00 -0400
Date: Tue, 17 Jul 2012 12:45:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
Message-ID: <20120717094526.GC7949@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
 <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
 <50052276.2080906@redhat.com>
 <500527BA.9000001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500527BA.9000001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:52:10AM +0200, Paolo Bonzini wrote:
> Il 17/07/2012 10:29, Asias He ha scritto:
> > So, vhost-blk at least saves ~6 syscalls for us in each request. 
> 
> Are they really 6?  If I/O is coalesced by a factor of 3, for example
> (i.e. each exit processes 3 requests), it's really 2 syscalls per request.
> 
> Also, is there anything we can improve?  Perhaps we can modify epoll and
> ask it to clear the eventfd for us (would save 2 reads)?  Or
> io_getevents (would save 1)?
> 
> > I guess you mean qemu here. Yes, in theory, qemu's block layer can be
> > improved to achieve similar performance as vhost-blk or kvm tool's
> > userspace virito-blk has. But I think it makes no sense to prevent one
> > solution becase there is another in theory solution called: we can do
> > similar in qemu.
> 
> It depends.  Like vhost-scsi, vhost-blk has the problem of a crippled
> feature set: no support for block device formats, non-raw protocols,
> etc.  This makes it different from vhost-net.

Well vhost-net is also more limited than virtio-net: no support for
userspace networking, no support for level interrupts,
no support for legacy qemu vlans, can not trace datapath in userspace,
only virtio is supported. None of these is fundamental but this is
how our implementation currently behaves so from user's point of view
that's how it is.  There are also fundamental limitations - e.g.
it's linux only, a special module needs to be loaded and user needs to
get an fd to the char device ...  The way we addressed it, is by making it seamless for
the user: basically if your setup matches what vhost-net can
accelerate, it gets enabled, if not - userspace is used. Most of the
logic is in libvirt.

> So it begs the question, is it going to be used in production, or just a
> useful reference tool?
> 
> Paolo

Sticking to raw already makes virtio-blk faster, doesn't it?
In that vhost-blk looks to me like just another optimization option.
Ideally I think user just should not care where do we handle virtio:
in-kernel or in userspace.  One can imagine it being enabled/disabled
automatically if none of the features unsupported by it are used.

For example currently you specify vhost=on for tap backend and
then if you try to setup an unsupported by it like level interrupts,
it gets disabled and userspace virtio is used.

-- 
MST
