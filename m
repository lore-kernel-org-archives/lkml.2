Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2IJFuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:50:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55614 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2IJFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:50:19 -0400
Message-ID: <504D7F95.9070700@redhat.com>
Date: Mon, 10 Sep 2012 07:50:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: fes@google.com, aarcange@redhat.com, riel@redhat.com, yvugenfi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mikew@google.com,
        yinghan@google.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <87vcfqfia1.fsf@rustcorp.com.au> <5049BE0E.6040202@redhat.com> <20120907105335.GB17211@redhat.com> <5049D899.60705@redhat.com> <20120907121712.GA17397@redhat.com> <5049E717.8080307@redhat.com> <20120907124432.GB17397@redhat.com> <5049FEDD.40303@redhat.com> <20120907142545.GC17397@redhat.com> <504A0858.4080508@redhat.com> <20120908222221.GA20588@redhat.com>
In-Reply-To: <20120908222221.GA20588@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/09/2012 00:22, Michael S. Tsirkin ha scritto:
>> Almost.  One is "the guest, if really needed, can tell the host of
>> pages".  If not negotiated, and the host does not support it, the host
>> must break the guest (e.g. fail to offer any virtqueues).
> 
> There is no way in spec to break the guest.
> You can not fail to offer virtqueues.

You can always return 0 for the first queue.

> Besides, there is no guarantee that virtqueue setup
> happens after feature negotiation.

It is the only way that makes sense though (unless the guest would write
0 for its features).  Should we change that?

>> The other is "the guest, though, would prefer not to do so".  It is
>> different because the guest can proceed in a fallback mode even if the
>> host doesn't offer it.
> 
> I think I get what your proposed SILENT means what I do not get
> is the motivation. It looks like a premature optimization to me.

The motivation is to let the driver choose between two behaviors: the
current one where ballooning is only done on request, and a more
aggressive one.

> The spec is pretty clear that if guest acks feature it
> is a contract that dictates behaviour.
> If it doesn't it is either ignored or just informative
> depending on feature.
> 
>> You could negotiate VIRTIO_BLK_F_TOPOLOGY
>> and end up never reading the fields; you could negotiate
>> VIRTIO_NET_F_GUEST_ANNOUNCE and never send a guest announcement.
> 
> Block example is just informative. It does not need to be
> negotiated even to be used. But last example is wrong.
> If you ack GUEST_ANNOUNCE hypervisor assumes guest will
> announce self, if guest does not do it this break migration.

It is wrong indeed, sorry.

Better example: the driver can negotiate VIRTIO_NET_F_CTRL_RX and never
set promiscuous mode.  The device has to obey if it does.

Similarly, if you set VIRTIO_BALLOON_F_SILENT_DEFLATE and only do chatty
deflate later, that's fine.  If you do silent deflate, and the device
negotiated the feature, it has to work.

>> Delaying or avoiding is the same in the end.  The spec says it well: "In
>> this case, deflation advice is merely a courtesy".
> 
> So it looks like we don't need a new bit to leak in atomic ctx.
> Just do not ack MUST_TELL_HOST and delay telling host to a wq.
> IMO we should not add random stuff to spec like this just because it
> seems like a good idea.

But this way you have to choose all-or-none.  If the host cannot do
silent deflate, you cannot balloon anymore, not even in the normal
"cooperative" mode.

> OK so TELL says *when* to notify host, SILENT if set allows guest
> to skip leak notifications? In this case TELL should just be ignored
> when SILENT is set.

Yeah, that was my first idea.  However, there are existing drivers that
ignore SILENT, so that would not be 100% exact.

> IMHO, renaming is fine since there is confusion.
> But WILL_TELL is also not all that clear imho.

> I think the confusion is that TELL_HOST seems to
> imply we can avoid telling host at all.
> How about being explicit?
> 
> VIRTIO_BALLOON_F_HOST_ACK_BEFORE_DEFLATE

Makes sense.

Paolo
