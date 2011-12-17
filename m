Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1LQRte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 12:49:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37905 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1LQRtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 12:49:31 -0500
Date: Sat, 17 Dec 2011 20:49:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20111217174923.GA4650@p183.telecom.by>
References: <20111216163928.030494ce1beb330e4e8b7b40@canb.auug.org.au>
 <20111216140039.c279e8d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216140039.c279e8d7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 02:00:39PM -0800, Andrew Morton wrote:
> On Fri, 16 Dec 2011 16:39:28 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_flash_release':
> > arch/powerpc/kernel/rtas_flash.c:218:16: error: 'struct proc_dir_entry' has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_excl_open':
> > arch/powerpc/kernel/rtas_flash.c:343:21: error: 'struct proc_dir_entry' has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c:348:16: error: 'struct proc_dir_entry' has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_excl_release':
> > arch/powerpc/kernel/rtas_flash.c:358:16: error: 'struct proc_dir_entry' has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'validate_flash_release':
> > arch/powerpc/kernel/rtas_flash.c:541:16: error: 'struct proc_dir_entry' has no member named 'count'
> > 
> > Caused by commit aef714db6205 ("core kernel: add refcount type and
> > refcount misuse debugging").
> > 
> > This would also break in drivers/nubus/proc.c
> > 
> > I have reverted that commit for today.
> 
> Thanks.  The plan apepars to be to make `struct kref' usable in this
> situation so I'll drop these patches.

If krefs would lose barriers, we might as well remove struct kref altogether.
Besides questionable mandatory passing of destructor to every kref_put(),
it is syntax sugar.

Non-atomic _refcnt_t do not fit into krefs regardless.

Now, rtas_flash.c. What this code simply doesn't work:
->count can be temporarily increased by simply issuing readdir().
