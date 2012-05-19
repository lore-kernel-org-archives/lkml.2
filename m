Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2ESJrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 05:47:04 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:33951
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751339Ab2ESJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 05:47:01 -0400
Date: Sat, 19 May 2012 11:46:58 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] UBI: add ubi_lnum_purge function to clear work queue
 for a lnum
In-Reply-To: <1337082012.2528.181.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205191140280.19017@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net> <1337082012.2528.181.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Take the work_sem at the beginning. Release at the very end.
>
> Then you can do something like this:
>
> int found = 1;
>
> while (found) {
> 	found = 0;
>
> 	spin_lock(&ubi->wl_lock);
> 	list_for_each_entry(wrk, tmp, &ubi->works, list) {
> 		if (wrk->lnum == lnum) {
> 			list_del(&wrk->list);
> 			ubi->works_count -= 1;
> 			ubi_assert(ubi->works_count >= 0);
> 			spin_unlock(&ubi->wl_lock);
>
> 			err = wrk->func(ubi, wrk, 0);
> 			if (err)
> 				return err;
>
> 			spin_lock(&ubi->wl_lock);
> 			found = 1;
> 			break;
> 	}
> 	spin_unlock(&ubi->wl_lock);
> }
>


If I use list_for_each_entry_safe(), it protects against deleting as it
iterates. If I take the work_sem first, is it okay to do a simple
traversal instead of one traversal per removed item? Even if another
thread adds new work for the same vol_id/lnum, its okay, because the
caller of this function only cares about vol_id/lnums erasures that
it knows are currently on the worklist.

Cheers,
Joel Reardon
