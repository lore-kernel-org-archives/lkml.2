Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab1D0XrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:47:13 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:26157 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752052Ab1D0XrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:47:09 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: AD0_RJgVM1kyAVOvcYukLiZqT7oKgA_VvBLXmBrQp.DJiGt
 Xhw7grDgQLGViVl36JBY5kHstqdnNqspunr4WAkj_kfLLEwp9mogzqRxN.0t
 fCh0znDyMUoKUVQtTLqPLiGBl.6KHjDnYUkSD7cmSqmwC.STJBU8gM0uxlft
 _OoTcW5ElvWIZdB_LsNWshc1ISX7DlIsEIvYxelVyTCSoiAVAuzLC5Mcl_5e
 e_bc02hfUDdfKIDkwFi1mhNH9TRtRnIcLx5YMR0.TOwmDzu2jPYSo3t.VPw.
 Ba_qCO6coN4zLJW7i5PMoYI.Hm0MUqI2NqWFZI45_YJezzOkBd6ljLS_iwha
 7SQoQIjDASMLS0GF69YNbfJ03hxe5Vj1133Pmnjzqhg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB8AAFA.2050903@schaufler-ca.com>
Date: Wed, 27 Apr 2011 16:47:06 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 5/7] smack: import the security label in smack_secctx_to_secid()
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-6-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-6-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> The security label passed as argument in smack_secctx_to_secid() must be
> first imported in the 'smack_known_list' list before finding the security
> identifier associated to it. This allows the function
> set_security_override_from_ctx() to be performed successfully even if the
> label is not yet present in the smack list.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Nacked-by: Casey Schaufler <casey@schaufler-ca.com>

security_secctx_to_secid() is called from the netlabel code
and hence cannot (to my understanding) allocate memory,
which is something that smk_import will do if the label is
new. I am willing to be convinced that doing so is safe,
but my understanding is that it is not.

> ---
>  security/smack/smack_lsm.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 0e7ed31..6612ba1 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3346,7 +3346,13 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>   */
>  static int smack_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
>  {
> -	*secid = smack_to_secid(secdata);
> +	char *smack;
> +
> +	smack = smk_import(secdata, seclen);
> +	if (smack == NULL)
> +		return -EINVAL;
> +
> +	*secid = smack_to_secid(smack);
>  	return 0;
>  }
>  

