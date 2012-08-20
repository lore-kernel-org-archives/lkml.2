Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab2HTSl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:41:58 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:34897 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2HTSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:41:56 -0400
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: Re: [PATCH] cifs: remove misleading strncpy: each name has length < 16
In-Reply-To: <1345481724-30108-6-git-send-email-jim@meyering.net> (Jim
	Meyering's message of "Mon, 20 Aug 2012 18:55:24 +0200")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-6-git-send-email-jim@meyering.net>
Date: Mon, 20 Aug 2012 20:41:12 +0200
Message-ID: <87zk5pl83b.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Meyering wrote:

> From: Jim Meyering <meyering@redhat.com>
>
> Each of the protocols[i].name strings (statically declared above)
> has length less than 16, so this use of strncpy is misleading:
>   strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
> Besides, if a new name were added with length N >= 16, the existing
> strncpy-using code would be buggy, creating a ->DialectsArray buffer
> containing N-16+1 unset bytes where the NUL terminator should have
> been.  Instead, traverse the name only once go get its length,

s/go/to/, of course.

> use a BUG_ON assertion to enforce the length restriction
> and use memcpy to perform the copy.
>
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  fs/cifs/cifssmb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 074923c..16a9018 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -441,8 +441,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
>
>  	count = 0;
>  	for (i = 0; i < CIFS_NUM_PROT; i++) {
> -		strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
> -		count += strlen(protocols[i].name) + 1;
> +		size_t len = strlen(protocols[i].name);
> +		BUG_ON(len >= 16);
> +		memcpy(pSMB->DialectsArray+count, protocols[i].name, len + 1);
> +		count += len + 1;
>  		/* null at end of source and target buffers anyway */
>  	}
>  	inc_rfc1001_len(pSMB, count);
