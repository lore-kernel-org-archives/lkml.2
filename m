Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2HPMwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:52:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab2HPMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:52:33 -0400
Date: Thu, 16 Aug 2012 15:53:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
Message-ID: <20120816125337.GA21526@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120815142803.GF3068@redhat.com>
 <1345052191.4683.435.camel@ul30vt.home>
 <20120815192224.GB5670@redhat.com>
 <1345060759.4683.451.camel@ul30vt.home>
 <1345120492.4683.467.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345120492.4683.467.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 06:34:52AM -0600, Alex Williamson wrote:
> > > > So I'm inclined to say source IDs are a requirement for shared
> > > > interrupts.
> > > 
> > > Can yo show a specific example that breaks?
> > > I don't think it can exist.
> > 
> > Only the edge vs level interaction if we define the policy above for
> > de-assert.
> 
> Hmm, there is still a race w/ level.  If we have a number of
> level-deassert-irqfds making use of the same gsi and sourceid and we
> individually de-assert and notify, a re-assert could get lost if it
> happens before all of the de-asserts have finished.
> We either need
> separate sourceids or we need to do a single de-assert followed by
> multiple notifies.  Right?  Thanks,
> 
> Alex

Good catch, I agree, we need a single deassert.

I think I see how to implement this without reference counting and
stuff.  So we chain all auto-deassert irqfds for a given GSI together,
and have a single ack notifier.  When list becomes empty, remove the ack
notifier.

It's actually a good thing to do anyway, too many ack notifiers
would slow unrelated GSIs down.

-- 
MST
