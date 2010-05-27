Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0E0Phu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab0E0Php (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:37:45 -0400
Date: Thu, 27 May 2010 17:36:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 2/3] sys_personality: make sure (int)personality >= 0
Message-ID: <20100527153613.GC13858@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527153522.GA13858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure about this patch. The kernel/libc part is correct, but
since user-space declares "int personality(unsigned long persona)"
the current behaviour can confuse the (poor written) applications
even on 64-bit machines.

Consider:

	personality(0xffffffff - 1);	// == (int)-2

	...

	int ret = personality(0);	// returns the old personality
	if (ret < 0)
		oops_we_cant_set_PER_LINUX(errno);

And, since libc correctly detects the successful return from syscall,
errno is random.

Change sys_personality() to ensure personality can not look like a
negative int. This disallows the MSB, it is not used for PER_ flags.

Suggested-by: Wenming Zhang <wezhang@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exec_domain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 34-rc1/kernel/exec_domain.c~2_MAKE_IT_POSITIVE	2010-05-27 15:15:12.000000000 +0200
+++ 34-rc1/kernel/exec_domain.c	2010-05-27 15:54:33.000000000 +0200
@@ -193,7 +193,8 @@ SYSCALL_DEFINE1(personality, u_long, per
 	u_long old = current->personality;
 
 	if (personality != 0xffffffff) {
-		if ((unsigned int)personality != personality)
+		/* ensure it never looks like a negative int to user-space */
+		if (personality > 0x7fffffff)
 			return -EINVAL;
 		set_personality(personality);
 	}

