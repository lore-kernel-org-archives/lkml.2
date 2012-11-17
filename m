Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2KQRk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 12:40:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48306 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003Ab2KQRkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 12:40:55 -0500
Message-ID: <1353174050.13961.5.camel@joe-AO722>
Subject: Re: [PATCH v2] checkpatch: debugfs_remove() can take NULL
From: Joe Perches <joe@perches.com>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>
Date: Sat, 17 Nov 2012 09:40:50 -0800
In-Reply-To: <1353162965-575-1-git-send-email-const@MakeLinux.com>
References: <1353162965-575-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-17 at 16:36 +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> debugfs_remove() and  debugfs_remove_recursive() can take a NULL, so let's check and warn about that.
> 
> Channegs since v1:
> 
> - added debugfs_remove_recursivere
> - all tests for pattenrs are "if (a) xxx(a)" are consolidates

Hello Constantine.

Just some trivia and a suggestion:

There are a couple of typos in the commit message
(I do that all the time myself)

> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
>  scripts/checkpatch.pl |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f18750e..2339b54 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3213,21 +3213,29 @@ sub process {
>  				$herecurr);
>  		}
>  
> -# check for needless kfree() checks
> +# check for needless "if"
>  		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
>  			my $expr = $1;
> +# check for needless kfree() checks
>  			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
>  				WARN("NEEDLESS_KFREE",
>  				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
> -		}
>  # check for needless usb_free_urb() checks
> -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> -			my $expr = $1;
>  			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
>  				WARN("NEEDLESS_USB_FREE_URB",
>  				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}
> +# check for needless debugfs_remove() checks
> +			if ($line =~ /\bdebugfs_remove\(\Q$expr\E\);/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE",
> +				     "debugfs_remove(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}
> +# check for needless debugfs_remove_recursive() checks
> +			if ($line =~ /\bdebugfs_remove_recursive\(\Q$expr\E\);/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE",
> +				     "debugfs_remove_recursive(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}
>  		}
>  
>  # prefer usleep_range over udelay

Perhaps this is better because it allows whitespace
around the check value:

Right now this doesn't trigger, with the suggestion, it does.

	if ( foo )
		kfree ( foo );

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d2d5ba1..c037c31 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3198,21 +3200,25 @@ sub process {
 				$herecurr);
 		}
 
+# check for needless "if (<foo>) fn(<foo>)" uses
+		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
+			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
+
 # check for needless kfree() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
+			if ($line =~ /\bkfree$expr/) {
 				WARN("NEEDLESS_KFREE",
 				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
-		}
 # check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
+			if ($line =~ /\busb_free_urb$expr/) {
 				WARN("NEEDLESS_USB_FREE_URB",
 				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
+# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
+			if ($line =~ /\b(debugfs_remove(?:_recursive)?)$expr/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE",
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
 		}
 
 # prefer usleep_range over udelay


