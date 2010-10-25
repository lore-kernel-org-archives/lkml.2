Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab0JYSnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0JYSnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:43:45 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 11/11] IMA: fix the ToMToU logic
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Date: Mon, 25 Oct 2010 14:42:25 -0400
Message-ID: <20101025184225.20504.18427.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current logic looks like this:

        rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
        if (rc < 0)
                goto out;

        if (mode & FMODE_WRITE) {
                if (inode->i_readcount)
                        send_tomtou = true;
                goto out;
        }

        if (atomic_read(&inode->i_writecount) > 0)
                send_writers = true;

Lets assume we have a policy which states that all files opened for read by
root must be measured.

Lets assume the file has permissions 777.

Lets assume that root has the given file open for read.

Lets assume that a non-root process opens the file write.

The non-root process will get to ima_counts_get() and will check the
ima_must_measure().  Since it is not supposed to measure it will goto out.

We should check the i_readcount no matter what since we might be causing a
ToMToU voilation!

This is close to correct , but still not quite perfect.  The situation could have
been that root, which was interested in the mesurement opened and closed the
file and another process which is not interested in the measurement is the one
holding the i_readcount ATM.  This is just overly strict on ToMToU violations,
which is better than not strict enough...

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/integrity/ima/ima_main.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 60dd615..203de97 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -112,22 +112,23 @@ void ima_counts_get(struct file *file)
 	if (!ima_initialized)
 		goto out;
 
-	rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
-	if (rc < 0)
-		goto out;
-
 	if (mode & FMODE_WRITE) {
-		if (inode->i_readcount)
+		if (inode->i_readcount && IS_IMA(inode))
 			send_tomtou = true;
 		goto out;
 	}
 
+	rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
+	if (rc < 0)
+		goto out;
+
 	if (atomic_read(&inode->i_writecount) > 0)
 		send_writers = true;
 out:
 	/* remember the vfs deals with i_writecount */
 	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		inode->i_readcount++;
+
 	spin_unlock(&inode->i_lock);
 
 	if (send_tomtou)

