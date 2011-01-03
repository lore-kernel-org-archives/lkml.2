Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1ACTwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:52:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932228Ab1ACTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:52:51 -0500
Date: Mon, 3 Jan 2011 11:52:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Ruffin <cmruffin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ihex: fix unused return value compiler warning.
Message-Id: <20110103115226.d4e4e4ae.akpm@linux-foundation.org>
In-Reply-To: <1293996430-12598-1-git-send-email-cmruffin@gmail.com>
References: <1293996430-12598-1-git-send-email-cmruffin@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Jan 2011 11:27:10 -0800
Chris Ruffin <cmruffin@gmail.com> wrote:

> fixed unusued return value compiler warnings due to unchecked write() calls.
> 
> Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
> ---
>  firmware/ihex2fw.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
> index ba0cf0b..a079bdd 100644
> --- a/firmware/ihex2fw.c
> +++ b/firmware/ihex2fw.c
> @@ -124,8 +124,7 @@ int main(int argc, char **argv)
>  	if (process_ihex(data, st.st_size))
>  		return 1;
>  
> -	output_records(outfd);
> -	return 0;
> +	return output_records(outfd);
>  }
>  
>  static int process_ihex(uint8_t *data, ssize_t size)
> @@ -269,11 +268,13 @@ static int output_records(int outfd)
>  
>  		p->addr = htonl(p->addr);
>  		p->len = htons(p->len);
> -		write(outfd, &p->addr, writelen);
> +		if (write(outfd, &p->addr, writelen) != writelen)
> +			return errno;
>  		p = p->next;
>  	}
>  	/* EOF record is zero length, since we don't bother to represent
>  	   the type field in the binary version */
> -	write(outfd, zeroes, 6);
> +	if (write(outfd, zeroes, 6) != 6)
> +		return errno;
>  	return 0;
>  }

write(1) will only set errno if it returned -1.  So in the case where
write() returned a positive number less than `count', output_records()
will return a garbage value of `errno'.

I guess this will suffice:

--- a/firmware/ihex2fw.c~ihex-fix-unused-return-value-compiler-warning-fix
+++ a/firmware/ihex2fw.c
@@ -269,12 +269,12 @@ static int output_records(int outfd)
 		p->addr = htonl(p->addr);
 		p->len = htons(p->len);
 		if (write(outfd, &p->addr, writelen) != writelen)
-			return errno;
+			return 1;
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
 	if (write(outfd, zeroes, 6) != 6)
-		return errno;
+		return 1;
 	return 0;
 }
_

