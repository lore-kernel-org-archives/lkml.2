Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab0FCKgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:36:10 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:54103 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab0FCKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ZK9aWzJyJ08aa6ChcUHj0/83Bva4cQADsbaQ+Fgy8fQMgnjqq5NJcXUpk4mn29F/Iy
         T+kPn0f9MHGbv462Kl+jAv9KnA9nsCiKbEcHc4rKfXvNp9DzRraBYsL4pluvlMrneMjY
         cgzCRB4TPEtsy9FpjFKI5nYJXX0q2wZW2hyWE=
Date: Thu, 3 Jun 2010 12:35:42 +0200
From: Dan Carpenter <error27@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Matthew Wilcox <matthew@wil.cx>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch v2] fcntl: return -EFAULT if copy_to_user fails
Message-ID: <20100603103542.GV5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
	Matthew Wilcox <matthew@wil.cx>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C07826A.6060302@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining, but we want to
return -EFAULT.
	ret = fcntl(fd, F_SETOWN_EX, NULL);
With the original code ret would be 8 here.

V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index f74d270..51e11bf 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -274,7 +274,7 @@ static int f_setown_ex(struct file *filp, unsigned long arg)
 
 	ret = copy_from_user(&owner, owner_p, sizeof(owner));
 	if (ret)
-		return ret;
+		return -EFAULT;
 
 	switch (owner.type) {
 	case F_OWNER_TID:
@@ -332,8 +332,11 @@ static int f_getown_ex(struct file *filp, unsigned long arg)
 	}
 	read_unlock(&filp->f_owner.lock);
 
-	if (!ret)
+	if (!ret) {
 		ret = copy_to_user(owner_p, &owner, sizeof(owner));
+		if (ret)
+			ret = -EFAULT;
+	}
 	return ret;
 }
 
