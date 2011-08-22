Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1HVPYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:24:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45708 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1HVPYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110822135604.GU2203@ZenIV.linux.org.uk>
References: <4E51CFD8.2090508@gmail.com>
	<CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
	<20110822131621.GS2203@ZenIV.linux.org.uk>
	<20110822132713.GT2203@ZenIV.linux.org.uk>
	<CA+5PVA5NE1Om9SK-UoA-RBH56RP-MLrNdiMVAVQx8LFaBdxaYg@mail.gmail.com>
	<20110822135604.GU2203@ZenIV.linux.org.uk>
Date: Mon, 22 Aug 2011 11:24:44 -0400
Message-ID: <CA+5PVA65eUx36JMgbBoEKy9FwBzasBehc_OGqsThgns9=oGdLA@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19
From: Josh Boyer <jwboyer@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 9:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Aug 22, 2011 at 09:33:34AM -0400, Josh Boyer wrote:
>
>> So the lockdep report in the RHBZ (which now that I look at it
>> probably isn't the same as this report) seems to be doing a readdir
>> while find is trying to mmap, which is calling into
>> hugetlbfs_file_mmap and throwing the same deadlock warning.  Is that
>> like the scenario you are describing above?
>
> Lockdep records the first trace that leads to locks taken in this
> order.  readdir() seems to be the first thing to step on i_mutex
> and mmap_sem (not too surprisingly, come to think of that - directory
> reads happening earlier in the boot than regular file writes).
>
> So when it reports i_mutex taken under mmap_sem, readdir gets mentioned
> by lockdep.  Often leading to comments along the lines of "but this
> inode is not a directory at all; shouldn't we relax the rules for
> non-directories?"  Nope; the same ordering very much applies to regular
> files.  With s/readdir/write/.
>
> The bottom line is: don't take i_mutex while holding mmap_sem.  Really.

OK, thanks.

It seems this particular hugetlbfs issue was reported a while ago here:

https://lkml.org/lkml/2011/4/15/272

I'll go poke that thread a bit.  That just leaves the ext4 evict case,
which hopefully Ted can answer.

josh
