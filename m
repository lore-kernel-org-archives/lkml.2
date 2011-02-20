Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1BTTxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:53:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50204
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab1BTTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:53:19 -0500
Date: Sun, 20 Feb 2011 11:53:55 -0800 (PST)
Message-Id: <20110220.115355.59672016.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com, mhocko@suse.cz, mingo@elte.hu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik8kjt1TZ5vOoAm_y0f7toGtOSpxOsgCXO-bey9@mail.gmail.com>
References: <AANLkTincrnq1kMcAYEWYLf5vdbQ4DYbYObbg=0cLfHnm@mail.gmail.com>
	<m1oc67zcov.fsf@fess.ebiederm.org>
	<AANLkTik8kjt1TZ5vOoAm_y0f7toGtOSpxOsgCXO-bey9@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Feb 2011 22:15:23 -0800

> So unregister_netdevice_many() should always return with the list
> empty and destroyed. There is no valid use of a list of netdevices
> after you've unregistered them.
> 
> Now, dev_deactivate_many() actually has uses of that list after
> they've been de-activated (__dev_close_many will deactivate them, and
> then after that do the whole ndo_stop dance too, so I guess all (two)
> callers of that function need to get rid of their list manually. So I
> think your patch to sch_generic.c is good, but I really think the
> semantics of unregister_netdevice_many() should just be changed.

The key, as Eric D. mentioned, is the moment we changed the "scope" of
this list.

Previously all manipulations and use were guareded entirely inside of
holding the RTNL mutex.

The commit that introduced this regression allowed the list to be
"live" across RTNL mutex drop/re-grab.

Anyways, Eric B.'s patch (which I've just added to net-2.6) should
handle the known remaining cases, and as Eric D. said we should do one
more audit to make sure we got them all now.
