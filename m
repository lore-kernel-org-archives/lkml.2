Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0D0BlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:41:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:44076 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab0D0Bk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:40:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,276,1270450800"; 
   d="scan'208";a="512711870"
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tim.c.chen@intel.com
In-Reply-To: <x2o84144f021004260309k9edf9e88t92e4c988d12de234@mail.gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>
	 <alpine.DEB.2.00.1004221045270.1204@router.home>
	 <4BD086D0.9090309@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>
	 <1272265147.2078.648.camel@ymzhang.sh.intel.com>
	 <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>
	 <4BD564BE.6020700@kernel.org>
	 <x2o84144f021004260309k9edf9e88t92e4c988d12de234@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 27 Apr 2010 09:41:17 +0800
Message-Id: <1272332477.2078.674.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 13:09 +0300, Pekka Enberg wrote:
> Hi,
> 
> On Mon, Apr 26, 2010 at 9:59 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> >>>> I haven't been able to reproduce this either on my Core 2 machine.
> >>> Mostly, the regression exists on Nehalem machines. I suspect it's related to
> >>> hyper-threading machine.
> 
> On 04/26/2010 09:22 AM, Pekka Enberg wrote:
> >> OK, so does anyone know why hyper-threading would change things for
> >> the per-CPU allocator?
> 
> On Mon, Apr 26, 2010 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> > My wild speculation is that previously the cpu_slub structures of two
> > neighboring threads ended up on the same cacheline by accident thanks
> > to the back to back allocation.  W/ the percpu allocator, this no
> > longer would happen as the allocator groups percpu data together
> > per-cpu.
> 
> Yanmin, do we see a lot of remote frees for your hackbench run? IIRC,
> it's the "deactivate_remote_frees" stat when CONFIG_SLAB_STATS is
> enabled.

After runing the testing with 2.6.34-rc5:

#slabinfo -AD
Name                   Objects      Alloc       Free   %Fast Fallb O
skbuff_head_cache         2518  800011810  800009770  95  19     0 1
kmalloc-512               1101  800009118  800008441  95  19     0 2
anon_vma_chain            2500     195878     194477  98  13     0 0
vm_area_struct            2487     160755     158908  97  20     0 1
anon_vma                  2645      88626      87637  99  12     0 0

[ymzhang@lkp-ne01 ~]$ cat /sys/kernel/slab/skbuff_head_cache/deactivate_remote_frees
1 C13=1
[ymzhang@lkp-ne01 ~]$ cat /sys/kernel/slab/kmalloc-512/deactivate_remote_frees       
3 C8=2 C15=1


After running testing against 2.6.33 kernel:
#slabinfo -AD
Name                   Objects      Alloc       Free   %Fast Fallb O
kmalloc-1024               961  800011628  800011167  93   1     0 3
skbuff_head_cache         2518  800012055  800010015  93   1     0 1
vm_area_struct            2892     162196     159987  97  19     0 1
names_cache                128      47139      47141  99  97     0 3
kmalloc-64                3612      40180      37287  99  89     0 0
Acpi-State                 816      36301      36301  99  98     0 0

I remember with 2.6.34-rc1, the fast alloc/free are close to the one of 2.6.33.


