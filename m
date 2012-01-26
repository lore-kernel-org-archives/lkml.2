Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2AZWqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:46:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41522 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2AZWqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:46:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1201261133230.1369@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org> <alpine.LSU.2.00.1201261133230.1369@eggly.anvils>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 26 Jan 2012 14:45:58 -0800
X-Google-Sender-Auth: Z-prXgB-pZj26xBThmZho5FBzs8
Message-ID: <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages() parameters
To: Hugh Dickins <hughd@google.com>
Cc: linux-rdma@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Thanks for the thoughtful answer...

> I think this is largely about the ZERO_PAGE.  If you do a read fault
> on an untouched anonymous area, it maps in the ZERO_PAGE, and will
> only give you your own private zeroed page when there's a write fault
> to touch it.
>
> I think your ib_umem_get() is making sure to give the process its own
> private zeroed page: if the area is PROT_READ, MAP_PRIVATE, userspace
> will not be wanting to write into it, but presumably it expects to see
> data placed in that page by the underlying driver, and it would be very
> bad news if the driver wrote its data into the ZERO_PAGE.

I think we are actually OK.  If umem->writable == 0, that is actually
a promise by the driver/HW that they are not going to write to this
memory.  Mapping ZERO_PAGE to the hardware is fine in this case,
since the hardware will just read zeroes exactly as it should.

One question is whether we're OK if userspace maps some
anonymous memory with PROT_WRITE but doesn't touch it,
and then tries to map it to the hardware read-only.  In that case
we hit get_user_pages() with write == 0.  If I understand the code
correctly, we end up mapping ZERO_PAGE in do_anonymous_page().

But then if userspace writes to this anonymous memory, a COW
will be triggered and the hardware will be left holding a different
page than the one that is mapped into userspace (ie the device
won't read what userspace writes).  Kind of the inverse of the
problem I hit.

I don't have a good understanding of what force == 1 means -- I
guess the question is what happens if userspace tells us to
write to a read-only mapping that userspace could have mapped
writable?

> And although the ZERO_PAGE gives the most vivid example, I think it goes
> beyond that to the wider issue of pages COWed after fork() - GUPping in
> this way fixes the easy cases (and I've no desire again to go down that
> rathole of fixing the most general cases).

For IB / RDMA we kind of explicitly give up on COW after fork().
But I guess I don't know what issue you're thinking of.  Is it
similar to what I described above?  In other words, we have
a readable mapping that we'll COW on a write fault, but the driver
is only following the mapping for reading and so a COW will
mess us up.

Sigh, what a mess ... it seems what we really want to do is know
if userspace might trigger a COW because or not, and only do a
preemptive COW in that case.  (We're not really concerned with
userspace fork()ing and setting up a COW in the future, since that's
what we have MADV_DONTFORK for)

The status quo works for userspace anonymous mappings but
it doesn't work for my case of mapping a kernel buffer read-only
into userspace.  And fixing my case breaks the anonymous case.
Do you see a way out of this dilemma?  Do we need to add yet
another flag to get_user_pages()?

Thanks!
  Roland
