Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2DITr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:47:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27852 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2DITrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:47:55 -0400
Message-ID: <4F833CDF.4080300@parallels.com>
Date: Mon, 09 Apr 2012 23:47:43 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 2/4] ipc: move all checkpoint-restore code under
 appropriate define
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6> <20120409175404.8358.32321.stgit@localhost6.localdomain6>
In-Reply-To: <20120409175404.8358.32321.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:54 PM, Stanislav Kinsbursky wrote:
> All new checkpoint/restore code parts are now covered with
> CONFIG_CHECKPOINT_RESTORE marco. So it would be easy to remove them, in case
> the whole project fails.
> 
> ---
>  ipc/compat.c |    9 ++++++---
>  ipc/msg.c    |   15 ++++++++++++++-
>  2 files changed, 20 insertions(+), 4 deletions(-)
> 
> @@ -387,8 +388,10 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
>  		msgtyp = ipck.msgtyp;
>  	}
>  	return do_msgrcv(first, uptr, second, msgtyp, third,
> -			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all
> -						: compat_do_msg_fill);
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all :
> +#endif
> +						compat_do_msg_fill);

These ifdefs in the middle of the code look not very elegant. Is there a way
to replace the checks they surround with static inline function (reporting
0 when CHECKPOINT_RESTORE is off) potentially letting the compiler optimize
out the code sitting under if (0) ?

>  }
>  
>  static inline int get_compat_msqid64(struct msqid64_ds *m64,
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 017bf0b..8d63cc7 100644
