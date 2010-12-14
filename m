Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0LNL2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:28:01 -0500
Received: from shutemov.name ([188.40.19.243]:40887 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0LNL2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:28:00 -0500
Date: Tue, 14 Dec 2010 13:27:59 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix gcc -Wconversion compilation warning
Message-ID: <20101214112759.GA13807@shutemov.name>
References: <1292259913-9911-1-git-send-email-kirill@shutemov.name>
 <m1sjy1uzj6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjy1uzj6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:35:25PM -0800, Eric W. Biederman wrote:
> "Kirill A. Shutsemov" <kirill@shutemov.name> writes:
> 
> > From: Dmitry V. Levin <ldv@altlinux.org>
> >
> > $ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
> > unsigned f(void) {return NLMSG_HDRLEN;}
> > EOF
> > <stdin>: In function 'f':
> > <stdin>:3:26: warning: negative integer implicitly converted to unsigned type
> >
> This doesn't look like a bad fix, but I believe things will fail if
> we give NLMSG_ALIGN an unsigned long like size_t.  Say like sizeof.
> 
> Admittedly it has to be a huge size but still if we are going
> to go fixing things...
> 
> And then there is the silliness that NLMSG_HDRLEN forces itself
> to be an int, when it start out as a size_t.
> 
> So I think NLMSG_ALIGN either needs to operation exclusively
> on unsigned longs aka size_t, or it needs to be type preserving.
> 
> Do you have time to look at this a bit more?

Something like this? Untested.
---
>From 8b86073dc9697c0eff93c003d6331c1e4aeda60e Mon Sep 17 00:00:00 2001
From: Kirill A. Shutemov <kirill@shutemov.name>
Date: Tue, 14 Dec 2010 12:50:39 +0200
Subject: [PATCH] netlink: fix gcc -Wconversion compilation warning

$ cat << EOF | gcc -Wconversion -xc -S -o/dev/null -
unsigned f(void) {return NLMSG_HDRLEN;}
EOF
<stdin>: In function 'f':
<stdin>:3:26: warning: negative integer implicitly converted to unsigned type

Define NLMSG_ALIGNTO as size_t, NLMSG_ALIGN always returns size_t and
drop non-sense casting in NLMSG_HDRLEN. Now NLMSG_HDRLEN returns size_t.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/netlink.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 1235669..db7d373 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -70,9 +70,9 @@ struct nlmsghdr {
    Check		NLM_F_EXCL
  */
 
-#define NLMSG_ALIGNTO	4
-#define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
-#define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
+#define NLMSG_ALIGNTO	((size_t) 4)
+#define NLMSG_ALIGN(len) ( ((size_t)(len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
+#define NLMSG_HDRLEN	 NLMSG_ALIGN(sizeof(struct nlmsghdr))
 #define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
 #define NLMSG_SPACE(len) NLMSG_ALIGN(NLMSG_LENGTH(len))
 #define NLMSG_DATA(nlh)  ((void*)(((char*)nlh) + NLMSG_LENGTH(0)))
-- 
 Kirill A. Shutemov
