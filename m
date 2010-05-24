Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab0EXXLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:11:05 -0400
Received: from kroah.org ([198.145.64.141]:36534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059Ab0EXXJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:39 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:52 2010
Message-Id: <20100524230352.012983722@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:00:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kees Cook <kees.cook@canonical.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [30/34] mmap_min_addr check CAP_SYS_RAWIO only for write
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit 4ae69e6b718589abe97c9625ccbb1e0bc95a8c0e upstream.

Redirecting directly to lsm, here's the patch discussed on lkml:
http://lkml.org/lkml/2010/4/22/219

The mmap_min_addr value is useful information for an admin to see without
being root ("is my system vulnerable to kernel NULL pointer attacks?") and
its setting is trivially easy for an attacker to determine by calling
mmap() in PAGE_SIZE increments starting at 0, so trying to keep it private
has no value.

Only require CAP_SYS_RAWIO if changing the value, not reading it.

Comment from Serge :

  Me, I like to write my passwords with light blue pen on dark blue
  paper, pasted on my window - if you're going to get my password, you're
  gonna get a headache.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
(cherry picked from commit 822cceec7248013821d655545ea45d1c6a9d15b3)
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -33,7 +33,7 @@ int mmap_min_addr_handler(struct ctl_table *table, int write,
 {
 	int ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (write && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);


