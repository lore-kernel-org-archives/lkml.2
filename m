Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0LHOnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:43:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab0LHOnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:43:01 -0500
Date: Wed, 8 Dec 2010 09:42:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101208144245.GB31703@redhat.com>
References: <1291232989.32004.1987.camel@laptop>
 <20101201195835.GE2511@redhat.com>
 <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
 <20101202052321.GH18100@redhat.com>
 <1291275270.4023.20.camel@twins>
 <20101202161502.GL18100@redhat.com>
 <1291764620.2032.1293.camel@laptop>
 <20101208140103.GM21786@redhat.com>
 <1291818005.28378.38.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291818005.28378.38.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:20:05PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-08 at 09:01 -0500, Don Zickus wrote:
> > On Wed, Dec 08, 2010 at 12:30:20AM +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-12-02 at 11:15 -0500, Don Zickus wrote:
> > > 
> > > > Vivek suggested to me this morning that I should just blantantly disable the
> > > > perf counter during init when running my test. 
> > > 
> > > Nah, we should actively scan for that during the bring-up and kill
> > > hw-perf when we find an enable bit set, some BIOSes actively use the
> > > PMU, this is something that should be discouraged.
> > 
> > Ok, the reboot notifier addresses the kexec problem but doesn't fix it
> > though (I have to test to confirm that, comments below).  
> 
> 
> > The bios check
> > should catch those situations (ironically I stumbled upon a machine with
> > this problem, so I will test your patch with it, though it only uses perf
> > counter 0). 
> 
> Right, they usually only steal one or two counters, but the fact that
> they're using them at all is insane and should be punished.
> 
> >  The kdump problem will still exist, not sure if we care and
> > perhaps we should document in the changelog that we know kdump is still
> > broken (unless we do care).
> 
> You mean even if we cure the kexec reboot notifier patch thing kdump is
> still borken?
> 

Yes. reboot notifier notifications are not sent in kdump path. In this
path we know kernel has crashed and we just try to do bare minimal things
to boot into second kernel. If some hardware is left in inconsistent
state we try to recover from that situation by resetting the device
when second kernel is booting.

Either driver itself can detect that device is in inconsistent state and
reset it otherwise we also pass a command line parameter "reset_devices" to
second kernel to explicitly tell kernel that devices might be in bad state,
reset these during initialization. If we want to use these perf counters in
kdump kernel, we shall have to do something similar.

Thanks
Vivek
