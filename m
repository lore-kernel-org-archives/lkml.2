Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1JSQRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:17:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45160 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007Ab1JSQRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:17:37 -0400
Message-ID: <1319041056.14493.12.camel@Joe-Laptop>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, David Rientjes <rientjes@google.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 19 Oct 2011 09:17:36 -0700
In-Reply-To: <20111019112220.GG3217@pengutronix.de>
References: <4E9D9558.7040705@cam.ac.uk>
	 <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
	 <1318982469.7569.1.camel@Joe-Laptop>
	 <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
	 <4E9E89F2.2060103@cam.ac.uk> <20111019102630.GE3217@pengutronix.de>
	 <4E9EAEB7.6080601@cam.ac.uk> <20111019112220.GG3217@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 13:22 +0200, Wolfram Sang wrote:
> > Maybe something as simple as a comment in the checkpatch source
> > to say that such a file / directory can cause false positives?
> 
> I'd hope this error message would be clear enough, what do you think?
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3dfc471..19e4de7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1506,7 +1506,7 @@ sub process {
>  			if (!$file && $tree && $p1_prefix ne '' &&
>  			    -e "$root/$p1_prefix") {
>  				WARN("PATCH_PREFIX",
> -				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
> +				     "patch prefix '$p1_prefix' exists as file/directory. Make sure this isn't a -p0 patch\n");
>  			}
>  
>  			if ($realfile =~ m@^include/asm/@) {
> 

How about:

 scripts/checkpatch.pl |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2300964..6259b12 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1499,17 +1499,17 @@ sub process {
 			$realfile =~ s@^([^/]*)/@@;
 
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
+			my $patched_file = "$root/$1";
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
 
-			$p1_prefix = $1;
-			if (!$file && $tree && $p1_prefix ne '' &&
-			    -e "$root/$p1_prefix") {
+			if (!$file && $tree && $realfile ne '' &&
+			    -e "$patched_file") {
 				WARN("PATCH_PREFIX",
-				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+				     "patched file '$patched_file' exists, patch appears to be a -p0 patch\n");
 			}
 
-			if ($realfile =~ m@^include/asm/@) {
+			if ($patched_file =~ m@/include/asm/@) {
 				ERROR("MODIFIED_INCLUDE_ASM",
 				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}


