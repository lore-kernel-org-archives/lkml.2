Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1INInA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:43:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53025 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab1INIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:42:59 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
In-Reply-To: <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
	 <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
	 <1315983230.2565.28.camel@edumazet-laptop>
	 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
	 <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 10:43:03 +0200
Message-ID: <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 16:20 +0800, Shaohua Li a écrit :
> 2011/9/14 Shaohua Li <shli@kernel.org>:
> > it appears we didn't account skipped swap entry in find_get_pages().
> > does the attached patch help?
> I can easily reproduce the issue. Just cp files in tmpfs, trigger swap and
> drop caches. The debug patch fixes it at my side.
> Eric, please try it.
> 

Hello Shaohua

I tried it with added traces :


[  277.077855] mv used greatest stack depth: 3336 bytes left
[  310.558012] nr_found=2 nr_skip=2
[  310.558139] nr_found=14 nr_skip=14
[  332.195162] nr_found=2 nr_skip=2
[  332.195274] nr_found=14 nr_skip=14
[  352.315273] nr_found=14 nr_skip=14
[  372.673575] nr_found=14 nr_skip=14
[  397.115463] nr_found=14 nr_skip=14
[  403.391694] cc1 used greatest stack depth: 3184 bytes left
[  404.761194] cc1 used greatest stack depth: 2640 bytes left
[  417.306510] nr_found=14 nr_skip=14
[  440.198051] nr_found=14 nr_skip=14

I also used :

-	if (unlikely(!ret && nr_found))
+	if (unlikely(!ret && nr_found > nr_skip))
 		goto restart;

It seems to fix the bug. I suspect it also aborts
invalidate_mapping_pages() if we skip 14 pages, but existing comment
states its OK :

        /*
         * Note: this function may get called on a shmem/tmpfs mapping:
         * pagevec_lookup() might then return 0 prematurely (because it
         * got a gangful of swap entries); but it's hardly worth worrying
         * about - it can rarely have anything to free from such a mapping
         * (most pages are dirty), and already skips over any difficulties.
         */
 
Thanks !


