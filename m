Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0DVAAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:00:51 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41782 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab0DVAAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:00:49 -0400
Date: Wed, 21 Apr 2010 17:00:49 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH v2] VMware Balloon driver
Message-ID: <20100422000048.GB4021@dtor-ws.eng.vmware.com>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
 <20100405142419.2c9bea3d.akpm@linux-foundation.org>
 <20100415210030.GA5359@dtor-ws.eng.vmware.com>
 <20100421165449.364d5325.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421165449.364d5325.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 04:54:49PM -0700, Andrew Morton wrote:
> On Thu, 15 Apr 2010 14:00:31 -0700
> Dmitry Torokhov <dtor@vmware.com> wrote:
> 
> > This is standalone version of VMware Balloon driver. Ballooning is a
> > technique that allows hypervisor dynamically limit the amount of memory
> > available to the guest (with guest cooperation). In the overcommit
> > scenario, when hypervisor set detects that it needs to shuffle some memory,
> > it instructs the driver to allocate certain number of pages, and the
> > underlying memory gets returned to the hypervisor. Later hypervisor may
> > return memory to the guest by reattaching memory to the pageframes and
> > instructing the driver to "deflate" balloon.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > ---
> > 
> > Unlike previous version, that tried to integrate VMware ballooning transport
> > into virtio subsystem, and use stock virtio_ballon driver, this one implements
> > both controlling thread/algorithm and hypervisor transport.
> > 
> > We are submitting standalone driver because KVM maintainer (Avi Kivity)
> > expressed opinion (rightly) that our transport does not fit well into
> > virtqueue paradigm and thus it does not make much sense to integrate
> > with virtio.
> > 
> > There were also some concerns whether current ballooning technique is
> > the right thing. If there appears a better framework to achieve this we
> > are prepared to evaluate and switch to using it, but in the meantime
> > we'd like to get this driver upstream.
> > 
> > Changes since v1:
> > 	- added comments throughout the code;
> > 	- exported stats moved from /proc to debugfs;
> > 	- better changelog.
> > 
> >
> > ...
> >
> > +#define VMW_BALLOON_NOSLEEP_ALLOC_MAX	16384U
> > +
> > +#define VMW_BALLOON_RATE_ALLOC_MIN	512U
> > +#define VMW_BALLOON_RATE_ALLOC_MAX	2048U
> > +#define VMW_BALLOON_RATE_ALLOC_INC	16U
> > +
> > +#define VMW_BALLOON_RATE_FREE_MIN	512U
> > +#define VMW_BALLOON_RATE_FREE_MAX	16384U
> > +#define VMW_BALLOON_RATE_FREE_INC	16U
> 
> hum.  What do these do and what units are they in?  Needs a comment?

These control inflating/deflating rate of the ballon, mesured in
pages/sec. I will add a comment.

> 
> >
> > ...
> >
> > +#define VMWARE_BALLOON_CMD(cmd, data, result)		\
> > +({							\
> > +	unsigned long __stat, __dummy1, __dummy2;	\
> > +	__asm__ __volatile__ ("inl (%%dx)" :		\
> > +		"=a"(__stat),				\
> > +		"=c"(__dummy1),				\
> > +		"=d"(__dummy2),				\
> > +		"=b"(result) :				\
> > +		"0"(VMW_BALLOON_HV_MAGIC),		\
> > +		"1"(VMW_BALLOON_CMD_##cmd),		\
> > +		"2"(VMW_BALLOON_HV_PORT),		\
> > +		"3"(data) :				\
> > +		"memory");				\
> > +	result &= -1UL;					\
> > +	__stat & -1UL;					\
> > +})
> 
> This is OK for both x86_32 and x86_64?

Yes it is.

> 
> Was it actually intended that this driver be enabled for 32-bit?
> 

Yes.

> > +#define STATS_INC(stat) (stat)++
> > +
> > +struct vmballoon_stats {
> > +	unsigned int timer;
> > +
> > +	/* allocation statustics */
> > +	unsigned int alloc;
> > +	unsigned int alloc_fail;
> > +	unsigned int sleep_alloc;
> > +	unsigned int sleep_alloc_fail;
> > +	unsigned int refused_alloc;
> > +	unsigned int refused_free;
> > +	unsigned int free;
> > +
> > +	/* monitor operations */
> > +	unsigned int lock;
> > +	unsigned int lock_fail;
> > +	unsigned int unlock;
> > +	unsigned int unlock_fail;
> > +	unsigned int target;
> > +	unsigned int target_fail;
> > +	unsigned int start;
> > +	unsigned int start_fail;
> > +	unsigned int guest_type;
> > +	unsigned int guest_type_fail;
> > +};
> > +
> > +struct vmballoon {
> > +
> > +	/* list of reserved physical pages */
> > +	struct list_head pages;
> > +
> > +	/* transient list of non-balloonable pages */
> > +	struct list_head refused_pages;
> > +
> > +	/* balloon size in pages */
> > +	unsigned int size;
> > +	unsigned int target;
> > +
> > +	/* reset flag */
> > +	bool reset_required;
> > +
> > +	/* adjustment rates (pages per second) */
> > +	unsigned int rate_alloc;
> > +	unsigned int rate_free;
> > +
> > +	/* slowdown page allocations for next few cycles */
> > +	unsigned int slow_allocation_cycles;
> > +
> > +	/* statistics */
> > +	struct vmballoon_stats stats;
> > +
> > +	/* debugfs file exporting statistics */
> > +	struct dentry *dbg_entry;
> > +
> > +	struct sysinfo sysinfo;
> > +
> > +	struct delayed_work dwork;
> > +};
> 
> afaict all the stats stuff is useless if CONFIG_DEBUG_FS=n.  Perhaps in
> that case the vmballoon.stats field should be omitted and STATS_INC
> be made a no-op?
> 

OK, will do.

Thanks Andrew.

-- 
Dmitry 
