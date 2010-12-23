Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0LWDZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:25:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab0LWDZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:25:39 -0500
Date: Wed, 22 Dec 2010 19:21:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohui Zheng <shaohui.zheng@linux.intel.com>
Cc: shaohui.zheng@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <Yinghai.Lu@Sun.COM>, Tejun Heo <tj@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [5/7, v9] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Message-Id: <20101222192118.2d286ca9.akpm@linux-foundation.org>
In-Reply-To: <20101223013410.GA11356@shaohui>
References: <20101210073119.156388875@intel.com>
	<20101210073242.670777298@intel.com>
	<20101222162727.56b830b0.akpm@linux-foundation.org>
	<20101223013410.GA11356@shaohui>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 09:34:10 +0800 Shaohui Zheng <shaohui.zheng@linux.intel.com> wrote:

> On Wed, Dec 22, 2010 at 04:27:27PM -0800, Andrew Morton wrote:
> > On Fri, 10 Dec 2010 15:31:24 +0800
> > > +
> > > +ssize_t arch_cpu_probe(const char *buf, size_t count)
> > > +{
> > > +	int nid = 0;
> > > +	int num = 0, selected = 0;
> > 
> > One definition per line make for more maintainable code.
> > 
> > Two of these initialisations are unnecessary.
> > 
> Agree, I will put them into 2 lines, and remove the initialisations.
> I always try to initialize them when we define it, it seems that it is a bad habit.
> 
> > > +	/* check parameters */
> > > +	if (!buf || count < 2)
> > > +		return -EPERM;
> > > +
> > > +	nid = simple_strtoul(buf, NULL, 0);
> > 
> > checkpatch?
> 
> it is a warning, so I ignore it.

Don't ignore warnings!  At least, not until you've understood the
reason for them and have a *reason* to ignore them.

simple_strtoul() will silently accept input of the form "42foo",
treating it as "42".  That's a userspace bug and the kernel should
report it.  This means that the code should be changed to handle error
returns from strict_strtoul().  And those error paths should be tested.

> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	if (selected >= num_possible_cpus()) {
> > > +		printk(KERN_ERR "No free cpu, give up cpu probing.\n");
> > > +		return -EPERM;
> > > +	}
> > > +
> > > +	/* register cpu */
> > > +	arch_register_cpu_node(selected, nid);
> > > +	acpi_map_lsapic_emu(selected, nid);
> > > +
> > > +	return count;
> > > +}
> > > +EXPORT_SYMBOL(arch_cpu_probe);
> > 
> > arch_cpu_probe() is global and exported to modules, but is undocumented.
> > 
> > If it had been documented, I might have been able to work out why arg
> > `count' is checked, but never used.
> > 
> 
> Sorry, Andrew, I did not catch it. Do you mean to add the document before
>  the definition of the function arch_cpu_probe?

Sure, add a comment documenting the function.

Why *does* it check `count' and then not use it?

> 
> > > +	/* cpu 0 is not hotplugable */
> > > +	if (cpu == 0) {
> > > +		printk(KERN_ERR "can not release cpu 0.\n");
> > 
> > It's generally better to make kernel messages self-identifying. 
> > Especially error messages.  If someone comes along and sees "can not
> > release cpu 0" in their logs, they don't have a clue what caused it
> > unless they download the kernel sources and go grepping.
> > 
> 
> How about "arch_cpu_release: can not release cpu 0.\n"?

Better, although "arch_cpu_release" isn't very meaningful to an
administrator.  "NUMA hotplug remove" or something like that would be
more useful.

All these messages should be looked at from the point of view of the
people who they are to serve.  Although in this special case, that's
most likely to be a kernel developer so I guess such clarity isn't
needed.


