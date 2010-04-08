Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0DHP1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:27:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:40198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab0DHP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:27:50 -0400
Date: Thu, 8 Apr 2010 12:27:41 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/6] perf tools: Reorganize some structs to save space
Message-ID: <20100408152741.GH3908@ghostprotocols.net>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
 <1270737529-24258-4-git-send-email-acme@infradead.org>
 <1270739509.20295.2419.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270739509.20295.2419.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 08, 2010 at 05:11:49PM +0200, Peter Zijlstra escreveu:
> On Thu, 2010-04-08 at 11:38 -0300, Arnaldo Carvalho de Melo wrote:
> > @@ -68,11 +68,11 @@ struct sample_data {
> >         u64 addr;
> >         u64 id;
> >         u64 stream_id;
> > -       u32 cpu;
> >         u64 period;
> > -       struct ip_callchain *callchain;
> > +       u32 cpu;
> >         u32 raw_size;
> >         void *raw_data;
> > +       struct ip_callchain *callchain;
> >  }; 
> 
> If that is a struct that is to match a kernel produced record then this
> is utterly broken.

No, it is not, it is filled in userspace:

tools/perf/util/event.c:

int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
{
        u64 *array = event->sample.array;

        if (type & PERF_SAMPLE_IP) {
                data->ip = event->ip.ip;
                array++;
        }

        if (type & PERF_SAMPLE_TID) {
                u32 *p = (u32 *)array;
                data->pid = p[0];
                data->tid = p[1];
                array++;
        }

        if (type & PERF_SAMPLE_TIME) {
                data->time = *array;
                array++;
        }
<SNIP>

We can reorder it at will and decoupled from any kernel changes.

- Arnaldo
