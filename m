Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2EATed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:34:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2EATec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:34:32 -0400
Date: Tue, 1 May 2012 12:34:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [Patch 2/4] ipc/mqueue: correct mq_attr_ok test
Message-Id: <20120501123430.63f4bf85.akpm@linux-foundation.org>
In-Reply-To: <4a62cbda48cf31ca796f37fa8904f314f643db57.1335894230.git.dledford@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
	<4a62cbda48cf31ca796f37fa8904f314f643db57.1335894230.git.dledford@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 May 2012 13:50:53 -0400
Doug Ledford <dledford@redhat.com> wrote:

> While working on the other parts of the mqueue stuff, I noticed that
> the calculation for overflow in mq_attr_ok didn't actually match
> reality (this is especially true since my last patch which changed
> how we account memory slightly).

Please cc Manfred on mqueue things?  He still watches ;)

> In particular, we used to test for overflow using:
>   msgs * msgsize + msgs * sizeof(struct msg_msg *)
> 
> That was never really correct because each message we allocate via
> load_msg() is actually a struct msg_msg followed by the data for
> the message (and if struct msg_msg + data exceeds PAGE_SIZE we end
> up allocating struct msg_msgseg structs too, but accounting for them
> would get really tedious, so let's ignore those...they're only a
> pointer in size anyway).  This patch updates the calculation to be
> more accurate in regards to maximum possible memory consumption by the
> mqueue.
> 
> ...
>
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
>
> ...
>
> @@ -684,8 +686,11 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
>  	/* check for overflow */
>  	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
>  		return 0;
> -	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
> -	    + sizeof (struct msg_msg *))) <
> +	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
> +		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
> +		sizeof(struct posix_msg_tree_node);
> +	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
> +			    mq_treesize) <
>  	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
>  		return 0;
>  	return 1;

That's a bit of a mouthful.  Does this look OK?

--- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix
+++ a/ipc/mqueue.c
@@ -672,7 +672,8 @@ static void remove_notification(struct m
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
 	int mq_treesize;
-
+	unsigned long total_size;
+	
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
@@ -690,9 +691,8 @@ static int mq_attr_ok(struct ipc_namespa
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
-	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
-			    mq_treesize) <
-	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
+	total_size = attr->mq_maxmsg * attr->mq_msgsize;
+	if (total_size + mq_treesize < total_size)
 		return 0;
 	return 1;
 }
_

