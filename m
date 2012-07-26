Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2GZVVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2GZVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benny Halevy <bhalevy@tonian.com>, Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 17/23] ore: Remove support of partial IO request (NFS crash)
Date: Thu, 26 Jul 2012 14:19:56 -0700
Message-Id: <20120726211407.432822551@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 62b62ad873f2accad9222a4d7ffbe1e93f6714c1 upstream.

Do to OOM situations the ore might fail to allocate all resources
needed for IO of the full request. If some progress was possible
it would proceed with a partial/short request, for the sake of
forward progress.

Since this crashes NFS-core and exofs is just fine without it just
remove this contraption, and fail.

TODO:
	Support real forward progress with some reserved allocations
	of resources, such as mem pools and/or bio_sets

[Bug since 3.2 Kernel]
CC: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exofs/ore.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -735,13 +735,7 @@ static int _prepare_for_striping(struct
 out:
 	ios->numdevs = devs_in_group;
 	ios->pages_consumed = cur_pg;
-	if (unlikely(ret)) {
-		if (length == ios->length)
-			return ret;
-		else
-			ios->length -= length;
-	}
-	return 0;
+	return ret;
 }
 
 int ore_create(struct ore_io_state *ios)


