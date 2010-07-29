Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0G2Hgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 03:36:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38684 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0G2Hgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 03:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=lT8LZFehb5uthKvO6wxzc5u3UA9oO4dlfE3eNsqPD04B4VX4Tk83l99kdXS9NMb3mj
         mMjFLATvVTr/p97xnHYz8R6mVdiSEq/hP0Bmomh79CnxOToiUAwyIHiScZtI8N08KWnh
         48AMIyRmy3MVFt+3lQ8L/BXu2XGRO9caTJvTg=
Date: Thu, 29 Jul 2010 09:36:10 +0200
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] kexec: return -EFAULT on copy_to_user() failures
Message-ID: <20100729073609.GR26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Simon Kagstrom <simon.kagstrom@netinsight.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to/from_user() returns the number of bytes remaining to be copied.
It never returns a negative value.  The correct return code is -EFAULT
and not -EIO.

All the callers check for non-zero returns so that's Ok, but the return
code is passed to the user so we should fix this.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 474a847..ab2258b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -151,8 +151,10 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	image->nr_segments = nr_segments;
 	segment_bytes = nr_segments * sizeof(*segments);
 	result = copy_from_user(image->segment, segments, segment_bytes);
-	if (result)
+	if (result) {
+		result = -EFAULT;
 		goto out;
+	}
 
 	/*
 	 * Verify we have good destination addresses.  The caller is
@@ -827,7 +829,7 @@ static int kimage_load_normal_segment(struct kimage *image,
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
 		if (result) {
-			result = (result < 0) ? result : -EIO;
+			result = -EFAULT;
 			goto out;
 		}
 		ubytes -= uchunk;
@@ -882,7 +884,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 		kexec_flush_icache_page(page);
 		kunmap(page);
 		if (result) {
-			result = (result < 0) ? result : -EIO;
+			result = -EFAULT;
 			goto out;
 		}
 		ubytes -= uchunk;
