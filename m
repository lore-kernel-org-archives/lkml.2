Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1GKUlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:41:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab1GKUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:41:54 -0400
Date: Mon, 11 Jul 2011 13:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: page->_count build failure [was: mmotm 2011-07-08-12-50
 uploaded]
Message-Id: <20110711134121.54557e28.akpm@linux-foundation.org>
In-Reply-To: <4E1B5CAA.7070001@gmail.com>
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
	<4E1B5CAA.7070001@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 22:27:22 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 07/08/2011 09:50 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2011-07-08-12-50 has been uploaded to
> 
> Hi, am I the only one encountering a build failure due to double
> definition of _count in page struct introduced by:
> commit fc9bb8c768abe7ae10861c3510e01a95f98d5933
> Author: Christoph Lameter <cl@linux.com>
> Date:   Wed Jun 1 12:25:48 2011 -0500
> 
>     mm: Rearrange struct page
> 
> in the -next tree?
> 
> $ make
> ...
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/linux/sched.h:64:0,
>                  from arch/x86/kernel/asm-offsets.c:9:
> include/linux/mm_types.h:74:15: error: duplicate member ____count___
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> $ gcc --version
> gcc (SUSE Linux) 4.6.0 20110607 [gcc-4_6-branch revision 174741]
> 

Oh dear.  Yes, I would call that an error.  Afacit the two `_count's
end up at the same offset in the page struct.  Perhaps that makes it
legal and your compiler got it wrong.  Or perhaps it is illegal and all
other compilers got it wrong.

Still, we should fix it.  It's daft to have two distinct page->_count's.

To fix it, we could rename one of them.  Which means that we're going
to need to work out which references to page->_count are referring to
which field.  Which demonstrates the problem!


hmm, let's jiggle the offset:

--- a/include/linux/mm_types.h~a
+++ a/include/linux/mm_types.h
@@ -71,6 +71,7 @@ struct page {
 					 * Kernel may make use of this field even when slub
 					 * uses the rest of the double word!
 					 */
+					int foo;
 					atomic_t _count;
 				};
 			};
_

nope, it still compiles OK.  It has to be gcc bustification I think. 
Fixed in gcc-4.6.0.

