Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0JXSGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 14:06:12 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:44420 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757050Ab0JXSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:06:10 -0400
Message-ID: <4CC4758E.9020102@panasas.com>
Date: Sun, 24 Oct 2010 20:06:06 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Nick Piggin <npiggin@kernel.dk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] exofs: use iput() for inode reference count decrements
References: <1286928961-15157-1-git-send-email-david@fromorbit.com> <1286928961-15157-7-git-send-email-david@fromorbit.com> <20101013113402.GC19456@infradead.org> <4CB5C70A.2010401@panasas.com> <20101017012437.GA4227@infradead.org>
In-Reply-To: <20101017012437.GA4227@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2010 18:06:09.0175 (UTC) FILETIME=[228EF270:01CB73A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2010 03:24 AM, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 10:49:46AM -0400, Boaz Harrosh wrote:
>> I suspect it's not a bug but a useless inc/dec because in all my testing
>> I have not seen an inode leak. Let me investigate if it can be removed.
>>
>> So I do not think we need it for 2.6.36.
>>
>> I'll take this patch into my 2.6.37-rcX merge window. It should appear
>> in linux-next by tomorrow. Hopefully followed by a removal patch later.
> 
> It's a very real bug.  If an inode goes away in-core before the creation
> on the OSD has finished, e.g. by using the drop_cache files the
> atomic_dec instead of the iput means you will never call iput_final
> and thus leak all ressources associated with the inode, as well as
> leaving it on all lists.  It's not easy to hit, but very nasty when
> it is hit.
> 

Hi Christoph Dave

As I suspected this fix is not good. For a simple reason, The create_done()
is called from scsi_done() which has irq disabled. So in iput() in the case
evict() is needed we BUG on trying to take the i_mutex.

> Another option to fix it might be to drop the refcount games and just
> add a wait for the objection creation in the evict_inode method to
> make sure we never remove the inode before the object creation
> has finished.
> 

On the other hand this solution does work, perfectly. Actually there
was already a "wait for the objection creation" in exofs_evict_inode().
Hence the reason I've never seen an inode leak. Below is the patch I'm
putting in -next for push to 2.6.37 (So there was no bug in exofs after all,
I'm not CC(ing) stable@)

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] exofs: remove inode->i_count ref/deref in exofs_new_inode/create_done

exofs_new_inode was incrementing the inode->i_count and
decrementing it in create_done, in a bad attempt to make
sure the inode will still be there when asynchronous create_done
finally arrives. This was stupid because iput() was not called,
and if is the final ref, could leak the inode.

However all this is not needed, because at exofs_evict_inode()
we already wait for create_done return by waiting for the
create_object event. Therefore remove the extra ref counting
and just Thicken the comment at exofs_evict_inode() a bit.
(Also use ready made __exofs_wait_obj_created instead of
open-coding it.)

CC: Dave Chinner <dchinner@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/inode.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 0ba9886..31e9164 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1102,7 +1102,6 @@ static void create_done(struct exofs_io_state *ios, void *p)
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
 	wake_up(&oi->i_wq);
 }
 
@@ -1153,17 +1152,11 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 	ios->obj.id = exofs_oi_objno(oi);
 	exofs_make_credential(oi->i_cred, &ios->obj);
 
-	/* increment the refcount so that the inode will still be around when we
-	 * reach the callback
-	 */
-	atomic_inc(&inode->i_count);
-
 	ios->done = create_done;
 	ios->private = inode;
 	ios->cred = oi->i_cred;
 	ret = exofs_sbi_create(ios);
 	if (ret) {
-		atomic_dec(&inode->i_count);
 		exofs_put_io_state(ios);
 		return ERR_PTR(ret);
 	}
@@ -1321,12 +1314,12 @@ void exofs_evict_inode(struct inode *inode)
 	inode->i_size = 0;
 	end_writeback(inode);
 
-	/* if we are deleting an obj that hasn't been created yet, wait */
-	if (!obj_created(oi)) {
-		BUG_ON(!obj_2bcreated(oi));
-		wait_event(oi->i_wq, obj_created(oi));
-		/* ignore the error attempt a remove anyway */
-	}
+	/* if we are deleting an obj that hasn't been created yet, wait
+	 * This also makes sure that create_done cannot be called with an
+	 * already deleted inode.
+	 */
+	__exofs_wait_obj_created(oi);
+	/* ignore the error attempt a remove anyway */
 
 	/* Now Remove the OSD objects */
 	ret = exofs_get_io_state(&sbi->layout, &ios);
-- 
1.7.2.3

