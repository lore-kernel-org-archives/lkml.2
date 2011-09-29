Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1I2Spv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:45:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab1I2Spu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:45:50 -0400
Date: Thu, 29 Sep 2011 10:57:16 -0700
From: Greg KH <gregkh@suse.de>
To: Doug Ledford <dledford@redhat.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <20110929175716.GA5815@suse.de>
References: <20110928220142.033134480@clark.kroah.org>
 <67a3ec41-d2f4-43bd-b006-a0c299d72c0e@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a3ec41-d2f4-43bd-b006-a0c299d72c0e@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 11:41:18AM -0400, Doug Ledford wrote:
> ----- Original Message -----
> > 3.0-stable review patch.  If anyone has any objections, please let us
> > know.
> > 
> 
> @@ -160,6 +161,7 @@ static struct inode *mqueue_get_inode(st
>                      u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
>                          spin_unlock(&mq_lock);
>                          /* mqueue_evict_inode() releases info->messages */
> +                        ret = -EMFILE;
>                          goto out_inode;
>                  }
>                  u->mq_bytes += mq_bytes;
> 
> NACK to this portion of the patch.  The test is for the total bytes
> allocated, and the RLIMIT is for bytes allocated.  This can happen on
> one file or on the hundredth file.  It isn't a file error, it's a
> memory error and should remain such.  If you want to accurately return
> the right error, then you need new_inode() to return an
> ERR_PTR(EMFILE) in the case that the number of message queues in the
> namespace is exceeded and propagate that back up, but as
> mqueue_get_inode() really only checks memory issues, not queue count
> issues, the only return it should generate is ENOMEM.

Um, that's the way this patch is upstream, right?  So perhaps it should
be fixed there first and then I can take the fix into -stable?

greg k-h
