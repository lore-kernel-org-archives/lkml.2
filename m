Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1DZVTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:19:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:63359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab1DZVPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483806"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: ben@decadent.org.uk, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [92/106] kconfig: Avoid buffer underrun in choice input
Message-Id: <20110426211414.7CDAE3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Hutchings <ben@decadent.org.uk>

commit 3ba41621156681afcdbcd624e3191cbc65eb94f4 upstream.

Commit 40aee729b350 ('kconfig: fix default value for choice input')
fixed some cases where kconfig would select the wrong option from a
choice with a single valid option and thus enter an infinite loop.

However, this broke the test for user input of the form 'N?', because
when kconfig selects the single valid option the input is zero-length
and the test will read the byte before the input buffer.  If this
happens to contain '?' (as it will in a mips build on Debian unstable
today) then kconfig again enters an infinite loop.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/kconfig/conf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/scripts/kconfig/conf.c
===================================================================
--- linux-2.6.35.y.orig/scripts/kconfig/conf.c
+++ linux-2.6.35.y/scripts/kconfig/conf.c
@@ -330,7 +330,7 @@ static int conf_choice(struct menu *menu
 		}
 		if (!child)
 			continue;
-		if (line[strlen(line) - 1] == '?') {
+		if (line[0] && line[strlen(line) - 1] == '?') {
 			print_help(child);
 			continue;
 		}
