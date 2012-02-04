Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2BDNEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:04:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2BDNEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:04:13 -0500
Date: Sat, 4 Feb 2012 14:03:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation, remove
 80col warning
Message-ID: <20120204130330.GA30198@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu>
 <20120203100743.GA3334@elte.hu>
 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
 <1328311239.21255.24.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328311239.21255.24.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Overly indented code should be refactored.

_AND_ the 80 cols warning should be removed. The overwhelming 
majority of developers either ignore the 80 cols warning or make 
the code worse as a result of the warning.

So something like the patch below.

Thanks,

	Ingo

--------------------->
Subject: checkpatch: Warn on code with 6+ tab indentation, remove 80col warning

It's better to warn about too deeply indented code than about 
too long lines, as the too long line tends to cause people to 
think about *that line*, instead of the surrounding code, fixing 
it by breaking the line unnecessarily, etc.

If we warn about too deep indentation then the fix will be a 
natural one: people will reduce code complexity, which is an 
almost black and white good thing.

The few false positives can be ignored.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..5406011 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1726,17 +1726,6 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
-		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
-		{
-			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
-		}
-
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
@@ -1924,6 +1913,12 @@ sub process {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
+
+			if ($line =~ /^\+\t{6,}/) {
+				WARN("DEEP_INDENTATION",
+				     "Too many leading tabs - code should probably be split up\n" . $herecurr);
+			}
+
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 
