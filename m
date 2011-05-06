Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab1EFA1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:30 -0400
Received: from kroah.org ([198.145.64.141]:37522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab1EFA1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:08 2011
Message-Id: <20110506002608.360813887@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [11/43] kconfig: Avoid buffer underrun in choice input
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 scripts/kconfig/conf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -330,7 +330,7 @@ static int conf_choice(struct menu *menu
 		}
 		if (!child)
 			continue;
-		if (line[strlen(line) - 1] == '?') {
+		if (line[0] && line[strlen(line) - 1] == '?') {
 			print_help(child);
 			continue;
 		}


