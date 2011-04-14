Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1DNJIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:08:19 -0400
Received: from gmmr7.centrum.cz ([90.183.38.150]:54369 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab1DNJIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:08:17 -0400
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.36
Date: Thu, 14 Apr 2011 11:08:16 +0200
From: "azurIt" <azurit@pobox.sk>
Cc: "Changli Gao" <xiaosuo@gmail.com>,
        "=?UTF-8?Q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
References: <20110315132527.130FB80018F1@mail1005.cent>	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>	 <4D9D8FAA.9080405@suse.cz>	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>	 <1302177428.3357.25.camel@edumazet-laptop>	 <1302178426.3357.34.camel@edumazet-laptop>	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>	 <1302190586.3357.45.camel@edumazet-laptop>	 <20110412154906.70829d60.akpm@linux-foundation.org>	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>	 <20110412183132.a854bffc.akpm@linux-foundation.org>	 <1302662256.2811.27.camel@edumazet-laptop>	 <20110413141600.28793661.akpm@linux-foundation.org>	 <1302747058.3549.7.camel@edumazet-laptop>	 <20110413222803.38e42baf.akpm@linux-foundation.org> <1302762718.3549.229.camel@edumazet-laptop>
In-Reply-To: <1302762718.3549.229.camel@edumazet-laptop>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110414110816.EA841944@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here it is:


# ls /proc/31416/fd | wc -l
5926


azur


______________________________________________________________
> Od: "Eric Dumazet" <eric.dumazet@gmail.com>
> Komu: Andrew Morton <akpm@linux-foundation.org>
> Dátum: 14.04.2011 08:32
> Predmet: Re: Regression from 2.6.36
>
> CC: "Changli Gao" <xiaosuo@gmail.com>, "Américo Wang" <xiyou.wangcong@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
>Le mercredi 13 avril 2011 à 22:28 -0700, Andrew Morton a écrit :
>> On Thu, 14 Apr 2011 04:10:58 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> 
>> > > --- a/fs/file.c~a
>> > > +++ a/fs/file.c
>> > > @@ -39,14 +39,17 @@ int sysctl_nr_open_max = 1024 * 1024; /*
>> > >   */
>> > >  static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
>> > >  
>> > > -static inline void *alloc_fdmem(unsigned int size)
>> > > +static void *alloc_fdmem(unsigned int size)
>> > >  {
>> > > -	void *data;
>> > > -
>> > > -	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>> > > -	if (data != NULL)
>> > > -		return data;
>> > > -
>> > > +	/*
>> > > +	 * Very large allocations can stress page reclaim, so fall back to
>> > > +	 * vmalloc() if the allocation size will be considered "large" by the VM.
>> > > +	 */
>> > > +	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) {
>> > > +		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>> > > +		if (data != NULL)
>> > > +			return data;
>> > > +	}
>> > >  	return vmalloc(size);
>> > >  }
>> > >  
>> > > _
>> > > 
>> > 
>> > Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>> > 
>> > #define PAGE_ALLOC_COSTLY_ORDER 3
>> > 
>> > On x86_64, this means we try kmalloc() up to 4096 files in fdtable.
>> 
>> Thanks.  I added the cc:stable to the changelog.
>> 
>> It'd be nice to get this tested if poss, to confrm that it actually
>> fixes things.
>> 
>> Also, Melpoke.
>
>Azurit, could you check how many fds are opened by your apache servers ?
>(must be related to number of virtual hosts / acces_log / error_log
>files)
>
>Pick one pid from ps list
>ps aux | grep apache
>
>ls /proc/{pid_of_one_apache}/fd | wc -l
>
>or
>
>lsof -p { pid_of_one_apache} | tail -n 2
>apache2 8501 httpadm   13w   REG     104,7  2350407   3866638 /data/logs/httpd/rewrites.log
>apache2 8501 httpadm   14r  0000      0,10        0 263148343 eventpoll
>
>Here it's "14"
>
>Thanks
>
>
>
