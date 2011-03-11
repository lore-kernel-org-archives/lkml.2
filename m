Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1CKJ0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:26:20 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59936 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898Ab1CKJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:26:15 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 11 Mar 2011 10:28:11 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc8
Message-ID: <20110311092811.GA2079@polaris.bitmath.org>
References: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Pxyaz-0001z4-BL.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Pxyaz-0001z4-BL 66fa6d58e7b50f01b7850646f3206347
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:40:04PM -0800, Linus Torvalds wrote:
> I would have been ok with releasing this as the final 38, but I'm
> going to be partially unreachable for several days next week, so I
> felt there was no point in opening the merge window yet.
> 
> Also, we do have regressions. Some of them hopefully fixed here, but
> it won't hurt to give it another week.
> 
> Not everything here is strictly a regression: the i_nlink fixes are
> long-standing races (very unlikely ones, admittedly), and the alpha
> updates just convert the irq chip descriptions so that we can enable
> GENERIC_HARDIRQS_NO_DEPRECATED on alpha too. But most everything is
> pretty simple, and the diffstat is fairly flat with nothing huge that
> stands out.
> 
> 40% drivers, 35% arch updates (alpha and arm), with the rest being fs,
> net and some block layer updates.
> 
> So please keep testing,

Hi Linus,

I stumbled upon this problem when a dkms package install claimed to
already have the latest version of a module, only it clearly did not.

It turns out the module srcversion is not unique. Doing a

cat /sys/module/*/srcversion | sort | uniq -c

shows something like this:

mainline>cat /sys/module/*/srcversion | sort | uniq -c
      1 3EF20C25CC62BD750F4C3F3
      1 41024DA8E830C7DAE171017
      1 47AD35AE180473EB06EED32
     19 533BB7E5866E52F63B9ACCB
      1 598C709DDDAB55EB331379A
      1 5AC5CB9DA8C242CBC76EEC0
      1 AAD974CC23F320629986F38
      2 AEBBDFD273E0316FD4E5D04
      [...]

Bisecting leads to this commit

commit b7bd182176960fdd139486cadb9962b39f8a2b50
Author: Michal Marek <mmarek@suse.cz>

    fixdep: Do not record dependency on the source file itself

which seems to be a change to the build system. Reverting followed by
"make clean" cures the symptoms, and all module srcversions are again
unique. Just doing make after the revert does not work, which seems
reasonable. However, I can't even begin to imagine what the real
reason is.

The patch below is what fixes it for me.

Thanks,
Henrik

---

>From 0004c5bdc44c22646269756b0e0bbff1a7a30ac3 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Fri, 11 Mar 2011 09:54:33 +0100
Subject: [PATCH] Revert "fixdep: Do not record dependency on the source file itself"

In 2.6.38-rc8, the module srcversion is not unique. Doing a

cat /sys/module/*/srcversion | sort | uniq -c

shows something like this:

mainline>cat /sys/module/*/srcversion | sort | uniq -c
      1 3EF20C25CC62BD750F4C3F3
      1 41024DA8E830C7DAE171017
      1 47AD35AE180473EB06EED32
     19 533BB7E5866E52F63B9ACCB
      1 598C709DDDAB55EB331379A
      1 5AC5CB9DA8C242CBC76EEC0
      1 AAD974CC23F320629986F38
      2 AEBBDFD273E0316FD4E5D04
      [...]

Bisecting leads to this commit

commit b7bd182176960fdd139486cadb9962b39f8a2b50
Author: Michal Marek <mmarek@suse.cz>

    fixdep: Do not record dependency on the source file itself

which is a change to the build system. Reverting followed by "make
clean" cures the symptoms and all module srcversions are unique. Just
doing make after the revert does not work.

I can't even begin to imagine what the real reason is.

This reverts commit b7bd182176960fdd139486cadb9962b39f8a2b50.
---
 scripts/basic/fixdep.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 6c94c6c..c9a16ab 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -315,7 +315,6 @@ static void parse_dep_file(void *map, size_t len)
 	char *end = m + len;
 	char *p;
 	char s[PATH_MAX];
-	int first;
 
 	p = strchr(m, ':');
 	if (!p) {
@@ -328,7 +327,6 @@ static void parse_dep_file(void *map, size_t len)
 
 	clear_config();
 
-	first = 1;
 	while (m < end) {
 		while (m < end && (*m == ' ' || *m == '\\' || *m == '\n'))
 			m++;
@@ -342,17 +340,9 @@ static void parse_dep_file(void *map, size_t len)
 		if (strrcmp(s, "include/generated/autoconf.h") &&
 		    strrcmp(s, "arch/um/include/uml-config.h") &&
 		    strrcmp(s, ".ver")) {
-			/*
-			 * Do not output the first dependency (the
-			 * source file), so that kbuild is not confused
-			 * if a .c file is rewritten into .S or vice
-			 * versa.
-			 */
-			if (!first)
-				printf("  %s \\\n", s);
+			printf("  %s \\\n", s);
 			do_config_file(s);
 		}
-		first = 0;
 		m = p + 1;
 	}
 	printf("\n%s: $(deps_%s)\n\n", target, target);
-- 
1.7.4.1

