Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1ECQ02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:26:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45949 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1ECQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:26:25 -0400
Subject: Re: [PATCH V2 2/2] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110502214921.GH4623@router-fw-old.local.net-space.pl>
References: <20110502214921.GH4623@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 03 May 2011 09:25:52 -0700
Message-ID: <1304439952.30823.68.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 23:49 +0200, Daniel Kiper wrote:
> +int register_online_page_callback(online_page_callback_t callback)
> +{
> +       int rc = -EPERM;
> +
> +       lock_memory_hotplug();
> +
> +       if (online_page_callback == generic_online_page) {
> +               online_page_callback = callback;
> +               rc = 0;
> +       }
> +
> +       unlock_memory_hotplug();
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(register_online_page_callback);

-EPERM is a bit uninformative here.  How about -EEXIST, plus a printk?

I also don't seen the real use behind having a "register" that can only
take a single callback.  At worst, it should be
"set_online_page_callback()" so it's more apparent that there can only
be one of these.

> +int unregister_online_page_callback(online_page_callback_t callback)
> +{
> +       int rc = -EPERM;
> +
> +       lock_memory_hotplug();
> +
> +       if (online_page_callback == callback) {
> +               online_page_callback = generic_online_page;
> +               rc = 0;
> +       }
> +
> +       unlock_memory_hotplug();
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(unregister_online_page_callback); 

Again, -EPERM is a bad code here. -EEXIST, perhaps?  It also deserves a
WARN_ON() or a printk on failure here.  

Your changelog doesn't mention, but what ever happened to doing
something dirt-simple like this?  I have a short memory.

> void arch_free_hotplug_page(struct page *page)
> {
>       if (xen_need_to_inflate_balloon())
>               put_page_in_balloon(page);
>       else
>               __free_page(page);
> }

-- Dave

