Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab1CYLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:06:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:58333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab1CYLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:06:01 -0400
Subject: Re: [RFC] perf: EBNF for event syntax
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: mingo@elte.hu, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1300851416.31224.58.camel@minggr.sh.intel.com>
References: <1300851416.31224.58.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 12:07:57 +0100
Message-ID: <1301051277.2250.195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 11:36 +0800, Lin Ming wrote:
> Hi, all
> 
> On Thu, Mar 17, 2011 at 2:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > How about we start writing proper EBNF syntax rules for this stuff, its
> > getting seriously out of hand.
> http://marc.info/?l=linux-kernel&m=130029871318866&w=2
> 
> As Peter suggested, I wrote a simple EBNF for event syntax, as below.
> My first plan is to pass in extra config value for some events,
> for example, offcore response and load latency.
> 
> perf record -e r100b(0004):p
> 
> As above, the extra config value 0004 is passed in the parentheses.
> 
> The EBNF
> ========
> 
> EventList		:=	Event [',' EventList]

There was a suggestion a while back to make:

 -e ev1,ev2,ev3

create an event group with ev2 and ev3 siblings of ev1, and have
multiple -e instances create separate counters.

The problem is that its not backwards compatible, but something like
that would still be very nice to have.

> Event			:= 	HardwareEvent 		|
> 				RawEvent		|
> 				SoftwareEvent		|
> 				TracepointEvent		|
> 				HardwareBreakpointEvent
> 
> HardwareEvent		:=	HardwareEventName [ExtraConfig] [Modifer]
> HardwareEventName	:=	'cpu-cycles' | 'cycles' | 'instructions' /* and so on ...*/
> ExtraConfig		:=	'(' ConfigValue [',' ConfigValue] ')'
> ConfigValue		:=	HexNumber
> 
> RawEvent		:=	RawSeperator RawCode [ExtraConfig] [Modifer]
> RawSeperator		:=	'r'
> RawCode			:=	HexNumber
> 
> SoftwareEvent		:=	SoftwareEventName
> SoftwareEventName	:=	'cpu-clock' | 'task-clock' | 'faults' /* and so on ...*/
> 
> TracepointEvent		:=	SubsystemName ':' TracepointName
> SubsystemName		:=	/* All AsciiString except the pre-defined hardware/software/cache events name and BreakpointSeparator */
> TracepointName		:=	'*' | AsciiString
> 
> HardwareBreakpointEvent	:=	BreakpointSeparator BreakpointAddress [':' AccessType]
> BreakpointSeparator	:=	'mem:'
> BreakpointAddress	:=	HexNumber
> AccessType		:=	'r' | 'w' | 'x'
> 
> Modifier		:= 	ModifierSperator ModifierList
> ModifierSperator	:= 	':'
> ModifierList		:= 	ModifierItem ModifierList
> ModifierItem		:= 	{PreciseModifer} | kernelModifer | UserModifer | HypervisorModifer
> PreciseModifer		:= 	'p' /* Can be multiple PreciseModifers */
> kernelModifer		:= 	'k'
> UserModifer		:= 	'u'
> HypervisorModifer	:= 	'h'

Otherwise, very nice. Eventually we'll be able to use a parser generator
for this.

