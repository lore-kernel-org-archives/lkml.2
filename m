Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2FSCQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:16:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2FSCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:16:13 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ARy8Wg5PTaYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pGLkceISAAAA:8 a=vgjkmybt65Fzzus6ckkA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340072171.25903.181.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Date: Mon, 18 Jun 2012 22:16:11 -0400
In-Reply-To: <874nq8hyfa.fsf@sejong.aot.lge.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	 <87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	 <87d34wi0y3.fsf@sejong.aot.lge.com>
	 <1340067793.25903.158.camel@gandalf.stny.rr.com>
	 <878vfkhzr8.fsf@sejong.aot.lge.com>
	 <1340069162.25903.176.camel@gandalf.stny.rr.com>
	 <874nq8hyfa.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I'm tired of getting error messages from sending to some stranger at
weisbec@gmail.com, I might as well send it to someone I know. Someone
with an 'f' ]


On Tue, 2012-06-19 at 10:40 +0900, Namhyung Kim wrote:
> On Mon, 18 Jun 2012 21:26:02 -0400, Steven Rostedt wrote:
> > On Tue, 2012-06-19 at 10:11 +0900, Namhyung Kim wrote:
> >
> >> > trace-cmd report -N
> >> > [...]
> >> >              kvm-6172  [000] 14669573.114126: kvm_entry:            vcpu 0
> >> >              kvm-6172  [000] 14669573.114127: kvm_exit:             [FAILED TO PARSE] exit_reason=30 guest_rip=0xffff357a isa=1 info1=217841672 info2=0
> >> >              kvm-6172  [000] 14669573.114130: kvm_emulate_insn:     [FAILED TO PARSE] rip=4294915450 csbase=0 len=1 insn=ì[ÃWVS<89>Ã<89>Ö¨^Gu^Q^O^E flags=5 failed=0
> >> >              kvm-6172  [000] 14669573.114130: kvm_pio:              pio_read at 0xcfc size 1 count 1
> >> >              kvm-6172  [000] 14669573.114131: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
> >> >              kvm-6172  [000] 14669573.114134: kvm_entry:            vcpu 0
> >> >
> >> 

> Ok. Then how about using __print_hex() for __print_insn? AFAICS
> ftrace_print_hex_seq() looks almost same as __print_insn() and as it's a
> generic function we can add its handler in libtraceevnt.

We can be a bit better at the raw print, sure. Here's the format that's
there:

	field:__u64 rip;	offset:16;	size:8;	signed:0;
	field:__u32 csbase;	offset:24;	size:4;	signed:0;
	field:__u8 len;	offset:28;	size:1;	signed:0;
	field:__u8 insn[15];	offset:29;	size:15;	signed:0;
	field:__u8 flags;	offset:44;	size:1;	signed:0;
	field:__u8 failed;	offset:45;	size:1;	signed:0;

It treated __u* as decimal numbers, but it also saw that insn[15] was an
array, and with single bytes at that. So it thought it was a string, and
tried to print it out as such.

We can change the heuristics of this to make it more readable.

-- Steve
 

