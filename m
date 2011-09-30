Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1I3CSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:18:14 -0400
Received: from nm21.access.bullet.mail.mud.yahoo.com ([66.94.237.222]:31512
	"HELO nm21.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752753Ab1I3CSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:18:12 -0400
X-Yahoo-Newman-Id: 200121.64207.bm@smtp105.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OQsZN.0VM1lyYQYKGehjGjokOevLsG99xOAMSYt6jiSWs9x
 Yn5vfTyCztoFdnhVieUXIZ8_S6jPb7hHjIOeUDkHmazu39N3QPRfdmWlM.3k
 _cLsZ1FIPGKUt3wIYwp8SLFTMm8gdpg1KmpKzrVKSWb36jmmsvOkOPtYmYO0
 0aokUJA75RR4gofgLycQEJQ1V6ytk1aJb7vPrw.1dbF5mggjubotDk1zeX90
 WWYbT8VKBO.bpC6VzlNc0rzfkl.1uuNzrLDq4hX9BPWyNxEGZOeFwsPDjfdq
 Rnc98uxC5T8z4qlqR6UGcgcXRSrf9OxKJuw7mnzpv7H50N94xhWt_v_vjXgm
 nCQB3cBZ8jN_Gi5gvSIkfdzt.hlISLgSXB6LJEwv050w_V8jQIT5rWkmAgdq
 .pUqs9UoL4ho_4JOB0fyIVov3GWvcmJNaHbjXG3KVg5r9Mdbg8Fsg.k9B80v
 QsJnJowhrA.ZKl5Li0hGZXYpMcgBHxg.S9Zh4_hbqkZwNz9Y-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E8526E1.3000305@schaufler-ca.com>
Date: Thu, 29 Sep 2011 19:18:09 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: Provide information for UDS getsockopt(SO_PEERCRED)
References: <4E80F20B.9050608@schaufler-ca.com>
In-Reply-To: <4E80F20B.9050608@schaufler-ca.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2011 2:43 PM, Casey Schaufler wrote:
>
> This patch is targeted for the smack-next tree.
>
> This patch takes advantage of the recent changes for performance
> and points the packet labels on UDS connect at the output label of
> the far side. This makes getsockopt(...SO_PEERCRED...) function
> properly. Without this change the getsockopt does not provide any
> information.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://gitorious.org/smack-next/kernel.git


> ---
>
>  security/smack/smack_lsm.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 2e71c3f..7d29351 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2767,6 +2767,7 @@ static int smack_unix_stream_connect(struct sock *sock,
>  {
>  	struct socket_smack *ssp = sock->sk_security;
>  	struct socket_smack *osp = other->sk_security;
> +	struct socket_smack *nsp = newsk->sk_security;
>  	struct smk_audit_info ad;
>  	int rc = 0;
>  
> @@ -2776,6 +2777,14 @@ static int smack_unix_stream_connect(struct sock *sock,
>  	if (!capable(CAP_MAC_OVERRIDE))
>  		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
>  
> +	/*
> +	 * Cross reference the peer labels for SO_PEERSEC.
> +	 */
> +	if (rc == 0) {
> +		nsp->smk_packet = ssp->smk_out;
> +		ssp->smk_packet = osp->smk_out;
> +	}
> +
>  	return rc;
>  }
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

