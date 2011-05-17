Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1EQRni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:43:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43891 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1EQRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:43:36 -0400
In-Reply-To: <20110517143756.GE30366@darkmag.usersys.redhat.com>
References: <20110515165945.GA20024@darkmag.usersys.redhat.com> <20110516.140359.111037536766782557.davem@davemloft.net> <OF948388D5.90B3F5A7-ON88257892.006C3228-88257892.0071B9D5@us.ibm.com> <20110517133801.GC30366@darkmag.usersys.redhat.com> <20110517143756.GE30366@darkmag.usersys.redhat.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: David Miller <davem@davemloft.net>, jmorris@namei.org, kaber@trash.net,
        kuznet@ms2.inr.ac.ru, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, mmarek@suse.cz, netdev@vger.kernel.org,
        pekkas@netcore.fi, yoshfuji@linux-ipv6.org
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/1] igmp: call ip_mc_clear_src() only when we have no users
 of ip_mc_list
X-KeepSent: 11F57B2A:6B43B7E6-88257893:005490B0;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.1FP5 SHF29 November 12, 2010
From: David Stevens <dlstevens@us.ibm.com>
Message-ID: <OF11F57B2A.6B43B7E6-ON88257893.005490B0-88257893.00615176@us.ibm.com>
Date: Tue, 17 May 2011 10:42:59 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 8.5.1FP2|March 17, 2010) at
 05/17/2011 11:43:00,
	Serialize complete at 05/17/2011 11:43:00
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Veaceslav,
        It looks to me like this will leak the source filters if we are 
called from ip_mc_destroy_dev(),
Even with your previous patch, you're assuming that we don't free the 
ip_mc_list and so we have the
same one when we up the device, but if there are no timers running, it 
looks like refcnt canl go to 0 and free
it. If we can ever free the ip_mc_list when users != 0 (or going to 0 
immediately after the drop), we
have to do the ip_mc_clear_src() or leak the list. I haven't looked at 
this code in years, so I'll need
to refresh my memory.
        So, I'll look at that a bit more; at a minimum, I think you need 
to do the clear_src
also in the destroy case. We could lose the filters and set the exclude 
count to users, instead
of 1; but I like the idea of keeping the source filters across a down/up, 
if we can be sure there
are no cases where we free the ip_mc_list without first freeing all the 
filters.

                                                                +-DLS

Veaceslav Falico <vfalico@redhat.com> wrote on 05/17/2011 07:37:56 AM:

> From: Veaceslav Falico <vfalico@redhat.com>
> To: David Stevens/Beaverton/IBM@IBMUS
> Cc: David Miller <davem@davemloft.net>, jmorris@namei.org, 
> kaber@trash.net, kuznet@ms2.inr.ac.ru, linux-kbuild@vger.kernel.org,
> linux-kernel@vger.kernel.org, mmarek@suse.cz, 
> netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org
> Date: 05/17/2011 07:39 AM
> Subject: [PATCH v3 1/1] igmp: call ip_mc_clear_src() only when we 
> have no users of ip_mc_list
> 
> In igmp_group_dropped() we call ip_mc_clear_src(), which resets the 
number
> of source filters per mulitcast. However, igmp_group_dropped() is also
> called on NETDEV_DOWN, NETDEV_PRE_TYPE_CHANGE and NETDEV_UNREGISTER, 
which
> means that the group might get added back on NETDEV_UP, NETDEV_REGISTER 
and
> NETDEV_POST_TYPE_CHANGE respectively, leaving us with broken source
> filters.
> 
> To fix that, we must clear the source filters only when there are no 
users
> in the ip_mc_list, i.e. in ip_mc_dec_group().
> 
> Correct version of the patch.
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 1fd3d9c..142ca0d 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1169,20 +1169,18 @@ static void igmp_group_dropped(struct ip_mc_list 
*im)
> 
>     if (!in_dev->dead) {
>        if (IGMP_V1_SEEN(in_dev))
> -         goto done;
> +         return;
>        if (IGMP_V2_SEEN(in_dev)) {
>           if (reporter)
>              igmp_send_report(in_dev, im, IGMP_HOST_LEAVE_MESSAGE);
> -         goto done;
> +         return;
>        }
>        /* IGMPv3 */
>        igmpv3_add_delrec(in_dev, im);
> 
>        igmp_ifc_event(in_dev);
>     }
> -done:
>  #endif
> -   ip_mc_clear_src(im);
>  }
> 
>  static void igmp_group_added(struct ip_mc_list *im)
> @@ -1319,6 +1317,7 @@ void ip_mc_dec_group(struct in_device *in_dev,
> __be32 addr)
>              *ip = i->next_rcu;
>              in_dev->mc_count--;
>              igmp_group_dropped(i);
> +            ip_mc_clear_src(i);
> 
>              if (!in_dev->dead)
>                 ip_rt_multicast_event(in_dev);

