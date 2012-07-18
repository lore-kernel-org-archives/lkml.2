Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2GRI0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:26:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34582 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2GRI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <50067009.9030508@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
	<CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
	<50052276.2080906@redhat.com>
	<500527BA.9000001@redhat.com>
	<50052E7E.6020100@redhat.com>
	<CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
	<50067009.9030508@redhat.com>
Date: Wed, 18 Jul 2012 09:26:02 +0100
Message-ID: <CAJSP0QXYgrAtmc=A28h2KyZjWaPKjz2jiXkwProZ9O3DnepM1Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 9:12 AM, Asias He <asias@redhat.com> wrote:
> On 07/17/2012 07:11 PM, Stefan Hajnoczi wrote:
>>
>> On Tue, Jul 17, 2012 at 10:21 AM, Asias He <asias@redhat.com> wrote:
>>>
>>> On 07/17/2012 04:52 PM, Paolo Bonzini wrote:
>>>>
>>>>
>>>> Il 17/07/2012 10:29, Asias He ha scritto:
>>>>>
>>>>>
>>>>> So, vhost-blk at least saves ~6 syscalls for us in each request.
>>>>
>>>>
>>>>
>>>> Are they really 6?  If I/O is coalesced by a factor of 3, for example
>>>> (i.e. each exit processes 3 requests), it's really 2 syscalls per
>>>> request.
>>>
>>>
>>>
>>> Well. I am counting the number of syscalls in one notify and response
>>> process. Sure the IO can be coalesced.
>>
>>
>> Linux AIO also supports batching in io_submit() and io_getevents().
>> Depending on the request pattern in the vring when you process it, you
>> should be able to do better than 1 set of syscalls per host I/O
>> request.
>>
>> Are you taking advantage of that at the moment in your userspace
>> benchmark?
>
>
> OK. I know that batching in io_submit() and io_getevetns(). There was a
> patch for kvm tool long time ago. Now, both vhost-blk and kvm tool are not
> taking advantage of that atm. There are issues: e.g. How many number of
> request we want to batch? Does this batching hurt latency?

I didn't mean introducing a delay so that multiple requests can be batched.

I was just thinking of the simple case: when there are a lot of
parallel requests the chance increases that a single vring interrupt
provides several I/O requests.  In that case it's easy for the
virtio-blk implementation to issue them all in one io_submit(2) call.
The same is true for io_getevents(2), there might be several completed
host I/O requests.

The reason I mentioned this was because the actual syscall pattern per
request might not require 1 io_submit(2)/io_getevents(2) if you are
processing a lot of requests in parallel.  The only way to know why
kvmtool is slower is by profiling...

Stefan
