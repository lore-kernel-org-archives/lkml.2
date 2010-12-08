Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LHAin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:38:43 -0500
Received: from kroah.org ([198.145.64.141]:54820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0LHAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:39 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:42 2010
Message-Id: <20101208000642.151033921@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nelson Elhage <nelhage@ksplice.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [26/44] do_exit(): make sure that we run with get_fs() == USER_DS
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nelson Elhage <nelhage@ksplice.com>

commit 33dd94ae1ccbfb7bf0fb6c692bc3d1c4269e6177 upstream.

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit().  do_exit may later (via mm_release in
fork.c) do a put_user to a user-controlled address, potentially allowing
a user to leverage an oops into a controlled write into kernel memory.

This is only triggerable in the presence of another bug, but this
potentially turns a lot of DoS bugs into privilege escalations, so it's
worth fixing.  I have proof-of-concept code which uses this bug along
with CVE-2010-3849 to write a zero to an arbitrary kernel address, so
I've tested that this is not theoretical.

A more logical place to put this fix might be when we know an oops has
occurred, before we call do_exit(), but that would involve changing
every architecture, in multiple places.

Let's just stick it in do_exit instead.

[akpm@linux-foundation.org: update code comment]
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1004,6 +1004,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	/*


