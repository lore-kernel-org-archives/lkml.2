Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1BNSHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:45646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1BNSHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:41 -0500
Date: Mon, 14 Feb 2011 13:54:17 GMT
From: tip-bot for Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, kamal@canonical.com, tglx@linutronix.de,
        rjw@sisk.pl, mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, kamal@canonical.com, tglx@linutronix.de,
        rjw@sisk.pl, mingo@elte.hu, len.brown@intel.com
In-Reply-To: <1296783486-23033-1-git-send-email-kamal@canonical.com>
References: <1296783486-23033-1-git-send-email-kamal@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Fix panic when handling "mem={invalid}" param
Message-ID: <tip-77eed821accf5dd962b1f13bed0680e217e49112@git.kernel.org>
Git-Commit-ID: 77eed821accf5dd962b1f13bed0680e217e49112
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77eed821accf5dd962b1f13bed0680e217e49112
Gitweb:     http://git.kernel.org/tip/77eed821accf5dd962b1f13bed0680e217e49112
Author:     Kamal Mostafa <kamal@canonical.com>
AuthorDate: Thu, 3 Feb 2011 17:38:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:15:43 +0100

x86: Fix panic when handling "mem={invalid}" param

Avoid removing all of memory and panicing when "mem={invalid}"
is specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on
platforms other than x86_32).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org> # .3x: as far back as it applies
LKML-Reference: <1296783486-23033-1-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/e820.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 294f26d..55a59d8 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -856,6 +856,9 @@ static int __init parse_memopt(char *p)
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
