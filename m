Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0JAWNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:13:42 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:33681 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab0JAWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:13:41 -0400
Message-ID: <4CA65D0E.6080604@hp.com>
Date: Fri, 01 Oct 2010 18:13:34 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11pre) Gecko/20100922 Lightning/1.0b2 Shredder/3.1.5pre
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix out-of-bounds reading in sctp_asoc_get_hmac()
References: <1285969907.2814.49.camel@Dan>
In-Reply-To: <1285969907.2814.49.camel@Dan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 05:51 PM, Dan Rosenberg wrote:
> The sctp_asoc_get_hmac() function iterates through a peer's hmac_ids
> array and attempts to ensure that only a supported hmac entry is
> returned.  The current code fails to do this properly - if the last id
> in the array is out of range (greater than SCTP_AUTH_HMAC_ID_MAX), the
> id integer remains set after exiting the loop, and the address of an
> out-of-bounds entry will be returned and subsequently used in the parent
> function, causing potentially ugly memory corruption.  This patch resets
> the id integer to 0 on encountering an invalid id so that NULL will be
> returned after finishing the loop if no valid ids are found.
>
> Signed-off-by: Dan Rosenberg<drosenberg@vsecurity.com>

Good catch.

Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

-vlad


>
> --- linux-2.6.35.5.orig/net/sctp/auth.c	2010-09-20 16:59:09.000000000 -0400
> +++ linux-2.6.35.5/net/sctp/auth.c	2010-10-01 16:48:58.000000000 -0400
> @@ -543,16 +543,20 @@ struct sctp_hmac *sctp_auth_asoc_get_hma
>   		id = ntohs(hmacs->hmac_ids[i]);
>
>   		/* Check the id is in the supported range */
> -		if (id>  SCTP_AUTH_HMAC_ID_MAX)
> +		if (id>  SCTP_AUTH_HMAC_ID_MAX) {
> +			id = 0;
>   			continue;
> +		}
>
>   		/* See is we support the id.  Supported IDs have name and
>   		 * length fields set, so that we can allocated and use
>   		 * them.  We can safely just check for name, for without the
>   		 * name, we can't allocate the TFM.
>   		 */
> -		if (!sctp_hmac_list[id].hmac_name)
> +		if (!sctp_hmac_list[id].hmac_name) {
> +			id = 0;
>   			continue;
> +		}
>
>   		break;
>   	}
>
>

