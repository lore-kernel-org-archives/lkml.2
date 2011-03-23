Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1CWDhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:37:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:4254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1CWDhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:37:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,228,1299484800"; 
   d="scan'208";a="616551271"
Subject: [RFC] perf: EBNF for event syntax
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 11:36:56 +0800
Message-ID: <1300851416.31224.58.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

On Thu, Mar 17, 2011 at 2:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> How about we start writing proper EBNF syntax rules for this stuff, its
> getting seriously out of hand.
http://marc.info/?l=linux-kernel&m=130029871318866&w=2

As Peter suggested, I wrote a simple EBNF for event syntax, as below.
My first plan is to pass in extra config value for some events,
for example, offcore response and load latency.

perf record -e r100b(0004):p

As above, the extra config value 0004 is passed in the parentheses.

The EBNF
========

EventList		:=	Event [',' EventList]
Event			:= 	HardwareEvent 		|
				RawEvent		|
				SoftwareEvent		|
				TracepointEvent		|
				HardwareBreakpointEvent

HardwareEvent		:=	HardwareEventName [ExtraConfig] [Modifer]
HardwareEventName	:=	'cpu-cycles' | 'cycles' | 'instructions' /* and so on ...*/
ExtraConfig		:=	'(' ConfigValue [',' ConfigValue] ')'
ConfigValue		:=	HexNumber

RawEvent		:=	RawSeperator RawCode [ExtraConfig] [Modifer]
RawSeperator		:=	'r'
RawCode			:=	HexNumber

SoftwareEvent		:=	SoftwareEventName
SoftwareEventName	:=	'cpu-clock' | 'task-clock' | 'faults' /* and so on ...*/

TracepointEvent		:=	SubsystemName ':' TracepointName
SubsystemName		:=	/* All AsciiString except the pre-defined hardware/software/cache events name and BreakpointSeparator */
TracepointName		:=	'*' | AsciiString

HardwareBreakpointEvent	:=	BreakpointSeparator BreakpointAddress [':' AccessType]
BreakpointSeparator	:=	'mem:'
BreakpointAddress	:=	HexNumber
AccessType		:=	'r' | 'w' | 'x'

Modifier		:= 	ModifierSperator ModifierList
ModifierSperator	:= 	':'
ModifierList		:= 	ModifierItem ModifierList
ModifierItem		:= 	{PreciseModifer} | kernelModifer | UserModifer | HypervisorModifer
PreciseModifer		:= 	'p' /* Can be multiple PreciseModifers */
kernelModifer		:= 	'k'
UserModifer		:= 	'u'
HypervisorModifer	:= 	'h'


Some valid examples
===================
Hardware events with modifiers,
cycles:pk,instructions:u

Raw event with extra config values and/or modifiers,
r0110(40A0):pu
r0110(40A0,40A1):k

Software event,
cpu-clock,faults

Hardware breakpoint events:
mem:400346
mem:800A03:w

Some invalid examples
=====================
r0110(40A0,40A1,40A2), invalid, only 2 extra config values are allowed
cpu-clock:p, invalid, software event does not have precise modifier


Any comments?

Thanks,
Lin Ming


