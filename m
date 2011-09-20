Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1ITO4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:56:45 -0400
Received: from gator34.hostgator.com ([184.173.197.218]:38797 "EHLO
	gator34.hostgator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1ITO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:56:42 -0400
X-Greylist: delayed 5808 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Sep 2011 10:56:42 EDT
Message-ID: <4E7892F1.1000107@gmail.com>
Date: Tue, 20 Sep 2011 15:19:45 +0200
From: Slawomir Czarko-Wasiutycz <slawomir.czarko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Lin Ming <mlin@ss.pku.edu.cn>, fa.linux.kernel@googlegroups.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Sattler <tsattler@gmx.de>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no> <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com> <CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com> <20110919175159.GL7800@redhat.com>
In-Reply-To: <20110919175159.GL7800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator34.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gmail.com
X-BWhitelist: no
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: d51a4d067.access.telenet.be (gaia.garous.net) [81.164.208.103]:42878
X-Source-Auth: slawek@czarko.net
X-Email-Count: 1
X-Source-Cap: cG9saWNhdDtwb2xpY2F0O2dhdG9yMzQuaG9zdGdhdG9yLmNvbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 07:51 PM, Andrea Arcangeli wrote:
> On Thu, Sep 15, 2011 at 02:43:32PM +0800, Lin Ming wrote:
>> # cat /proc/`pgrep khugepaged`/io
>> rchar: 0
>> wchar: 0
>> syscr: 0
>> syscw: 0
>> read_bytes: 0
>> write_bytes: 0
>> cancelled_write_bytes: 0
>>
>> Andrea,
>>
>>  From above output, all fields are zero.
>> Does it mean that transparent huge page was not triggered/used at all?
> Good idea to check it like that, yes that should confirm no
> ->writepage was called by khugepaged through
> compaction->migrate->writepage.
>
> It may have been used for migration, but the compaction code run by
> khugepaged didn't trigger writes, or the write_bytes should have been
>> 0.
> With regard to Slawomir's problem, the kernel
> kernel-PAE-2.6.40.4-5.fc15.i686 includes Mel's fix for the compaction
> scan to stay in the right zone.
I tried with previous kernel (2.6.40.3-0.fc15) and I haven't seen this 
problem when running the PC for 24 hours and building code in a loop 
inside the VM. With 2.6.40.4-5.fc15 I get it after a few hours.

>
> Slawomir could you run the command "cat /proc/`pgrep khugepaged`/io"
> as root, so see if there's significant writeout going from khugepaged?
For a long time there were just zeros appearing. After stalls started I 
got this:
[root]# cat /proc/`pgrep khugepaged`/io
rchar: 0
wchar: 0
syscr: 0
syscw: 0
read_bytes: 0
write_bytes: 24576
cancelled_write_bytes: 0

and after some time:

[root]# cat /proc/`pgrep khugepaged`/io
rchar: 0
wchar: 0
syscr: 0
syscw: 0
read_bytes: 0
write_bytes: 32768
cancelled_write_bytes: 0

> If there is you can try the patch in the below link.
>
> https://lkml.org/lkml/2011/7/26/103
>
> But the fact it happens on top of VMplayer with a PAE guest, may also
> be a variable to take into account, migrate does quite some pagetable
> work. If VMplayer uses EPT/NTP (do you have EPT/NTP available as VT
> feature in the host /proc/cpuinfo?) it's hard to see how that could be
> related.
I don't have EPT/NTP in /proc/cpuinfo. CPU is AMD Phenom(tm) II X6 1100T 
Processor

Here are the flags from /proc/cpuinfo:

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb npt lbrv svm_lock nrip_save pausefilter

I'll build a kernel with the suggested patch and give it a try.

