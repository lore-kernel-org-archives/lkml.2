Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0CRKWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0CRKWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:22:15 -0400
Message-ID: <4BA1FEB0.7000400@redhat.com>
Date: Thu, 18 Mar 2010 12:21:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu>
In-Reply-To: <20100318101025.GA13073@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 12:10 PM, Ingo Molnar wrote:
>
>> It's not a 1:1 connection. There are more users of the KVM interface. To
>> name a few I'm aware of:
>>
>> - Mac-on-Linux (PPC)
>> - Dolphin (PPC)
>> - Xenner (x86)
>> - Kuli (s390)
>>      
> There must be a misunderstanding here: tools/perf/ still has a clear userspace
> interface and ABI. There's external projects making use of it: sysprof and
> libpfm (and probably more i dont know about it). Those projects are also
> contributing back.
>    

So it seems it is possible to scale the package wall.

> Still it's _very_ useful to have a single reference implementation under
> tools/perf/ where we concentrate the best of the code. That is where we make
> sure that each new kernel feature is appropriately implemented in user-space
> as well, that the combination works well together and is releasable to users.
> That is what keeps us all honest: the latency of features is much lower, and
> there's no ping-pong of blame going on between the two components in case of
> bugs or in case of misfeatures.
>    

That would make sense for a truly minimal userspace for kvm: we once had 
a tool called kvmctl which was used to run tests (since folded into 
qemu).  It didn't contain a GUI and was unable to run a general purpose 
guest.  It was a few hundred lines of code, and indeed patches to kvmctl 
had a much closer correspondence to patches with kvm (though still low, 
as most kvm patches don't modify the ABI).

> Same goes for KVM+Qemu: it would be so much nicer to have a single,
> well-focused reference implementation under tools/kvm/ and have improvements
> flow into that code base.
>
> That way KVM developers cannot just shrug "well, GUI suckage is a user-space
> problem" - like the answers i got in the KVM usability thread ...
>
> The buck will stop here.
>    

Suppose we copy qemu tomorrow into tools/.  All the problems will be 
copied with it.  Someone still has to write patches to fix them.  Who 
will it be?

>> The kernel/userspace interface really isn't the difficult part. Getting
>> device emulation working properly, easily and fast is.
>>      
> The kernel/userspace ABI is not difficult at all. Getting device emulation
> working properly, easily and fast indeed is. And my experience is that it is
> not working properly nor quickly at the moment, at all. (see the 'KVM
> usability' thread)
>
> Getting device emulation working properly often involves putting certain
> pieces that are currently done in Qemu into kernel-space. That kind of
> 'movement of emulation technology' from user-space component into the
> kernel-space component [or back] would very clearly be helped if those two
> components were in the same repository.
>    

Moving emulation into the kernel is indeed a problem.  Not because it's 
difficult, but because it indicates that the interfaces exposed to 
userspace are insufficient to obtain good performance.  We had that with 
vhost-net and I'm afraid we'll have that with vhost-blk.

> And i have first-hand experience there: we had (and have) similar scenarios
> with tools/perf routinely. We did some aspects in user-space, then decided to
> do it in kernel-space. Sometimes we moved kernel bits to user-space. It was
> very easy and there were no package and version complications as it's a single
> project. Sometimes we even moved bits back and forth until we found the right
> balance.
>    

That's reasonable in the first iterations of a project.

-- 
error compiling committee.c: too many arguments to function

