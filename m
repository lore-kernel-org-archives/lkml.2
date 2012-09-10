Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2IJGiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2IJGiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:38:18 -0400
Message-ID: <504D8AD1.6050006@redhat.com>
Date: Mon, 10 Sep 2012 08:38:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: fes@google.com, aarcange@redhat.com, riel@redhat.com, yvugenfi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mikew@google.com,
        yinghan@google.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <20120907105335.GB17211@redhat.com> <5049D899.60705@redhat.com> <20120907121712.GA17397@redhat.com> <5049E717.8080307@redhat.com> <20120907124432.GB17397@redhat.com> <5049FEDD.40303@redhat.com> <20120907142545.GC17397@redhat.com> <504A0858.4080508@redhat.com> <20120908222221.GA20588@redhat.com> <504D7F95.9070700@redhat.com> <20120910060359.GB16819@redhat.com>
In-Reply-To: <20120910060359.GB16819@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/09/2012 08:03, Michael S. Tsirkin ha scritto:
> On Mon, Sep 10, 2012 at 07:50:13AM +0200, Paolo Bonzini wrote:
>> Il 09/09/2012 00:22, Michael S. Tsirkin ha scritto:
>>>> Almost.  One is "the guest, if really needed, can tell the host of
>>>> pages".  If not negotiated, and the host does not support it, the host
>>>> must break the guest (e.g. fail to offer any virtqueues).
>>>
>>> There is no way in spec to break the guest.
>>> You can not fail to offer virtqueues.
>>
>> You can always return 0 for the first queue.
> 
> I don't think guest drivers recover gracefully from this.
> Do they?

No, that's the point ("break the guest" is really "break the driver").

>>> Besides, there is no guarantee that virtqueue setup
>>> happens after feature negotiation.
>>
>> It is the only way that makes sense though (unless the guest would write
>> 0 for its features).  Should we change that?
> 
> I do think it would be nice to add a generic way for device to
> notify guest about an internal failure.
> This can only happen after DRIVER_OK status is written though,
> and since existing drivers do not expect such failure, it might
> be too late.

Agreed.

>>>> The other is "the guest, though, would prefer not to do so".  It is
>>>> different because the guest can proceed in a fallback mode even if the
>>>> host doesn't offer it.
>>>
>>> I think I get what your proposed SILENT means what I do not get
>>> is the motivation. It looks like a premature optimization to me.
>>
>> The motivation is to let the driver choose between two behaviors: the
>> current one where ballooning is only done on request, and a more
>> aggressive one.
> 
> Yes but why is being silent any good? Optimization?
> Any data to show that it will help some workload?

Idle guests can move cache pages to the balloon.  You can overcommit
more aggressively, because the host can madvise away a lot more memory.

>>> OK so TELL says *when* to notify host, SILENT if set allows guest
>>> to skip leak notifications? In this case TELL should just be ignored
>>> when SILENT is set.
>>
>> Yeah, that was my first idea.  However, there are existing drivers that
>> ignore SILENT, so that would not be 100% exact.
> 
> Not sure I follow the logic.
> They don't ack SILENT so that would be 100% exact.

Hmm, then I'm not sure I follow yours.  We agreed that delaying
notifications or skipping them is really the same thing, right?

I think we're just stuck in a linguistic problem, with "must not" being
wrong and "does not have to" being too verbose.  Calling it
VIRTIO_BALLOON_F_SILENT_DEFLATE was a workaround for this, but perhaps
it adds more confusion.

Paolo
