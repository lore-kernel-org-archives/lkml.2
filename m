Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2CWK3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:29:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55028 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2CWK3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:29:51 -0400
Date: Fri, 23 Mar 2012 03:29:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: Tree for Mar 23: doubled patch in vmscan.c
In-Reply-To: <20120323172333.9af9b678fcde0e6e75b5f6dd@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.1203230303260.31362@eggly.anvils>
References: <20120323172333.9af9b678fcde0e6e75b5f6dd@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Stephen Rothwell wrote:
> 
> Changes since 20120322:
> 
> The akpm tree lost lots of patches that turned up elsewhere (mostly in
> Linus' tree).

I'm amused to notice that your merging process is as impatient as akpm,
and just cannot wait for Mel to remove lumpy reclaim from mm/vmscan.c.

It has chosen to do so itself, by duplicating Konstantin's "mm: forbid
lumpy-reclaim in shrink_active_list()" (we had expected that to be held
back, but it's gone in anyway, oh well) into shrink_inactive_list(),
overriding the set_reclaim_mode() a few lines above with a spurious
reset_reclaim_mode(sc).

I expect that will sort itself out automatically once you get an update
from akpm, but something to beware of meanwhile (probably just a matter
of deleting Konstantin's patch from your trove now it's in Linus's tree).

Corrective patch below for illustration, but would need to be applied
with care: I wouldn't be surprised if it chose to do exactly the wrong
thing when applied automatically.

Hugh

--- linux-next/mm/vmscan.c.orig	2012-03-23 01:29:33.312011679 -0700
+++ linux-next/mm/vmscan.c	2012-03-23 03:00:08.688142469 -0700
@@ -1528,8 +1528,6 @@ shrink_inactive_list(unsigned long nr_to
 
 	lru_add_drain();
 
-	reset_reclaim_mode(sc);
-
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
