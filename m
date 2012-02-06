Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2BFSXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:23:31 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17007 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2BFSXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:23:30 -0500
Date: Mon, 6 Feb 2012 13:20:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject (ffff88003ffbb4b8): tried to init an initialized object,
 something is seriously wrong.
Message-ID: <20120206182040.GA1862@phenom.dumpdata.com>
References: <20120203205953.GA2897@phenom.dumpdata.com>
 <20120203213949.GC8196@kroah.com>
 <20120203214235.GA10549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203214235.GA10549@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F301AA0.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:42:35PM -0800, Greg KH wrote:
> On Fri, Feb 03, 2012 at 01:39:49PM -0800, Greg KH wrote:
> > On Fri, Feb 03, 2012 at 03:59:53PM -0500, Konrad Rzeszutek Wilk wrote:
> > > Hey Greg,
> > > 
> > > With or without your previous patch (the one that added an cpu_device_release
> > > function) I am getting this in 3.3-rc2.  I did not get this in 3.2.
> > > 
> > > I added some extra printks to make sure that the handle_vcpu_hotplug_event
> > > code actually did call 'arch_unregister_cpu' which is certainly looks
> > > to be doing.
> > > 
> > > I hadn't done a bisection yet, but was wondering if this is related
> > > to the previous issues with the sysdev. Or kobject getting more observant.
> > 
> > No, it's related to the previous issue, let me knock up a patch to fix
> > this as well...
> 
> Does this patch solve the problem for you?

Yeah, no warnings. But neither is the CPU coming back up :-(

Thought that might be related to something else  - let me double check
with 3.2 whether there are some race-conditions that I might be hitting.

> 
> thanks,
> 
> greg k-h
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 23f2c4c..4dabf50 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -240,6 +240,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  	int error;
>  
>  	cpu->node_id = cpu_to_node(num);
> +	memset(&cpu->dev, 0x00, sizeof(struct device));
>  	cpu->dev.id = num;
>  	cpu->dev.bus = &cpu_subsys;
>  	cpu->dev.release = cpu_device_release;
