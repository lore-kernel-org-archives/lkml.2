Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1HVN4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:56:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52958 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1HVN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:56:07 -0400
Date: Mon, 22 Aug 2011 14:56:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency detected
 3.1.0-rc2-00190-g3210d19
Message-ID: <20110822135604.GU2203@ZenIV.linux.org.uk>
References: <4E51CFD8.2090508@gmail.com>
 <CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
 <20110822131621.GS2203@ZenIV.linux.org.uk>
 <20110822132713.GT2203@ZenIV.linux.org.uk>
 <CA+5PVA5NE1Om9SK-UoA-RBH56RP-MLrNdiMVAVQx8LFaBdxaYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5NE1Om9SK-UoA-RBH56RP-MLrNdiMVAVQx8LFaBdxaYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:33:34AM -0400, Josh Boyer wrote:

> So the lockdep report in the RHBZ (which now that I look at it
> probably isn't the same as this report) seems to be doing a readdir
> while find is trying to mmap, which is calling into
> hugetlbfs_file_mmap and throwing the same deadlock warning.  Is that
> like the scenario you are describing above?

Lockdep records the first trace that leads to locks taken in this
order.  readdir() seems to be the first thing to step on i_mutex
and mmap_sem (not too surprisingly, come to think of that - directory
reads happening earlier in the boot than regular file writes).

So when it reports i_mutex taken under mmap_sem, readdir gets mentioned
by lockdep.  Often leading to comments along the lines of "but this
inode is not a directory at all; shouldn't we relax the rules for
non-directories?"  Nope; the same ordering very much applies to regular
files.  With s/readdir/write/.

The bottom line is: don't take i_mutex while holding mmap_sem.  Really.
