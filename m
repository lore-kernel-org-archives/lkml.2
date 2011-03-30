Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1C3BZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:25:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab1C3BZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:25:07 -0400
Date: Tue, 29 Mar 2011 18:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: add alignment for some variables
Message-Id: <20110329182544.6ad4eccb.akpm@linux-foundation.org>
In-Reply-To: <1301447843.3981.48.camel@sli10-conroe>
References: <1301277536.3981.27.camel@sli10-conroe>
	<m2oc4v18x8.fsf@firstfloor.org>
	<1301360054.3981.31.camel@sli10-conroe>
	<20110329152434.d662706f.akpm@linux-foundation.org>
	<1301446882.3981.33.camel@sli10-conroe>
	<20110329180611.a71fe829.akpm@linux-foundation.org>
	<1301447843.3981.48.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 09:17:23 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> On Wed, 2011-03-30 at 09:06 +0800, Andrew Morton wrote:
> > On Wed, 30 Mar 2011 09:01:22 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> > 
> > > +/*
> > > + * Make sure vm_committed_as in one cacheline and not cacheline shared with
> > > + * other variables. It can be updated by several CPUs frequently.
> > > + */
> > > +struct percpu_counter vm_committed_as ____cacheline_internodealigned_in_smp;
> > 
> > The mystery deepens.  The only cross-cpu writeable fields in there are
> > percpu_counter.lock and its companion percpu_counter.count.  If CPUs
> > are contending for the lock then that itself is a problem - how does
> > adding some padding to the struct help anything?
> I had another patch trying to address the lock contention (for case
> OVERCOMMIT_GUESS), will send out soon. But thought better to have the
> correct alignment for OVERCOMMIT_NEVER case.

I still don't understand why adding
____cacheline_internodealigned_in_smp to vm_committed_as improves
anything.

Here it is:

struct percpu_counter {
	spinlock_t lock;
	s64 count;
#ifdef CONFIG_HOTPLUG_CPU
	struct list_head list;	/* All percpu_counters are on a list */
#endif
	s32 __percpu *counters;
};

and your patch effectively converts this to

  struct percpu_counter {
	spinlock_t lock;
  	s64 count;
  #ifdef CONFIG_HOTPLUG_CPU
	struct list_head list;	/* All percpu_counters are on a list */
  #endif
	s32 __percpu *counters;
+	char large_waste_of_space[lots];
  };

how is it that this improves things?
