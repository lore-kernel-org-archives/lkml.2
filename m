Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab1FAALb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:11:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46407 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab1FAALa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:11:30 -0400
Date: Wed, 1 Jun 2011 10:11:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier@gentoo.org>, Linus <torvalds@linux-foundation.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH] kgdbts: only use new
 asm-generic/ptrace.h api when needed
Message-Id: <20110601101117.6c9792a1.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTind_F4-5sLUO1GVxK_yY_eXz_J0Vg@mail.gmail.com>
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
	<1306591465-9622-1-git-send-email-vapier@gentoo.org>
	<4DE3688A.4040600@mvista.com>
	<BANLkTind_F4-5sLUO1GVxK_yY_eXz_J0Vg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 12:28:17 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
>
> i prefer to have as much outside of ifdefs as possible.  gcc optimizes
> the result away, so it isnt a code size problem.

Can we just get a patch sent to Linus, please?   His tree has now been
broken for powerpc and sparc32 for 5 days :-(

It would have been nice if the original patch had been in linux-next at
some point (especially given that I have a "kgdb" tree in linux-next).

/me just slightly annoyed.

Linus, the fix patch is below (I have applied it to linux-next today):

From:	Mike Frysinger <vapier@gentoo.org>
To:	kgdb-bugreport@lists.sourceforge.net,
	Jason Wessel <jason.wessel@windriver.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc:	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH] kgdbts: only use new asm-generic/ptrace.h api when needed
Date:	Sat, 28 May 2011 10:04:25 -0400

The new instruction_pointer_set helper is defined for people who have
converted to asm-generic/ptrace.h, so don't use it generally unless
the arch needs it (in which case it has been converted).  This should
fix building of kgdb tests for arches not yet converted.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/kgdbts.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index b0c5631..8cebec5 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -304,7 +304,10 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 		return 1;
 	}
 	/* Readjust the instruction pointer if needed */
-	instruction_pointer_set(&kgdbts_regs, ip + offset);
+	ip += offset;
+#ifdef GDB_ADJUSTS_BREAK_OFFSET
+	instruction_pointer_set(&kgdbts_regs, ip);
+#endif
 	return 0;
 }
 
-- 
1.7.5.rc3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
