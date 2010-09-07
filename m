Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0IGTmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:42:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1517 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0IGTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:41:59 -0400
Subject: Re: checkpatch problem
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100907180025.GD2662@shadowen.org>
References: <23323.1283864982@redhat.com>
	 <20100907180025.GD2662@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 12:41:57 -0700
Message-ID: <1283888517.23280.241.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 19:00 +0100, Andy Whitcroft wrote:
> On Tue, Sep 07, 2010 at 02:09:42PM +0100, David Howells wrote:
> > Checkpatch generates the following messages for inline asm strings:
> > WARNING: unnecessary whitespace before a quoted newline
> > #49: FILE: arch/m32r/include/asm/irqflags.h:31:
> > +               "ld24   %0, #0  ; Use 32-bit insn.                      \n\t"
> > however, inline asm is more readable if I can tabulate things, including the
> > newline markers:
> > 	asm volatile (
> > 		"ld24	%0, #0	; Use 32-bit insn.			\n\t"
> > 		"mvfc	%1, psw	; No interrupt can be accepted here.	\n\t"
> > 		"mvtc	%0, psw						\n\t"
> > 		"and3	%0, %1, #0xffbf					\n\t"
> > 		"mvtc	%0, psw						\n\t"
> > 		: "=&r" (tmpreg0), "=&r" (tmpreg1)
> > 		:
> > 		: "cbit", "memory");
> > Can you please fix it, even if it's only to permit multiple TAB chars before
> > '\n'.
> A tricky one to know how to detect it as different.  Often we do not
> have the asm markers to hint us to change style.  This affects us often
> as gcc abuses the meaning of almost every character and has different
> spacing for them too.

Maybe restrict the test to $logFunctions that have whitespace
before newlines?

Something like below.

Caveat: it doesn't necessarily report on the proper line.

For instance:
	printk(KERN_DEBUG "ABCDEF \n");
vs
	printk(KERN_DEBUG "ABC"
	       "DEF \n");

The second example reports the whitespace on the first line,
not the second line.

 scripts/checkpatch.pl |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..f2ae4d5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1419,11 +1419,6 @@ sub process {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
-# check for spaces before a quoted newline
-		if ($rawline =~ /^.*\".*\s\\n/) {
-			WARN("unnecessary whitespace before a quoted newline\n" . $herecurr);
-		}
-
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
@@ -2335,6 +2330,22 @@ sub process {
 			}
 		}
 
+# check for whitespace before newlines in logging functions
+
+		if ($line =~ /^.*$logFunctions/) {
+			my $ln = $linenr;
+			my $cnt = $realcnt;
+			my ($off, $dstat, $dcond, $rest);
+			($dstat, $dcond, $ln, $cnt, $off) =
+				ctx_statement_block($linenr, $realcnt, 0);
+			for (my $n = 0; $n < $cnt; $n++) {
+			    my $l = $rawlines[$ln-1+$n];
+			    if ($l =~ /\".*[ \t]\\n/) {
+				WARN("Logging function has unnecessary whitespace before a newline\n" . $herecurr);
+			    }
+			}
+		    }
+
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known good container


