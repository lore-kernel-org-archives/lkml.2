Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2IGOox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2IGOov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:44:51 -0400
Message-ID: <504A0858.4080508@redhat.com>
Date: Fri, 07 Sep 2012 16:44:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <5049BE0E.6040202@redhat.com> <20120907105335.GB17211@redhat.com> <5049D899.60705@redhat.com> <20120907121712.GA17397@redhat.com> <5049E717.8080307@redhat.com> <20120907124432.GB17397@redhat.com> <5049FEDD.40303@redhat.com> <20120907142545.GC17397@redhat.com>
In-Reply-To: <20120907142545.GC17397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 16:25, Michael S. Tsirkin ha scritto:
>> > Silent deflate is deflating just by using the page, without using the
>> > deflateq at all.  So it can be done even from GFP_ATOMIC context.
> BTW I don't see a need to avoid deflateq.
> Without MUST_TELL_HOST you can just deflate and then
> bounce telling the host out to a thread.

Yes, that's fine too.

>> > But knowing that the guest will _not_ deflate silently also benefits the
>> > host. This is the cause of unpinning ballooned pages and pinning them
>> > again upon deflation. This allows cooperative memory overcommit even if
>> > the guests' memory is pinned, similar to what Xen did before it
>> > supported overcommit.  This is the second feature bit.
> This is the MUST_TELL_HOST.

Almost.  One is "the guest, if really needed, can tell the host of
pages".  If not negotiated, and the host does not support it, the host
must break the guest (e.g. fail to offer any virtqueues).

The other is "the guest, though, would prefer not to do so".  It is
different because the guest can proceed in a fallback mode even if the
host doesn't offer it.

You're interpreting features as something that dictates behavior, but
they're really just advisory.  You could negotiate VIRTIO_BLK_F_TOPOLOGY
and end up never reading the fields; you could negotiate
VIRTIO_NET_F_GUEST_ANNOUNCE and never send a guest announcement.

>> > * guest will always do silent deflation: current Windows driver.
> Not exactly. It is not silent. It tells host
> just after use.

Yeah, but no difference from the POV of the driver.

Delaying or avoiding is the same in the end.  The spec says it well: "In
this case, deflation advice is merely a courtesy".

>> > Negotiates nothing, or if it cares it can negotiate
>> > VIRTIO_BALLOON_F_SILENT_DEFLATE.  Host mustn't do munlock/mlock dance.
>> >
>> > * guest may do silent deflation if available: combo of Linux driver +
>> > Frank's driver.  Negotiates both features, looks at
>> > VIRTIO_BALLOON_F_SILENT_DEFLATE host feature to decide how to behave:
>> > 
>> >   ** If PCI passthrough, the host will not negotiate
>> >      VIRTIO_BALLOON_F_SILENT_DEFLATE.  The driver will behave as the
>> >      current Linux driver, the host can do the munlock/mlock dance.
> So this case is just existing interface. OK.
> 
>> >   ** If no PCI passthrough, the host will negotiate
>> >      VIRTIO_BALLOON_F_SILENT_DEFLATE, and the driver can balloon more
>> >      aggressively and not use the deflateq.
>> > 
> This last trickery confuses me.  It just does not make sense to set both
> SILENT and TELL: either you are silent or you tell.

"I can be chatty if you ask me, but I'd rather be silent if you let me".

TELL is a request of the host to the guest; the guest can agree or not.

SILENT is a request of the guest to the host; the host can agree or not.

> What is the benefit of avoiding host notification?
> It seems cleaner for the host to know the state.

Yeah, if you want to do it you can.

Paolo
