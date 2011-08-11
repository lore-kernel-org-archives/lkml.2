Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1HKQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:05:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1HKQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:05:11 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=aaAdOvpg3WkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=XP4Ko9G5nC1x_yysKeIA:9 a=1GwZeYR5M8FxURsr16QA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
From: Steven Rostedt <rostedt@goodmis.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Alex Ray <alexjray.ncsu@gmail.com>,
        v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Ray <ajray@ncsu.edu>
In-Reply-To: <87k4ak54gn.fsf@skywalker.in.ibm.com>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu>
	 <877h6l7hoj.fsf@skywalker.in.ibm.com>
	 <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com>
	 <87wrel5gp8.fsf@skywalker.in.ibm.com>
	 <CAFkjPT=ePtKi0Z-AjBm_W38VPTV3HbT6hWSMHOHezytoqAbNvQ@mail.gmail.com>
	 <87k4ak54gn.fsf@skywalker.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Aug 2011 12:05:08 -0400
Message-ID: <1313078708.18583.314.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 21:24 +0530, Aneesh Kumar K.V wrote:
> On Wed, 10 Aug 2011 13:36:52 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > On Wed, Aug 10, 2011 at 12:17 PM, Aneesh Kumar K.V
> > <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > On Wed, 10 Aug 2011 07:24:56 -0500, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > >> On Wed, Aug 10, 2011 at 4:13 AM, Aneesh Kumar K.V
> > >> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > >> > On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
> > >> >> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
> > >> >> functionality from v9fs.  Logging is (already) controlled with the
> > >> >> run-time debug= option, this gets rid of the compile-time option (which
> > >> >> was being misunderstood and misused).
> > >> >>
> > >> >> Signed-off-by: Alex Ray <ajray@ncsu.edu>
> > >> >
> > >> > I see this merged to for-next.  Do we know whether enabling debug always have a
> > >> > performance impact ?.
> > >> >
> > >>
> > >> No clue, but without any debug it makes it impossible for user's to
> > >> generate reasonable bug reports.  If I understand the tracepoint
> > >> collection facility correctly, it incurs exactly the same overhead as
> > >> a DPRINT when the debug mount option is set to 0 (although tracepoints
> > >> are much lower overhead when actually collecting).
> > >
> > > I was worried about overhead when we are not collecting any debug info.
> > >
> > 
> > I understand that.  But the overhead when not collecting is the
> > conditional branch.
> > According to Documentation/trace/tracepoints.txt this is the same for the
> > tracepoints:
> > 
> > "When a tracepoint is "off" it has no effect, except for adding a tiny
> > time penalty
> > (checking a condition for a branch) and space penalty (adding a few
> > bytes for the function call at the end of the instrumented function
> > and adds a data structure in a separate section)."
> > 
> > So, since DPRINT is essentially if(p9_debug_level & level) == level)
> > it should roughly amount to the same overhead, no?  I suppose we could
> > get fancy and and prefix it with an unlikely.
> > 
> 
> Is that true with jump label ? May be we should update tracepoints.txt ?

Correct, that should be updated. When jump labels are enabled, we have a
nop and an unconditional branch over the trace code, which when enable
will change the nop to call the trace code.

We do have a slight hit in icache, but nothing I have been able to
measure. But if we do, I could even modify it to become even less of an
impact (but will cause tracing to slow down, but we don't really care if
it speeds up non tracing case ;)

-- Steve


> 
> Upstream commit:
> bf5438fca2950b03c21ad868090cc1a8fcd49536
> 8f7b50c514206211cc282a4247f7b12f18dee674
> 
> -aneesh


