Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1CaMdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:33:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36353 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1CaMdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VoSo5cU+6lShSaL3a9Z3Z68K5uJacR5lDN/kzriEV8sdGVsbEq897aFWtnYwmTdIGg
         m8ucn5IIDJYyfGjw1slGftg5tuZVmUMTzckZb2fem16KNjpeQhMfVX9neWIsGQB1kYrh
         shi+8b0IjIkXzhmBEANQutaUwXjJxprmkacwY=
Date: Thu, 31 Mar 2011 14:33:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf: Mmap 512 kiB by default
Message-ID: <20110331123330.GA1856@nowhere>
References: <1301496028.4859.183.camel@twins>
 <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
 <1301558992.2250.489.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301558992.2250.489.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:09:52AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-03-31 at 03:35 +0200, Frederic Weisbecker wrote:
> > The default setting of perf record is to mmap 128 pages if the user
> > did not override with -m.
> > However the page size may vary accross different architecture
> > settings, giving different default size between each.
> > 
> > Moreover the kernel side still has a default max number of mlocked
> > pages of 512 kiB + 1 page for unprivileged users. 128 + 1 pages
> > with page size > 4096 overlaps this threshold.
> > 
> > Thus, better adapt to this limitation and set the default number of
> > pages to fit those 512 kiB + 1 page.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  tools/perf/builtin-record.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 6febcc1..a7e14bd 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -41,7 +41,7 @@ static u64			user_interval			= ULLONG_MAX;
> >  static u64			default_interval		=      0;
> >  
> >  static unsigned int		page_size;
> > -static unsigned int		mmap_pages			=    128;
> > +static unsigned int		mmap_pages			= UINT_MAX;
> >  static unsigned int		user_freq 			= UINT_MAX;
> >  static int			freq				=   1000;
> >  static int			output;
> > @@ -506,6 +506,10 @@ static int __cmd_record(int argc, const char **argv)
> >  	if (have_tracepoints(&evsel_list->entries))
> >  		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
> >  
> > +	/* 512 kiB: default amount of unprivileged mlocked memory */
> > +	if (mmap_pages == UINT_MAX)
> > +		mmap_pages = (512 * 1024) / page_size;
> > +
> >  	if (forks) {
> >  		child_pid = fork();
> >  		if (child_pid < 0) {
> 
> Ok, these two patches look good, I'll queue them. However a follow up
> might be to change the perf-record parameter from nr_pages to kb, which
> is a much more user friendly interface anyway ;-)

Agreed. I just wanted to keep that -m around on top of nr_pages beacuse
we have some tools/scripts relying on it, like perf lock, which need to
be changed as well.

We need a new option for this I think, and deprecate -m later perhaps, the
time for external users to migrate? Or just remove -m but it's certainly
going to be replaced soon.

