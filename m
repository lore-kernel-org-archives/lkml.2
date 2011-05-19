Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab1ESDgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:36:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33037 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1ESDgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DB5XkknWPpNG3XJEktzrznqrWZktjh3GfAxyKttCK1oNSEapzED3HnrAtrybB9tKRu
         BQsCFiwDUB4CJGwu4TwA==
Date: Wed, 18 May 2011 20:36:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 2/2] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
In-Reply-To: <20110517213858.GC30232@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105182026390.20651@chino.kir.corp.google.com>
References: <20110517213858.GC30232@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Daniel Kiper wrote:

> This patch contains online_page_callback and apropriate functions for
> setting/restoring online page callbacks. It allows to do some machine
> specific tasks during online page stage which is required to implement
> memory hotplug in virtual machines. Additionally, __online_page_set_limits(),
> __online_page_increment_counters() and __online_page_free() function
> was added to ease generic hotplug operation.
> 

There are several issues with this.

First, this is completely racy and only allows one global callback to be 
in use at a time without looping, which is probably why you had to pass an 
argument to restore_online_page_callback().  Your implementation also 
requires that a callback must be synchronized with itself for the 
comparison to generic_online_page to make any sense.  Nobody knows which 
callback is effective at any given moment and has no guarantees that when 
they've set the callback that it will be the one called, otherwise.

Second, there's no explanation offered about why you have to split 
online_page() into three separate functions.  In addition, you've exported 
all of them so presumably modules will need to be doing this when loading 
or unloading and that further complicates the race mentioned above.

Third, there are no followup patches that use this interface or show how 
you plan on using it (other than eluding that it will be used for virtual 
machines in the changelog) so we're left guessing as to why we need it 
implemented in this fashion and restricts the amount of help I can offer 
because I don't know the problem you're facing.
