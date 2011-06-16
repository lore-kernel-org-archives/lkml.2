Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab1FPS2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:28:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64563 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab1FPS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mDNC+/xwUvdUnjvKnHLkCDxxbH2S/v2OQ8fd3RN+PLNVRNvV8iLg9TTfpWXn3dQ2O4
         WebKC+T3A0p8wrEaQEqcsgb5p4m00JP/FAeYS1eVVxZLgRmA6ujoWrOx4dIJumLnRh+/
         KMEbBCiGkK7I2C5rpkvfWPIK6jzHn7gWKDy1E=
Date: Thu, 16 Jun 2011 20:28:05 +0200
From: Tejun Heo <tj@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
Message-ID: <20110616182805.GD2611@htj.dyndns.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
 <1308071218-5912-2-git-send-email-tj@kernel.org>
 <1308226372.13240.42.camel@twins>
 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
 <1308246910.13240.238.camel@twins>
 <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 16, 2011 at 11:17:40AM -0700, Suresh Siddha wrote:
> On Thu, 2011-06-16 at 10:55 -0700, Peter Zijlstra wrote:
> > the caller already did get_online_cpus(), 
> > 
> > do_optimize_kprobes()
> >   get_online_cpus()
> >   arch_optimize_kprobes()
> >     text_poke_smp_batch()
> >   put_online_cpus()

Peter, I don't think it's that simple.  get_online_cpus() itself can't
create circular dependency by itself.  It allows recursing.  The chain
involves cpu_hotplug_begin() which returns with hotplug mutex held.

> So the circular dependency reported is not possible in practice right?
> 
> Above patch is working around a false positive.

But I don't think the lockdep warning is spurious.  text_mutex ->
hotplug.lock dependency is created during kprobe patching.
hotplug.lock -> smp_alt during CPU hotplug, and then the alternative
code calling get_online_cpus() creates reverse dependency through
get_online_cpus().  So, the reasoning and comment are wrong but
grapping hotplug mutex there does create a circular dependency.

This probably can be resolved in prettier way but let's leave it alone
for now.

Thanks.

-- 
tejun
