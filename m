Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1I2Pni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:43:38 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:58386 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab1I2Pnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:43:37 -0400
Date: Thu, 29 Sep 2011 11:41:18 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <67a3ec41-d2f4-43bd-b006-a0c299d72c0e@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110928220142.033134480@clark.kroah.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.231.143]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 3.0-stable review patch.  If anyone has any objections, please let us
> know.
> 

@@ -160,6 +161,7 @@ static struct inode *mqueue_get_inode(st
                     u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
                         spin_unlock(&mq_lock);
                         /* mqueue_evict_inode() releases info->messages */
+                        ret = -EMFILE;
                         goto out_inode;
                 }
                 u->mq_bytes += mq_bytes;

NACK to this portion of the patch.  The test is for the total bytes allocated, and the RLIMIT is for bytes allocated.  This can happen on one file or on the hundredth file.  It isn't a file error, it's a memory error and should remain such.  If you want to accurately return the right error, then you need new_inode() to return an ERR_PTR(EMFILE) in the case that the number of message queues in the namespace is exceeded and propagate that back up, but as mqueue_get_inode() really only checks memory issues, not queue count issues, the only return it should generate is ENOMEM.

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

