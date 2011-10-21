Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1JUVSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:18:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49033 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1JUVSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:18:34 -0400
Subject: [PATCH 5/5] ext4: Fix endian problem in MMP initialization
To: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@mit.edu>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 21 Oct 2011 14:18:25 -0700
Message-ID: <20111021211825.10784.97113.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102121-5930-0000-0000-0000007C363F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of startup, the MMP initialization code does this:

mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());

Next, mmp->mmp_seq is written out to disk, a delay happens, and then the MMP
block is read back in and the sequence value is tested:

if (seq != le32_to_cpu(mmp->mmp_seq)) {
	/* fail the mount */

On a LE system such as x86, the *le32* functions do nothing and this works.
Unfortunately, on a BE system such as ppc64, this comparison becomes:

if (cpu_to_le32(new_seq) != le32_to_cpu(cpu_to_le32(new_seq)) {
	/* fail the mount */

Except for a few palindromic sequence numbers, this test always causes the
mount to fail, which makes MMP filesystems generally unmountable on ppc64.  The
attached patch fixes this situation.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/mmp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 9bdef3f..a7a4986 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -295,7 +295,8 @@ skip:
 	/*
 	 * write a new random sequence number.
 	 */
-	mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
+	seq = mmp_new_seq();
+	mmp->mmp_seq = cpu_to_le32(seq);
 
 	retval = write_mmp_block(bh);
 	if (retval)

