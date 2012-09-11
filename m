Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2IKCk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 22:40:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:1048 "EHLO
	smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2IKCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:40:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,401,1344211200"; 
   d="scan'208";a="794515465"
Date: Mon, 10 Sep 2012 19:40:47 -0700
From: Matt Wilson <msw@amazon.com>
To: "Justin M. Forbes" <jmforbes@linuxtx.org>
CC: Jan Beulich <JBeulich@suse.com>, Stefan Bader <stefan.bader@canonical.com>,
        <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
Message-ID: <20120911024047.GA7620@u002268147cd4502c336d.ant.amazon.com>
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <504A05B00200007800099C7B@nat28.tlf.novell.com>
 <5049F4E9.9050306@canonical.com>
 <504A1A950200007800099D4C@nat28.tlf.novell.com>
 <20120907142251.GA20096@linuxtx.org>
 <504A32800200007800099E40@nat28.tlf.novell.com>
 <1347033622.2980.12.camel@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347033622.2980.12.camel@fedora64.linuxtx.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:00:22AM -0500, Justin M. Forbes wrote:
> On Fri, 2012-09-07 at 16:44 +0100, Jan Beulich wrote:
> > 
> > All of this still doesn't provide evidence that a plain upstream
> > kernel is actually having any problems in the first place. Further,
> > if you say EC2 has a crippled hypervisor patch - is that patch
> > available for looking at somewhere?
> 
> Yes, I can verify that a plain upstream kernel has problems in the first
> place, which is why we are carrying a patch to simply disable xsave all
> together in the pv guest.
> EC2 is not carrying a patch to cripple the hypervisor, there was an old
> xen bug that makes all this fail.  The correct fix for that bug is to
> patch the hypervisor, but they have not done so. Upstream xen has had
> the fix for quite some time, but that doesn't change the fact that a lot
> of xen guest usage these days is on EC2.  This is no different than
> putting in a quirk to work around a firmware bug in common use.

I've done some testing and have results that indicate otherwise. The
out-of-tree xen_write_cr4() patch is not needed as of 2.6.39. I tested
3.2.21 on a machine that has XSAVE capabilities:

[ec2-user@ip-10-160-18-80 ~]$ cpuid -1 -i | grep -i xsave/xstor
      XSAVE/XSTOR states                      = true
      OS-enabled XSAVE/XSTOR                  = false

on an older hypervisor build:

[ec2-user@ip-10-160-18-80 ~]$ cat /sys/hypervisor/version/major
3
[ec2-user@ip-10-160-18-80 ~]$ cat /sys/hypervisor/version/minor
0

and it boots without a problem. This patch correctly detects that the
hypervisor supports XSAVE by testing for OSXSAVE:

commit 947ccf9c3c30307b774af3666ee74fcd9f47f646
Author:     Shan Haitao <haitao.shan@intel.com>
AuthorDate: Tue Nov 9 11:43:36 2010 -0800
Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CommitDate: Wed Apr 6 08:31:13 2011 -0400

    xen: Allow PV-OPS kernel to detect whether XSAVE is supported
    
    Xen fails to mask XSAVE from the cpuid feature, despite not historically
    supporting guest use of XSAVE.  However, now that XSAVE support has been
    added to Xen, we need to reliably detect its presence.
    
    The most reliable way to do this is to look at the OSXSAVE feature in
    cpuid which is set iff the OS (Xen, in this case), has set
    CR4.OSXSAVE.

Matt
