Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1KGMrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:47:03 -0500
Received: from damascus.uab.es ([158.109.168.135]:23959 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1KGMrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:47:00 -0500
X-Greylist: delayed 1748 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 07:47:00 EST
Date: Mon, 07 Nov 2011 15:49:17 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
In-reply-to: <25866.1320657093@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
Cc: Hugh Dickins <hughd@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Message-id: <1320677357.2330.7.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18498.006)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
References: <1320614101.3226.5.camel@offbook>
 <25866.1320657093@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 04:11 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 06 Nov 2011 18:15:01 -0300, Davidlohr Bueso said:
> 
> > @@ -1159,7 +1159,12 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
> >  			struct page **pagep, void **fsdata)
> 
> > +	if (atomic_long_read(&user->shmem_bytes) + len > 
> > +	    rlimit(RLIMIT_TMPFSQUOTA))
> > +		return -ENOSPC;
> 
> Is this a per-process or per-user limit?  If it's per-process, it doesn't
> really do much good, because a user can use multiple processes to over-run the
> limit (either intentionally or accidentally).

This is a per-user limit.
> 
> > @@ -1169,10 +1174,12 @@ shmem_write_end(struct file *file, struct address_space *mapping,
> >  			struct page *page, void *fsdata)
> 
> > +	if (pos + copied > inode->i_size) {
> >  		i_size_write(inode, pos + copied);
> > +		atomic_long_add(copied, &user->shmem_bytes);
> > +	}
> If this is per-user, it's racy with shmem_write_begin() - two processes can hit
> the write_begin(), be under quota by (say) 1M, but by the time they both
> complete the user is 1M over the quota.
> 
I guess using a spinlock instead of atomic operations would serve the
purpose.

> >  @@ -1535,12 +1542,15 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
> > +	struct user_struct *user = current_user();
> > +	atomic_long_sub(inode->i_size, &user->shmem_bytes);
> 
> What happens here if user 'fred' creates a file on a tmpfs, and then logs out so he has
> no processes running, and then root does a 'find tmpfs -user fred -exec rm {} \;' to clean up?
> We just decremented root's quota, not fred's....
> 
Would the same would occur with mqueues? I haven't tested it but I don't
see anywhere that user->mq_bytes is decreased like this.

Thanks,
Davidlohr

