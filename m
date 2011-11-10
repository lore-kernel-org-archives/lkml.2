Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab1KJCoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:44:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45601 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1KJCoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:44:01 -0500
Date: Wed, 9 Nov 2011 18:43:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
In-Reply-To: <1320892395.22361.229.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1111091828500.32414@chino.kir.corp.google.com>
References: <1319511521.22361.135.camel@sli10-conroe> <20111025114406.GC10182@redhat.com> <1319593680.22361.145.camel@sli10-conroe> <1320643049.22361.204.camel@sli10-conroe> <20111110021853.GQ5075@redhat.com> <1320892395.22361.229.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Shaohua Li wrote:

> > hugepage_attr_group is defined even if CONFIG_SYSFS is not set and I
> > just made a build with CONFIG_SYSFS=n and it builds just fine without
> > any change.
> 
> > $ grep CONFIG_SYSFS .config
> > # CONFIG_SYSFS is not set
> > 
> > So we can drop 1/5 above.
> this isn't the case in the code. And the code uses hugepage_attr_group
> is already within CONFIG_SYSFS, so your build success.
> 

You're right, but I agree that the #ifdef's just make the function error 
handling much too complex.  Would you mind adding sysfs_*_out labels at 
the end of the function to handle these errors instead?  And I think we 
should be doing khugepaged_slab_init() and mm_slots_hash_init() before 
initializing sysfs.

Something like

	out:
		khugepaged_slab_free();
		mm_slots_hash_free();	<-- after you remove it from #if 0
		return err;

	#ifdef CONFIG_SYSFS
	sysfs_khugepaged_out:
		sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
	sysfs_hugepage_out:
		sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
		...
		goto out;
	#endif
