Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1EGGaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:30:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1EGGaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FzaV7hP4+gQx4hbN8qh8Ipzi10u0/M4U3k/m++d8DWyIBUuMMcQOU9G60Se9BDtLb/
         8zD/5STB1JlRyB+PTPDM/k29DtGcnHzCVqkYJFrH1vWxfHE1C+jCZLHZjsRXJSxSm4Yd
         UxtpTozAg5pkUzm98M4Bmn4Gxsv7DrnBLQVCc=
Subject: [PATCH] fs: avoid unecessary smp_wmb() in dup_fd()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Changli Gao <xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 08:30:01 +0200
Message-ID: <1304749801.2821.716.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While copying old_fds array to new_fds, we dont need
rcu_assign_pointer() and its smp_wmb(), since we are the only thread
populating new_fds at this point.

A bit later, rcu_assign_pointer(newf->fdt, new_fdt) makes sure
our writes are committed to memory before new_fds content is visible to
other threads.

This removes following sparse warning :

fs/file.c:371:3: warning: incorrect type in assignment (different
address spaces)
fs/file.c:371:3:    expected struct file *<noident>
fs/file.c:371:3:    got struct file [noderef] <asn:4>*<noident>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Changli Gao <xiaosuo@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 4c6992d..8320a8e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -368,7 +368,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 			 */
 			FD_CLR(open_files - i, new_fdt->open_fds);
 		}
-		rcu_assign_pointer(*new_fds++, f);
+		*new_fds++ = f;
 	}
 	spin_unlock(&oldf->file_lock);
 


