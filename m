Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2IOC01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:26:27 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59590 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2IOC0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:26:25 -0400
Message-ID: <5053E67C.3000906@linux.vnet.ibm.com>
Date: Sat, 15 Sep 2012 07:52:52 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Gleb Natapov <gleb@redhat.com>,
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
x-cbid: 12091502-5490-0000-0000-000002230B7F
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

I able to test this on 3.6-rc5 (where I do not see inconsistency may be
it was my bad to go with rc1), with 32 guest 1x and 2x overcommit
scenario

Here is the result on 16 core ple machine (with HT 32 thread) x240
machine

base = 3.6-rc5 + ple handler improvement patch
patched = base + vcpuid usage patch

+-----------+-----------+-----------+------------+-----------+
      ebizzy (records/sec higher is better)
+-----------+-----------+-----------+------------+-----------+
     base         stdev       patched    stdev        %improve
+-----------+-----------+-----------+------------+-----------+
1x 11293.3750   624.4378   11242.8750   583.1757    -0.44716
2x  3641.8750   468.9400    4088.8750   290.5470    12.27390
+-----------+-----------+-----------+------------+-----------+


Avi, Marcelo.. any comments on this?

