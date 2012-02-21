Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2BUU7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:59:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55525 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755406Ab2BUU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:59:23 -0500
Message-ID: <1329857959.5143.11.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Add some --strict coding style checks
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: andrei.emeltchenko.news@gmail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 12:59:19 -0800
In-Reply-To: <20120221.154053.2103818562080068513.davem@davemloft.net>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument alignment across multiple lines should
match the open parenthesis.

Logical continuations should be at the end of
the previous line, not the start of a new line.

These are not required by CodingStyle so make the
tests active only when using --strict.

Tested with:
int foo(void)
{
	if (foo &&
	    bar())
		baz();

	if (foo &&
	     bar())
		baz();

	foo_some_long_function(bar,
			       baz);

	foo_some_long_function(bar,
		baz);

	return 0;
}

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..629944e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1783,6 +1783,28 @@ sub process {
 			     "please, no space before tabs\n" . $herevet);
 		}
 
+# check for && or || at the start of a line
+		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
+			CHK("LOGICAL_CONTINUATIONS",
+			    "Logical continuations should be on the previous line\n" . $hereprev);
+		}
+
+# check multi-line statement indentation matches previous line
+		if ($prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/ && $rawline =~ /^\+([ \t]*)/) {
+			$prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/;
+			my $oldindent = $1;
+			my $if_or_func = $2;
+			$rawline =~ /^\+([ \t]*)/;
+			my $newindent = $1;
+			my $goodindent = $oldindent .
+					 "\t" x (length($if_or_func) / 8) .
+					 " "  x (length($if_or_func) % 8);
+			if ($newindent ne "$goodindent") {
+				CHK("PARENTHESIS_ALIGNMENT",
+				    "Alignment should match open parenthesis\n" . $hereprev);
+			}
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments


