Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1K1PpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:45:12 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2332 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1K1PpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:45:07 -0500
Message-ID: <4ED3AC7D.6090108@hp.com>
Date: Mon, 28 Nov 2011 10:45:01 -0500
From: Vladislav Yasevich <vladislav.yasevich@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Xi Wang <xi.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] sctp: integer overflow in sctp_auth_create_key()
References: <426D7BA8-ECD0-44D6-A09F-2033F0C825FC@gmail.com>
In-Reply-To: <426D7BA8-ECD0-44D6-A09F-2033F0C825FC@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 08:25 PM, Xi Wang wrote:
> The previous commit 30c2235c is incomplete and cannot prevent integer
> overflows. For example, when key_len is 0x80000000 (INT_MAX + 1), the
> left-hand side of the check, (INT_MAX - key_len), which is unsigned,
> becomes 0xffffffff (UINT_MAX) and bypasses the check.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
>  net/sctp/auth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 865e68f..989e0fd 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -82,7 +82,7 @@ static struct sctp_auth_bytes *sctp_auth_create_key(__u32 key_len, gfp_t gfp)
>  	struct sctp_auth_bytes *key;
>  
>  	/* Verify that we are not going to overflow INT_MAX */
> -	if ((INT_MAX - key_len) < sizeof(struct sctp_auth_bytes))
> +	if (key_len > INT_MAX - sizeof(struct sctp_auth_bytes))
>  		return NULL;
>  
>  	/* Allocate the shared key */


Hmm.  Yes, this is a more correct check.

Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>


However, I don't think this is a security issue.  As I've written before, this function is
called from 2 places:

  1) setsockopt() code path

  2) sctp_auth_asoc_set_secret() code path

In case (1), sca_keylength is never going to exceed 65535 since it's
bounded by a u16 from the user api.  As such, The integer promotion will
not impact anything and the malloc() will never overflow.

In case (2), sca_keylength is computed based on the key the user provided
(MAX_USHORT) and the combination of protocol negotiated data where that
combination has a max size of 3 * MAX_USHORT (see sctp_auth_make_key_vector()).
So, even this case, our maximum key length can be 4* MAX_USHORT which still
will always be below MAX_INT and will not overflow.

So, I don't think there is big security consideration here, just a bad
check that just happens to always work.

-vlad
