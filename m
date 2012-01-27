Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2A0MdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 07:33:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2A0Mc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 07:32:59 -0500
Date: Fri, 27 Jan 2012 13:32:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
Message-ID: <20120127123244.GC6294@m.brq.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1326717103-10287-6-git-send-email-jolsa@redhat.com>
 <1327595209.2446.117.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327595209.2446.117.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 05:26:49PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> > Adding 'format' attribute for pmu device that contains
> > a syntax description on how to construct raw events.
> > 
> > The event configuration is described in following
> > struct pefr_event_attr attributes:
> > 
> >   config
> >   config1
> >   config2
> > 
> > Each line of the format file describes mapping of name
> > and bitfield definition within one of abve attributes.
> > 
> > eg:
> >   event   config:0-7
> >   umask   config:8-15
> >   usr     config:16
> >   os      config:17
> >   edge    config:18
> >   any     config:21
> >   inv     config:23
> >   cmask   config:24-31
> > 
> > Line syntax:
> >   line:      NAME config ':' bits
> >   config:    'config' | 'config1' | 'config2"
> >   bits:      bits ',' bit_term | bit_term
> >   bit_term:  VALUE '-' VALUE | VALUE
> > 
> > Adding event_format callback to the struct pmu, which provides
> > the format information. The pmu shall override this function
> > and provide its own specific format information.
> > 
> > If not overloaded the default format information is used:
> > 
> >   config  config:0-63
> >   config1 config1:0-63
> >   config2 config2:0-63 
> 
> Shouldn't config[012] be hard-coded like period? They are struct
> perf_event_attr members after all and it doesn't really make sense to
> have them dynamic if we're going to have to add them to all pmu/format
> things.

Well, let me clarify that config[12] and 'period' are different stuff.
Also I remember you asked me about the config terms namespace in some
other email and I forgot to answer :)


So, while period is event term that user can specify in the event config
section like:
      cycles/period=100000/

the config[12] are values that are specified in the format definitions
as values that are changed by event terms.. like:
	config1:1,6-10,44

Now for event terms.. whatever term name is specified in the pmu
format definition, it is considered as valid term, when the 'pmu' event
is configured.. eg events like:
	cpu/krava=1/u

Apart from that we recognize the term 'period', which could be specified
only for symbolic events so far:
      cycles/period=100000/

So there can't be name clash between 'period' term and the rest so far.
Once we would like to have say 'period' term inside 'pmu' events like:
	cpu/krava=1,period=1000/u

we would need to consider some namespace rules or smth.


Now for config[12] formats.. they are parsed as simple strings and
'hardcoded' in function format_value. I think what you suggest is
to 'hardcode' them into the grammar... right?

So instead of using rule:
format_term: PP_NAME ':' bits

there'll be 3 rules like:

format_term: 'config':' bits
format_term: 'config1' ':' bits
format_term: 'config2' ':' bits

I dont have strong feelings one way or the other... but since we already
have the parser in place we could use it.. ehm :)


thanks,
jirka
