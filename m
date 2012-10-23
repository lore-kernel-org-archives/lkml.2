Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2JWTKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:10:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab2JWTKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:10:06 -0400
Date: Tue, 23 Oct 2012 12:10:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-Id: <20121023121005.ed33061a.akpm@linux-foundation.org>
In-Reply-To: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 19:30:58 +0400
Denis Kirjanov <kirjanov@gmail.com> wrote:

> fix buffer overrun if no suitable bandwidth found
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
>  drivers/edac/amd64_edac.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 5a297a2..d85ad9e 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -188,6 +188,9 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
>  		 * scrubrates array.
>  		 */
>  	}
> +	if (i == ARRAY_SIZE(scrubrates)) {
> +		i--;
> +	}
>  
>  	scrubval = scrubrates[i].scrubval;
>  

That's pretty strange code in there.

If the comment is to be believed, isn't this a suitable fix?

--- a/drivers/edac/amd64_edac.c~a
+++ a/drivers/edac/amd64_edac.c
@@ -171,7 +171,7 @@ static int __amd64_set_scrub_rate(struct
 	 * bandwidth entry that is greater or equal than the setting requested
 	 * and program that. If at last entry, turn off DRAM scrubbing.
 	 */
-	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+	for (i = 0; i < ARRAY_SIZE(scrubrates) - 1; i++) {
 		/*
 		 * skip scrub rates which aren't recommended
 		 * (see F10 BKDG, F3x58)
_

Also, I don't think "buffer overrun" is an appropriate description here
- to me, "buffer overrun" implies writing to memory outside the buffer.
 I'd call this "array overindexing" or similar.

Finally, when fixing a bug, please always describe the user-visible
impact of that bug.  You have cc'ed stable on this patch (using the
incorrect email address, btw) which implies that the effects are serious,
but people will want to know specific details about those effects when
considering the patch.

