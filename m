Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0KBWgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:36:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:32833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0KBWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:36:04 -0400
Date: Tue, 2 Nov 2010 23:36:02 +0100
From: David Sterba <dsterba@suse.cz>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com
Subject: fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-ID: <20101102223601.GA27513@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
in fs/ocfs2/dlm/dlmdomain.c an allocation with GFP_KERNEL is done
with locks held:

dlm_query_region_handler
  spin_lock(dlm_domain_lock)
    dlm_match_regions
      kmalloc(GFP_KERNEL)

Change it to GFP_ATOMIC.

Signed-off-by: David Sterba <dsterba@suse.cz>
CC: Joel Becker <joel.becker@oracle.com>
CC: Mark Fasheh <mfasheh@suse.com>
CC: ocfs2-devel@oss.oracle.com

--
Exists in v2.6.37-rc1 and current linux-next.

diff -u -p a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c 2010-10-22 10:23:23.502434402 +0200
+++ b/fs/ocfs2/dlm/dlmdomain.c 2010-11-02 17:11:06.000000000 +0100
@@ -959,7 +959,7 @@ static int dlm_match_regions(struct dlm_
                r += O2HB_MAX_REGION_NAME_LEN;
        }

-       local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
+       local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
        if (!local) {
                status = -ENOMEM;
                goto bail;

