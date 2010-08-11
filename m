Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0HKJSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 05:18:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:58941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0HKJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 05:18:11 -0400
Date: Wed, 11 Aug 2010 11:18:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Karsten Mehrhoff <kawime@gmx.de>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: tomoyo-init (tomoyo-tools) results in kernel panic on kernel
 2.6.35-git2/3
In-Reply-To: <op.vg8otu2fgp7xae@127.0.0.1>
Message-ID: <alpine.LNX.2.00.1008111116200.2702@pobox.suse.cz>
References: <op.vg0yh9gtgp7xae@127.0.0.1> <201008070504.o7754Daw083381@www262.sakura.ne.jp> <alpine.LRH.2.00.1008101443340.2372@twin.jikos.cz> <201008102014.o7AKEwte077880@www262.sakura.ne.jp> <op.vg8otu2fgp7xae@127.0.0.1>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Karsten Mehrhoff wrote:

> > > Still, if a legacy userspace application is able to cause kernel panic,
> > > that sounds like something we'd rather fix immediately.
> > 
> > I assume the panic message which Karsten encountered is either
> > 
> >  Profile version %u is not supported.
> > 
> > or
> > 
> >  Profile %u (used by '%s') not defined.
> > 
> > which happens only if access control rules (a.k.a. policy) was not
> > loaded when /sbin/init starts.
> > 
> > If what Karsten encountered is not the cases above,
> > I agree that we need to fix immediately.
> > 
> > Regards.
> 
> The panic message was:
> >  Profile %u (used by '%s') not defined.
> 
> Profile 0 (used by '0') not defined.

Looking at the code ...

	void tomoyo_check_profile(void)
	{
	        struct tomoyo_domain_info *domain;
	        const int idx = tomoyo_read_lock();
	        tomoyo_policy_loaded = true;
	        /* Check all profiles currently assigned to domains are defined. */
	        list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
	                const u8 profile = domain->profile;
	                if (tomoyo_profile_ptr[profile])
	                        continue;
	                panic("Profile %u (used by '%s') not defined.\n",
	                      profile, domain->domainname->name);
	        }
	        tomoyo_read_unlock(idx);
	        if (tomoyo_profile_version != 20090903)
	                panic("Profile version %u is not supported.\n",
	                      tomoyo_profile_version);
	        printk(KERN_INFO "TOMOYO: 2.3.0\n");
	        printk(KERN_INFO "Mandatory Access Control activated.\n");
	}

makes one wonder whether not having up-to-date userspace really does 
qualify for unconditional kernel panic.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
