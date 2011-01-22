Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AVUkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:40:36 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24810 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1AVUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:40:35 -0500
Date: Sat, 22 Jan 2011 21:41:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Lasse Collin <lasse.collin@tukaani.org>
cc: linux-kernel@vger.kernel.org
Subject: Possible array overrun in lzma_reset()
Message-ID: <alpine.LNX.2.00.1101222124360.7746@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Covery prevent checker noticed that there's a buffer overrun in 
lib/xz/xz_dec_lzma2.c::lzma_reset() :

...
778  		/*
779  		 * All probabilities are initialized to the same value. This hack
780  		 * makes the code smaller by avoiding a separate loop for each
781  		 * probability array.
782  		 *
783  		 * This could be optimized so that only that part of literal
784  		 * probabilities that are actually required. In the common case
785  		 * we would write 12 KiB less.
786  		 */
Event ptr_assign: Pointer "probs" is assigned the address of a static array pointer "&s->lzma.is_match[0]" of size 32 bytes.
787  		probs = s->lzma.is_match[0];
At conditional (1): "i < 14134UL" taking true path
At conditional (2): "i < 14134UL" taking true path
At conditional (3): "i < 14134UL" taking true path
788  		for (i = 0; i < PROBS_TOTAL; ++i)
Event overrun-local: Overrunning static array of size 32 bytes at byte position 28266 by indexing pointer "probs" with index variable "i".
Event overrun-local: Note: These bugs are often difficult to see at first glance. Coverity recommends a close inspection of the events leading to this overrun.
789  			probs[i] = RC_BIT_MODEL_TOTAL / 2;
...

I looked into the report and found that 's->lzma.is_match' is
	uint16_t is_match[STATES][POS_STATES_MAX]
where 'STATES' is '#define STATES 12' and 'POS_STATES_MAX' is '#define POS_STATES_MAX (1 << 4)'.

So I think the checker has a point. However, I'm not familiar enough with 
this code to know what the proper fix is, so I just thought I'd report it 
to the proper people.

Happy bug fixing :-)


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

