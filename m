Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0G2IfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab0G2IfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:35:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100729060004.GD2447@linux.vnet.ibm.com>
References: <20100729060004.GD2447@linux.vnet.ibm.com> <18537.1280318862@redhat.com> <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com> <20100727155023.GF1967@jolsa.brq.redhat.com> <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com> <24865.1280249187@redhat.com> <32758.1280321226@redhat.com> 
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Thu, 29 Jul 2010 09:34:20 +0100
Message-ID: <30107.1280392460@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> It is perfectly legal for an RCU callback to invoke call_rcu().  However,
> this should be used -only- to wait for RCU readers.  If there are no
> RCU readers, the callback might be re-invoked in very short order,
> expecially on UP systems.
> 
> Or am I misunderstanding what you mean by "require call_rcu() to be
> able to cope iwth requeueing"?

I mean for call_rcu() to be called on an object that's already been
call_rcu()'d but not yet processed.

For example if struct cred gets its usage count reduced to 0, __put_cred()
will call_rcu() it, but what happens if someone comes along and resurrects it
by increasing its usage count again?  And what happens if the usage count is
reduced back to zero and __put_cred() calls call_rcu() again before
put_cred_rcu() has a chance to run?

David
