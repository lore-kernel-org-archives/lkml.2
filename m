Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2IGPjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:39:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43510 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2IGPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:39:14 -0400
Date: Fri, 7 Sep 2012 08:30:22 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: liang xie <xieliang007@gmail.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, balbi@ti.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] A trivial memory leak fix while calling system_path
Message-ID: <20120907153022.GA19165@ghostprotocols.net>
References: <CADu=CFpMKkAW5+=Us9J2GOxZTBDN91FTeteCgbyh8c7fsP837g@mail.gmail.com>
 <87oblibb7r.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oblibb7r.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 07, 2012 at 03:26:00PM +0900, Namhyung Kim escreveu:
> On Fri, 7 Sep 2012 11:34:49 +0800, liang xie wrote:
> > +	const char *exec_path = perf_exec_path();
> >
> > -	add_path(&new_path, perf_exec_path());
> > +	add_path(&new_path, exec_path);
> >  	add_path(&new_path, argv0_path);
> >
> >  	if (old_path)
> > @@ -95,6 +96,7 @@ void setup_path(void)
> >  	setenv("PATH", new_path.buf, 1);
> >
> >  	strbuf_release(&new_path);
> > +	free((void *)exec_path);
> >  }
> 
> The problem is that perf_exec_path() can return a non-dynamically
> allocated string (e.g. command line argument or environment string) and
> currently we cannot know where the returned string is came from.

And that is just gross, ugh. Make it always return dynamically allocated
string, not const, drop the cast on free and be done with it :-)

- Arnaldo

> It might cause much more troubles when you free that kind of string than
> just leaking a couple of bytes IMHO.
> 
> Thanks,
> Namhyung
> 
> >
> >  static const char **prepare_perf_cmd(const char **argv)
> > diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
> > index 6f2975a..798f66d 100644
> > --- a/tools/perf/util/help.c
> > +++ b/tools/perf/util/help.c
> > @@ -187,6 +187,7 @@ void load_command_list(const char *prefix,
> >  		uniq(other_cmds);
> >  	}
> >  	exclude_cmds(other_cmds, main_cmds);
> > +	free((void *)exec_path);
> >  }
> >
> >  void list_commands(const char *title, struct cmdnames *main_cmds,
