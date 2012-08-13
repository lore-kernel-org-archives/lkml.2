Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2HMTFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab2HMTFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:05:18 -0400
Date: Mon, 13 Aug 2012 16:04:21 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        faisal.latif@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, fubar@us.ibm.com, andy@greyhouse.net,
        divy@chelsio.com, jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [patch net-next 03/16] vlan: add link to upper device
Message-ID: <20120813160421.77a74e4e@obelix.rh>
In-Reply-To: <1344871635-1052-4-git-send-email-jiri@resnulli.us>
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
	<1344871635-1052-4-git-send-email-jiri@resnulli.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 17:27:02 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
>  net/8021q/vlan.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index 9096bcb..739665e 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -105,6 +105,8 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
>  	 */
>  	unregister_netdevice_queue(dev, head);
>  
> +	netdev_upper_dev_unlink(real_dev, dev);
> +
>  	if (grp->nr_vlan_devs == 0)
>  		vlan_gvrp_uninit_applicant(real_dev);
>  
> @@ -162,9 +164,13 @@ int register_vlan_dev(struct net_device *dev)
>  	if (err < 0)
>  		goto out_uninit_applicant;
>  
> +	err = netdev_upper_dev_link(real_dev, dev);
> +	if (err)
> +		goto out_uninit_applicant;
> +
>  	err = register_netdevice(dev);
>  	if (err < 0)
> -		goto out_uninit_applicant;
> +		goto out_upper_dev_unlink;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
see below:

>  
>  	/* Account for reference in struct vlan_dev_priv */
>  	dev_hold(real_dev);
> @@ -180,6 +186,8 @@ int register_vlan_dev(struct net_device *dev)
>  
>  	return 0;
>  
> +upper_dev_unlink:
^^^^^^^^^^^^^^^^^^^
should be out_upper_dev_unlink:

fbl

> +	netdev_upper_dev_unlink(real_dev, dev);
>  out_uninit_applicant:
>  	if (grp->nr_vlan_devs == 0)
>  		vlan_gvrp_uninit_applicant(real_dev);

