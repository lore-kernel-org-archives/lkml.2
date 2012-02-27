Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2B0RYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:24:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:44788 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab2B0RYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:24:03 -0500
MIME-Version: 1.0
Message-ID: <e60d5136-c2d2-45a4-97f4-5d8e58b12000@default>
Date: Mon, 27 Feb 2012 09:23:24 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrea Righi <andrea@betterlinux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        =?iso-8859-1?B?QWxleCBWaWxsYWPtrXMgTGFzc28=?= 
	<a_villacis@palosanto.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        =?iso-8859-1?B?QWxleCBWaWxsYWPtrXMgTGFzc28=?= 
	<a_villacis@palosanto.com>
Subject: RE: [PATCH] zcache: avoid AB-BA deadlock condition
References: <<1329739909-3174-1-git-send-email-andrea@betterlinux.com>>
In-Reply-To: <<1329739909-3174-1-git-send-email-andrea@betterlinux.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F4BBC1D.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Righi [mailto:andrea@betterlinux.com]
> Sent: Monday, February 20, 2012 5:12 AM
> To: Greg Kroah-Hartman
> Cc: Dan Magenheimer; Seth Jennings; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org;
> stable@kernel.org
> Subject: [PATCH] zcache: avoid AB-BA deadlock condition
> 
> Commit 9256a47 fixed a deadlock condition, being sure that the buddy
> list spinlock is always taken before the page spinlock.
> 
> However in zbud_free_and_delist() locking order is the opposite
> (page lock -> list lock).
> 
> Possible unsafe locking scenario (reported by lockdep):
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&(&zbpg->lock)->rlock);
>                                 lock(zbud_budlists_spinlock);
>                                 lock(&(&zbpg->lock)->rlock);
>    lock(zbud_budlists_spinlock);
> 
> Fix by grabbing the locks in opposite order in zbud_free_and_delist().
> 
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Thanks for catching this Andrea!  (And thanks also to
Alex Vallacis-Lasso for independently reporting and testing:
http://permalink.gmane.org/gmane.linux.kernel/1257214 )

Greg, this patch could be targeted for 3.3-rc6 and 3.2-stable.
AFAIK, nobody has actually experienced a deadlock from this so
if Linus has the screws down tight for -rc6, it could wait
until the 3.4 window.

> ---
>  drivers/staging/zcache/zcache-main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index ef7c52b..dce04be 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -299,10 +299,12 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
>  	struct zbud_page *zbpg =
>  		container_of(zh, struct zbud_page, buddy[budnum]);
> 
> +	spin_lock(&zbud_budlists_spinlock);
>  	spin_lock(&zbpg->lock);
>  	if (list_empty(&zbpg->bud_list)) {
>  		/* ignore zombie page... see zbud_evict_pages() */
>  		spin_unlock(&zbpg->lock);
> +		spin_unlock(&zbud_budlists_spinlock);
>  		return;
>  	}
>  	size = zbud_free(zh);
> @@ -310,7 +312,6 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
>  	zh_other = &zbpg->buddy[(budnum == 0) ? 1 : 0];
>  	if (zh_other->size == 0) { /* was unbuddied: unlist and free */
>  		chunks = zbud_size_to_chunks(size) ;
> -		spin_lock(&zbud_budlists_spinlock);
>  		BUG_ON(list_empty(&zbud_unbuddied[chunks].list));
>  		list_del_init(&zbpg->bud_list);
>  		zbud_unbuddied[chunks].count--;
> @@ -318,7 +319,6 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
>  		zbud_free_raw_page(zbpg);
>  	} else { /* was buddied: move remaining buddy to unbuddied list */
>  		chunks = zbud_size_to_chunks(zh_other->size) ;
> -		spin_lock(&zbud_budlists_spinlock);
>  		list_del_init(&zbpg->bud_list);
>  		zcache_zbud_buddied_count--;
>  		list_add_tail(&zbpg->bud_list, &zbud_unbuddied[chunks].list);
> --
> 1.7.5.4
