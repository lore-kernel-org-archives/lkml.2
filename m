Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab1D0XWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:22:40 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:20003 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757155Ab1D0XWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:22:37 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: elIVThEVM1mlaWDvhIBk_fIlcb0qelb2gll.0CXJEc1gSho
 82jQQYMLudYMLXg99aRhRojfdhOvXLXW_xr_kvNzNJ5y7bHe4y7ZyGtruV_0
 C.JLhCba_KRp7NPO74ZjZpD_qDKWssoSiITIulGutH0urDchrAXb.Bv4cadh
 fC.c6.PRaOxWHZ.6ssDWDKC_DcfGbmXqsn9Mi8lj991KXaN2RpDGi5enWcey
 3NW9jg1jKJgnCGtAq_XWYSaL62IqCxkRQ1GQsdOYPVHAbcoXhOexM0NnbWdM
 v1vsj9xloZZhbwiEhrzM..70ByqKJp2yGLNqRLnGmP_Zmvrg7zuNd8BENYFU
 fzfTbQ1KsiRnjMRYJdOd3VepP.ohl8UVB0Gmc6aG05Q--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB8A53A.4010709@schaufler-ca.com>
Date: Wed, 27 Apr 2011 16:22:34 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
Subject: Re: [RFC][PATCH 4/7] smack: fix label check in smack_kernel_act_as()
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-5-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-5-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> The function smack_kernel_act_as() must return -EINVAL if the label
> returned by smack_from_secid() is equal to 'smack_known_invalid.smk_known',
> which means that no entries in the 'smack_known_list' list matching the
> security identifier given are found.

I'll admit that the code here is wrong, but I disagree with the fix.

smack_from_secid() will never return NULL, so the check for NULL is
pointless. Checking for known_invalid is not right either, as the
Smack philosophy is to return a label in all cases, as is evident
by the behavior of smack_from_secid(). Thus, the correct change
would be to remove the error check completely and set the new task
value to the value obtained from smack_from_secid in all cases.

Besides, where did the caller of this function get a secid that isn't
going to map to a Smack label?

> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/smack/smack_lsm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index e3c9e54..0e7ed31 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1415,7 +1415,7 @@ static int smack_kernel_act_as(struct cred *new, u32 secid)
>  	struct task_smack *new_tsp = new->security;
>  	char *smack = smack_from_secid(secid);
>  
> -	if (smack == NULL)
> +	if (smack == smack_known_invalid.smk_known)
>  		return -EINVAL;
>  
>  	new_tsp->smk_task = smack;

