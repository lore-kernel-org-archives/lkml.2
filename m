Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1AMPou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:44:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756285Ab1AMPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:44:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110113125308.GJ14750@redhat.com>
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
 <4D2C21FE.3000406@redhat.com> <4D2E1010.4080706@redhat.com>
 <AANLkTimLJnV9oJwnaN+jdvNus4cxuqvgUqHUwi7vpqBe@mail.gmail.com> <20110113125308.GJ14750@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 07:43:55 -0800
Message-ID: <AANLkTimi9ZfO+8rGuBSKdSiXSZmQfvs8eceYRgdpdO6s@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
To: Gleb Natapov <gleb@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 4:53 AM, Gleb Natapov <gleb@redhat.com> wrote:
>
> I implemented get_user_pages_nowait() on top of your patch. In my testing
> it works as expected when used inside KVM. Does this looks OK to you?

It looks reasonable, although I suspect the subtle behavior wrt the
mmap_sem means that you should not expose the magic bare
FAULT_FLAG_ALLOW_RETRY flag to the __get_user_pages() thing. It's just
too easy to introduce bugs, methinks.

So I'd suggest

 - drop FOLL_RETRY

 -  make FOLL_NOWAIT set both (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_NOWAIT)

and that way the get_user_pages() thing will never release the
mmap_sem, and you never have any subtle locking issues for that
particular interface.

But some other VM person should look at it too.

                                 Linus
