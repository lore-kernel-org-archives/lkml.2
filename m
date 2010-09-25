Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0IYSNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:13:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab0IYSNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:13:07 -0400
Date: Sat, 25 Sep 2010 19:13:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: rth@twiddle.net
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100925181304.GV19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	What happens if we get to RESTORE_ALL with interrupts enabled,
find that we want to restore HAE, get to
        stq     $21, HAE_CACHE($19);    \
and get hit by an interrupt right after that assignment?  Note that
*alpha_mv->hae_register is still not updated, but alpha_mv->hae_cache
already is, so if the interrupt calls set_hae() it would get seriously
confused if the value it wants is equal to the value we've put into
->hae_cache.

	Until ~2002 it used to have a couple of swpipl around these
assignments and __set_hae() is still doing those.  I agree that on
many exits we *will* have interrupts disabled when we get to RESTORE_ALL,
but not on all of them.  E.g. any interrupt taken in kernel mode will
happily go to restore_all without bothering with swpipl at all.

	AFAICS, it looks like a race; the change in question had been
introduced in "Update Alpha UP for thread_info and scheduler changes"
(Feb 10 2002, commit 374eeee8a8a50e12278dfa37021df7b6efe506c3 in historical
git tree).

	Comments?
