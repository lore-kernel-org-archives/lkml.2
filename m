Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0IBSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:16:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0IBSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:16:39 -0400
X-Authority-Analysis: v=1.1 cv=8rLOhk8wZGSvnaCM3aW+9DxbPzg0bBAKX0Qt8NUyFX0= c=1 sm=0 a=h6dlIqBDnR0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mVL3gQTcX71xQAafrcUA:9 a=1ac4UyvpxOgSNeYKGv8A:7 a=v1BBsSDJI7cdxenNKxJWIRcsusYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernelshark plugins and ftrace array fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
In-Reply-To: <4C7FB603.60609@redhat.com>
References: <4C7F9639.7000804@redhat.com>
	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 14:16:38 -0400
Message-ID: <1283451398.2356.360.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 17:34 +0300, Avi Kivity wrote:
> On 09/02/2010 05:25 PM, Steven Rostedt wrote:
> > On Thu, 2010-09-02 at 15:19 +0300, Avi Kivity wrote:
> >> I'd like to add enhance kvm_emulate_insn display in kernelshark to
> >> show the disassembly of the instruction being emulated.  However,
> >> pevent_get_field_val() doesn't support arrays (the instruction is
> >> provided in a 15-byte array).
> >>
> >> Can you add support for arrays in the kernelshark API?  With that, it
> >> looks like adding disassembly output to the kvm plugin should be quite
> >> simple.
> >>
> > Sure, I could add a pevent_get_field_array() or something. Could you
> > tell me the event and give me an example of what you want to do.
> 
> plugin_kvm.c:
> 
> kvm_emulate_insn_handler()
> {
>     fetch insn array and len field
>     feed into disassembler
>     trace_seq_printf() the disassembled instruction
> }
> 

OK, with no modification of what I have already, I just created this
handler:

static int
kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
                         struct event_format *event, void *context)
{
        struct format_field *field;
        unsigned char *data = record->data;
        int i;

        field = pevent_find_field(event, "insn");
        if (!field) {
                trace_seq_puts(s, "Can't find inst field");
                return 0;
        }

        trace_seq_puts(s, "insn: ");
        for (i = 0; i < field->size; i++) {
                trace_seq_printf(s, "%s%02x",
                                 i ? "," : "",
                                 data[field->offset + i]);
        }

        return 0;
}


I think this is what you would want, right?

-- Steve



