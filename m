Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab0FCKEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:04:21 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:37400 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab0FCKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=BaQ2RvbLfLXDDKIWMQvIFuk6QVIA1kCgYRSFi/+GL9MgHHo/3ryZwOSCpnTVk7sHNZ
         Ic3sImeheV8bKYTbl4pmqjcYs03US1QTm9B+ltLgUrGLtXFFhJhBCSvKwxoE/MbV0GRT
         hm6pLtWCOByzgRorJZZg8gEz06Eua20XMozB4=
Date: Thu, 3 Jun 2010 12:04:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] fcntl: return -EFAULT if copy_to_user fails
Message-ID: <20100603100402.GR5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining, but we want to
return -EFAULT.

	ret = fcntl(fd, F_SETOWN_EX, NULL);

With the original code ret would be 8 here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index f74d270..0ea7b0f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -274,7 +274,7 @@ static int f_setown_ex(struct file *filp, unsigned long arg)
 
 	ret = copy_from_user(&owner, owner_p, sizeof(owner));
 	if (ret)
-		return ret;
+		return -EFAULT;
 
 	switch (owner.type) {
 	case F_OWNER_TID:
