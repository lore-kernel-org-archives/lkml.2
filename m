Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0CVGgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:36:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0CVGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:36:31 -0400
Message-ID: <4BA70F9A.8030304@redhat.com>
Date: Mon, 22 Mar 2010 08:35:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu>
In-Reply-To: <20100321212009.GE30194@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 11:20 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> Well, for what it's worth, I rarely ever use anything else. My virtual
>>> disks are raw so I can loop mount them easily, and I can also switch my
>>> guest kernels from outside... without ever needing to mount those disks.
>>>        
>> Curious, what do you use them for?
>>
>> btw, if you build your kernel outside the guest, then you already have
>> access to all its symbols, without needing anything further.
>>      
> There's two errors with your argument:
>
> 1) you are assuming that it's only about kernel symbols
>
> Look at this 'perf report' output:
>
> # Samples: 7127509216
> #
> # Overhead     Command                  Shared Object  Symbol
> # ........  ..........  .............................  ......
> #
>      19.14%         git  git                            [.] lookup_object
>      15.16%        perf  git                            [.] lookup_object
>       4.74%        perf  libz.so.1.2.3                  [.] inflate
>       4.52%         git  libz.so.1.2.3                  [.] inflate
>       4.21%        perf  libz.so.1.2.3                  [.] inflate_table
>       3.94%         git  libz.so.1.2.3                  [.] inflate_table
>       3.29%         git  git                            [.] find_pack_entry_one
>       3.24%         git  libz.so.1.2.3                  [.] inflate_fast
>       2.96%        perf  libz.so.1.2.3                  [.] inflate_fast
>       2.96%         git  git                            [.] decode_tree_entry
>       2.80%        perf  libc-2.11.90.so                [.] __strlen_sse42
>       2.56%         git  libc-2.11.90.so                [.] __strlen_sse42
>       1.98%        perf  libc-2.11.90.so                [.] __GI_memcpy
>       1.71%        perf  git                            [.] decode_tree_entry
>       1.53%         git  libc-2.11.90.so                [.] __GI_memcpy
>       1.48%         git  git                            [.] lookup_blob
>       1.30%         git  git                            [.] process_tree
>       1.30%        perf  git                            [.] process_tree
>       0.90%        perf  git                            [.] tree_entry
>       0.82%        perf  git                            [.] lookup_blob
>       0.78%         git  [kernel.kallsyms]              [k] kstat_irqs_cpu
>
> kernel symbols are only a small portion of the symbols. (a single line in this
> case)
>
> To get to those other symbols we have to read the ELF symbols of those
> binaries in the guest filesystem, in the post-processing/reporting phase. This
> is both complex to do and relatively slow so we dont want to (and cannot) do
> this at sample time from IRQ context or NMI context ...
>    

Okay.  So a symbol server is necessary.  Still, I don't think -kernel is 
a good reason for including the symbol server in the kernel itself.  If 
someone uses it extensively together with perf, _and_ they can't put the 
symbol server in the guest for some reason, let them patch mkinitrd to 
include it.

> Also, many aspects of reporting are interactive so it's done lazily or
> on-demand. So we need ready access to the guest filesystem - for those guests
> which decide to integrate with the host for this.
>
> 2) the 'SystemTap mistake'
>
> You are assuming that the symbols of the kernel when it got built got saved
> properly and are discoverable easily. In reality those symbols can be erased
> by a make clean, can be modified by a new build, can be misplaced and can
> generally be hard to find because each distro puts them in a different
> installation path.
>
> My 10+ years experience with kernel instrumentation solutions is that
> kernel-driven, self-sufficient, robust, trustable, well-enumerated sources of
> information work far better in practice.
>    

What about line number information?  And the source?  Into the kernel 
with them as well?


> The thing is, in this thread i'm forced to repeat the same basic facts again
> and again. Could you _PLEASE_, pretty please, when it comes to instrumentation
> details, at least _read the mails_ of the guys who actually ... write and
> maintain Linux instrumentation code? This is getting ridiculous really.
>    

I've read every one of your emails.  If I misunderstood or overlooked 
something, I apologize.  The thread is very long and at times 
antagonistic so it's hard to keep all the details straight.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

