Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab1HIOkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:40:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HIOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:40:18 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=v1FfYHn01Y4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=TLglayryQyMzkZJfSTAA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] net/9p: Convert net/9p protocol dumps to tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <87obzy8xrd.fsf@skywalker.in.ibm.com>
References: <1312890773-15305-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <CAOJsxLHDg8+QUFu68NBQoq8EgrgapTE15sFXQucw+pyDXV0tLQ@mail.gmail.com>
	 <87r54u92ok.fsf@skywalker.in.ibm.com> <1312894395.3064.23.camel@fedora>
	 <87obzy8xrd.fsf@skywalker.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 09 Aug 2011 10:39:13 -0400
Message-ID: <1312900753.18583.251.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 19:58 +0530, Aneesh Kumar K.V wrote:
> On Tue, 09 Aug 2011 08:53:15 -0400, Steven Rostedt <srostedt@redhat.com> wrote:

> > > +	    TP_printk("clnt %lu %s(tag = %d)\n%.8x: %s\n%.8x: %s\n",
> > > +		      (long)__entry->clnt, show_9p_op(__entry->type),
> > > +		      __entry->tag, 0, __entry->line1, 16 , __entry->line2)
> > 
> > Yeah, you would need to make the above ugly to print out the array, but
> > it's not that hard. And you will be saving 102 bytes per event in the
> > ring buffer, which is very expensive real-estate. Not to mention the
> > time it takes to copy all that.
> > 
> 
> Any suggestion on how to get this pretty printing of the hex data. I can
> update print_hex_dump_bytes to dump the hex data to a buffer. But not
> sure where i can free the buffer after using that in TP_printk. 

By making it very ugly :)

	TP_printk("clnt %lu %s(tag = %d)\n%.8x: "
		"%02x %02x %02x %02x %02x %02x %02x %02x %02x "
		"%02x %02x %02x %02x %02x %02x %02x %02x %02x\n"
		"%.8x: "
		"%02x %02x %02x %02x %02x %02x %02x %02x %02x "
		"%02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
		(long)__entry->clnt, show_9p_op(__entry->type),
		__entry->tag, 0,
		__entry->line1[0], __entry->line1[1],
		__entry->line1[2], __entry->line1[3],
		__entry->line1[4], __entry->line1[5],
		__entry->line1[6], __entry->line1[7],
		__entry->line1[8], __entry->line1[9],
		__entry->line1[10], __entry->line1[11],
		__entry->line1[12], __entry->line1[13],
		__entry->line1[14], __entry->line1[15],
		16,
		__entry->line2[0], __entry->line2[1],
		__entry->line2[2], __entry->line2[3],
		__entry->line2[4], __entry->line2[5],
		__entry->line2[6], __entry->line2[7],
		__entry->line2[8], __entry->line2[9],
		__entry->line2[10], __entry->line2[11],
		__entry->line2[12], __entry->line2[13],
		__entry->line2[14], __entry->line2[15])


Like I said, it's not pretty, but it saves buffer space and moves the
slow copy out of the fast path.

-- Steve



