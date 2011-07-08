Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1GHFDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1GHFDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.571305977@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Walls <awalls@md.metrocast.net>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [060/107] [media] lirc_zilog: fix spinning rx thread
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 6a8c97ac92461ec57e36b10572e78d4221e8faa8 upstream.

We were calling schedule_timeout with the rx thread's task state still
at TASK_RUNNING, which it shouldn't be. Make sure we call
set_current_state(TASK_INTERRUPTIBLE) *before* schedule_timeout, and
we're all good here. I believe this problem was mistakenly introduced in
commit 5bd6b0464b68d429bc8a3fe6595d19c39dfc4d95, and I'm not sure how I
missed it before, as I swear I tested the patchset that was included in,
but alas, stuff happens...

Acked-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/lirc/lirc_zilog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -475,14 +475,14 @@ static int lirc_thread(void *arg)
 	dprintk("poll thread started\n");
 
 	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		/* if device not opened, we can sleep half a second */
 		if (atomic_read(&ir->open_count) == 0) {
 			schedule_timeout(HZ/2);
 			continue;
 		}
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		/*
 		 * This is ~113*2 + 24 + jitter (2*repeat gap + code length).
 		 * We use this interval as the chip resets every time you poll


