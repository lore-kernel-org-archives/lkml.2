Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0E0Ph2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab0E0PhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:37:24 -0400
Date: Thu, 27 May 2010 17:35:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 1/3] sys_personality: validate personality before
	set_personality()
Message-ID: <20100527153548.GB13858@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527153522.GA13858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_personality(personality) is obviously wrong. It calls set_personality()
which always sets current->personality = personality and then does

	if (current->personality != personality)
		return -EINVAL;

If this "u_long" argument doesn't fit into "unsigned int" ->personality,
we return -EINVAL but change the caller's ->personality.

Move this check up to ensure the overflow is not possible, before calling
set_personality() which never fails.

Pointed-out-by: Wenming Zhang <wezhang@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exec_domain.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 34-rc1/kernel/exec_domain.c~1_CK_OVERFLOW_EARLIER	2009-04-06 00:03:42.000000000 +0200
+++ 34-rc1/kernel/exec_domain.c	2010-05-27 15:15:12.000000000 +0200
@@ -193,9 +193,9 @@ SYSCALL_DEFINE1(personality, u_long, per
 	u_long old = current->personality;
 
 	if (personality != 0xffffffff) {
-		set_personality(personality);
-		if (current->personality != personality)
+		if ((unsigned int)personality != personality)
 			return -EINVAL;
+		set_personality(personality);
 	}
 
 	return (long)old;

