Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0HRXio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:38:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1186 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab0HRXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:38:43 -0400
Subject: Re: add memset checks to checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100818221721.GA2667@redhat.com>
References: <20100818204016.GA29640@redhat.com>
	 <1282167133.6724.165.camel@Joe-Laptop> <20100818214818.GA31094@redhat.com>
	 <1282168679.6724.174.camel@Joe-Laptop>  <20100818221721.GA2667@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 16:38:41 -0700
Message-ID: <1282174721.6724.202.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 18:17 -0400, Dave Jones wrote:
> On Wed, Aug 18, 2010 at 02:57:59PM -0700, Joe Perches wrote:
>  > > I'm all for improving my shoddy perl where possible, but this doesn't seem to actually
>  > > catch any of the test cases I wrote.  (it's also missing a } )
>  > I intend never to be a perl monk.
>  > I notice the missing { before the elsif after I sent it.
>  > Oh well.
>  > I just typed it in the emailer, so it's not tested at all.
>  > Also it's missing a $ after 1 in the second $memset_size test.
> still didn't catch anything for me.
>  > What are your test cases anyway?
> 
> memset(foo, 0, 10);
> memset(foo, 10, 0);
> memset(foo, 1, 10);
> memset(foo, 10, 1);
> 
>  > Likely $Lval isn't matching things like
>  > sizeof(*foo) so this isn't checked:
>  > 
>  > 	memset(foo, bar, sizeof(*foo));
> 
> I chose to just ignore any non integer arguments to keep things simple.

This seems to work.

I think $FuncArg is not great though.

Because $FuncArg uses $match_balanced_parens, the
match list args are unexpected.

$2, $4, and $6 are the args of any memset argument
that uses style func(args)

ie: memset(addr(foo), val(bar), sizeof(*foo))

Andy, what do you think?

Not-signed-off-by: Joe Perches

---
 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..af7a4f9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -172,6 +172,10 @@ our $Operators	= qr{
 			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
 		  }x;
 
+our $match_balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+our $Function	= qr{(?:$Ident\s*$match_balanced_parens)};
+our $FuncArg	= qr{(?:$Lval|$Constant|$Function)};
+
 our $NonptrType;
 our $Type;
 our $Declare;
@@ -2655,6 +2659,20 @@ sub process {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# Check for misused memsets
+
+		if ($line =~ /^\+.*\bmemset\s*\(\s*($FuncArg)\s*,\s*($FuncArg)\s*,\s*($FuncArg)\s*\)/) {
+			my $memset_addr = $1;
+			my $memset_val = $3;
+			my $memset_size = $5;
+
+			if ($memset_size =~ /^(0x|)0$/i) {
+				ERROR("memset uses second argument as constant byte value, not third.\n" . $herecurr);
+			} elsif ($memset_size =~ /^(0x|)1$/i) {
+				WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)


