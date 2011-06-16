Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1FPMpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:45:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53775 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1FPMo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KAv9BXwKfjytP3udq00/91icGNKnHHtbQHBrhjQGQFjX+ioaK+t9Qhw2BVnVM3lr/+
         7xn/ulFtvs0bD0ytrTkkgdKFzCtcGNo8JyepGOl5H6UO2tG7WGsXWH5n7QQdSnnD8BzV
         KZ+gVbwggBMGVpcivCUf9gLbYJgIoRzJXCiDw=
Date: Thu, 16 Jun 2011 14:44:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
Message-ID: <20110616124452.GC2611@htj.dyndns.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
 <1308071218-5912-2-git-send-email-tj@kernel.org>
 <1308226372.13240.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308226372.13240.42.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 02:12:52PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-14 at 19:06 +0200, Tejun Heo wrote:
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -719,8 +719,7 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
> >         tpp.nparams = 1;
> >         atomic_set(&stop_machine_first, 1);
> >         wrote_text = 0;
> > -       /* Use __stop_machine() because the caller already got online_cpus. */
> > -       __stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
> > +       stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
> >         return addr;
> >  }
> 
> Please have a look at: 
> 
> ---
> commit d91309f69b7bdb64aeb30106fde8d18c5dd354b5
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Feb 11 22:07:46 2011 +0100
> 
>     x86: Fix text_poke_smp_batch() deadlock
>     
>     Fix this deadlock - we are already holding the mutex:

Ah, right, I thought cpu_hotplug_begin() sets active_writer and then
returns with cpu_hotplug.lock released.  Weird locking there.
Anyways, this one should be dropped then and I don't think it affects
the rest of the series much.

Thanks.

-- 
tejun
