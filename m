Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0J3Odl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:33:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57807 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0J3Odj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O7ZqD+d6AAWm9o+MNCKFLNnK5JZXOqKTrmXpzcTaLyejlHEfygR0HRdXbKaYe8dfNB
         a7i1tYT5orrIJ8GWB5Jm93CnxTxlAgFCZDLRUYM269cKttz3wt12CMGAUda58RtT0GPb
         JZb/YHy8u0h4Vfke9mpPBqWppvYz27K3Jeir8=
Subject: Re: [PATCH] net: core: scm: fix information leak to userland
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288448796-6147-1-git-send-email-segooon@gmail.com>
References: <1288448796-6147-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 16:33:25 +0200
Message-ID: <1288449205.2680.968.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 18:26 +0400, Vasiliy Kulikov a écrit :
> Structure cmsghdr is copied to userland with padding bytes
> unitialized on architectures where __kernel_size_t is unsigned long.
> It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  net/core/scm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 413cab8..a4a9b70 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -233,6 +233,7 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
>  		msg->msg_flags |= MSG_CTRUNC;
>  		cmlen = msg->msg_controllen;
>  	}
> +	memset(&cmhdr, 0, sizeof(cmhdr));
>  	cmhdr.cmsg_level = level;
>  	cmhdr.cmsg_type = type;
>  	cmhdr.cmsg_len = cmlen;


???

struct cmsghdr {
        __kernel_size_t cmsg_len;       /* data byte count, including hdr */
        int             cmsg_level;     /* originating protocol */
        int             cmsg_type;      /* protocol-specific type */
};

Could you explain where are the padding bytes ?



