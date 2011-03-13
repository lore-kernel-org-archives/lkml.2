Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1CMOA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 10:00:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab1CMOAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 10:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uZOppghS3ziWcEf9oBpaOL+/Jxy6AjjLghgqsnzD8a5j+EFmgnkotVTBI1jyAyu4BU
         1VJTWeUm/C7YdCHTmRiQPLpYe+T+UqgCEWKs2yOHTaoHIfgNhZejVFMsB/0xUg9tlnMi
         kJztxy+Fhg/u/itsmU5dknE7ATpH8ROd9ZW2E=
MIME-Version: 1.0
In-Reply-To: <1299780740-32652-1-git-send-email-segoon@openwall.com>
References: <1299780740-32652-1-git-send-email-segoon@openwall.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 13 Mar 2011 22:00:03 +0800
Message-ID: <AANLkTimPZJoCzz386e-4m0Y4khWGZirZguGFmuFYCrry@mail.gmail.com>
Subject: Re: [PATCH] ipv4: netfilter: ipt_CLUSTERIP: fix buffer overflow
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 2:12 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> buffer string is copied from userspace.  It is not checked whether it is
> zero terminated.  This may lead to overflow inside of simple_strtoul().
>
> It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
> root writable only by default, however, on some setups permissions might be
> relaxed to e.g. network admin user.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested.
>
>  net/ipv4/netfilter/ipt_CLUSTERIP.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index 403ca57..7aabf9a 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -666,6 +666,7 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
>
>        if (copy_from_user(buffer, input, PROC_WRITELEN))

I think size should be used instead of PROC_WRITELEN.

if (size > PROC_WRITELEN)
     return -EIO;
if (copy_from_user(buffer, input, size))
    return -EFAULT;
buffer[size] = '\0';

>                return -EFAULT;
> +       buffer[sizeof(buffer)-1] = 0;
>
>        if (*buffer == '+') {
>                nodenum = simple_strtoul(buffer+1, NULL, 10);



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
