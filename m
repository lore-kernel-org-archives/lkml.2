Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2JQOM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab2JQOM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:12:56 -0400
Date: Wed, 17 Oct 2012 10:12:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20121017141234.GD31663@redhat.com>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 01:35:17PM +0900, HATAYAMA Daisuke wrote:
> Multiple CPUs are useful for CPU-bound processing like compression and
> I do want to use compression to generate crash dump quickly. But now
> we cannot wakeup the 2nd and later cpus in the kdump 2nd kernel if
> crash happens on AP. If crash happens on AP, kexec enters the 2nd
> kernel with the AP, and there BSP in the 1st kernel is expected to be
> haling in the 1st kernel or possibly in any fatal system error state.

Hatayama san,

Do you have any rough numbers on what kind of speed up we are looking
at. IOW, what % of time is gone compressing a filetered dump. On large
memory machines, saving huge dump files is anyway not an option due to
time it takes. So we need to filter it to bare minimum and after that
vmcore size should be reasonable and compression time might not be a
big factor. Hence I am curious what kind of gains we are looking at.

> 
> To wake up AP, we use the method called INIT-INIT-SIPI. INIT causes
> BSP to jump into BIOS init code. A typical visible behaviour is hang
> or immediate reset, depending on the BIOS init code.
> 
> AP can be initiated by INIT even in a fatal state: MP spec explains
> that processor-specific INIT can be used to recover AP from a fatal
> system error. On the other hand, there's no method for BSP to recover;
> it might be possible to do so by NMI plus any hand-coded reset code
> that is carefully designed, but at least I have no idea in this
> direction now.
> 
> Therefore, the idea I do in this patch set is simply to disable BSP if
> vboot cpu is AP.

So in regular boot BSP still works as we boot on BSP. So this will take
effect only in kdump kernel?

How well does it work with nr_cpus kernel parameter. Currently we boot
with nr_cpus=1 to save upon amount of memory to be reserved. I guess
you might want to boot with nr_cpus=2 or nr_cpus=4 in your case to
speed up compression?


[..]
> Note: recent upstream kernel fails reserving memory for kdump 2nd
> kernel. To run kdump, please apply the patch below on top of this
> patch set:
> https://lkml.org/lkml/2012/8/31/238

Above is a big issue. 3.6 kernel is broken and I can't take dump on F18
either. (works only on one machine). I have not looked enough into it
the issue to figure out what's the issue at hand, but we really need
atleast a stop gap fix (assuming others are working on longer term 
fix).

Thanks
Vivek
