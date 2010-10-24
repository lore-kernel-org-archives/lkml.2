Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab0JXOck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 10:32:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33264 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab0JXOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:32:39 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Brad Boyer <flar@allandria.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchit Garg <sancgarg@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] net/9p: Return error on read with NULL buffer
In-Reply-To: <20101023195957.GA13348@cynthia.pants.nu>
References: <1287412853-24700-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1287412853-24700-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20101023195957.GA13348@cynthia.pants.nu>
User-Agent: Notmuch/0.3.1-90-g8071c5c (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sun, 24 Oct 2010 20:02:32 +0530
Message-ID: <m31v7f1x1b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010 12:59:57 -0700, Brad Boyer <flar@allandria.com> wrote:
> On Mon, Oct 18, 2010 at 08:10:53PM +0530, Aneesh Kumar K.V wrote:
> > This patch ensures that a read(fd, NULL, 0 ) returns  EFAULT on a 9p file.
> 
> Is there some specific reason you want this behavior? I believe the
> generic Linux code returns success in this case. I tried this exact
> system call with fd being a pty or a file on ext3 and got 0 for both.

Linux code return 0 in case count == 0;
This is what i find on ext4.

open("a.c", O_RDONLY)                   = 3
read(3, 0, 10)                          = -1 EFAULT (Bad address)

open("a.c", O_RDONLY)                   = 3
read(3, NULL, 0)                        = 0

This patch ensure that we get the behaviour as in case one in case of 9p
file system. But patch broke the behaviour in step 2. So below is the
updated one

commit bd1717e5300ab0bb9aa2df139ffbc5e49f1baeb6
Author: Sanchit Garg <sancgarg@linux.vnet.ibm.com>
Date:   Tue Oct 19 09:17:02 2010 +0530

    net/9p: Return error on read with NULL buffer
    
    This patch ensures that a read(fd, NULL, 10) returns  EFAULT on a 9p file.
    
    Signed-off-by: Sanchit Garg <sancgarg@linux.vnet.ibm.com>
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/net/9p/client.c b/net/9p/client.c
index e141e46..dbca5b3 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1333,16 +1333,13 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
 
 	if (data) {
 		memmove(data, dataptr, count);
-	}
-
-	if (udata) {
+	} else {
 		err = copy_to_user(udata, dataptr, count);
 		if (err) {
 			err = -EFAULT;
 			goto free_and_error;
 		}
 	}
-
 	p9_free_req(clnt, req);
 	return count;
 


-aneesh
