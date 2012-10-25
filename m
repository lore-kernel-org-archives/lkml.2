Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab2JYLOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181Ab2JYLOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:14:16 -0400
Date: Thu, 25 Oct 2012 07:14:11 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: shmem_getpage_gfp VM_BUG_ON triggered. [3.7rc2]
Message-ID: <20121025111411.GB24886@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20121025023738.GA27001@redhat.com>
 <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:36:27PM -0700, Hugh Dickins wrote:

 > > 1148                         error = shmem_add_to_page_cache(page, mapping, index,
 > > 1149                                                 gfp, swp_to_radix_entry(swap));
 > > 1150                         /* We already confirmed swap, and make no allocation */
 > > 1151                         VM_BUG_ON(error);
 > > 1152                 }
 > 
 > That's very surprising.  Easy enough to handle an error there, but
 > of course I made it a VM_BUG_ON because it violates my assumptions:
 > I rather need to understand how this can be, and I've no idea.
 > 
 > Clutching at straws, I expect this is entirely irrelevant, but:
 > there isn't a warning on line 1151 of mm/shmem.c in 3.7.0-rc2 nor
 > in current linux.git; rather, there's a VM_BUG_ON on line 1149.
 > 
 > So you've inserted a couple of lines for some reason (more useful
 > trinity behaviour, perhaps)? 

detritus from the recent mpol_to_str bug that I was chasing.
Shouldn't be relevant...

diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/mm>
--- src/git-trees/kernel/linux/mm/shmem.c       2012-10-12 10:01:46.613408580 ->
+++ linux-dj/mm/shmem.c 2012-10-15 12:31:32.979653309 -0400
@@ -885,13 +885,15 @@ redirty:
 static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
 {
        char buffer[64];
+       int ret;
 
        if (!mpol || mpol->mode == MPOL_DEFAULT)
                return;         /* show nothing */
 
-       mpol_to_str(buffer, sizeof(buffer), mpol, 1);
-
-       seq_printf(seq, ",mpol=%s", buffer);
+       memset(buffer, 0, sizeof(buffer));
+       ret = mpol_to_str(buffer, sizeof(buffer), mpol, 1);
+       if (ret > 0)
+               seq_printf(seq, ",mpol=%s", buffer);
 }


 > And have some config option I'm
 > unfamiliar with, that mutates a BUG_ON or VM_BUG_ON into a warning?

Yes, I do have this..

-#define VM_BUG_ON(cond) BUG_ON(cond)
+#define VM_BUG_ON(cond) WARN_ON(cond)

because I got tired of things not going over my usb serial port when I hit them
a while ago. BUG_ON is pretty unfriendly to bug finding.

	Dave

