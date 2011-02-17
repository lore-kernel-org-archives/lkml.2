Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1BQGjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 01:39:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1BQGjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 01:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f0G7E9sbswCcNVcWYcMN9YDS6iiFFJw7vmCJq6N9oIwnuCUDfuVtMpnyZrx0bz4vxD
         bTTOq9Uho3piIPbTV2+exJCSq0AScNZnX7MKGNsKnsZS1OxoyxK6DDC6QtJmftL/oR+E
         H/WARLlIe5yy+/7q5FPVRRWbEL+a9Uzahv80A=
Subject: Re: IGMP and rwlock: Dead ocurred again on TILEPro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: xiyou.wangcong@gmail.com, cypher.w@gmail.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, netdev@vger.kernel.org
In-Reply-To: <20110216.214625.189707123.davem@davemloft.net>
References: <20110217044917.GA2653@cr0.nay.redhat.com>
	 <AANLkTikkro-_9pv5uJ4+SqYh9Fr480_96Wh1Pv6Pvtez@mail.gmail.com>
	 <20110217054237.GB2653@cr0.nay.redhat.com>
	 <20110216.214625.189707123.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 07:39:08 +0100
Message-ID: <1297924748.2645.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 février 2011 à 21:46 -0800, David Miller a écrit :
> From: Américo Wang <xiyou.wangcong@gmail.com>
> Date: Thu, 17 Feb 2011 13:42:37 +0800
> 
> > On Thu, Feb 17, 2011 at 01:04:14PM +0800, Cypher Wu wrote:
> >>>
> >>> Have you turned CONFIG_LOCKDEP on?
> >>>
> >>> I think Eric already converted that rwlock into RCU lock, thus
> >>> this problem should disappear. Could you try a new kernel?
> >>>
> >>> Thanks.
> >>>
> >>
> >>I haven't turned CONFIG_LOCKDEP on for test since I didn't get too
> >>much information when we tried to figured out the former deadlock.
> >>
> >>IGMP used read_lock() instead of read_lock_bh() since usually
> >>read_lock() can be called recursively, and today I've read the
> >>implementation of MIPS, it's should also works fine in that situation.
> >>The implementation of TILEPro cause problem since after it use TNS set
> >>the lock-val to 1 and hold the original value and before it re-set
> >>lock-val a new value, it a race condition window.
> >>
> > 
> > I see no reason why you can't call read_lock_bh() recursively,
> > read_lock_bh() is roughly equalent to local_bh_disable() + read_lock(),
> > both can be recursive.
> > 
> > But I may miss something here. :-/
> 
> IGMP is doing this so that taking the read lock does not stop packet
> processing.
> 
> TILEPro's rwlock implementation is simply buggy and needs to be fixed.

Yep. Finding all recursive readlocks in kernel and convert them to
another locking model is probably more expensive than fixing TILEPro
rwlock implementation.



