Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0IBTYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:24:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0IBTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:24:06 -0400
X-Authority-Analysis: v=1.1 cv=jsU1gHzFqI0vjyg35dbbhFRlpVAv39iqdMS5PbCl9Js= c=1 sm=0 a=h6dlIqBDnR0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=sybXhTVv07V_ylgEDrIA:9 a=nde2ZgVCRycOuCCF9z0A:7 a=Qwppkhgipr6o30zsXh6FlkuuNm8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernelshark plugins and ftrace array fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
In-Reply-To: <1283452736.2356.388.camel@gandalf.stny.rr.com>
References: <4C7F9639.7000804@redhat.com>
	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com>
	 <1283451398.2356.360.camel@gandalf.stny.rr.com>
	 <1283452736.2356.388.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 15:24:03 -0400
Message-ID: <1283455443.2356.433.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 14:38 -0400, Steven Rostedt wrote:

> I think I will add a:
> 
> void *pevent_get_field_raw(stuct trace_seq *s,
> 			struct event_format *event, 
> 			char *field_name,
> 			struct record *record,
> 			int **field_len);
> 
> which will return a pointer into record->data and set the field_len to
> the actual size.
> 
> This will be useful for dynamic arrays too, since it is more complex
> than just using a field->offset.

I just pushed out the changes and my new example looks like this:

static int
kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
                         struct event_format *event, void *context)
{
        unsigned char *data;
        int len;
        int i;

        data = pevent_get_field_raw(s, event, "insn", record,
                                    &len, 1);
        if (!data)
                return -1;

        trace_seq_puts(s, "insn: ");
        for (i = 0; i < len; i++) {
                trace_seq_printf(s, "%s%02x",
                                 i ? "," : "",
                                 data[i]);
        }

        return 0;
}


