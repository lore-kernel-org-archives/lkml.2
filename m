Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2E3PPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:15:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38459 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab2E3PPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:15:39 -0400
Date: Wed, 30 May 2012 11:08:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Message-ID: <20120530150827.GA12109@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:09:12PM +0000, Liu, Jinsong wrote:
> > 
> > Still no go, this is current linus with your patch applied. I'll look
> > into it 
> > later when there's time.
> 
> The root cause is,
> 1). at cpu/mcheck/mce.c, device_initcall_sync(mcheck_init_device) is *after* all device_initcall();
> 2). at cpu/mcheck/mce_amd.c, device_initcall(threshold_init_device) will
>     threshold_init_device 
>     --> threshold_create_device 
>     --> threshold_create_bank
>     --> kobject_create_and_add(name, &dev->kobj);
>         // at this point, struct device *dev = per_cpu(mce_device, cpu), which is a NULL pointer.
>         // mce_device is initialized at mcheck_init_device --> mce_device_create
> 3). so kernel panic
> 
> So our RFC patch would affect amd mce logic.
> 
> ===========================
> 
> I have a thought about symlink approach, but seems it would bring more issues, e.g.
> 1). it need change more native mce code, like remove /dev/mcelog which created at native mce (under xen platform), or
> 2). it still need to change device_initcall(mcheck_init_device) to device_initcall_sync(mcheck_init_device), if it want to implicitly block native /dev/mcelog --> but that would panic amd mce logic.
> 
> IMO currently there are 2 options:
> 1). use the original approach (implicitly redirect /dev/mcelog to xen_mce_chrdev_device) --> what point of this approach do you think unreasonable? It just remove a 'static' from native mce code!
> 2). use another /dev/xen-mcelog interface, with another misc minor '226'

The 2) is no good.

3) What about moving the corresponding other users (so threshold_init_device), 
to be at late_initcall and the mce to be at late_initcall_sync

4) Or make the driver you are making start at fs_initcall ?
