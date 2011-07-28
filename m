Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1G1J1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:27:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60086 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1G1J1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:27:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=HK6HEaixQz5ZyZc4lYy5meDkWR8KN7XaMcXk23J5/YMQeJZkwROMVCO8FWlpP0WOn
	ie6vc03FItfn2aLXHQ4+A==
Date: Thu, 28 Jul 2011 02:26:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tmpfs radix_tree: locate_item to speed up swapoff
In-Reply-To: <alpine.LSU.2.00.1107271801450.9888@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107280159480.4995@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils> <alpine.LSU.2.00.1107191553040.1593@sister.anvils> <20110727162819.b595e442.akpm@linux-foundation.org> <alpine.LSU.2.00.1107271801450.9888@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Hugh Dickins wrote:
> On Wed, 27 Jul 2011, Andrew Morton wrote:
> > On Tue, 19 Jul 2011 15:54:23 -0700 (PDT)
> > Hugh Dickins <hughd@google.com> wrote:
> > 
> > > But it was a shock to find swapoff of a 500MB file 20 times slower
> > > on my laptop, taking 10 minutes; and at that rate it significantly
> > > slows down my testing.
> > 
> > So it used to take half a minute?  That was already awful.
> > Why?  Was it IO-bound?  It doesn't sound like it.
> 
> No, not IO-bound at all.

I oversimplified: about 10 seconds of that was waiting for IO,
the rest (of 10 minutes or of half a minute) was cpu.  It's the cpu
part of it which the change of radix tree has affected, for the worse.

> > How much did that 10 minutes improve?
> 
> To 1 minute: still twice as slow as before.  I believe that's because of
> the smaller nodes and greater height of the generic radix tree.  I ought
> to experiment with a bigger RADIX_TREE_MAP_SHIFT to verify that belief
> (though I don't think tmpfs swapoff would justify raising it): will do.

Yes, raising RADIX_TREE_MAP_SHIFT from 6 to 10 (so on 32-bit the rnode
is just over 4kB, comparable with the old shmem's use of pages for this)
brings the time down considerably: still slower than before, but 12%
slower instead of twice as slow (or 20% slower instead of 3 times as
slow when comparing sys times).

Not that making a radix_tree_node need order:1 page would be sensible.

Hugh
