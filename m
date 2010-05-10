Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab0EJXBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:01:24 -0400
Received: from kroah.org ([198.145.64.141]:51757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883Ab0EJW6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.384795492@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [44/98] x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 7ce5a2b9bb2e92902230e3121d8c3047fab9cb47 upstream.

When we do a thread switch, we clear the outgoing FS/GS base if the
corresponding selector is nonzero.  This is taken by __switch_to() as
an entry invariant; it does not verify that it is true on entry.
However, copy_thread() doesn't enforce this constraint, which can
result in inconsistent results after fork().

Make copy_thread() match the behavior of __switch_to().

Reported-and-tested-by: Samuel Thibault <samuel.thibault@inria.fr>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4BD1E061.8030605@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -295,11 +295,10 @@ int copy_thread(unsigned long clone_flag
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
-	p->thread.fs = me->thread.fs;
-	p->thread.gs = me->thread.gs;
-
 	savesegment(gs, p->thread.gsindex);
+	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
 	savesegment(fs, p->thread.fsindex);
+	p->thread.fs = p->thread.fsindex ? 0 : me->thread.fs;
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 


