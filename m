Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab2AFRzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:55:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59989 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900Ab2AFRzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAGTjWtB3PjWDfaunXjF-KQwKYg-bPgrn-8N=8iwL0EPvviXMuw@mail.gmail.com>
References: <20120104225223.18184.1537.stgit@mike2.sea.corp.google.com>
 <20120104225237.18184.71853.stgit@mike2.sea.corp.google.com>
 <87y5tnat2g.fsf@rustcorp.com.au> <CAGTjWtB3PjWDfaunXjF-KQwKYg-bPgrn-8N=8iwL0EPvviXMuw@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 6 Jan 2012 09:54:46 -0800
Message-ID: <CAGTjWtBbLtm47kozBC2fdwGYKsOooQec0W9PwUEAF58mYDioaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/2] virtio_net: Don't disable napi on low memory.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 6:46 PM, Mike Waychison <mikew@google.com> wrote:
> On Wed, Jan 4, 2012 at 4:31 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> 4) You use the skb data for the linked list; use the skb head's list.

What did you mean by this?  I was under the impression that the ->next
and ->prev fields in sk_buff were the first two elements specifically
so that the pointer could be treated as a list_head.  If it's the cast
in particular that you have an objection with, I can easily change
this to a singly linked list threaded through ->next if that's
cleaner.

>>
>> Instead, here's how I think it should be done:
...
>
> This sounds reasonable to me.  I'll see what I can muster together this week.
>

So I started implementing it the way you were mentioning, and ran into
a problem with the original patchset.

Currently the "mergeable" and "big" receive buffers use a private page
free list (virtnet_info->pages) which has no synchronization itself.
This means that the batched version can't use get_a_page() and
give_pages() as is, which reduces the need to re-use the same alloc
halves that I've split.   Alternatives I can think of at this point:

- pass in a flag to the allocators like "bool is_serial" that is true
if we are serializing with napi, (which determines if we can much with
vi->pages)
or
- not use the same allocators for the "mergeable" and "big" paths.
The mergeable allocator in the non-serialized case reduces to
alloc_page(), while the big allocator looks like a copy and paste that
uses alloc_page instead of get_a_page().

Preferences?  I'll code one of the two up and see what it looks like.
