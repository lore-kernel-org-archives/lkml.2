Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0LWIMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:12:14 -0500
Received: from smtp.nokia.com ([147.243.128.26]:60011 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0LWIMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:12:14 -0500
Message-ID: <4D130452.2010706@nokia.com>
Date: Thu, 23 Dec 2010 10:12:02 +0200
From: =?UTF-8?B?SnVoYW5pIE3DpGtlbMOk?= <ext-juhani.3.makela@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Kprobe: Fixed a leak when a retprobe entry function returns
 non-zero
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sirs,

Here is a little fix I found necessary to implement in order to perform
some probing:

----
A kretprobe can install an optional entry probe that is called when
the probed function is entered. If the callback returns non zero,
the return probe will not be called and the instance is forgotten.
However, the allocated instance of struct kretprobe_instance was
not returned in the free_instances list. Fixed this by returning
the unused instance to the free list if it was not needed.
---
 kernel/kprobes.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5240d75..69d0ca9 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -971,8 +971,16 @@ static int __kprobes pre_handler_kretprobe(struct
kprobe *p,
 		ri->rp = rp;
 		ri->task = current;

-		if (rp->entry_handler && rp->entry_handler(ri, regs))
+		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
+			/*
+			 * Restore the instance to the free list
+			 * if it is not needed any more.
+			 */
+			spin_lock_irqsave(&rp->lock, flags);
+			hlist_add_head(&ri->hlist, &rp->free_instances);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
+		}

 		arch_prepare_kretprobe(ri, regs);
----

I'm not at all positive that this is the right fix, but at least in our
environment it seems to help. Here is some background info:

We have implemented a kernel module that implements capability check
tracing by adding a kretprobe in the "capable" function. Every time a
capability check is made, it gathers some data about the process being
checked, the capability number and the result of the check. If the check
comes with current->mm == NULL, it's disregarded by the tracer to avoid
unnecessary overhead, and the entry_handler returns value 1.

Normally this works fine, but this week we noticed that if the module is
compiled in and activated in an early phase in the boot it doesn't work
at all. It appeared that our entry_handler was called as many times as
was set in the maxactive field of the registered probe, and every time
it returned 1 because current->mm was NULL in all of the calls. Then no
more callbacks were made. When the probe was de-registered, the nmissed
counter had a large value (>6000), and after registering it again the
probing started to work.

This made me suspect a resource leak, and as far as I can see there
indeed is one in kprobe.c::pre_handler_kretprobe. The fix above solved
the problem and seems not to have any undesired side effects.

We are using kernel version 2.6.32, but it seems to me that the same
problem exists in more current kernels judging by a quick look.

Why the problem manifests itself only if the tracing is enabled early in
the boot I cannot say. Could it be that if the entry_handler returns 0
at least once before the free list has been exhausted, it resets the
situation somehow? Or is it that after some point after userspace
initialization current->mm is never NULL?

The capability tracing module itself is ment for upstream, but I have
been told its code is not kernel quality (not enough comments) and the
implementation lacks obvious features so we have not dared to offer it
yet. It is used for defining profiles for daemon processes currently
running as root by checking what capabilities they actually need and
then assigning them only those, in the context of the MSSF security
framework project:

http://conference2010.meego.com/session/mobile-simplified-security-framework-overview

In case you are interested I'm happy to make the code and documentation
available at the forum of your choice.

Yours sincerely,
Juhani Mäkelä
Nixu OPEN - https://www.nixuopen.org
