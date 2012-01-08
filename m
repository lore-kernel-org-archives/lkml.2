Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2AHTve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 14:51:34 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14334 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2AHTvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 14:51:33 -0500
Date: Sun, 8 Jan 2012 20:51:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: Please merge two small bug fix patches from linux-next
Message-ID: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Below are two patches that have been in linux-next for ages (via akpm's 
tree). They are prette simple, straight-up, bug fixes. They have been 
submitted to maintainers multiple times over (IIRC at least the past 
year), but for some reason the maintainers seem uninterested in picking 
them up (or even responding to them).
There has been no negative comments at all to them while they have been in 
-next.
I'd really appreciate it if they could get merged.

I've just pulled them out of the current linux-next and applied them on 
top of your tree - that's what is below.



From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 22 Dec 2011 16:03:46 +1100
Subject: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()

We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :

We allocate memory:
        ...
                        struct user_sgmap* usg;
                        usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
                          + sizeof(struct sgmap), GFP_KERNEL);
and then neglect to free it:
        ...
                        for (i = 0; i < usg->count; i++) {
                                u64 addr;
                                void* p;
                                if (usg->sg[i].count >
                                    ((dev->adapter_info.options &
                                     AAC_OPT_NEW_COMM) ?
                                      (dev->scsi_host_ptr->max_sectors << 9) :
                                      65536)) {
                                        rcode = -EINVAL;
                                        goto cleanup;
        ... this 'goto' makes 'usg' go out of scope and leak the memory we
            allocated.
            Other exits properly kfree(usg), it's just here it is neglected.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/aacraid/commctrl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 8a0b330..0bd38da 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -650,6 +650,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
+					kfree(usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-- 
1.7.8.1



From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 22 Dec 2011 16:04:13 +1100
Subject: audit: always follow va_copy() with va_end()

A call to va_copy() should always be followed by a call to va_end() in the
same function.  In kernel/autit.c::audit_log_vformat() this is not always
done.  This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jesper Juhl <jj@codesealer.com>
---
 kernel/audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09fae26..2c1d6ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1260,12 +1260,13 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
 		avail = audit_expand(ab,
 			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
 		if (!avail)
-			goto out;
+			goto out_va_end;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
-	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
+out_va_end:
+	va_end(args2);
 out:
 	return;
 }
-- 
1.7.8.1



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

