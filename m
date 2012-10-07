Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2JGQth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:49:37 -0400
Received: from shutemov.name ([176.9.204.213]:59905 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab2JGQtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:49:31 -0400
Date: Sun, 7 Oct 2012 19:50:12 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: Deadlock on poweroff
Message-ID: <20121007165012.GA23535@shutemov.name>
References: <20121007024711.GA21403@shutemov.name>
 <20121007160311.GE2485@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007160311.GE2485@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 09:03:11AM -0700, Paul E. McKenney wrote:
> On Sun, Oct 07, 2012 at 05:47:11AM +0300, Kirill A. Shutemov wrote:
> > Hi Paul and all,
> > 
> > With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
> > poweroff.
> > 
> > It guess it happens because of race for cpu_hotplug.lock:
> > 
> > 	CPU A					CPU B
> > disable_nonboot_cpus()
> > _cpu_down()
> > cpu_hotplug_begin()
> >  mutex_lock(&cpu_hotplug.lock);
> > __cpu_notify()
> > padata_cpu_callback()
> > __padata_remove_cpu()
> > padata_replace()
> > synchronize_rcu()
> > 					rcu_gp_kthread()
> > 					get_online_cpus();
> > 					mutex_lock(&cpu_hotplug.lock);
> > 
> > Have you seen the issue before?
> 
> This is a new one for me.  Does the following (very lightly tested)
> patch help?

Works for me. Thanks.

-- 
 Kirill A. Shutemov
