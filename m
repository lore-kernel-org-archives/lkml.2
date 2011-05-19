Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab1ESUqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:46:01 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:59078 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077Ab1ESUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:46:00 -0400
Date: Thu, 19 May 2011 22:45:09 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V3 2/2] mm: Extend memory hotplug API to allow memory hotplug in virtual machines
Message-ID: <20110519204509.GD27202@router-fw-old.local.net-space.pl>
References: <20110517213858.GC30232@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105182026390.20651@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105182026390.20651@chino.kir.corp.google.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:36:02PM -0700, David Rientjes wrote:
> On Tue, 17 May 2011, Daniel Kiper wrote:
>
> > This patch contains online_page_callback and apropriate functions for
> > setting/restoring online page callbacks. It allows to do some machine
> > specific tasks during online page stage which is required to implement
> > memory hotplug in virtual machines. Additionally, __online_page_set_limits(),
> > __online_page_increment_counters() and __online_page_free() function
> > was added to ease generic hotplug operation.
>
> There are several issues with this.
>
> First, this is completely racy and only allows one global callback to be
> in use at a time without looping, which is probably why you had to pass an

One callback is allowed by design. Currently I do not see
any real usage for more than one callback.

> argument to restore_online_page_callback().  Your implementation also

This is protection against accidental callback restore
by module which does not registered callback.

> requires that a callback must be synchronized with itself for the
> comparison to generic_online_page to make any sense.  Nobody knows which

This is protection against accidental earlier registered callback
overwrite by module which does not registered callback.

> callback is effective at any given moment and has no guarantees that when
> they've set the callback that it will be the one called, otherwise.

It is assured by design described above that if module registered callback
then it will be called during online page phase (If it is not earlier
unregistered by module knowing address to that callback).

> Second, there's no explanation offered about why you have to split
> online_page() into three separate functions.  In addition, you've exported
> all of them so presumably modules will need to be doing this when loading
> or unloading and that further complicates the race mentioned above.

My work on memory hotplug for Xen showed that most of the code from original
online_page() is called in my implementation of Xen online_page(). In that
situation Dave Hansen and I agreed that it is worth to split original
online_page() into let say "atomic" operations and export them to
other modules to reuse existing code and avoid stupid bugs.

> Third, there are no followup patches that use this interface or show how
> you plan on using it (other than eluding that it will be used for virtual
> machines in the changelog) so we're left guessing as to why we need it
> implemented in this fashion and restricts the amount of help I can offer
> because I don't know the problem you're facing.

Patch which depends on that patch is here: https://lkml.org/lkml/2011/5/17/413.
However, I agree that comment is not clear.

In general I see that comment for this
patch should be clarified/extended.

Daniel
