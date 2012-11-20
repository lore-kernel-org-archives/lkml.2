Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2KTO3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:29:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2KTO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:29:09 -0500
Date: Tue, 20 Nov 2012 14:29:06 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
Message-ID: <20121120142906.GD7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 12:20:18AM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> debugfs_remove() and  debugfs_remove_recursive() can take a NULL, so let's check and warn about that.
> 
> Changes since v3, as Joe Perches suggested:
> - removed redundant check
> 
> Changes since v2, as Joe Perches suggested:
> - match whitespace around argument
> 
> Changes since v1, as Joe Perches suggested:
> - added debugfs_remove_recursive
> - all tests for patterns are "if (a) xxx(a)" are consolidated
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
>  scripts/checkpatch.pl |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f18750e..76ad9f2 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3213,21 +3213,25 @@ sub process {
>  				$herecurr);
>  		}
>  
> +# check for needless "if (<foo>) fn(<foo>)" uses
> +		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
> +			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
> +
>  # check for needless kfree() checks
> -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> -			my $expr = $1;
> -			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
> +			if ($line =~ /\bkfree$expr/) {
>  				WARN("NEEDLESS_KFREE",
>  				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
> -		}
>  # check for needless usb_free_urb() checks
> -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> -			my $expr = $1;
> -			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
> +			if ($line =~ /\busb_free_urb$expr/) {
>  				WARN("NEEDLESS_USB_FREE_URB",
>  				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
> +# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
> +			if ($line =~ /\b(debugfs_remove(?:_recursive)?)$expr/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE",
> +				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}
>  		}
>  
>  # prefer usleep_range over udelay

This all looks sensible, though we still have three blocks doing the
same thing.  How about we standardise this check into a single check,
generating the capacity from the matched name.

Something like the below on top of V4.

-apw

>From 676ce396a349f2242f80e9b2c5fb68584ec09f14 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Tue, 20 Nov 2012 14:27:59 +0000
Subject: [PATCH] checkpatch: consolidate if (foo) bar(NULL) checks

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 313617b..6660246 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3229,19 +3229,16 @@ sub process {
 			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
 
 # check for needless kfree() checks
-			if ($line =~ /\bkfree$expr/) {
-				WARN("NEEDLESS_KFREE",
-				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
-			}
 # check for needless usb_free_urb() checks
-			if ($line =~ /\busb_free_urb$expr/) {
-				WARN("NEEDLESS_USB_FREE_URB",
-				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
-			}
 # check for needless debugfs_remove() and debugfs_remove_recursive*() checks
-			if ($line =~ /\b(debugfs_remove(?:_recursive)?)$expr/) {
-				WARN("NEEDLESS_DEBUGFS_REMOVE",
-				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
+				my $func = $1;
+				my $func_capacity = "NEEDLESS_$1";
+
+				$func_capacity =~ s/(.$)/\U$1\E/;
+
+				WARN($func_capacity,
+				     "$func(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 
-- 
1.7.10.4

