Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0IWTN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:13:58 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60124 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752066Ab0IWTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:13:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ8/m0xGGN6i/2dsb2JhbACiM3LHe4VCBA
Date: Thu, 23 Sep 2010 15:08:54 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 03/11] jump label: Base patch for jump label
Message-ID: <20100923190854.GA32400@Krystal>
References: <20100923034910.867858597@goodmis.org> <20100923035608.228041459@goodmis.org> <20100923143758.GA4022@Krystal> <20100923153902.GD2825@redhat.com> <20100923154852.GA12648@Krystal> <20100923184006.GE2825@redhat.com> <20100923185540.GA30262@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100923185540.GA30262@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:05:37 up 169 days,  4:56,  3 users,  load average: 0.32, 0.17,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
[...]
> > jump label: fix __init module section race
> > 
> > Jump label uses is_module_text_address() to ensure that the module
> > __init sections are valid before updating them. However, between the
> > check for a valid module __init section and the subsequent jump
> > label update, the module's __init section could be free out from under
> > us.
> > 
> > We fix this potential race putting the address check *and* the jump
> > label update under a rcu_read_lock(), and making sure a grace period
> > has completed before we free the __init section.
> > 
> > Thanks to Mathieu Desnoyers for pointing out this race condition.

Actually, there might be another way to deal with this that would not
require holding rcu read lock at all in this path, nor adding
synchronize_rcu in the module code.

This involves adding a notifier right before the init code is freed, so
the static jump code can disable all static jumps pointing to init code
area for the given module.

On the plus side, this means text_poke would be free to still use
synchronize_rcu() if it ever needs to. Also, calling a notifier chain
before freeing the module init region will hurt module load time much
less than waiting for a grace period.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
