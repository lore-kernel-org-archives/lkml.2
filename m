Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0IXPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0IXPlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:41:09 -0400
Date: Fri, 24 Sep 2010 17:41:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3] tracing: proper check for irq_depth routines
Message-ID: <20100924154102.GB1818@jolsa.brq.redhat.com>
References: <1285243253-7372-1-git-send-email-jolsa@redhat.com>
 <1285243253-7372-2-git-send-email-jolsa@redhat.com>
 <1285271293.26872.1613.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285271293.26872.1613.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:48:13PM -0400, Steven Rostedt wrote:
> On Thu, 2010-09-23 at 14:00 +0200, Jiri Olsa wrote:
> > The check_irq_entry and check_irq_return could be called
> > from graph event context. In such case there's no graph
> > private data allocated. Adding checks to handle this case.
> > 
> > wbr,
> > jirka
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/trace_functions_graph.c |   24 ++++++++++++++++++++----
> >  1 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index 02c708a..1390159 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -887,12 +887,20 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
> >  		unsigned long addr, int depth)
> >  {
> >  	int cpu = iter->cpu;
> > +	int *depth_irq;
> >  	struct fgraph_data *data = iter->private;
> > -	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> >  
> > -	if (flags & TRACE_GRAPH_PRINT_IRQS)
> > +	/*
> > +	 * We either display irqs, or we got called as
> > +	 * graph event, and out private data do no exist.
> 
> "out private data do no exist" makes no sense.
> 
> > +	 * In both cases we bypass the irq check.
> > +	 */
> > +	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
> > +	    (!data))
> >  		return 0;
> >  
> > +	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> > +
> >  	/*
> >  	 * We are inside the irq code
> >  	 */
> > @@ -925,12 +933,20 @@ static int
> >  check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
> >  {
> >  	int cpu = iter->cpu;
> > +	int *depth_irq;
> >  	struct fgraph_data *data = iter->private;
> > -	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> >  
> > -	if (flags & TRACE_GRAPH_PRINT_IRQS)
> > +	/*
> > +	 * We either display irqs, or we got called as
> > +	 * graph event, and out private data do no exist.
> 
> ditto.
> 
> -- Steve
> 
> > +	 * In both cases we bypass the irq check.
> > +	 */
> > +	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
> > +	    (!data))
> >  		return 0;
> >  
> > +	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
> > +
> >  	/*
> >  	 * We are not inside the irq code.
> >  	 */
> 
> 

hi,
attaching changed patch

thanks,
jirka

---
The check_irq_entry and check_irq_return could be called
from graph event context. In such case there's no graph
private data allocated. Adding checks to handle this case.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 02c708a..1390159 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -887,12 +887,20 @@ check_irq_entry(struct trace_iterator *iter, u32 flags,
 		unsigned long addr, int depth)
 {
 	int cpu = iter->cpu;
+	int *depth_irq;
 	struct fgraph_data *data = iter->private;
-	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
 
-	if (flags & TRACE_GRAPH_PRINT_IRQS)
+	/*
+	 * We either display irqs, or we got called as
+	 * graph event, and private data do no exist.
+	 * In both cases we bypass the irq check.
+	 */
+	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
+	    (!data))
 		return 0;
 
+	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
 	/*
 	 * We are inside the irq code
 	 */
@@ -925,12 +933,20 @@ static int
 check_irq_return(struct trace_iterator *iter, u32 flags, int depth)
 {
 	int cpu = iter->cpu;
+	int *depth_irq;
 	struct fgraph_data *data = iter->private;
-	int *depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
 
-	if (flags & TRACE_GRAPH_PRINT_IRQS)
+	/*
+	 * We either display irqs, or we got called as
+	 * graph event, and private data do no exist.
+	 * In both cases we bypass the irq check.
+	 */
+	if ((flags & TRACE_GRAPH_PRINT_IRQS) ||
+	    (!data))
 		return 0;
 
+	depth_irq = &(per_cpu_ptr(data->cpu_data, cpu)->depth_irq);
+
 	/*
 	 * We are not inside the irq code.
 	 */
-- 
1.7.1

