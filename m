Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2IDMAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:00:25 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49669 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2IDMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:00:23 -0400
Message-ID: <5045EC91.9050406@linux.vnet.ibm.com>
Date: Tue, 04 Sep 2012 17:27:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/1] kvm: Use vcpu_id as pivot instead of last boosted
 vcpu in PLE handler
References: <20120829192100.22412.92575.sendpatchset@codeblue> <20120902101234.GB27250@redhat.com> <50438978.9000405@redhat.com>
In-Reply-To: <50438978.9000405@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12090411-9264-0000-0000-000002458E79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 09:59 PM, Rik van Riel wrote:
> On 09/02/2012 06:12 AM, Gleb Natapov wrote:
>> On Thu, Aug 30, 2012 at 12:51:01AM +0530, Raghavendra K T wrote:
>>> The idea of starting from next vcpu (source of yield_to + 1) seem to
>>> work
>>> well for overcomitted guest rather than using last boosted vcpu. We
>>> can also
>>> remove per VM variable with this approach.
>>>
>>> Iteration for eligible candidate after this patch starts from vcpu
>>> source+1
>>> and ends at source-1 (after wrapping)
>>>
>>> Thanks Nikunj for his quick verification of the patch.
>>>
>>> Please let me know if this patch is interesting and makes sense.
>>>
>> This last_boosted_vcpu thing caused us trouble during attempt to
>> implement vcpu destruction. It is good to see it removed from this POV.
>
> I like this implementation. It should achieve pretty much
> the same as my old code, but without the downsides and without
> having to keep the same amount of global state.
>

My theoretical understanding how it would help is,

       |
       V
T0 ------- T1

suppose there are 4 vcpus (v1..v4) out of 32/64 vcpus simpultaneously 
enter directed yield handler,

if last_boosted_vcpu = i then v1 .. v4 will start from i, and there may
be some unnecessary attempts for directed yields.

We may not see such attempts with above patch. But again I agree that,
whole directed_yield stuff itself is very complicated because of 
possibility of each vcpu in different state (running/pauseloop exited 
while spinning/eligible)  and how they are located w.r.t each other.

Here is the result I got for ebizzy, 32 vcpu guest 32 core PLE machine
for 1x 2x and 3x overcommits.

base = 3.5-rc5 kernel with ple handler improvements patches applied
patched = base + vcpuid patch

      base         stdev       patched     stdev       %improvement
1x  1955.6250    39.8961    1863.3750    37.8302    -4.71716
2x  2475.3750   165.0307    3078.8750   341.9500    24.38014
3x  2071.5556    91.5370    2112.6667    56.6171     1.98455

Note:
I have to admit that, I am seeing very inconsistent results while 
experimenting with 3.6-rc kernel (not specific to vcpuid patch but as a 
whole) but not sure if it is some thing wrong in my config or should I 
spend some time debugging. Anybody has observed same?

