Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2GWEXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 00:23:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57515 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2GWEXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 00:23:21 -0400
Message-ID: <500CD1AF.8050707@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 12:23:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/9] KVM: x86: simplify read_emulated
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056DE6.6020801@linux.vnet.ibm.com> <20120719235828.GA7121@amt.cnet> <5008BFC0.4070703@linux.vnet.ibm.com> <20120720105840.GA16859@amt.cnet> <50095A00.7010606@linux.vnet.ibm.com> <20120720195203.GA25355@amt.cnet>
In-Reply-To: <20120720195203.GA25355@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072304-7014-0000-0000-0000019A765A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 03:52 AM, Marcelo Tosatti wrote:
> On Fri, Jul 20, 2012 at 09:15:44PM +0800, Xiao Guangrong wrote:
>> On 07/20/2012 06:58 PM, Marcelo Tosatti wrote:
>>> On Fri, Jul 20, 2012 at 10:17:36AM +0800, Xiao Guangrong wrote:
>>>> On 07/20/2012 07:58 AM, Marcelo Tosatti wrote:
>>>>
>>>>>> -	}
>>>>>> +	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
>>>>>> +				      &ctxt->exception);
>>>>>> +	if (rc != X86EMUL_CONTINUE)
>>>>>> +		return rc;
>>>>>> +
>>>>>> +	mc->end += size;
>>>>>> +
>>>>>> +read_cached:
>>>>>> +	memcpy(dest, mc->data + mc->pos, size);
>>>>>
>>>>> What prevents read_emulated(size > 8) call, with
>>>>> mc->pos == (mc->end - 8) now?
>>>>
>>>> Marcelo,
>>>>
>>>> The splitting has been done in emulator_read_write_onepage:
>>>>
>>>> 	while (bytes) {
>>>> 		unsigned now = min(bytes, 8U);
>>>>
>>>> 		frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
>>>> 		frag->gpa = gpa;
>>>> 		frag->data = val;
>>>> 		frag->len = now;
>>>> 		frag->write_readonly_mem = (ret == -EPERM);
>>>>
>>>> 		gpa += now;
>>>> 		val += now;
>>>> 		bytes -= now;
>>>> 	}
>>>>
>>>> So i think it is safe to remove the splitting in read_emulated.
>>>
>>> Yes, it is fine to remove it.
>>>
>>> But splitting in emulate.c prevented the case of _cache read_ with size
>>>> 8 beyond end of mc->data. Must handle that case in read_emulated.
>>>
>>> "What prevents read_emulated(size > 8) call, with mc->pos == (mc->end - 8) now?"
>>
>> You mean the mmio region is partly cached?
>>
>> I think it can not happen. Now, we pass the whole size to emulator_read_write_onepage(),
>> after it is finished, it saves the whole data into mc->data[], so, the cache-read
>> can always get the whole data from mc->data[].
> 
> I mean that nothing prevents a caller from reading beyond the end of
> mc->data array (but then again this was the previous behavior).

1024 bytes should be enough for instructions, may be we can add a WARN_ON
to check buffer-overflow.

> 
> ACK
> 

Thank you, Marcelo!



