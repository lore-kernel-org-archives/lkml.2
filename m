Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab0GIAOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:14:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0GIAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:14:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reduce stack usage of node_read_meminfo()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20100708135805.b4411965.akpm@linux-foundation.org>
References: <20100708181629.CD3C.A69D9226@jp.fujitsu.com> <20100708135805.b4411965.akpm@linux-foundation.org>
Message-Id: <20100709091138.CD57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 09:14:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu,  8 Jul 2010 18:20:14 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > Now, cmpilation node_read_meminfo() output following warning. Because
> > it has very large sprintf() argument.
> > 
> > 	drivers/base/node.c: In function 'node_read_meminfo':
> > 	drivers/base/node.c:139: warning: the frame size of 848 bytes is
> > 	larger than 512 bytes
> 
> hm, I'm surprised it's that much.

me too.

> 
> > --- a/drivers/base/node.c
> > +++ b/drivers/base/node.c
> > @@ -66,8 +66,7 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
> >  	struct sysinfo i;
> >  
> >  	si_meminfo_node(&i, nid);
> > -
> > -	n = sprintf(buf, "\n"
> > +	n = sprintf(buf,
> >  		       "Node %d MemTotal:       %8lu kB\n"
> >  		       "Node %d MemFree:        %8lu kB\n"
> >  		       "Node %d MemUsed:        %8lu kB\n"
> > @@ -78,13 +77,33 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
> >  		       "Node %d Active(file):   %8lu kB\n"
> >  		       "Node %d Inactive(file): %8lu kB\n"
> >  		       "Node %d Unevictable:    %8lu kB\n"
> > -		       "Node %d Mlocked:        %8lu kB\n"
> > +		       "Node %d Mlocked:        %8lu kB\n",
> > +		       nid, K(i.totalram),
> > +		       nid, K(i.freeram),
> > +		       nid, K(i.totalram - i.freeram),
> > +		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
> > +				node_page_state(nid, NR_ACTIVE_FILE)),
> 
> Why the heck did we decide to print the same node-id 10000 times?

dunno. but I don't want to make behavior change for only stack reducing.


> 
> > +	n += sprintf(buf,
> 
> You just got caught sending untested patches.
> 
> --- a/drivers/base/node.c~drivers-base-nodec-reduce-stack-usage-of-node_read_meminfo-fix
> +++ a/drivers/base/node.c
> @@ -93,7 +93,7 @@ static ssize_t node_read_meminfo(struct 
>  		       nid, K(node_page_state(nid, NR_MLOCK)));
>  
>  #ifdef CONFIG_HIGHMEM
> -	n += sprintf(buf,
> +	n += sprintf(buf + n,
>  		       "Node %d HighTotal:      %8lu kB\n"
>  		       "Node %d HighFree:       %8lu kB\n"
>  		       "Node %d LowTotal:       %8lu kB\n"
> @@ -103,7 +103,7 @@ static ssize_t node_read_meminfo(struct 
>  		       nid, K(i.totalram - i.totalhigh),
>  		       nid, K(i.freeram - i.freehigh));
>  #endif
> -	n += sprintf(buf,
> +	n += sprintf(buf + n,
>  		       "Node %d Dirty:          %8lu kB\n"
>  		       "Node %d Writeback:      %8lu kB\n"
>  		       "Node %d FilePages:      %8lu kB\n"
> _
> 
> 
> Please, run the code and check that we didn't muck up the output.

100% my fault. I ran it, but I forgot to merge two patches ;)




