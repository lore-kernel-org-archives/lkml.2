Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab0EYVyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:54:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53327 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab0EYVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=qlspFEimB2Wx2EDuxhIZk05yVXlTIJ+1ur2WjQr+mj5cAlnsoKsCtCC84BhUCpxaZI
         RCRd3l+RmdgynvcgLvnpCIWC7eKhp/z01hwb/tIjkzi3xiPzSKlzsIipN99D3ERRuyA7
         mNm3KmV3k5yAxALTnnUY+rmMMuv53kiaiSWHc=
Date: Tue, 25 May 2010 23:54:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org
Subject: [patch] mempolicy: ERR_PTR dereference in mpol_shared_policy_init()
Message-ID: <20100525215401.GA2506@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lee Schermerhorn <lee.schermerhorn@hp.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code called mpol_put(new) while "new" was an ERR_PTR.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 7575101..5d6fb33 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2098,7 +2098,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 		/* contextualize the tmpfs mount point mempolicy */
 		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
 		if (IS_ERR(new))
-			goto put_free; /* no valid nodemask intersection */
+			goto free_scratch; /* no valid nodemask intersection */
 
 		task_lock(current);
 		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
@@ -2114,6 +2114,7 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 
 put_free:
 		mpol_put(new);			/* drop initial ref */
+free_scratch:
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
 }
