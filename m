Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1G0WQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1G0WQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:16:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dan Ehrenberg <dehrenberg@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
	<20110727210828.GB12714@infradead.org>
	<20110727141415.a67cafb8.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 27 Jul 2011 18:15:53 -0400
In-Reply-To: <20110727141415.a67cafb8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 27 Jul 2011 14:14:15 -0700")
Message-ID: <x49vcuns73a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 27 Jul 2011 17:08:28 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Mon, Jun 20, 2011 at 04:17:35PM -0700, Dan Ehrenberg wrote:
>> > The fast path does not apply for operations of the wrong size
>> > or alignmnent, or for operations on raw drives with 512-byte sectors.
>> > It might be possible to make this special case a little more general
>> > while maintaining its performance benefits, but I do not believe that
>> > the full performance benefits can be achieved without resorting to
>> > special handling of simple cases, as is done in this patch.
>> 
>> Did you check how this compares to Andis small optimizations?
>> 
>> Also operations on raw disks are something people with fast devices
>> care about a lot.  We often hear about benchmark regressions due to
>> stupid little things in the direct I/O code.
>> 
>> If we want to special case something that would be a very easy target,
>> with a 1:1 mapping of logical to physical blocks and thus no need
>> to call the allocator first, and no need for any kind of locking
>> or alignment handling.
>
> Ken did this back in 2006
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e61c90188b9956edae1105eef361d8981a352fcd)
> but we reverted that shortly afterwards for some reason.

For this reason:

commit b2e895dbd80c420bfc0937c3729b4afe073b3848
Author: Andrew Morton <akpm@osdl.org>
Date:   Sat Feb 3 01:14:01 2007 -0800

    [PATCH] revert blockdev direct io back to 2.6.19 version
    
    Andrew Vasquez is reporting as-iosched oopses and a 65% throughput
    slowdown due to the recent special-casing of direct-io against
    blockdevs.  We don't know why either of these things are occurring.
    
    The patch minimally reverts us back to the 2.6.19 code for a 2.6.20
    release.
