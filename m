Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab0HLVCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:02:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933716Ab0HLVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:02:30 -0400
Date: Thu, 12 Aug 2010 14:02:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] checkpatch: check for incorrect permissions
Message-Id: <20100812140222.d3dedf91.akpm@linux-foundation.org>
In-Reply-To: <1281590145-30708-1-git-send-email-rabin.vincent@stericsson.com>
References: <1281590145-30708-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 10:45:45 +0530
Rabin Vincent <rabin.vincent@stericsson.com> wrote:

> Throw an error when a source file has been given execute permissions
> using the mode change line present in git diffs.  Also alow the filename
> matching to use the "diff" line in addition to the "+++" line, since the
> mode change lines appear before any "+++" lines.
> 
> Cc: Andy Whitcroft <apw@canonical.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  scripts/checkpatch.pl |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2039acd..4c35cb9 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1308,7 +1308,7 @@ sub process {
>  		$here = "#$realline: " if ($file);
>  
>  		# extract the filename as it passes
> -		if ($line=~/^\+\+\+\s+(\S+)/) {
> +		if ($line=~/^\+\+\+\s+(\S+)/ || $line=~/^diff\s.*?(\S+)$/) {

Breakage.  This causes the false warning:

WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch

to be emitted when processing the below patch:



From: Dan Carpenter <error27@gmail.com>

copy_to_user() returns the number of bytes remaining but we want to return
a negative error code on errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/ip2/ip2main.c~ip2-return-efault-on-copy_to_user-errors drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-return-efault-on-copy_to_user-errors
+++ a/drivers/char/ip2/ip2main.c
@@ -2930,6 +2930,8 @@ ip2_ipl_ioctl (struct file *pFile, UINT 
 				if ( pCh )
 				{
 					rc = copy_to_user(argp, pCh, sizeof(i2ChanStr));
+					if (rc)
+						rc = -EFAULT;
 				} else {
 					rc = -ENODEV;
 				}
_

