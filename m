Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2GWLGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:06:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61874 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2GWLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:06:15 -0400
Date: Mon, 23 Jul 2012 13:06:10 +0200
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: isimatu.yasuaki@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH] memory-hotplug: Add memblock_state notifier
Message-ID: <20120723110610.GB18801@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1342783088-29970-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
 <500D1474.9070708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D1474.9070708@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 23, 2012 at 05:08:04PM +0800, Wen Congyang wrote:
> > +static int memblock_state_notifier_nb(struct notifier_block *nb, unsigned long
> > +		val, void *v)
> > +{
> > +	struct memory_notify *arg = (struct memory_notify *)v;
> > +	struct memory_block *mem = NULL;
> > +	struct mem_section *ms;
> > +	unsigned long section_nr;
> > +
> > +	section_nr = pfn_to_section_nr(arg->start_pfn);
> > +	ms = __nr_to_section(section_nr);
> > +	mem = find_memory_block(ms);
> > +	if (!mem)
> > +		goto out;
> 
> we may offline more than one memory block.
>
thanks, you are right.

> > +
> > +	switch (val) {
> > +	case MEM_GOING_OFFLINE:
> > +	case MEM_OFFLINE:
> > +	case MEM_GOING_ONLINE:
> > +	case MEM_ONLINE:
> > +	case MEM_CANCEL_ONLINE:
> > +	case MEM_CANCEL_OFFLINE:
> > +		mem->state = val;
> 
> mem->state is protected by the lock mem->state_mutex, so if you want to
> update the state, you must lock mem->state_mutex. But you cannot lock it
> here, because it may cause deadlock:
> 
> acpi_memhotplug                           sysfs interface
> ===============================================================================
>                                           memory_block_change_state()
>                                               lock mem->state_mutex
>                                               memory_block_action()
> offline_pages()
>     lock_memory_hotplug()
>                                                   offline_memory()
>                                                       lock_memory_hotplug() // block
>     memory_notify()
>         memblock_state_notifier_nb()
> ===============================================================================

good point. Maybe if memory_hotplug_lock and state_mutex locks are acquired in
the same order in the 2 code paths, this could be avoided.

> I'm writing another patch to fix it.

ok, I 'll test.
thanks,

- Vasilis
