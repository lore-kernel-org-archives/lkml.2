Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0IOKCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:02:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:53722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0IOKCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:02:38 -0400
Date: Wed, 15 Sep 2010 10:01:56 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4c8f7a23.cae9d80a.2c11.0bb4@mx.google.com>
References: <4c8f7a23.cae9d80a.2c11.0bb4@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Avoid kernel crash when disabling watchdog
Message-ID: <tip-d9ca07a05ce1c42ac9717e54eaea4546a3a80978@git.kernel.org>
Git-Commit-ID: d9ca07a05ce1c42ac9717e54eaea4546a3a80978
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:01:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9ca07a05ce1c42ac9717e54eaea4546a3a80978
Gitweb:     http://git.kernel.org/tip/d9ca07a05ce1c42ac9717e54eaea4546a3a80978
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 14 Sep 2010 15:34:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:43:58 +0200

watchdog: Avoid kernel crash when disabling watchdog

In case you boot with the watchdog disabled, i.e., nowatchdog, then,
if you try to disable it via /proc/sys/kernel/watchdog, you get
a kernel crash. The reason is that you are trying to cancel a hrtimer
which has never been initialized.

This patch fixes this by skipping execution of
watchdog_disable_all_cpus() when the watchdog is marked
disabled from boot.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4c8f7a23.cae9d80a.2c11.0bb4@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index fa71aeb..89eadbb 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -473,6 +473,9 @@ static void watchdog_disable_all_cpus(void)
 {
 	int cpu;
 
+	if (no_watchdog)
+		return;
+
 	for_each_online_cpu(cpu)
 		watchdog_disable(cpu);
 
