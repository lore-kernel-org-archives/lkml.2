Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab1EWUBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:01:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62537 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab1EWUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=H0SQ9LPhRnoMPuFRi7ATz4V8JyldPTkgy3DhehHieyI8JsqDGmQtYKrBpNUJEHICzO
         njdaA0KxvWne1we0qxhOe1dLmPZgVCngo3MkOOleIYeZxNmYnaY+5qolIXBycr0EJkfJ
         yw7NNUQ3DCjjXGg1fdV5aBSIaDdTsDSGvI0/s=
Date: Mon, 23 May 2011 22:01:23 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost6.localdomain6
To: Steven Rostedt <rostedt@goodmis.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eduardo Silva <edsiper@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: Fix ftrace.c compiler warning when calling
 ftrace_nop_replace()
In-Reply-To: <1306156114.1465.37.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1105232159350.4933@localhost6.localdomain6>
References: <1306113548.29789.2.camel@monotop>  <4DD9BA2F.9000303@zytor.com> <1306156114.1465.37.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463803646-1583054631-1306180886=:4933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463803646-1583054631-1306180886=:4933
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT



On Mon, 23 May 2011, Steven Rostedt wrote:

> On Sun, 2011-05-22 at 18:36 -0700, H. Peter Anvin wrote:
> > On 05/22/2011 06:19 PM, Eduardo Silva wrote:
> > > the function ftrace_nop_replace() returns a 'static const unsigned char *'
> > > value, so when the caller perform a direct assignment to a
> > > 'static unsigned char *', the compiler raise the following warning message:
> > > 
> > >  ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
> > >  ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
> > > 
> > > Adding the proper casts the message goes away.
> > > 
> > > Signed-off-by: Eduardo Silva <edsiper@gmail.com>
> > 
> > This quiets a warning of something that potentially looks like a real
> > bug.  Perhaps "new" should be const?
> 
> Although there is no real bug here, I hate these "hide the warning"
> patches.
> 
> The real solution is to change all the users into const *. This should
> be doable as the new and old pointers are not modified.
> 
> And remember:
> 
> 	char *changes;
> 	const char *no_changes;
> 
> 	no_changes = changes;  /* is OK! (no compiler warnings) */
> 
> 	changes = no_changes; /* is not OK. (compiler will warn). */
> 
> -- Steve

The following needs some testing, just compile tested for now.

>From 71d6e5971cc90a03fd2d7bf8aaa2b81932bd0c7c Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 23 May 2011 21:24:27 +0200
Subject: [PATCH] ftrace: Change unsigned char *new, *old to const
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This removes the warning:
arch/x86/kernel/ftrace.c: In function ¡ftrace_make_nop¢:
/arch/x86/kernel/ftrace.c:308: warning: assignment discards qualifiers from pointer target type

Steven Rostedt suggested to make these pointers const pointers.

This patch assumes that
https://patchwork.kernel.org/patch/798172/
is applied first.

Reported-by: Eduardo Silva <edsiper@gmail.com>
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kernel/ftrace.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0ba15a6..e4f23d1 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -123,7 +123,7 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 static atomic_t nmi_running = ATOMIC_INIT(0);
 static int mod_code_status;		/* holds return value of text write */
 static void *mod_code_ip;		/* holds the IP to write to */
-static void *mod_code_newcode;		/* holds the text to write to the IP */
+static const void *mod_code_newcode;	/* holds the text to write to the IP */
 
 static unsigned nmi_wait_count;
 static atomic_t nmi_update_count = ATOMIC_INIT(0);
@@ -225,7 +225,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 }
 
 static int
-do_ftrace_mod_code(unsigned long ip, void *new_code)
+do_ftrace_mod_code(unsigned long ip, const void *new_code)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -266,8 +266,8 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-		   unsigned char *new_code)
+ftrace_modify_code(unsigned long ip, const unsigned char *old_code,
+		   const unsigned char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 
@@ -301,7 +301,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	const unsigned char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_call_replace(ip, addr);
@@ -312,7 +312,7 @@ int ftrace_make_nop(struct module *mod,
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned char *new, *old;
+	const unsigned char *new, *old;
 	unsigned long ip = rec->ip;
 
 	old = ftrace_nop_replace();
-- 
1.7.2.3

---1463803646-1583054631-1306180886=:4933--
