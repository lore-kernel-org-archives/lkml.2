Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1ECUOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:14:42 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48759 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1ECUOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:14:41 -0400
Date: Tue, 3 May 2011 22:13:34 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 2/2] mm: Extend memory hotplug API to allow memory hotplug in virtual machines
Message-ID: <20110503201334.GB15775@router-fw-old.local.net-space.pl>
References: <20110502214921.GH4623@router-fw-old.local.net-space.pl> <1304439952.30823.68.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304439952.30823.68.camel@nimitz>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:25:52AM -0700, Dave Hansen wrote:
> On Mon, 2011-05-02 at 23:49 +0200, Daniel Kiper wrote:
> > +int register_online_page_callback(online_page_callback_t callback)
> > +{
> > +       int rc = -EPERM;
> > +
> > +       lock_memory_hotplug();
> > +
> > +       if (online_page_callback == generic_online_page) {
> > +               online_page_callback = callback;
> > +               rc = 0;
> > +       }
> > +
> > +       unlock_memory_hotplug();
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(register_online_page_callback);
> 
> -EPERM is a bit uninformative here.  How about -EEXIST, plus a printk?

EEXIST means File exists (POSIX.1). It could be misleading. That is why
I decided to use EPERM. I could not find any better choice. I think another
choice is EINVAL (not the best one in my opinion). Additionally, I am not
sure it should have printk. I think it is role of caller to notify (or not)
about possible errors.

> I also don't seen the real use behind having a "register" that can only
> take a single callback.  At worst, it should be
> "set_online_page_callback()" so it's more apparent that there can only
> be one of these.

OK.

> > +int unregister_online_page_callback(online_page_callback_t callback)
> > +{
> > +       int rc = -EPERM;
> > +
> > +       lock_memory_hotplug();
> > +
> > +       if (online_page_callback == callback) {
> > +               online_page_callback = generic_online_page;
> > +               rc = 0;
> > +       }
> > +
> > +       unlock_memory_hotplug();
> > +
> > +       return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_online_page_callback); 
> 
> Again, -EPERM is a bad code here. -EEXIST, perhaps?  It also deserves a
> WARN_ON() or a printk on failure here.  

Please look above.

> Your changelog doesn't mention, but what ever happened to doing
> something dirt-simple like this?  I have a short memory.

Andrew Morton complained about (ab)use of notifiers. He suggested
to use callback machanism (I could not find any better solution
in Linux Kernel). He convinced me.

Daniel
