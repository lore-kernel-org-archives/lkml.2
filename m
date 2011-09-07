Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1IGR76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:59:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1IGR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:59:57 -0400
Date: Wed, 7 Sep 2011 10:59:52 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110907175952.GC23829@thinkpad-t410>
Mail-Followup-To: Pavel Ivanov <paivanof@gmail.com>,
	Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@tuxera.com>
References: <CAG1a4rscDrbiCKxSPvbkG7SutQ5HCU2tX9FJEv81nFuVxLWekg@mail.gmail.com>
 <1315096661.23425.YahooMailClassic@web29510.mail.ird.yahoo.com>
 <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 12:35:22AM -0400, Pavel Ivanov wrote:
> On Sat, Sep 3, 2011 at 8:37 PM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
> >> I've looked into the code myself a little and here's what I
> >> see.
> >> hfsplus_read_wrapper() calls to hfsplus_submit_bio() twice
> >> to fill
> >> sbi->s_vhdr and sbi->s_backup_vhdr. And according to
> >> parameters they
> >> are filled with pointers into sbi->s_vhdr_buf and
> >> sbi->s_backup_vhdr_buf respectively. It's done with the
> >> following code
> >> at fs/hfsplus/wrapper.c:79:
> >>
> >>     if (!(rw & WRITE) && data)
> >>         *data = (u8 *)buf +
> >> offset;
> >>
> >> So s_vhdr and s_backup_vhdr shouldn't be freed, s_vhdr_buf
> >> and
> >> s_backup_vhdr_buf should be freed instead. And indeed
> >> changing in
> >> hfsplus_fill_super()
> >>
> >>     kfree(sbi->s_vhdr);
> >>     kfree(sbi->s_backup_vhdr);
> >>
> >> to
> >>
> >>     kfree(sbi->s_vhdr_buf);
> >>     kfree(sbi->s_backup_vhdr_buf);
> >>
> >> fixes BUG reports from SLUB.
> >
> > The code around there is a bit too dense, and both of the *_buf are recent introductions (and temp values, I think) as is hfsplus_submit_bio() itself, around the 2.6.39/3.0 time frame. I think the intention is to fill s_vhdr/s_backup_vhdr via mulitple fetches using *_buf as temp buffer.
> 
> Well, look at the commit 6596528e. It clearly shows that result of
> kmalloc() is no longer assigned to sbi->s_vhdr and sbi->s_backup_vhdr,
> but is assigned to sbi->s_vhdr_buf and sbi->s_backup_vhdr_buf. Also
> this commit clearly changes hfsplus_put_super() so that it doesn't
> free sbi->s_vhdr and sbi->s_backup_vhdr, but frees sbi->s_vhdr_buf and
> sbi->s_backup_vhdr_buf instead. I guess Seth just missed
> hfsplus_fill_super() in there as it's pretty unusual exit path.

Yes, that was definitely just an oversight. Has anyone provided a patch
yet? If not I've pasted a patch below. Seems like a fix should be
applied ASAP.


>From d27825b880028e9a45ba640d86c9e8101db0606b Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 7 Sep 2011 10:38:35 -0700
Subject: [PATCH] hfsplus: Fix kfree of wrong pointers in hfsplus_fill_super() error path

Commit 6596528 (hfsplus: ensure bio requests are not smaller than
the hardware sectors) changed the pointers used for volume header
allocations but failed to change the pointer freed in the error
path of hfsplus_fill_super(). This patch fixes the problem.

Reported-by: Pavel Ivanov <paivanof@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: <stable@kernel.org>
---
 fs/hfsplus/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index c106ca2..cadbb8c 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -525,8 +525,8 @@ out_close_cat_tree:
 out_close_ext_tree:
 	hfs_btree_close(sbi->ext_tree);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_vhdr_buf);
+	kfree(sbi->s_backup_vhdr_buf);
 out_unload_nls:
 	unload_nls(sbi->nls);
 	unload_nls(nls);
-- 
1.7.4.1

