Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2BDT1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 14:27:44 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46521 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754147Ab2BDT1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 14:27:43 -0500
Message-ID: <1328383659.7008.7.camel@joe2Laptop>
Subject: Re: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation,
 remove 80col warning
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Date: Sat, 04 Feb 2012 11:27:39 -0800
In-Reply-To: <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
References: <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
	 <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop> <20120204130330.GA30198@elte.hu>
	 <1328372536.5766.3.camel@joe2Laptop> <20120204180237.GA7682@elte.hu>
	 <1328381300.5996.2.camel@joe2Laptop>
	 <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-04 at 20:54 +0200, Pekka Enberg wrote:
> On Sat, Feb 4, 2012 at 8:48 PM, Joe Perches <joe@perches.com> wrote:
> > There are some truly _ugly_ > 80 char lines that
> > people attempt where checkpatch should issue some
> > "don't do that" message.
> 
> The practical downsides of the current warning are much more severe. I
> personally don't use checkpatch much these days because of the silly
> fixed limit.

More likely you developed a keen sense of
kernel style appropriateness and don't need
any checkpatch nannying.

I don't disagree with something like setting
the normally allowed line length to 100 and
maybe keeping a --strict limit to 80.

Something like:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2b52aeb..7602bce 100755
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
 
@@ -1726,15 +1729,19 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+# check line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
-		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
-		    $length > 80)
-		{
-			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) {
+			if ($length > $max_line_len_strict) {
+				CHK("LONG_LINE",
+				     "line over $max_line_len_strict characters\n" . $herecurr);
+			}
+			if ($length > $max_line_len_warn) {
+				WARN("LONG_LINE",
+				     "line over $max_line_len_warn characters\n" . $herecurr);
+			}
 		}
 
 # check for spaces before a quoted newline


