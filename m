Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2JWV7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:59:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58333 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2JWV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:59:11 -0400
Date: Wed, 24 Oct 2012 01:59:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-ID: <20121023215907.GB24069@moon>
References: <5085B1A8.4020609@parallels.com>
 <20121022205641.GL2303@moon>
 <20121022213449.GH31440@moon>
 <20121022145158.53bddfc1.akpm@linux-foundation.org>
 <20121023061341.GA7020@moon>
 <20121022233025.09ec2d92.akpm@linux-foundation.org>
 <20121023063430.GB7020@moon>
 <20121023071549.GC7020@moon>
 <20121023143045.183657c4.akpm@linux-foundation.org>
 <20121023214639.GM7020@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023214639.GM7020@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:46:39AM +0400, Cyrill Gorcunov wrote:
> 
> > Also...  what happens if there's an unrecognised bit set in `flags'? 
> > Memory corruption or code skew could cause this.  We emit a couple of
> > NULs into the procfs output, which I guess is an OK response to such a
> > condition.
> 
> That's indeed will produce some nil character on the screen. I guess we
> need some designited init here, say
> 
> 	[0 ... (BITS_PER_LONG-1)] = { {'-', '-'} },
> 	...
> 	[ilog2(VM_READ)]	= { {'r', 'd'} },
> 	...
> 	and so on, i'll update on top
> 

Andrew, could you please fold it on top of your
procfs-add-vmflags-field-in-smaps-output-v3-fix ?

(If this is inconvenient -- just give me a word and I'll
 squash everything in one new patch instead).
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-on-top

Use designated init to assign "??" mnemonic on unknown flags.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/task_mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -488,6 +488,11 @@ static void show_smap_vma_flags(struct s
 	static const struct {
 		const char l[2];
 	} mnemonics[BITS_PER_LONG] = {
+		/*
+		 * In case if we meet a flag we don't know about.
+		 */
+		[0 ... (BITS_PER_LONG-1)] = { {'?', '?'} },
+
 		[ilog2(VM_READ)]	= { {'r', 'd'} },
 		[ilog2(VM_WRITE)]	= { {'w', 'r'} },
 		[ilog2(VM_EXEC)]	= { {'e', 'x'} },
