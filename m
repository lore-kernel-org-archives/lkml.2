Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2HLIsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 04:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab2HLIsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 04:48:35 -0400
Date: Sun, 12 Aug 2012 11:49:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH v2] macvtap: rcu_dereference outside read-lock section
Message-ID: <20120812084929.GB4430@redhat.com>
References: <20120811.181642.1587792778007257202.davem@davemloft.net>
 <1344752791-21140-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344752791-21140-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 10:26:31AM +0400, Denis Efremov wrote:
> rcu_dereference occurs in update section. Replacement by
> rcu_dereference_protected in order to prevent lockdep
> complaint.
> 
> Found by Linux Driver Verification project (linuxtesting.org)
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  drivers/net/macvtap.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 0737bd4..0f0f9ce 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -94,7 +94,8 @@ static int get_slot(struct macvlan_dev *vlan, struct macvtap_queue *q)
>  	int i;
>  
>  	for (i = 0; i < MAX_MACVTAP_QUEUES; i++) {
> -		if (rcu_dereference(vlan->taps[i]) == q)
> +		if (rcu_dereference_protected(vlan->taps[i],
> +					      lockdep_is_held(&macvtap_lock)) == q)

And now it's too long.  Maybe a temporary would be better?

		struct macvtap_queue *t;
		t = rcu_dereference_protected(vlan->taps[i],
					      lockdep_is_held(&macvtap_lock));
		if (t == q)
  			return i;
		
?

Anyway -

Acked-by: Michael S. Tsirkin <mst@redhat.com>


>  			return i;
>  	}
>  
> -- 
> 1.7.7
