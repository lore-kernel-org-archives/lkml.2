Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2KFUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:00:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2KFUA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:00:28 -0500
Date: Tue, 6 Nov 2012 12:00:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Add a --strict test for macro argument
 reuse
Message-Id: <20121106120027.94648924.akpm@linux-foundation.org>
In-Reply-To: <1352198139.16194.21.camel@joe-AO722>
References: <1352198139.16194.21.camel@joe-AO722>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2012 02:35:39 -0800
Joe Perches <joe@perches.com> wrote:

> Add a test for reuse of macro arguments to highlight
> any possible side-effects from this reuse.
> 
> Avoid this check on token name pasting and when the
> argument is used in a typeof or a __builtin.

Does this mean that if I do

	#define foo(a) bar(a, a)

that checkpatch will not generate a warning unless I give it
"--strict"?  If so: whaaah!  I want that warning to come out by
default.

Not being totally lazy, I tried it myself but my perl v5.10.1 had
conniptions over this patch:

akpm:/usr/src/25> perl scripts/checkpatch.pl -f a.c
Illegal character in prototype for main::CHECK : "MACRO_ARG_REUSE","Macroargumentreuse'$arg'-possibleside-effects?\n"."$herectx" at scripts/checkpatch.pl line 3039.
syntax error at scripts/checkpatch.pl line 3039, near ""Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx")"
  (Might be a runaway multi-line () string starting on line 3038)
syntax error at scripts/checkpatch.pl line 3045, near "} else"
Global symbol "$herecurr" requires explicit package name at scripts/checkpatch.pl line 3049.
syntax error at scripts/checkpatch.pl line 3051, near "}"
Global symbol "$realfile" requires explicit package name at scripts/checkpatch.pl line 3057.
Global symbol "$line" requires explicit package name at scripts/checkpatch.pl line 3058.
Global symbol "$realcnt" requires explicit package name at scripts/checkpatch.pl line 3060.
Global symbol "$realcnt" requires explicit package name at scripts/checkpatch.pl line 3064.
Global symbol "$here" requires explicit package name at scripts/checkpatch.pl line 3075.
syntax error at scripts/checkpatch.pl line 3091, near "}"
scripts/checkpatch.pl has too many errors.

<looks at the patch>

<fixes it>

--- a/scripts/checkpatch.pl~checkpatch-add-a-strict-test-for-macro-argument-reuse-fix
+++ a/scripts/checkpatch.pl
@@ -3035,7 +3035,7 @@ sub process {
 				$tmp =~ s/\b$arg\s*\#\#//g;
 				my $use_cnt = $tmp =~ s/\b$arg\b//g;
 				if ($use_cnt > 1) {
-					CHECK("MACRO_ARG_REUSE",
+					ERROR("MACRO_ARG_REUSE",
 					      "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
 				}
 			}
_


Ah, good:

akpm:/usr/src/25> perl scripts/checkpatch.pl -f a.c
ERROR: Macro argument reuse 'a' - possible side-effects?
#1: FILE: a.c:1:
+#define foo(a) bar(a, a)

total: 1 errors, 0 warnings, 1 lines checked

a.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


So what's all this stuff about "--strict" in the patch title?
