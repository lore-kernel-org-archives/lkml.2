Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab2BNCaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:30:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59792 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab2BNCaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:30:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120213.195835.1573147101037168145.davem@davemloft.net>
References: <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee>
 <20120213214623.GJ11077@ponder.secretlab.ca> <20120213.195835.1573147101037168145.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Feb 2012 19:30:02 -0700
X-Google-Sender-Auth: Rfyiw_vi-W63r4AnMm9iH7dOEYI
Message-ID: <CACxGe6tqsYs8-n2Q+EGGekS6wOOYYXUvUbEu6sfQ7U3--Gyjnw@mail.gmail.com>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 5:58 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Mon, 13 Feb 2012 14:46:23 -0700
>
>> Ugh; that looks bad.  If it failed there, then the global device node list
>> is corrupted.  I hate to ask you this, but would you be able to git bisect to
>> narrow down the commit that causes the problem?
>
> Wild guess on all of these bugs, bad OF node reference counting and a
> OF node is free'd up prematurely.
>
> If you look at the sparc code that has been subsumed into the generic
> drivers/of/ stuff over the past few years, you'll see that we never
> consistently did any of the reference counting bits on the sparc side.

Hmmm.... The of_node_put() code path shouldn't exist on sparc.  You'll
see that it is #ifdef'd out in include/linux/of.h.  Plus, only
'OF_DETACHED' nodes are allowed to be released, an there are only 3
code paths (all calling of_detach_node()) specific to powerpc that can
detach a node.

> I never did it, because I don't anticipate ever having hot-plug
> support for OF nodes.
>
> Anyways, if you now start to mix the drivers/of/ stuff which
> religiously does the reference counting with of_node_{get,put}()
> with the remaining scraps of sparc code that doesn't... it might
> not be pretty.
>
> In the crash dump after your test patch, we are in
> of_find_node_by_phandle() with a 'np' pointer in the allnodes list
> equal to 0x50.

Definitely not right!  It would be interesting to add a printk() to
of_find_node_by_phandle() or of_find_node_by_path() to blast out the
node names as it traverses the tree.  That could help track down
corruption.

>
> The signature in the original crash dump is identical, except
> that time we were in of_find_node_by_path(), but again the 'np'
> pointer was 0x50.
>
> Something else that might be suspicious were the memblock changes
> that happened this release cycle, so I wouldn't be surprised if
> a bisect turned up something in there.
>
> FWIW I've been running current kernels on my niagara boxes without
> incident for several weeks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
