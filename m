Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0CRCnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 22:43:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:63861 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751446Ab0CRCnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 22:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,262,1267430400"; 
   d="scan'208";a="781790005"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
In-Reply-To: <1268818013.2813.82.camel@localhost>
References: <1268717232.2813.36.camel@localhost>
	 <4B9F19F7.6000309@redhat.com> <1268725724.2813.48.camel@localhost>
	 <1268731733.2813.54.camel@localhost>  <20100316094758.GH7961@elte.hu>
	 <1268818013.2813.82.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 18 Mar 2010 10:45:10 +0800
Message-Id: <1268880310.2813.84.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 17:26 +0800, Zhang, Yanmin wrote:
> On Tue, 2010-03-16 at 10:47 +0100, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > On Tue, 2010-03-16 at 15:48 +0800, Zhang, Yanmin wrote:
> > > > On Tue, 2010-03-16 at 07:41 +0200, Avi Kivity wrote:
> > > > > On 03/16/2010 07:27 AM, Zhang, Yanmin wrote:
> > > > > > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> > > > > >
> > > > > > Based on the discussion in KVM community, I worked out the patch to support
> > > > > > perf to collect guest os statistics from host side. This patch is implemented
> > > > > > with Ingo, Peter and some other guys' kind help. Yang Sheng pointed out a
> > > > > > critical bug and provided good suggestions with other guys. I really appreciate
> > > > > > their kind help.
> > > > > >
> > > > > > The patch adds new subcommand kvm to perf.
> > > > > >
> > > > > >    perf kvm top
> > > > > >    perf kvm record
> > > > > >    perf kvm report
> > > > > >    perf kvm diff
> > > > > >
> > > > > > The new perf could profile guest os kernel except guest os user space, but it
> > > > > > could summarize guest os user space utilization per guest os.
> > > > > >
> > > > > > Below are some examples.
> > > > > > 1) perf kvm top
> > > > > > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > > > > > --guestmodules=/home/ymzhang/guest/modules top
> > > > > >
> > > > > >    
> > > > > 
> > > > Thanks for your kind comments.
> > > > 
> > > > > Excellent, support for guest kernel != host kernel is critical (I can't 
> > > > > remember the last time I ran same kernels).
> > > > > 
> > > > > How would we support multiple guests with different kernels?
> > > > With the patch, 'perf kvm report --sort pid" could show
> > > > summary statistics for all guest os instances. Then, use
> > > > parameter --pid of 'perf kvm record' to collect single problematic instance data.
> > > Sorry. I found currently --pid isn't process but a thread (main thread).
> > > 
> > > Ingo,
> > > 
> > > Is it possible to support a new parameter or extend --inherit, so 'perf 
> > > record' and 'perf top' could collect data on all threads of a process when 
> > > the process is running?
> > > 
> > > If not, I need add a new ugly parameter which is similar to --pid to filter 
> > > out process data in userspace.
> > 
> > Yeah. For maximum utility i'd suggest to extend --pid to include this, and 
> > introduce --tid for the previous, limited-to-a-single-task functionality.
> > 
> > Most users would expect --pid to work like a 'late attach' - i.e. to work like 
> > strace -f or like a gdb attach.
> 
> Thanks Ingo, Avi.
> 
> I worked out below patch against tip/master of March 15th.
> 
> Subject: [PATCH] Change perf's parameter --pid to process-wide collection
> From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 
> Change parameter -p (--pid) to real process pid and add -t (--tid) meaning
> thread id. Now, --pid means perf collects the statistics of all threads of
> the process, while --tid means perf just collect the statistics of that thread.
> 
> BTW, the patch fixes a bug of 'perf stat -p'. 'perf stat' always configures
> attr->disabled=1 if it isn't a system-wide collection. If there is a '-p'
> and no forks, 'perf stat -p' doesn't collect any data. In addition, the
> while(!done) in run_perf_stat consumes 100% single cpu time which has bad impact
> on running workload. I added a sleep(1) in the loop.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Ingo,

Sorry, the patch has bugs.  I need do a better job and will work out 2
separate patches against the 2 issues.

Yanmin


