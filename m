Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2GTCRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:17:45 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49884 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2GTCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:17:44 -0400
Message-ID: <5008BFC0.4070703@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 10:17:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/9] KVM: x86: simplify read_emulated
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056DE6.6020801@linux.vnet.ibm.com> <20120719235828.GA7121@amt.cnet>
In-Reply-To: <20120719235828.GA7121@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072002-8256-0000-0000-000003618F11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 07:58 AM, Marcelo Tosatti wrote:

>> -	}
>> +	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
>> +				      &ctxt->exception);
>> +	if (rc != X86EMUL_CONTINUE)
>> +		return rc;
>> +
>> +	mc->end += size;
>> +
>> +read_cached:
>> +	memcpy(dest, mc->data + mc->pos, size);
> 
> What prevents read_emulated(size > 8) call, with
> mc->pos == (mc->end - 8) now?

Marcelo,

The splitting has been done in emulator_read_write_onepage:

	while (bytes) {
		unsigned now = min(bytes, 8U);

		frag = &vcpu->mmio_fragments[vcpu->mmio_nr_fragments++];
		frag->gpa = gpa;
		frag->data = val;
		frag->len = now;
		frag->write_readonly_mem = (ret == -EPERM);

		gpa += now;
		val += now;
		bytes -= now;
	}

So i think it is safe to remove the splitting in read_emulated.

