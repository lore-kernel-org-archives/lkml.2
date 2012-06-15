Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2FOJHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:07:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57824 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2FOJHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:07:41 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-98-4fdafb58b8cc
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	<1339486959-25241-4-git-send-email-namhyung@kernel.org>
	<1339524114.13377.140.camel@gandalf.stny.rr.com>
	<87ehpj6hic.fsf@sejong.aot.lge.com>
	<1339730825.13377.311.camel@gandalf.stny.rr.com>
Date: Fri, 15 Jun 2012 18:04:52 +0900
In-Reply-To: <1339730825.13377.311.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 14 Jun 2012 23:27:05 -0400")
Message-ID: <87ipet3pzf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

On Thu, 14 Jun 2012 23:27:05 -0400, Steven Rostedt wrote:
> On Wed, 2012-06-13 at 12:02 +0900, Namhyung Kim wrote:
>> On Tue, 12 Jun 2012 14:01:54 -0400, Steven Rostedt wrote:
>> > On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
>> >> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>> >> +		    char *buf, size_t buflen)
>> >
>> > Hmm, actually I wonder if we should put the error into the pevent
>> > structure. Then we wouldn't even need to waste time to pass the data
>> > through.
>> >
>> > That is, you can simply do:
>> >
>> > 	ret = pevent_foo();
>> > 	if (ret < 0) {
>> > 		pevent_strerr(pevent, buf, buflen);
>> > 		printf("%s\n", buf);
>> > 	}
>> >
>> > Perhaps even include a pevent_perror(), to just do:
>> >
>> > 	if (ret < 0) {
>> > 		pevent_perror(pevent);
>> > 		return ret;
>> > 	}
>> >
>> 
>> I thought something like this, but worried about the thread-safety. What
>> about if more than one thread call pevent functions for a same pevent
>> concurrently?  Should we make the pevent->errno TLS?
>
> I hate threads :-)
>
> Anyway, there's a couple of things that can be done:
>
> 1) have two functions. A simple 'pevent_stderr()' that does the above,
> and perhaps a pevent_get_error() that can be passed the return value of
> a previous command, and give you the error string for it. This is thread
> safe for programs that require it. The ret is always returned.
>

I'm not sure I understood you. Are you saying the pevent_get_error
should look like:

       char *pevent_get_error(int errcode, ...)

? So, what's the difference to my original pevent_strerror ?


> 2) Make it TLS, although honestly I've never made dynamic variables
> that, and didn't even realize that you could.
>

Right, it should be TSD (thread-specific data) for dynamic ones,
I guess.


> I'm liking the explicit 'make this thread safe' method (#1). As it may
> be for a gui, a separate thread may be used to print out the error
> messages, and making it thread unique will make that difficult.
>

Yeah, I like the #1 too.


> If you need the code to be thread safe, have all errors do:
>
> 	ret = pevent_foo();
> 	if (ret < 0) {
> 		pevent_strerr_val(ret, buf, buflen);
>
>
> For programs that do not need to be thread safe, then:
>
> 	ret = pevent_foo();
> 	if (ret < 0) {
> 		pevent_strerr(pevent, buf, buflen);
>

Do we really need these two? I think having a single API is just
enough, IMHO.

Thanks,
Namhyung
