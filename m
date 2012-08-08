Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2HHALY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:11:24 -0400
Received: from nm3-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.136]:45461
	"HELO nm3-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751873Ab2HHALX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:11:23 -0400
X-Yahoo-Newman-Id: 236473.244.bm@smtp109.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0CBj8kwVM1lniW2eTUVH4tJOhzwRgGHkfOZdyZ2xiVMfnPw
 IGwTT10dhD9vfMw8gcmoSOIvr9PUj1IiXe3Xb0F7ePdmlCBy1qNJuRm1cTH7
 N0KjEZBPgH6euYDhoBwdn7f6U0KHbJwHnc0J7UxxyIdRrlJDwlE5qViVWrOE
 nBKaPkbjj2lTu1Sp7nU8dA7CIB90gR_dHOO2vNle5g99ZTKSXdV2cZyPGNQI
 6KcNoslzTeu6fMbV5kP0ZeZ6Bv6OZ.mR2PkQNZhia80jMNjO2VFOWNbAbkUi
 Tcw0jh.Fo3UKnX6nff.ORaWt5DdNjpafBUzZX8b8LeCxxcnhUSrIO2l0i_Kj
 g9SqoUazgV6h3v2m666byP4iVI4Jx4Z.KfreUB.cYj4BJfKF3SMO.5WdLzkt
 4YHS_ynNfSoD.mLpjc0G49eRr.adYVXjtFpijgztIoHbq7VctJv43EKRgo8k
 TmSf0b82w1pk7RkM1E1dZo_I6pVkohn6Xft.qOW9aLw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5021AEAA.5040503@schaufler-ca.com>
Date: Tue, 07 Aug 2012 17:11:22 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [ 010/122] smack: off by one error
References: <20120807221948.220495155@linuxfoundation.org> <20120807221949.167564072@linuxfoundation.org>
In-Reply-To: <20120807221949.167564072@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2012 3:24 PM, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>
> 3.5-stable review patch.  If anyone has any objections, please let me know.

No objection here.

>
> ------------------
>
> From: Alan Cox <alan@linux.intel.com>
>
> commit 3b9fc37280c521b086943f9aedda767f5bf3b2d3 upstream.
>
> Consider the input case of a rule that consists entirely of non space
> symbols followed by a \0. Say 64 + \0
>
> In this case strlen(data) = 64
> kzalloc of subject and object are 64 byte objects
> sscanfdata, "%s %s %s", subject, ...)
>
> will put 65 bytes into subject.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  security/smack/smackfs.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -325,11 +325,11 @@ static int smk_parse_long_rule(const cha
>  	int datalen;
>  	int rc = -1;
>  
> -	/*
> -	 * This is probably inefficient, but safe.
> -	 */
> +	/* This is inefficient */
>  	datalen = strlen(data);
> -	subject = kzalloc(datalen, GFP_KERNEL);
> +
> +	/* Our first element can be 64 + \0 with no spaces */
> +	subject = kzalloc(datalen + 1, GFP_KERNEL);
>  	if (subject == NULL)
>  		return -1;
>  	object = kzalloc(datalen, GFP_KERNEL);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

