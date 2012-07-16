Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2GPCUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:20:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54976 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2GPCT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:19:59 -0400
Message-ID: <50037A4B.4050900@gmail.com>
Date: Sun, 15 Jul 2012 20:19:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com> <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com> <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com>
In-Reply-To: <20120712160634.GI7298@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/12 10:06 AM, Gleb Natapov wrote:
>> I started with cycles:pp; should not really matter - they all need
>> to work without blowing up VMs (cycles:p, cycles:pH, cycles:pG,
>> cycles:pp, cycles:ppH, cycles:ppG).
> cycles:ppG and cycles:pG should be illegal. Peter's patch takes care of
> this. Others should set exclude guest and have to work without blowing
> up VMs.

I was only testing your patch; I'll add Peter's going forward.

---8<---

>> perf kvm --guestmount=/tmp/guest-mount record -fo /tmp/perf.data -a
>> -v -e cycles:pH -- sleep 60
> Do not run perf kvm. It does not set exclude_guest and :p and :pp is not
> compatible with guest profiling and should be disallowed. Again Peter's
> patch takes care of this.

Well, perf-kvm needs to work too - and yes you can set exclude_guest 
with it (doesn't make sense to use perf-kvm with exclude_guest, but then 
VMs should not die because of it). If someone adds -e <hardware 
event>:p{p} it needs to be handled cleanly. The G and H event modifiers 
can be used explicitly to exclude host or guest and that case too needs 
to be handled properly from whatever the context is.

Peter's patch handles kernel side checks requiring exclude_guest if the 
pebs is to be used. A user running perf-kvm, perf-record and perf-top 
deserves something better than a confusing 'not supported error' which 
includes a message suggesting perf events is not enabled. I have some 
local patches for record and top to cover this.

>
> Run perf top -e cycles:pH or similar.
>
>>
>> Note the :pH this time.
> I am not sure what perf kvm does with :pH modifier, but H modifier does
> not make sense with perf kvm and should be reported as an error by perf tool.

perf-kvm passes everything from record on to the builtin record command. 
So, 'perf kvm record -e cycles:pH' effectively becomes 'perf record -e 
cycles:pH' with 2 global flags modified (perf_guest set and perf_host 
unset). There is nothing invalid about the perf-kvm command.

---8<---

>> My server has 16 cpus and the VM has only 2 vcpus; with the -a I
>> would expect some host sampling. Note: in the above case :pp resets
>> the exclude-host modifier set by the perf-kvm part, so hosts samples
>> are not excluded. See parse_events_modifier().
> Isn't this a bug? Why anything at all resets exclude-host set by
> perf-kvm?

Arguably yes and arguably no. As with any linux command later arguments 
can unset/reset earlier ones. In this case -e <event>:<modifier> comes 
after the perf-kvm --guest --host settings. I can whip up a patch for 
perf {record,top} to spit out a debug message if perf_{guest,host} are 
not consistent with excl_{guest,host} if that's wanted.

Don't forget -- perf-kvm has the --host flag to enable host side 
monitoring and --no-guest can be used to disable guest side monitoring.

David
