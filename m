Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0LHBPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:15:01 -0500
Received: from kroah.org ([198.145.64.141]:33723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717Ab0LHBDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:30 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.018639160@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [236/289] x86: Ignore trap bits on single step exceptions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 6c0aca288e726405b01dacb12cac556454d34b2a upstream.

When a single step exception fires, the trap bits, used to
signal hardware breakpoints, are in a random state.

These trap bits might be set if another exception will follow,
like a breakpoint in the next instruction, or a watchpoint in the
previous one. Or there can be any junk there.

So if we handle these trap bits during the single step exception,
we are going to handle an exception twice, or we are going to
handle junk.

Just ignore them in this case.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=21332

Reported-by: Michael Stefaniuc <mstefani@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Alexandre Julliard <julliard@winehq.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hw_breakpoint.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -433,6 +433,10 @@ static int __kprobes hw_breakpoint_handl
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
+	/* If it's a single step, TRAP bits are random */
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;


