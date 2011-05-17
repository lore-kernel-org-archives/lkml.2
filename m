Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1EQPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:50:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab1EQPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:50:37 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=ljoxONi0YS4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3VP_IZUOL2isl_lmfpcA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] kvm: log directly from the guest to the host kvm buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, joro@8bytes.org,
        agraf@suse.de, linux-kernel@vger.kernel.org,
        Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
References: <1305207413.18715.3.camel@gondor.retis>
	 <4DCBF904.6040104@redhat.com>
	 <BANLkTi=BnRCJ4S32S=+zNNOSTxmZsR6Jrg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 11:50:34 -0400
Message-ID: <1305647434.5456.738.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 17:39 +0200, Dhaval Giani wrote:

> >>
> >> +int kvm_pv_ftrace(struct kvm_vcpu *vcpu, unsigned long ip, gpa_t addr)
> >> +{
> >> +       int ret;
> >> +       char *fmt = (char *) kzalloc(PAGE_SIZE, GFP_KERNEL);
> >> +
> >> +       ret = kvm_read_guest(vcpu->kvm, addr, fmt, PAGE_SIZE);
> >> +
> >> +       trace_printk("KVM instance %p: VCPU %d, IP %lu: %s",
> >> +                               vcpu->kvm, vcpu->vcpu_id, ip, fmt);
> >> +
> >> +       kfree(fmt);
> >> +
> >> +       return 0;
> >> +}
> >
> > A kmalloc and printf seem expensive here.  I'd prefer to log the arguments
> > and format descriptor instead.  Similarly the guest should pass unformatted
> > parameters.+int kvm_ftrace_printk(unsigned long ip, const char *fmt, ...)
> >>
> 
> the trace_printk is actually quite cheap (IIRC), but I guess Steve is
> the best person to let us know about that. We can avoid the kzalloc
> overhead though.

You could replace the kzalloc with a static page. Perhaps, one page per
CPU. Then you just need to disable interrupts (unless this is never
called by an interrupt) to get the information into the page, without
any allocation.

trace_printk() does basically the same thing, but uses a single page
with locks. I've thought about replacing that with per cpu pages too,
but haven't gotten around to it.

I also agree that you should just write to some buffer and when it
overflows, flush it.

-- Steve


