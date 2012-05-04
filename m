Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab2EDQp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:45:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41140 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751134Ab2EDQp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:45:26 -0400
Message-ID: <1336149924.7920.14.camel@joe2Laptop>
Subject: Re: [PATCH V2] checkpatch: add check for whitespace before
 semicolon at end-of-line
From: Joe Perches <joe@perches.com>
To: Eric Nelson <eric.nelson@boundarydevices.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        u-boot@lists.denx.de, rylv50@freescale.com, marex@denx.de,
        vapier@gentoo.org
Date: Fri, 04 May 2012 09:45:24 -0700
In-Reply-To: <1336147186-27853-1-git-send-email-eric.nelson@boundarydevices.com>
References: <1336147186-27853-1-git-send-email-eric.nelson@boundarydevices.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 08:59 -0700, Eric Nelson wrote:
> Requires --strict option during invocation:
> 	~/linux$ scripts/checkpatch --strict foo.patch
> 
> This tests for a bad habits of mine like this:
> 
> 	return 0 ;
> 
> Note that it does allow a special case of a bare semicolon
> for empty loops:
> 
> 	while (foo())
> 		;
> 
> ---
> V2 adds the special case and requirement for --strict based on
> recommendations of Joe Perches.
> 
>  scripts/checkpatch.pl |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a3b9782..e711122 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3227,6 +3227,12 @@ sub process {
>  			 "Statements terminations use 1 semicolon\n" . $herecurr);
>  		}
>  
> +# check for whitespace before semicolon - not allowed at end-of-line
> +		if ($line =~ /\S+\s+;$/) {
> +		    CHK("SPACING",
> +			 "Whitespace before semicolon\n" . $herecurr);

Hey Eric.

This is still a suboptimal test because it should
allow optional spacing after the semicolon before
the EOL.

	if ($line =~ /\S\s+;\s*$/)

I still think it's not really necessary to
check for end of line.  It'd also be OK to
report spacing issues on code like:

	for (i = 0 ; i < 100 ; i++)
and
	case foo: x = 1 ; break;

So maybe the test should be

	if ($line =~ /\S\s+;/)

But this test emits a CHK on lines
that add a line with just a ; so that
needs a small update to

	if ($line =~ /^\+.*\S\s+;/)

Also the test should probably be adjacent
to all the other "SPACING" tests so maybe:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cb08290..aadcfba 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2461,6 +2461,13 @@ sub process {
 				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
+
+# check for whitespace before a non-naked semicolon
+		if ($line =~ /^\+.*\S\s+;/) {
+			CHK("SPACING",
+			    "space prohibited before semicolon\n" . $herecurr);
+		}
+
 # Check operator spacing.
 		if (!($line=~/\#\s*include/)) {
 			my $ops = qr{


