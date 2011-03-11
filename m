Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1CKHmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:42:55 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:46134 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1CKHmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:42:54 -0500
Date: Fri, 11 Mar 2011 08:42:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: chenliu@asset.uwaterloo.ca
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, cotte@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]early: Fix possible overlapping data buffer
Message-ID: <20110311074251.GA2569@osiris.boeblingen.de.ibm.com>
References: <20110310173337.GA10906@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310173337.GA10906@asset.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:33:37PM -0500, chenliu@asset.uwaterloo.ca wrote:
> This patch fixes bugzilla #12965:
> https://bugzilla.kernel.org/show_bug.cgi?id=12965

Not sure it's worth all the hazzle. After all it's just a theoratical bug,
but...

> The original code contains dangerous uses of sprintf functions like
> sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13", defsys_cmd, min_size),
> where defsys_cmd is used both as input string as well as output string. It
> should remember the written bytes of the previous sprintf and use that as the
> offset when adding something. Also use snprintf makes the code safer.
> 
> Signed-off-by: Chen Liu<chenliunju@gmail.com>

Please make sure your From: and Sign-off email addresses match.
Also it would be nice if you could add some line breaks in your patch
description ;)

Also it would be good to know if you tested the patch. Does saving
an NSS still work with your patch applied?

> ---
>  arch/s390/kernel/early.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> --- a/arch/s390/kernel/early.c
> +++ b/arch/s390/kernel/early.c
> @@ -94,6 +94,7 @@ static noinline __init void create_kerne
>  	unsigned int sinitrd_pfn, einitrd_pfn;
>  #endif
>  	int response;
> +	int hlen;
>  	size_t len;
>  	char *savesys_ptr;
>  	char defsys_cmd[DEFSYS_CMD_SIZE];
> @@ -124,7 +125,7 @@ static noinline __init void create_kerne
>  	end_pfn = PFN_UP(__pa(&_end));
>  	min_size = end_pfn << 2;
> 
> -	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
> +	hlen = sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
>  		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
>  		eshared_pfn, end_pfn);

Your patch introduced a new line with more than 80 characters long. You also
broke indentation since we have a multiline function call with parameters here.
In addition you add snprintf calls later. Why not here?
The checkpatch tool might give you some hints.


> @@ -133,13 +134,13 @@ static noinline __init void create_kerne
>  		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
>  		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
>  		min_size = einitrd_pfn << 2;
> -		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
> +		hlen += snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen, " EW %.5X-%.5X",
>  		sinitrd_pfn, einitrd_pfn);

Line too long. Plus indentation broken (well, it was already broken).
If you add an snprintf() call, then you should also make sure that the
resulting string is '\0' terminated.

>  	}
>  #endif
> 
> -	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK PARMREGS=0-13",
> -		defsys_cmd, min_size);
> +	hlen += snprintf(defsys_cmd + hlen, DEFSYS_CMD_SIZE - hlen, " EW MINSIZE=%.7iK PARMREGS=0-13",
> +		min_size);

Line too long and indentation broken. Also again you need to make sure that
the string is '\0' terminated.
In addition hlen is unused afterwards. So no need to update it here.
