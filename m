Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1G2SCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:02:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1G2SCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:02:10 -0400
Subject: Re: [PATCH] sunrpc: use better NUMA affinities
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, Neil Brown <neilb@suse.de>,
        David Miller <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Banks <gnb@fastmail.fm>
In-Reply-To: <20110729164214.GI23194@fieldses.org>
References: <1311876249.2346.39.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110729164214.GI23194@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 20:02:05 +0200
Message-ID: <1311962525.2873.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 12:42 -0400, J. Bruce Fields a écrit :
> On Thu, Jul 28, 2011 at 08:04:09PM +0200, Eric Dumazet wrote:
> > Use NUMA aware allocations to reduce latencies and increase throughput.
> > 
> > sunrpc kthreads can use kthread_create_on_node() if pool_mode is
> > "percpu" or "pernode", and svc_prepare_thread()/svc_init_buffer() can
> > also take into account NUMA node affinity for memory allocations.
> ...
> > @@ -662,14 +675,16 @@ svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
> >  		nrservs--;
> >  		chosen_pool = choose_pool(serv, pool, &state);
> >  
> > -		rqstp = svc_prepare_thread(serv, chosen_pool);
> > +		node = svc_pool_map_get_node(chosen_pool->sp_id);
> > +		rqstp = svc_prepare_thread(serv, chosen_pool, node);
> 
> The only correct value for the third argument there is
> svc_pool_map_get_node(chosen_pool->sp_id), so let's have
> svc_prepare_thread() call that itself.
> 

I have no idea of what you mean ;)

I need 'node' for the following kthread_create_on_node()


> Seems OK otherwise.
> 
> Any suggestions on how we should test this?

I did tests on my machine, seems good.

I checked that stacks were now correct using :
"echo t > /proc/sysrq-trigger"



