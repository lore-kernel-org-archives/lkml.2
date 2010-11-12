Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0KLO00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:26:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33105 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0KLO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:26:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Qy5QVbfonpUp8t1zCRwh+Wx0Ue/owcREI/MEhLZHF/MZjfkG06b40ISy2xzgywqRCD
         NWgKLhk+rnO7dgqhmCF0j5m5AQJX1pP2IsR/WYDkoD2OTk6TdSiddjSHDF7tPKakp9qB
         j6Q9dQ+kDrfNr25RB0GX0Adkj7nwEO9s4k0uU=
Subject: Re: [PATCH net-next-2.6] igmp: RCU conversion of in_dev->mc_list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
In-Reply-To: <1289568858.3185.252.camel@edumazet-laptop>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
	 <1289546874.17691.1774.camel@edumazet-laptop>
	 <20101112081945.GA5949@cr0.nay.redhat.com>
	 <1289553759.3185.1.camel@edumazet-laptop>
	 <1289568858.3185.252.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 15:26:14 +0100
Message-ID: <1289571974.3185.254.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 14:34 +0100, Eric Dumazet a écrit :
> Le vendredi 12 novembre 2010 à 10:22 +0100, Eric Dumazet a écrit :
> > Le vendredi 12 novembre 2010 à 16:19 +0800, Américo Wang a écrit :
> > > On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
> > 
> > > >A RCU conversion is far more complex.
> > > >
> > > 
> > > Yup.
> > 
> > 
> > Well, actually this is easy in this case.
> > 
> > I'll post a patch to do this RCU conversion.
> > 
> > 
> 
> Note : compile tested only, I'll appreciate if someone can test it ;)
> 
> Note: one patch from net-2.6 is not yet included in net-next-2.6, so
> please make sure you have it before testing ;)
> 
> ( http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=18943d292facbc70e6a36fc62399ae833f64671b )
> 
> 
> Thanks
> 
> [PATCH net-next-2.6] igmp: RCU conversion of in_dev->mc_list
> 
> in_dev->mc_list is protected by one rwlock (in_dev->mc_list_lock).
> 
> This can easily be converted to a RCU protection.
> 
> Writers hold RTNL, so mc_list_lock is removed, not replaced by a
> spinlock.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Cypher Wu <cypher.w@gmail.com>
> Cc: Américo Wang <xiyou.wangcong@gmail.com>
> ---

...

>  void ip_mc_up(struct in_device *in_dev)
>  {
> -	struct ip_mc_list *i;
> +	struct ip_mc_list *pmc;
>  
>  	ASSERT_RTNL();
>  
>  	ip_mc_inc_group(in_dev, IGMP_ALL_HOSTS);
>  
> -	for (i=in_dev->mc_list; i; i=i->next)
> -		igmp_group_added(i);
> +	for_each_pmc_rtnl(in_dev, pmc);
> +		igmp_group_added(pmc);
>  }


Oops there is an extra ; after the for_each_pmc_rtnl(in_dev, pmc)

should be

	for_each_pmc_rtnl(in_dev, pmc)
		igmp_group_added(pmc);



