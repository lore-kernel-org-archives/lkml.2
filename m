Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3AGCsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:48:33 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:64280 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3AGCsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:48:31 -0500
Date: Mon, 7 Jan 2013 03:48:27 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
Message-ID: <20130107024827.GZ27530@wantstofly.org>
References: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 08:27:22PM -0500, Nickolai Zeldovich wrote:

> Do not dereference p->station_id after kfree(cmd) because p
> points into the cmd data structure.

Good catch, but the patch would be better titled "mwl8k.c: avoid
having a working driver", as the station_id return code _is_ needed
by the caller in case of success.


> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>  drivers/net/wireless/mwl8k.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index f221b95..83564d3 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -4250,9 +4250,11 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
>  	p->amsdu_enabled = 0;
>  
>  	rc = mwl8k_post_cmd(hw, &cmd->header);
> +	if (!rc)
> +		rc = p->station_id;
>  	kfree(cmd);
>  
> -	return rc ? rc : p->station_id;
> +	return rc;
>  }
>  
>  static int mwl8k_cmd_update_stadb_del(struct ieee80211_hw *hw,
> -- 
> 1.7.10.4
