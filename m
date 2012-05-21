Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2EUIeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2EUIee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:34:34 -0400
Message-ID: <4FB9FE08.4050905@redhat.com>
Date: Mon, 21 May 2012 11:34:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com>
In-Reply-To: <4FB9A92D.7050108@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 05:32 AM, Yanfei Zhang wrote:
> 于 2012年05月21日 01:43, Avi Kivity 写道:
> > On 05/16/2012 10:50 AM, zhangyanfei wrote:
> >> This patch set exports offsets of VMCS fields as note information for
> >> kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
> >> runtime state of guest machine image, such as registers, in host
> >> machine's crash dump as VMCS format. The problem is that VMCS internal
> >> is hidden by Intel in its specification. So, we slove this problem
> >> by reverse engineering implemented in this patch set. The VMCSINFO
> >> is exported via sysfs to kexec-tools just like VMCOREINFO.
> >>
> >> Here are two usercases for two features that we want.
> >>
> >> 1) Create guest machine's crash dumpfile from host machine's crash dumpfile
> >>
> >> In general, we want to use this feature on failure analysis for the system
> >> where the processing depends on the communication between host and guest
> >> machines to look into the system from both machines's viewpoints.
> >>
> >> As a concrete situation, consider where there's heartbeat monitoring
> >> feature on the guest machine's side, where we need to determine in
> >> which machine side the cause of heartbeat stop lies. In our actual
> >> experiments, we encountered such situation and we found the cause of
> >> the bug was in host's process schedular so guest machine's vcpu stopped
> >> for a long time and then led to heartbeat stop.
> >>
> >> The module that judges heartbeat stop is on guest machine, so we need
> >> to debug guest machine's data. But if the cause lies in host machine
> >> side, we need to look into host machine's crash dump.
> > 
> > Do you mean, that a heartbeat failure in the guest lead to host panic?
> > 
> > My expectation is that a problem in the guest will cause the guest to
> > panic and perhaps produce a dump; the host will remain up.
> > 
>
> The point is that before our investigation, we didn't know which side 
> leads to this buggy situation. Maybe a bug in host machine or the guest
> machine itself causes a heartbeat failure.

How can a guest bug cause a host panic?

> So we want to get both host machine's crash dump and guest machine's
> crash dump *at the same time*. Then we could use userspace tools to
> get guest machine crash dump from host machine's and analyse them
> separately to find which side causes the problem.
>

If the guest caused the problem, there would be no panic; therefore
there was a host bug.

> >> Without this feature, we first create guest machine's dump and then
> >> create host mahine's, but there's only a short time between two
> >> processings, during which it's unlikely that buggy situation remains.
> >>
> >> So, we think the feature is useful to debug both guest machine's and
> >> host machine's sides at the same time, and expect we can make failure
> >> analysis efficiently.
> >>
> >> Of course, we believe this feature is commonly useful on the situation
> >> where guest machine doesn't work well due to something of host machine's.
> >>
> >> 2) Get offsets of VMCS information on the CPU running on the host machine
> >>
> >> If kdump doesn't work well, then it means we cannot use kvm API to get
> >> register values of guest machine and they are still left on its vmcs
> >> region. In the case, we use crash dump mechanism running outside of
> >> linux kernel, such as sadump, a firmware-based crash dump. Then VMCS
> >> information is then necessary.
> > 
> > Shouldn't sadump then expose the VMCS offsets? Perhaps bundling them
> > into its dump file?
> > 
>
> Firmware-based crash dump doesn't concern the os running on the machine.
> So it will not do any os handling when machine crashes.

Seems to me the VMCS offsets are OS independent.

-- 
error compiling committee.c: too many arguments to function

