Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1GVVXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:23:23 -0400
Received: from claw.goop.org ([74.207.240.146]:45078 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1GVVXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:23:22 -0400
Message-ID: <4E29CF51.60600@goop.org>
Date: Fri, 22 Jul 2011 12:28:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/8] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <aa0d82c6e7a1c22a941da0df3c4ba58fea375074.1308878118.git.jeremy.fitzhardinge@citrix.com> <4E050704.3070409@zytor.com> <4E05128D.4020000@goop.org> <4E29C241.70102@zytor.com>
In-Reply-To: <4E29C241.70102@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 11:32 AM, H. Peter Anvin wrote:
> On 06/24/2011 03:41 PM, Jeremy Fitzhardinge wrote:
>> On 06/24/2011 02:52 PM, H. Peter Anvin wrote:
>>> These should be asm volatile, I believe.
>> OK.
>>
>>     J
> You still owe me a new patch here, I believe...

Ah, yes, though I don't think it can make a difference in practice,
since the caller contains barrier()s on either side.  And the non-asm
non-locked variant has no equivalent.  But it can't hurt.

    J

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 22 Jul 2011 12:27:14 -0700
Subject: [PATCH] x86/ticketlocks: make asms volatile to be extra sure

Make the locked-unlock asms volatile, just to be extra sure they won't wander away.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 2d14e7c..05fd59e 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -36,11 +36,11 @@
 static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
 {
 	if (sizeof(lock->tickets.head) == sizeof(u8))
-		asm (LOCK_PREFIX "incb %0"
-		     : "+m" (lock->tickets.head) : : "memory");
+		asm volatile (LOCK_PREFIX "incb %0"
+			      : "+m" (lock->tickets.head) : : "memory");
 	else
-		asm (LOCK_PREFIX "incw %0"
-		     : "+m" (lock->tickets.head) : : "memory");
+		asm volatile (LOCK_PREFIX "incw %0"
+			      : "+m" (lock->tickets.head) : : "memory");
 
 }
 #else


