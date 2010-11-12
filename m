Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0KLH2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:28:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60562 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0KLH16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w2D+A88Kag5bM7YBkvH8z7bfUPK/KMQodZnE1HbRh4SdsIB4ArXcTSZi+xF8/qB2OK
         kYO8n7T/tkXolS0VaBMASTuk14VG+8QjTlG79OsUyYFmXnzUTqGzu0y2KsF4jldDA1It
         ve6Uq/jNf8/tBhLgXnjrLCRhHU5f6reoILGU0=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20101112071323.GB5660@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 08:27:54 +0100
Message-ID: <1289546874.17691.1774.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 15:13 +0800, Américo Wang a écrit :
> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
> >On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
> >>
> >> Hi
> >>
> >> CC netdev, since you ask questions about network stuff _and_ rwlock
> >>
> >>
> >>> I'm using TILEPro and its rwlock in kernel is a liitle different than
> >>> other platforms. It have a priority for write lock that when tried it
> >>> will block the following read lock even if read lock is hold by
> >>> others. Its code can be read in Linux Kernel 2.6.36 in
> >>> arch/tile/lib/spinlock_32.c.
> >>
> >> This seems a bug to me.
> >>
> >> read_lock() can be nested. We used such a schem in the past in iptables
> >> (it can re-enter itself),
> >> and we used instead a spinlock(), but with many discussions with lkml
> >> and Linus himself if I remember well.
> >>
> >It seems not a problem that read_lock() can be nested or not since
> >rwlock doesn't have 'owner', it's just that should we give
> >write_lock() a priority than read_lock() since if there have a lot
> >read_lock()s then they'll starve write_lock().
> >We should work out a well defined behavior so all the
> >platform-dependent raw_rwlock has to design under that principle.
> 

AFAIK, Lockdep allows read_lock() to be nested.

> It is a known weakness of rwlock, it is designed like that. :)
> 

Agreed.

> The solution is to use RCU or seqlock, but I don't think seqlock
> is proper for this case you described. So, try RCU lock.

In the IGMP case, it should be easy for the task owning a read_lock() to
pass a parameter to the called function saying 'I already own the
read_lock(), dont try to re-acquire it'

A RCU conversion is far more complex.



