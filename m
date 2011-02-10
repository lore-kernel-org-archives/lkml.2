Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1BJOnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:43:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab1BJOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:43:21 -0500
Date: Thu, 10 Feb 2011 14:42:53 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, pebolle@tiscali.nl, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, pebolle@tiscali.nl, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1297278153-21111-1-git-send-email-dzickus@redhat.com>
References: <1297278153-21111-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog, nmi: Lower the severity of error messages
Message-ID: <tip-5651f7f47dbb1cf2b95a60582546db4ff508e2b4@git.kernel.org>
Git-Commit-ID: 5651f7f47dbb1cf2b95a60582546db4ff508e2b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Feb 2011 14:42:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5651f7f47dbb1cf2b95a60582546db4ff508e2b4
Gitweb:     http://git.kernel.org/tip/5651f7f47dbb1cf2b95a60582546db4ff508e2b4
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 9 Feb 2011 14:02:33 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Feb 2011 13:21:59 +0100

watchdog, nmi: Lower the severity of error messages

During boot if the hardlockup detector fails to initialize, it
complains very loudly.  Some failures should be expected under
certain situations, ie no lapics, or resource in-use.  Tone
those error messages down a bit.  Keep the rest at a high level.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1297278153-21111-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f37f974..18bb157 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -363,8 +363,14 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
-	       cpu, PTR_ERR(event));
+
+	/* vary the KERN level based on the returned errno */
+	if (PTR_ERR(event) == -EOPNOTSUPP)
+		printk(KERN_INFO "NMI watchdog disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
+	else if (PTR_ERR(event) == -ENOENT)
+		printk(KERN_WARNING "NMI watchdog disabled (cpu%i): hardware events not enabled\n", cpu);
+	else
+		printk(KERN_ERR "NMI watchdog disabled (cpu%i): unable to create perf event: %ld\n", cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
