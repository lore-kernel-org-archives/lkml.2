Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2HBP04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 11:26:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54532 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750786Ab2HBP0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:26:55 -0400
Message-ID: <1343921213.2011.9.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Add control statement test to
 SINGLE_STATEMENT_DO_WHILE_MACRO
From: Joe Perches <joe@perches.com>
To: Schrober <franzschrober@yahoo.de>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Aug 2012 08:26:53 -0700
In-Reply-To: <20120802142053.GH2501@dm>
References: <4204029.7cYAuJfu4T@bentobox> <20120802142053.GH2501@dm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b13edf7ff2d ("checkpatch: add checks for do {} while (0) macro misuses")
added a test that is overly simplistic for single statement macros.

Macros that start with control tests should be enclosed
in a do {} while (0) loop.

Add the necessary control tests to the check.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2012-08-02 at 15:20 +0100, Andy Whitcroft wrote:
> On Thu, Aug 02, 2012 at 10:00:04AM +0200, Schrober wrote:
> > Hi,

Hello and thanks for the report.

> > I think your check for SINGLE_STATEMENT_DO_WHILE_MACRO is wrong.

And you are correct.

> It does appear this check should not apply when a control statement is
> included.

The patch below is tested with:
$ cat t.c

#define bar_1(foo)				\
	if (foo)				\
		baz();				\

#define bar_2(foo)				\
do {						\
	if (foo)				\
		baz();				\
} while (0)

#define bar_3(foo)				\
do {						\
	baz();					\
} while (0)

#define bar_4(foo)				\
do {						\
	baz();					\
} while (0);

#define bar_5(foo)				\
do {						\
	while (foo)				\
		baz();				\
} while (0)

#define bar_6(foo)				\
do {						\
	switch (foo) {				\
	case 1:					\
		baz();				\
	}					\
} while (0)

$

So perhaps...

 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 913d6bd..ca05ba2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3016,7 +3016,8 @@ sub process {
 					$herectx .= raw_line($linenr, $n) . "\n";
 				}
 
-				if (($stmts =~ tr/;/;/) == 1) {
+				if (($stmts =~ tr/;/;/) == 1 &&
+				    $stmts !~ /^\s*(if|while|for|switch)\b/) {
 					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
 					     "Single statement macros should not use a do {} while (0) loop\n" . "$herectx");
 				}


