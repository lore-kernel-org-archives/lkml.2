Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943Ab2DLUFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:05:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:33503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622Ab2DLUFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131781377"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v2
Date: Thu, 12 Apr 2012 13:04:29 -0700
Message-Id: <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <20120412161805.133c4ad0@notabene.brown>
References: <20120412161805.133c4ad0@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:18:05PM +1000, NeilBrown wrote:
> On Wed, 11 Apr 2012 12:40:27 -0700 Jim Kukunas
> <james.t.kukunas@linux.intel.com> wrote:

<snip> 

> Could I trouble you to run 'checkpatch.pl' and fix up some of the more
> reasonable complaints?
>
> ERROR: open brace '{' following function declarations go on the next line
> #243: FILE: lib/raid6/recov_ssse3.c:28:
> +     static const u8 __attribute__((aligned(16))) x0f[16] = {
>
> is clearly bogus, but
>
> WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
> #243: FILE: lib/raid6/recov_ssse3.c:28:
> +     static const u8 __attribute__((aligned(16))) x0f[16] = {
>
> is probably worth considering, as are some others.

Hi Neil,

Thanks for taking a look at this revision.

Before I submitted these patches, I actually had run checkpatch. I've included
my thought process below, along with the corresponding snippets of the
checkpatch output.

> WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
> #50: FILE: include/linux/raid/pq.h:126:
> +extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));

This keeps with the existing code conventions. The code block is:

extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));

> WARNING: printk() should include KERN_ facility level
> #120: FILE: lib/raid6/algos.c:103:
> +		printk("raid6: using %s recovery algorith\n", nest->name);
> 
> WARNING: printk() should include KERN_ facility level
> #122: FILE: lib/raid6/algos.c:105:
> +		printk("raid6: Yikes! No recovery algorithm found!\n");
> 
> WARNING: printk() should include KERN_ facility level
> #159: FILE: lib/raid6/algos.c:176:
> +		printk("raid6: Yikes!  No memory available.\n");

Again, these are following the conventions of the existing code such as:

printk("raid6: using algorithm %s (%ld MB/s)\n",

In fact, the last printk, about no memory available, was simply moved to a 
different line in my patch.

> ERROR: open brace '{' following function declarations go on the next line
> #423: FILE: lib/raid6/recov_ssse3.c:201:
> +	static const u8 __attribute__((aligned(16))) x0f[16] = {
> 
> ERROR: open brace '{' following function declarations go on the next line
> #250: FILE: lib/raid6/recov_ssse3.c:28:
> +	static const u8 __attribute__((aligned(16))) x0f[16] = {

As you pointed out, these are both bogus.

> WARNING: suspect code indent for conditional statements (8, 8)
> #291: FILE: lib/raid6/recov_ssse3.c:69:
> +	while (bytes) {
> [...]
> +	/* xmm6, xmm14, xmm15 */

This one slipped through the cracks. I've corrected it in the attached patches.

> WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
> #423: FILE: lib/raid6/recov_ssse3.c:201:
> +	static const u8 __attribute__((aligned(16))) x0f[16] = {
> 
> WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
> #250: FILE: lib/raid6/recov_ssse3.c:28:
> +	static const u8 __attribute__((aligned(16))) x0f[16] = {

There were two reasons why I didn't use __aligned. The first being the
existing code conventions:

const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));

and also, by using __attribute__((aligned(size))), there isn't a need to add

#ifndef __KERNEL__
#define __aligned(x) __attribute__((aligned(x)))
#endif

to x86.h for the test program.

That being said, I've changed these two in the attached patches.

> ERROR: need consistent spacing around '+' (ctx:VxW)
> #88: FILE: lib/raid6/x86.h:43:
> +#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
> 
> ERROR: need consistent spacing around '+' (ctx:VxW)
> #89: FILE: lib/raid6/x86.h:44:
> +#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
                          	     ^
These defines are plucked from arch/x86/include/asm/cpufeature.h.

In an perfect world, we'd just include that header, but it isn't visible from
userspace, so instead we copy the values.

Thus, to me, it makes sense to me to keep the symmetry here, but I can change
this if you want.

>
> NeilBrown
>

Thanks again.

--
Jim Kukunas
Intel Open Source Technology Center


