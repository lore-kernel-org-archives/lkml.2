Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2BAPVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:21:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2BAPVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:21:38 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=zCINYGxz3jhYVmrHnAIA:9 a=wL0-nGbBGwaU3SWVLGoA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328109697.5882.65.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 01 Feb 2012 10:21:37 -0500
In-Reply-To: <20120201080539.GA11770@elte.hu>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
	 <1328072925.5882.57.camel@gandalf.stny.rr.com>
	 <20120201080539.GA11770@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 09:05 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> It would be better to make this a regular commit, this kind of 
> diagnostics obviously makes sense. That way i could pull in your 
> updated branch for more testing.


Ingo,

I added the below patch on top of my previous pull request. If you run
this on the box that failed, it should give us a little more info.

Thanks!

Please pull the latest tip/perf/jump-label-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label-3

Head SHA1: abdefd743e4a28f11bcd38a441253f01dafea03e


Steven Rostedt (1):
      x86/jump lables: Show where and what was wrong on errors

----
 arch/x86/kernel/jump_label.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)
---------------------------
commit abdefd743e4a28f11bcd38a441253f01dafea03e
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Feb 1 09:59:24 2012 -0500

    x86/jump lables: Show where and what was wrong on errors
    
    When modifying text sections for jump labels, a paranoid check is
    performed. If the check fails, the system "bugs". But why it failed
    is not shown.
    
    The BUG_ON()s in the jump label update code is replaced with bug_at(ip).
    This is a function that will show what pointer failed, and what was
    at the location of the failure that made jump label panic.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 7112a27..2839524 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -32,6 +32,18 @@ union jump_code_union {
 	} __packed;
 };
 
+static void bug_at(unsigned char *ip, int line)
+{
+	/*
+	 * The location is not an op that we were expecting.
+	 * Something went wrong. Crash the box, as something could be
+	 * corrupting the kernel.
+	 */
+	printk("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
+	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
+	BUG();
+}
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
 				   void *(*poker)(void *, const void *, size_t),
@@ -59,12 +71,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 			code.jump = 0xe9;
 			code.offset = entry->target - (entry->code + size);
 		} else
-			/*
-			 * The location is not a nop that we were expecting,
-			 * something went wrong. Crash the box, as something could be
-			 * corrupting the kernel.
-			 */
-			BUG();
+			bug_at(ip, __LINE__);
 	} else {
 		/*
 		 * We are disabling this jump label. If it is not what
@@ -78,7 +85,8 @@ static void __jump_label_transform(struct jump_entry *entry,
 				return;
 
 			/* We are initializing from the default nop */
-			BUG_ON(memcmp(ip, default_nop, 5) != 0);
+			if (unlikely(memcmp(ip, default_nop, 5) != 0))
+				bug_at(ip, __LINE__);
 
 			/* Set to the ideal nop */
 			size = JUMP_LABEL_NOP_SIZE;
@@ -91,7 +99,9 @@ static void __jump_label_transform(struct jump_entry *entry,
 			code.jump = 0xe9;
 			code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-			BUG_ON(memcmp(ip, &code, 5) != 0);
+
+			if (unlikely(memcmp(ip, &code, 5) != 0))
+				bug_at(ip, __LINE__);
 
 			size = JUMP_LABEL_NOP_SIZE;
 			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
@@ -101,13 +111,14 @@ static void __jump_label_transform(struct jump_entry *entry,
 			/* Had better be a 2 byte jmp */
 			code.jump_short = 0xeb;
 			code.offset = entry->target - (entry->code + 2);
-			BUG_ON(memcmp(ip, &code, 2) != 0);
+			if (unlikely(memcmp(ip, &code, 2) != 0))
+				bug_at(ip, __LINE__);
 
 			size = 2;
 			memcpy(&code, nop_short, size);
 		} else
 			/* The code was not what we expected!  */
-			BUG();
+			bug_at(ip, __LINE__);
 	}
 
 	(*poker)(ip, &code, size);


