Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1IZO5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1IZO47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:56:59 -0400
Date: Mon, 26 Sep 2011 16:56:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20110926145606.GA8886@jolsa.brq.redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317044192.26514.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 09:36:31AM -0400, Steven Rostedt wrote:
> On Mon, 2011-09-26 at 11:11 +0200, Jiri Olsa wrote:
> > Changing the way the event files are searched by quering specified
> > event files directly, instead of walking the events directory.
> > 
> > Hopefully this way is more straightforward and faster.
> 
> Have you looked at my code I posted earlier that uses the libparsevents?
> 
> It uses globs such that you could do -e sched:sched* and it will enable
> all sched events.

ops, haven't seen those changes yet..
I think I can go only with 2/2 patch, if the 1/2 collides with your changes

I'll check, thanks
jirka

> 
> -- Steve
> 
> 
> 
> > +	 * and one safety byte ;)
> > +	 */
> > +	file = malloc_or_die(strlen(path) + strlen(sys) +
> > +			     strlen(name) + strlen("format") + 5);
> >  
> > -		free(format);
> > -	}
> > -	closedir(dir);
> > +	sprintf(file, "%s/%s/%s/format", path, sys, name);
> > +	return file;
> >  }
> >  
> > -static void read_ftrace_files(struct tracepoint_path *tps)
> > +static void put_format_file(char *file)
> >  {
> > -	char *path;
> > -
> > -	path = get_tracing_file("events/ftrace");
> > -
> > -	copy_event_system(path, tps);
> > -
> > -	put_tracing_file(path);
> > +	free(file);
> >  }
> >  
> > -static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
> > +/*
> > + * Walk tracepoint event objects and store them.
> > + * Only those matching the sys parameter are stored
> > + * and marked as done.
> > + */
> > +static void read_event_files_system(struct tracepoint_path *tps,
> > +				    const char *sys)
> >  {
> > +	off_t count_pos;
> > +	u32 count = 0;
> > +
> > +	/* Place for number of events under single system. */
> > +	count_pos = lseek(output_fd, 0, SEEK_CUR);
> > +	write_or_die(&count, 4);
> > +
> >  	while (tps) {
> > -		if (!strcmp(sys, tps->system))
> > -			return true;
> > +		if ((!tps->done) &&
> > +		    (!strcmp(sys, tps->system))) {
> > +			char *file;
> > +
> > +			file = get_format_file(tps->system, tps->name);
> > +			if (file) {
> > +				record_file(file, 8);
> > +				count++;
> > +			}
> > +
> > +			put_format_file(file);
> > +			tps->done = 1;
> > +		}
> > +
> >  		tps = tps->next;
> 
> 
