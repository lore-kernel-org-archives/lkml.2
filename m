Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1A3W0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 17:26:10 -0500
Received: from usaga03-in.huawei.com ([206.16.17.220]:62067 "EHLO
	usaga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1A3W0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 17:26:09 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jan 2011 17:26:09 EST
Date: Sun, 30 Jan 2011 14:21:11 -0800
From: Kaushik Barde <kbarde@huawei.com>
Subject: RE: One (possible) x86 get_user_pages bug
In-reply-to: <4D456139.4090508@redhat.com>
To: "'Avi Kivity'" <avi@redhat.com>, "'Jeremy Fitzhardinge'" <jeremy@goop.org>
Cc: "'Jan Beulich'" <JBeulich@novell.com>,
        "'Xiaowei Yang'" <xiaowei.yang@huawei.com>,
        "'Nick Piggin'" <npiggin@kernel.dk>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        "'Kenneth Lee'" <liguozhu@huawei.com>,
        "'linqaingmin'" <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        "'Wu Fengguang'" <fengguang.wu@intel.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        "'Marcelo Tosatti'" <mtosatti@redhat.com>
Message-id: <001801cbc0cc$00d98d70$028ca850$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
Thread-index: AcvAfeg92q3NfNbiSnmuJgUEgTqz7gASdFRg
References: <4D416D9A.9010603@huawei.com>
 <4D419416020000780002ECB7@vpn.id2.novell.com> <4D41B90D.5000305@goop.org>
 <4D456139.4090508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree i.e. deviation from underlying arch consideration is not a good
idea.

Also, agreed, hypervisor knows which page entries are ready for TLB flush
across vCPUs. 

But, using above knowledge, along with TLB flush based on IPI is a better
solution.  Its ability to synchronize it with pCPU based IPI and TLB flush
across vCPU. is key. 

IPIs themselves should be in few hundred uSecs in terms latency. Also, why
should pCPU be in sleep state for active vCPU scheduled page workload?

-Kaushik

-----Original Message-----
From: Avi Kivity [mailto:avi@redhat.com] 
Sent: Sunday, January 30, 2011 5:02 AM
To: Jeremy Fitzhardinge
Cc: Jan Beulich; Xiaowei Yang; Nick Piggin; Peter Zijlstra;
fanhenglong@huawei.com; Kaushik Barde; Kenneth Lee; linqaingmin;
wangzhenguo@huawei.com; Wu Fengguang; xen-devel@lists.xensource.com;
linux-kernel@vger.kernel.org; Marcelo Tosatti
Subject: Re: One (possible) x86 get_user_pages bug

On 01/27/2011 08:27 PM, Jeremy Fitzhardinge wrote:
> And even just considering virtualization, having non-IPI-based tlb
> shootdown is a measurable performance win, since a hypervisor can
> optimise away a cross-VCPU shootdown if it knows no physical TLB
> contains the target VCPU's entries.  I can imagine the KVM folks could
> get some benefit from that as well.

It's nice to avoid the IPI (and waking up a cpu if it happens to be 
asleep) but I think the risk of deviating too much from the baremetal 
arch is too large, as demonstrated by this bug.

(well, async page faults is a counterexample, I wonder if/when it will 
bite us)

-- 
error compiling committee.c: too many arguments to function

