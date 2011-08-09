Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1HIOah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:30:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52147 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1HIOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:30:35 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Steven Rostedt <srostedt@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@kernel.org>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] net/9p: Convert net/9p protocol dumps to tracepoints
In-Reply-To: <1312894395.3064.23.camel@fedora>
References: <1312890773-15305-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <CAOJsxLHDg8+QUFu68NBQoq8EgrgapTE15sFXQucw+pyDXV0tLQ@mail.gmail.com> <87r54u92ok.fsf@skywalker.in.ibm.com> <1312894395.3064.23.camel@fedora>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Aug 2011 19:58:38 +0530
Message-ID: <87obzy8xrd.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Aug 2011 08:53:15 -0400, Steven Rostedt <srostedt@redhat.com> wrote:
> On Tue, 2011-08-09 at 18:12 +0530, Aneesh Kumar K.V wrote:
> 
> > +#define P9_PROTO_DUMP_SZ (16 * 3 + 2 + 16 + 1)
> 
> Wow, you're making your event have 67 byte arrays, two of them.
> 
> > +TRACE_EVENT(9p_protocol_dump,
> > +	    TP_PROTO(struct p9_client *clnt, struct p9_fcall *pdu),
> > +
> > +	    TP_ARGS(clnt, pdu),
> > +
> > +	    TP_STRUCT__entry(
> > +		    __field(	__u64,		clnt				)
> > +		    __field(	__u8,		type				)
> > +		    __field(	__u16,		tag				)
> > +		    __array(	unsigned char,	line1,	P9_PROTO_DUMP_SZ	)
> > +		    __array(	unsigned char,	line2,	P9_PROTO_DUMP_SZ	)
> > +		    ),
> 
> Wouldn't it be better to put this as two unsigned char arrays of 16
> bytes?
> 
> > +
> > +	    TP_fast_assign(
> > +		    const u8 *ptr   =  pdu->sdata;
> > +		    __entry->clnt   =  (__u64)clnt;
> > +		    __entry->type   =  pdu->id;
> > +		    __entry->tag    =  pdu->tag;
> > +		    hex_dump_to_buffer(ptr, 16, 16,
> > +				       1, __entry->line1, P9_PROTO_DUMP_SZ, true);
> > +		    hex_dump_to_buffer(ptr + 16, 16, 16,
> > +				       1, __entry->line2, P9_PROTO_DUMP_SZ, true);
> > +		    ),
> > +
> > +	    TP_printk("clnt %lu %s(tag = %d)\n%.8x: %s\n%.8x: %s\n",
> > +		      (long)__entry->clnt, show_9p_op(__entry->type),
> > +		      __entry->tag, 0, __entry->line1, 16 , __entry->line2)
> 
> Yeah, you would need to make the above ugly to print out the array, but
> it's not that hard. And you will be saving 102 bytes per event in the
> ring buffer, which is very expensive real-estate. Not to mention the
> time it takes to copy all that.
> 

Any suggestion on how to get this pretty printing of the hex data. I can
update print_hex_dump_bytes to dump the hex data to a buffer. But not
sure where i can free the buffer after using that in TP_printk. 

-aneesh
