Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0CVMFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:05:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54540 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0CVMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Ny2LJfeUuHQh8tzqpsK9M26xFs/3AsIBmzKDJzQYsExn717KFOCwBbtXQvFDr21yOe
         i2pFr+4r7hGDaSnVemds6VK8ei+AB/NnPoXL5iRnq30QFBHTy/0pPx6eLxtElbPPAwB+
         a9YoOaLiXbNmYjNEnLccDrNw/b4nigZP6ruhw=
Date: Mon, 22 Mar 2010 15:05:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] kcore: fix test for end of list
Message-ID: <20100322120509.GC21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	WANG Cong <xiyou.wangcong@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"m" is never NULL here.  We need a different test for the end of list
condition.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found with a static checker and compile tested only.  Please review
carefully.

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index a44a789..b442dac 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 		}
 		read_unlock(&kclist_lock);
 
-		if (m == NULL) {
+		if (&m->list == &kclist_head) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
 		} else if (is_vmalloc_or_module_addr((void *)start)) {
