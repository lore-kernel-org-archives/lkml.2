Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2BETBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:01:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58079 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755144Ab2BETBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:01:30 -0500
Message-ID: <1328468489.7008.70.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Add line-length options, set default to 100
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Sun, 05 Feb 2012 11:01:29 -0800
In-Reply-To: <20120205181349.GA24281@elte.hu>
References: <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop> <20120204130330.GA30198@elte.hu>
	 <1328372536.5766.3.camel@joe2Laptop> <20120204180237.GA7682@elte.hu>
	 <1328381300.5996.2.camel@joe2Laptop>
	 <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
	 <1328383659.7008.7.camel@joe2Laptop> <20120205113821.GA22399@elte.hu>
	 <1328458885.7008.58.camel@joe2Laptop> <20120205181349.GA24281@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

80 column line lengths can be a bit constraining.

Make the default 100 and still emit a warning
when that length is exceeded.

When option --strict is set, emit a check when
the length is > 80 too.

Add a command line option --line-length to set
the standard line length allowed.

Using command line option --ignore=LINE_LENGTH
will not emit any line-length messages.

Adding a .checkpatch.conf file with appropriate
command line options would also avoid line-length
messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2b52aeb..6923270 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -34,6 +34,9 @@ my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
 
+my $max_line_length_warn = 100;		# normal cases
+my $max_line_length_strict = 80;	# when using --strict
+
 sub help {
 	my ($exitcode) = @_;
 
@@ -50,6 +53,7 @@ Options:
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --line-length=val          set line length to emit a warning when exceeded
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
@@ -105,6 +109,7 @@ GetOptions(
 	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
+	'line-length=i'	=> \$max_line_length_warn,
 	'ignore=s'	=> \@ignore,
 	'show-types!'	=> \$show_types,
 	'root=s'	=> \$root,
@@ -1726,15 +1731,19 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+# check line length limits
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
-		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
-		{
-			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/)) {
+			if ($length > $max_line_length_strict) {
+				CHK("LONG_LINE",
+				    "line longer than $max_line_length_strict characters\n" . $herecurr);
+			}
+			if ($length > $max_line_length_warn) {
+				WARN("LONG_LINE",
+				     "line longer than $max_line_length_warn characters\n" . $herecurr);
+			}
 		}
 
 # check for spaces before a quoted newline


