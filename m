Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2KOVB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:01:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53982 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2KOVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:01:27 -0500
Date: Thu, 15 Nov 2012 13:01:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/4] mm, oom: cleanup pagefault oom handler
In-Reply-To: <50A4AB9E.4030106@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1211151257500.27188@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com> <alpine.DEB.2.00.1211140113020.32125@chino.kir.corp.google.com> <50A4AB9E.4030106@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Kamezawa Hiroyuki wrote:

> > @@ -708,15 +671,17 @@ out:
> > 
> >   /*
> >    * The pagefault handler calls here because it is out of memory, so kill a
> > - * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a
> > parallel
> > - * oom killing is already in progress so do nothing.  If a task is found
> > with
> > - * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
> > + * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
> > + * parallel oom killing is already in progress so do nothing.
> >    */
> >   void pagefault_out_of_memory(void)
> >   {
> > -	if (try_set_system_oom()) {
> > +	struct zonelist *zonelist = node_zonelist(first_online_node,
> > +						  GFP_KERNEL);
> 
> 
> why GFP_KERNEL ? not GFP_HIGHUSER_MOVABLE ?
> 

The usual way to get a zonelist consisting of all zones ordered by 
preferring a node is node_zonelist(nid, GFP_KERNEL), but there's no 
difference between using GFP_KERNEL, GFP_HIGHUSER_MOVABLE, or even 0.  I 
simply duplicated what the sysrq trigger was doing, but you could also do 
&first_online_pgdat->node_zonelists[0], it's really just a matter of 
preference.
