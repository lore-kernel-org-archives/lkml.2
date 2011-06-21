Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1FUVoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 17:44:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60071 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1FUVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 17:44:16 -0400
Date: Tue, 21 Jun 2011 23:44:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
Message-ID: <20110621214413.GB3263@one.firstfloor.org>
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com> <m2oc1q3okc.fsf@firstfloor.org> <BANLkTi=GeY+6ZTKkYidFd+J=T7ER1+Lk6kv+uJe6GA6v1HrVaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=GeY+6ZTKkYidFd+J=T7ER1+Lk6kv+uJe6GA6v1HrVaQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 02:21:48PM -0700, Daniel Ehrenberg wrote:
> On Tue, Jun 21, 2011 at 1:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Dan Ehrenberg <dehrenberg@google.com> writes:
> >
> >> This code introduces a fast-path variant of __blockdev_direct_IO
> >> for the special case where the request size is a multiple of the page
> >> size, the inode block size is a page, the user memory is page-aligned,
> >> the underlying storage is contiguous on disk and the file location is
> >> already initialized. The special case decreases the amount of
> >> bookkeeping required, which saves a significant amount of CPU time on
> >> a fast device such as a ramdisk or an SSD.  The patch is inspired by
> >> earlier code by Ken Chen.
> >
> > Is it understood why your fast path is that much faster?
> > i.e. what's the slow part in the normal path that it avoids?
> >
> > I am wondering if some of the improvements could be gotten even for less
> > rigid pre conditions.
> 
> I should start by saying that I really should've submitted this with
> an [RFC] tag. I'm eager for feedback on my first Linux kernel patch,
> and I'm really glad you responded.
> 
> The slowness in the dio code that I have observed is not in any
> particular place, but rather a death of a thousand cuts. Lines like
>         memset(dio, 0, offsetof(struct dio, pages));

Hmm, is it cache miss stalls or just core cycles? 

If the later I assume gcc generated an slow out of line call
for memset.  I guess that would be fixable.

If the former maybe need a strategic prefetch?

Possibly a slab constructor would also help and avoid some of the 
reinitialization costs (this would requirement a fixed size
limit for the fast path, but I guess that's reasonable)

> show up as significant in the CPU profile, but so do other random
> lines that manipulate the struct dio.

That would suggest cache misses?

So why does your version avoid those?

> You're right that these preconditions are rather rigid, though. If you
> have a suggestion for a more general precondition, I can try it out
> and see if it maintains the performance properties I want.

Not fully sure, but I would be interested in support for 512 byte sectors
at least.

-Andi
