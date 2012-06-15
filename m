Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2FOD1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:27:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2FOD1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:27:06 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=htBDhw327rwAgFoJTnUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339730825.13377.311.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Thu, 14 Jun 2012 23:27:05 -0400
In-Reply-To: <87ehpj6hic.fsf@sejong.aot.lge.com>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
	 <1339524114.13377.140.camel@gandalf.stny.rr.com>
	 <87ehpj6hic.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 12:02 +0900, Namhyung Kim wrote:
> Hi,
> 
> On Tue, 12 Jun 2012 14:01:54 -0400, Steven Rostedt wrote:
> > On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
> >> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
> >> +		    char *buf, size_t buflen)
> >
> > Hmm, actually I wonder if we should put the error into the pevent
> > structure. Then we wouldn't even need to waste time to pass the data
> > through.
> >
> > That is, you can simply do:
> >
> > 	ret = pevent_foo();
> > 	if (ret < 0) {
> > 		pevent_strerr(pevent, buf, buflen);
> > 		printf("%s\n", buf);
> > 	}
> >
> > Perhaps even include a pevent_perror(), to just do:
> >
> > 	if (ret < 0) {
> > 		pevent_perror(pevent);
> > 		return ret;
> > 	}
> >
> 
> I thought something like this, but worried about the thread-safety. What
> about if more than one thread call pevent functions for a same pevent
> concurrently?  Should we make the pevent->errno TLS?

I hate threads :-)

Anyway, there's a couple of things that can be done:

1) have two functions. A simple 'pevent_stderr()' that does the above,
and perhaps a pevent_get_error() that can be passed the return value of
a previous command, and give you the error string for it. This is thread
safe for programs that require it. The ret is always returned.

2) Make it TLS, although honestly I've never made dynamic variables
that, and didn't even realize that you could.

I'm liking the explicit 'make this thread safe' method (#1). As it may
be for a gui, a separate thread may be used to print out the error
messages, and making it thread unique will make that difficult.

If you need the code to be thread safe, have all errors do:

	ret = pevent_foo();
	if (ret < 0) {
		pevent_strerr_val(ret, buf, buflen);


For programs that do not need to be thread safe, then:

	ret = pevent_foo();
	if (ret < 0) {
		pevent_strerr(pevent, buf, buflen);


-- Steve


