Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2FZXWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:22:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37113 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2FZXWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120626214709.GA15406@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
	<4FEA1E2E.4020806@redhat.com>
	<CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com>
	<20120626214709.GA15406@redhat.com>
Date: Tue, 26 Jun 2012 16:21:58 -0700
Message-ID: <CAK+C7kUN-kYVK9AnEhcof98p+eZN1dkt9qVyYppETOeS2n3CMQ@mail.gmail.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
From: Frank Swiderski <fes@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>, Rafael Aquini <aquini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 2:47 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Jun 26, 2012 at 02:31:26PM -0700, Frank Swiderski wrote:
>> On Tue, Jun 26, 2012 at 1:40 PM, Rik van Riel <riel@redhat.com> wrote:
>> > On 06/26/2012 04:32 PM, Frank Swiderski wrote:
>> >>
>> >> This implementation of a virtio balloon driver uses the page cache to
>> >> "store" pages that have been released to the host.  The communication
>> >> (outside of target counts) is one way--the guest notifies the host when
>> >> it adds a page to the page cache, allowing the host to madvise(2) with
>> >> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
>> >> (via the regular page reclaim).  This means that inflating the balloon
>> >> is similar to the existing balloon mechanism, but the deflate is
>> >> different--it re-uses existing Linux kernel functionality to
>> >> automatically reclaim.
>> >>
>> >> Signed-off-by: Frank Swiderski<fes@google.com>
>> >
>> >
>> > It is a great idea, but how can this memory balancing
>> > possibly work if someone uses memory cgroups inside a
>> > guest?
>>
>> Thanks and good point--this isn't something that I considered in the
>> implementation.
>>
>> > Having said that, we currently do not have proper
>> > memory reclaim balancing between cgroups at all, so
>> > requiring that of this balloon driver would be
>> > unreasonable.
>> >
>> > The code looks good to me, my only worry is the
>> > code duplication. We now have 5 balloon drivers,
>> > for 4 hypervisors, all implementing everything
>> > from scratch...
>>
>> Do you have any recommendations on this?  I could (I think reasonably
>> so) modify the existing virtio_balloon.c and have it change behavior
>> based on a feature bit or other configuration.  I'm not sure that
>> really addresses the root of what you're pointing out--it's still
>> adding a different implementation, but doing so as an extension of an
>> existing one.
>>
>> fes
>
> Let's assume it's a feature bit: how would you
> formulate what the feature does *from host point of view*?
>
> --
> MST

In this implementation, the host doesn't keep track of pages in the
balloon, as there is no explicit deflate path.  The host device for
this implementation should merely, for example, MADV_DONTNEED on the
pages sent in an inflate.  Thus, the inflate becomes a notification
that the guest doesn't need those pages mapped in, but that they
should be available if the guest touches them.  In that sense, it's
not a rigid shrink of guest memory.  I'm not sure what I'd call the
feature bit though.

Was that the question you were asking, or did I misread?

fes
