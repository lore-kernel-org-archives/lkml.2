Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2H2G27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:28:59 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:38897 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2H2G26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:28:58 -0400
From: Jim Meyering <jim@meyering.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied command
In-Reply-To: <20120828202459.GA13638@mwanda> (Dan Carpenter's message of "Tue,
	28 Aug 2012 13:24:59 -0700")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-4-git-send-email-jim@meyering.net>
	<20120824102725.GH7585@arm.com> <876288o7ny.fsf@rho.meyering.net>
	<20120828202459.GA13638@mwanda>
Date: Wed, 29 Aug 2012 08:28:47 +0200
Message-ID: <874nnm6wkg.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On Fri, Aug 24, 2012 at 01:23:29PM +0200, Jim Meyering wrote:
>> In that case, what would you think of a patch to use strcpy instead?
>>
>>   -		strncpy(object->comm, current->comm, sizeof(object->comm));
>>   +		strcpy(object->comm, current->comm);
>
> Another option would be to use strlcpy().  It's slightly neater than
> the strncpy() followed by a NUL assignment.
>
>> Is there a preferred method of adding a static_assert-like statement?
>> I see compile_time_assert and a few similar macros, but I haven't
>> spotted anything that is used project-wide.
>
> BUILD_BUG_ON().

Hi Dan,

Thanks for the feedback and tip.  How about this patch?

-- >8 --
Subject: [PATCH] kmemleak: remove unwarranted uses of strncpy

Use of strncpy was not justified -- was misleading, in fact, since
none of the three uses could trigger strncpy's truncation feature,
nor did they require the NUL-padding it can provide.  Replace each
use with a BUG_ON_BUILD to ensure that the existing constraint
(source string is no larger than the size of the destination buffer)
and a use of strcpy.  With the literals, it's easy to see that each
is shorter than TASK_COMM_LEN (aka, 16).  In the third case, the
source and destination buffer have the same length, so there is no
possibility of truncation.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 mm/kmemleak.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..7359ffa 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -542,10 +542,12 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	/* task information */
 	if (in_irq()) {
 		object->pid = 0;
-		strncpy(object->comm, "hardirq", sizeof(object->comm));
+		BUILD_BUG_ON(sizeof "hardirq" > sizeof(current->comm));
+		strcpy(object->comm, "hardirq");
 	} else if (in_softirq()) {
 		object->pid = 0;
-		strncpy(object->comm, "softirq", sizeof(object->comm));
+		BUILD_BUG_ON(sizeof "softirq" > sizeof(current->comm));
+		strcpy(object->comm, "softirq");
 	} else {
 		object->pid = current->pid;
 		/*
@@ -554,7 +556,8 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 		 * dependency issues with current->alloc_lock. In the worst
 		 * case, the command line is not correct.
 		 */
-		strncpy(object->comm, current->comm, sizeof(object->comm));
+		BUILD_BUG_ON(sizeof (object->comm) > sizeof(current->comm));
+		strcpy(object->comm, current->comm);
 	}

 	/* kernel backtrace */
--
1.7.12.116.g31e0100
