Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327Ab0J1WCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:02:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33104 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab0J1WCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:02:20 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 0/4] IMA: making i_readcount a first class inode citizen 
Date: Thu, 28 Oct 2010 18:02:01 -0400
Message-Id: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 14:41 -0400, Eric Paris wrote:

<snip>

> I believe that IBM is going to look into making i_readcount a first
> class citizen which can be used by both IMA and generic_setlease().
> Then people could say IMA had 0 per inode overhead   :)

This patchset separates the incrementing/decrementing of the i_readcount,
in the VFS layer, from other IMA functionality, by replacing the current
ima_counts_get() call with iget_readcount(). Its unclear whether this
call to increment i_readcount should be made earlier. 

The patch ordering is a bit redundant in order to leave removing the ifdef
around i_readcount until the last patch. The first three patches: defines 
iget/iput_readcount(), moves the IMA functionality in ima_counts_get() to
ima_file_check(), and removes the IMA imbalance code, simplifying IMA. The
last patch moves iget/iput_readcount() to the fs directory and removes the
ifdef around i_readcount, making i_readcount into a "first class inode citizen".

The generic_setlease code could then take advantage of i_readcount, assuming
it can take the spin_lock, by doing something like:

-		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
+
+		spin_lock(&inode->i_lock);
+		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0)){
+			spin_unlock(&inode->i_lock);
 			goto out;
-		if ((arg == F_WRLCK)
-		    && ((atomic_read(&dentry->d_count) > 1)
-			|| (atomic_read(&inode->i_count) > 1)))
+		}
+		if ((arg == F_WRLCK) && (inode->i_readcount > 1)) {
+			spin_unlock(&inode->i_lock);
 			goto out;
+		}
+		spin_unlock(&inode->i_lock);
 	}
 
Mimi

Mimi Zohar (4):
  IMA: define readcount functions
  IMA: maintain i_readcount in the VFS layer
  IMA: remove IMA imbalance checking
  IMA: making i_readcount a first class inode citizen

 fs/file_table.c                   |   23 +++++++-
 fs/inode.c                        |    3 +
 fs/open.c                         |    3 +-
 include/linux/fs.h                |    4 +-
 include/linux/ima.h               |    6 --
 security/integrity/ima/ima_iint.c |    5 --
 security/integrity/ima/ima_main.c |  125 ++++--------------------------------
 7 files changed, 43 insertions(+), 126 deletions(-)

-- 
1.7.2.2

