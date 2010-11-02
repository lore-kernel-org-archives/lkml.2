Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0KBRIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:08:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44286 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0KBRIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:08:38 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode citizen 
Date: Tue,  2 Nov 2010 13:08:22 -0400
Message-Id: <1288717707-5295-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
- renamed iget/iput_readcount to i_readcount_inc/dec (Dave Chinner's suggestion)
- finished cleaning up the locking, so that: (based on Eric's comment.)
	- i_lock is not required
	- i_mutex is taken when making measurement decisions to prevent
	  file metadata(eg. permissions, xattr) changing from under it.
	- iint->mutex is taken when accessing/modifying the iint structure.
- Based on the previous posting discussion, i_readcount is now defined as
atomic. 

This patchset separates the incrementing/decrementing of the i_readcount,
in the VFS layer, from other IMA functionality, by replacing the current
ima_counts_get() call with i_readcount_inc(). Its unclear whether this
call to increment i_readcount should be made earlier, like i_writecount.

The patch ordering is a bit redundant in order to leave removing the ifdef
around i_readcount until the last patch. The first four patches: redefines 
i_readcount as atomic, defines i_readcount_inc/dec(), moves the IMA
functionality in ima_counts_get() to ima_file_check(), and removes the
IMA imbalance code, simplifying IMA. The last patch removes the ifdef
around i_readcount, making i_readcount into a "first class inode citizen".

The generic_setlease code could then take advantage of i_readcount.
 
Mimi

Mimi Zohar (5):
  IMA: convert i_readcount to atomic
  IMA: define readcount functions
  IMA: maintain i_readcount in the VFS layer
  IMA: remove IMA imbalance checking
  IMA: making i_readcount a first class inode citizen

 fs/file_table.c                   |    5 +-
 fs/open.c                         |    3 +-
 include/linux/fs.h                |   16 ++++-
 include/linux/ima.h               |    6 --
 security/integrity/ima/ima_iint.c |    5 --
 security/integrity/ima/ima_main.c |  130 ++++---------------------------------
 6 files changed, 31 insertions(+), 134 deletions(-)

-- 
1.7.2.2

