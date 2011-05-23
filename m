Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1EWNdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:20 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:45942 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab1EWNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:33:17 -0400
X-AuditID: 12074425-b7b78ae000007e02-44-4dda621e2b3e
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 8/8] x86-64: Optimize vDSO time()
Date: Mon, 23 May 2011 09:31:31 -0400
Message-Id: <40e2700f8cda4d511e5910be1e633025d28b36c2.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsUixCmqrSuXdMvX4HODrMXFtotsFn1XjrJb
	HLn2nd3iYuM2Fos551tYLPa9P8tmcXnXHDaLLZeaWS02b5rKbPGo7y27xY8Nj1kduD26H31i
	9LjylMNjy8qbTB632v4we8zf+ZHRY+esu+wem1Z1snm8O3eO3ePEjN8sHp83yQVwRXHZpKTm
	ZJalFunbJXBl9C1awlawk71i65bD7A2MC9i6GDk5JARMJBas72KFsMUkLtxbDxTn4hAS2Mco
	MXv9elYIZwOjxOHZJxghnGdMEruWrwFrZxNQkehY+oCpi5GDQ0RASGLp3TqQGmaBtcwS+7oX
	M4HUCAOtOHulgRHEZhFQldix5AALiM0rECRx7NpjqNUKEleuzAOLcwoYSMzffRLMFhLQl5h0
	dClO8QmMAgsYGVYxyqbkVunmJmbmFKcm6xYnJ+blpRbpWujlZpbopaaUbmIERQK7i+oOxgmH
	lA4xCnAwKvHwLta86SvEmlhWXJl7iFGSg0lJlNcl/pavEF9SfkplRmJxRnxRaU5q8SFGCQ5m
	JRHeBu0bvkK8KYmVValF+TApaQ4WJXHe+ZLqvkIC6YklqdmpqQWpRTBZGQ4OJQnetESgoYJF
	qempFWmZOSUIaSYOTpDhPEDDg0BqeIsLEnOLM9Mh8qcYdTmm3v59gFGIJS8/L1VKnDcOpEgA
	pCijNA9uDiyBvWIUB3pLmDcApIoHmPzgJr0CWsIEtETi702QJSWJCCmpBkbT0muJtk2VZ/dp
	HBNfYzC36Ull6TU9kQipr74ZDPNMz/JuEvkc/nOK39bbQareN3JarDOXrnNr9TnIbr/y36qQ
	nCnHn/qZbJr6rMjc1kX/ZfO9CQ3zdA6uv5Y5h6Py96Ut4qu1d1ZEfDo0n2HGlJql3cxCDh43
	3Q127J43ySEvWks0/rh9bIgSS3FGoqEWc1FxIgBziwdXOwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function just reads a 64-bit variable that's updated
atomically, so we don't need any locks.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vclock_gettime.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index e6e9f90..a69929e 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -180,12 +180,8 @@ notrace time_t __vdso_time(time_t *t)
 	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
 		return time_syscall(t);
 
-	do {
-		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
-
-		result = VVAR(vsyscall_gtod_data).wall_time_sec;
-
-	} while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq));
+	/* This is atomic on x86_64 so we don't need any locks. */
+	result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
 
 	if (t)
 		*t = result;
-- 
1.7.5.1

