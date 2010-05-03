Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab0ECXu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:50:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52801 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0ECXu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:50:26 -0400
Date: Mon, 3 May 2010 18:50:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       David Howells <dhowells@redhat.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3/3] RFC: p9auth: add p9auth fs
Message-ID: <20100503235019.GA16384@us.ibm.com>
References: <20100427164139.GA7359@us.ibm.com>
 <20100427164517.GC7530@us.ibm.com>
 <20100428111749.GA27247@redhat.com>
 <20100428151015.GB4100@us.ibm.com>
 <20100428153933.GA6610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428153933.GA6610@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments, Oleg.  I will fold this patch into the
main patch, but I'll spare everyone a full repost right now.

thanks,
-serge

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH 1/1] p9auth: address feedback

Address two comments by Oleg:

Return -ERESTARTNOINTR rather than -EINTR if we are interrupted
while waiting on cap_mutex.  And check size of input buffer for
something sane.  A user with hundreds of auxilliary groups could
end up with a > PAGE_SIZE message, so maybe this is a bit too
stringent, but I'm not sure how realistic that is.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/p9auth.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/p9auth.c b/kernel/p9auth.c
index a174373..5f89b4d 100644
--- a/kernel/p9auth.c
+++ b/kernel/p9auth.c
@@ -354,7 +354,10 @@ static ssize_t p9auth_grant_write(struct file *file, const char __user *buffer,
 	char *user_buf;
 
 	if (mutex_lock_interruptible(&cap_mutex))
-		return -EINTR;
+		return -ERESTARTNOINTR;
+
+	if (count > PAGE_SIZE)
+		return -E2BIG;
 
 	user_buf = kzalloc(count+1, GFP_KERNEL);
 	if (!user_buf)
@@ -387,7 +390,10 @@ static ssize_t p9auth_use_write(struct file *file, const char __user *buffer,
 	char *user_buf;
 
 	if (mutex_lock_interruptible(&cap_mutex))
-		return -EINTR;
+		return -ERESTARTNOINTR;
+
+	if (count > PAGE_SIZE)
+		return -E2BIG;
 
 	user_buf = kzalloc(count+1, GFP_KERNEL);
 	if (!user_buf)
-- 
1.7.0.4

