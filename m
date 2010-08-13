Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0HMHbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:31:14 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9495 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751640Ab0HMHbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:31:13 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz1432N98dNzz1202hzz8275eh8275bh7606fh3198rz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L72Y7C-02-A7C-02
X-M-MSG: 
Date: Fri, 13 Aug 2010 09:04:35 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Venkatesh Pallipadi <venki@google.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Wrong /proc/cpuinfo core id on AMD fam_f model_9
Message-ID: <20100813070435.GE4569@loge.amd.com>
References: <1281648529-29678-1-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1281648529-29678-1-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 05:28:49PM -0400, Venkatesh Pallipadi wrote:
> Commit 4a376ec3a2599c02207cd4cbd5dbf73783548463 changes cpuinfo cpu_core_id
> from an unique id in a physical package to core id within a node. And it
> does not change phys_proc_id or booted_cores to reflect this new topology.

It shouldn't change phys_proc_id because that is supposed to be the
socket information. (both for AMD and Intel)

> This breaks the user view of topology in /proc/cpuinfo.
> 
> With commit 4a376ec /proc/cpuinfo output (for one package) looks something like
> processor: 0..11
> physical id: 0..0
> core id: 0..5 0..5
> siblings: 12
> cpu cores: 12
> 
> That is, there are processors with same "physical id" and same "core id" (which
> are not SMT siblings). As I understand, if /proc/cpuinfo says there are 12
> "cpu cores" per package, there should be 12 unique core ids in that package.
> And same "physical id" and "core id" is supposed to indicate SMT siblings.

I don't agree. That's rather an Intel centric view. You should use
thread_sibling information to identify this.  See the topology
sub-directory for each CPU.

> The change below reverts the cpu_core_id part of that commit and

Please don't do that. Potentially you are breaking user space. You
rather need to know the core id (0..5) within a node instead of the
CoreId (0..11) within the entire package. See AMD's BKDG for family
0x10 CPUs. As a rule of thumb you require the ID of a core within one
Node -- not within a package.

> /proc/cpuinfo has
> processor: 0..11
> physical id: 0..0
> core id: 0..11
> siblings: 12
> cpu cores: 12

> Also, if the intention of the original change was to export two node info,
> then changing just the core id is not enough. User has no way to determine
> which of these 6 cores out of 12 belong to same node by looking at
> /proc/cpuinfo output.

Yes, you can't get this info from /proc/cpuinfo output. But
/proc/cpuinfo is completely useless to gather entire toplogy
information anyway.  You should extract most stuff from the topology
subdirectory for CPUs.

> Both "physical id" and "cpu cores" has to change
> to reflect that or one more node id needs to be added (I didn't say that :))

No, physical id has _not_ to change.

The other option -- exporting NodeId -- I tried last year but this
was rejected. (see http://marc.info/?l=linux-kernel&m=124964980507887)
Did not have time to work on implementing other proposed solutions though ... Sigh

Thus, so far, the node sibling information is only reflected in the L3
cache sibling mask for Magny-Cours-CPUs. Ugly, but working.

> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

NOT-Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


