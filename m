Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2IDJTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:19:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:61450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab2IDJTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,366,1344236400"; 
   d="scan'208";a="217506600"
Date: Tue, 4 Sep 2012 17:13:27 +0800
From: Feng Tang <feng.tang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf ui/browser: Add a browser for perf script
Message-ID: <20120904171327.0901e142@feng-i7>
In-Reply-To: <87a9x6eei8.fsf@sejong.aot.lge.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
	<1346660073-20279-6-git-send-email-feng.tang@intel.com>
	<87a9x6eei8.fsf@sejong.aot.lge.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

Thanks for your kind and thorough reviews.

On Tue, 4 Sep 2012 10:57:35 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> On Mon,  3 Sep 2012 16:14:31 +0800, Feng Tang wrote:
> > Create a script browser, so that user can check all the available
> > scripts and run them inside the main perf report or annotation
> > browsers, for all the perf samples or samples belong to one
> > thread/symbol.
> >
> > The work flow is, users can use function key to list all the available
> > scripts in system and chose one, which will be executed with
> > popen("perf script -s xxx.xx",) and all the output lines are put into
> > one ui browser, pressing 'q' or left arrow key will make it return
> > to previous browser.
> 
> It could be used for TUI interface of perf script itself too (at least
> for --list option) IMHO.

Do you mean make the "perf script -l" to be shown in a browser, or we
use the same popen("perf script -l") way to cache and list the all the
scripts so that we don't need the find_scripts()?

> 
> 
> >
> > Please be noted, most of the in-tree scripts with name xxxtop are
> > dynamically run and not supported by this static browser. 
> 
> If so, wouldn't it be better adding a filter not to show those
> unsupported scripts somehow?

Good idea, will simply filter them in next version.
> 
> 
> > You can run the event_analyzing_sample.py for example.
> >
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---

> > +
> > +/* 160 bytes for one output line */
> > +#define AVERAGE_LINE_LEN	160
> > +
> > +struct script_line {
> > +	struct list_head node;
> > +	char line[AVERAGE_LINE_LEN];
> > +};
> > +
> > +struct perf_script_browser {
> > +	struct ui_browser b;
> > +	struct list_head entries;
> > +	const char *script_name;
> > +	int nr_lines;
> > +};
> > +
> > +#define SCRIPT_NAMELEN	40
> > +#define SCRIPT_MAX_NO	32
> > +#define SCRIPT_FULLPATH_LEN 128
> 
> I'm not sure these magic numbers are enough.
> 
> 
> > +
> > +/* Return 0 on success */
> > +static int list_scripts(char *script_name)
> > +{
> > +	char *buffer, *scripts[SCRIPT_MAX_NO], *scripts_path[SCRIPT_MAX_NO];
> > +	int i, num, choice, ret = -1;
> > +
> > +	/* Preset the script name to SCRIPT_NAMELEN */
> > +	buffer = zalloc(SCRIPT_MAX_NO * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN));
> > +	if (!buffer)
> > +		return ret;
> > +
> > +	for (i = 0; i < SCRIPT_MAX_NO; i++) {
> > +		scripts[i] = buffer + i * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN);
> > +		scripts_path[i] = scripts[i] + SCRIPT_NAMELEN;
> > +	}
> > +
> > +	num = find_scripts(scripts, scripts_path);
> > +	if (num) {
> 
> It should be:
> 
> 	if (num > 0) {
> 
> since the find_scripts() can return -1.

Yes, as you pointed out in the other review.


> > +
> > +	fp = popen(cmd, "r");
> > +	if (!fp)
> > +		goto exit;
> > +
> > +	while ((retlen = getline(&line, &len, fp)) != -1) {
> > +		strcpy(sline[nr_entries].line, line);
> 
> What if the len is larger than sline[].line?

That's a problem, how about adding a check for "retlen" and cut that
line to fit the SCRIPT_FULLPATH_LEN? Or we just wrap the long line
by using several struct script_line to save it?

> 
> 
> > +		list_add_tail(&sline[nr_entries].node, &script.entries);
> > +
> > +		if (script.b.width < retlen)
> > +			script.b.width = retlen;
> > +		nr_entries++;
> 
> I think you need this too:
> 
> 		if (nr_entries >= MAX_LINES)
> 			break;
> > +	}
> > +
> > +	script.nr_lines = nr_entries;
> > +	script.b.nr_entries = nr_entries;
> > +	script.b.entries = &script.entries;
> > +
> > +	ret = script_browser__run(&script);
> > +
> > +	if (line)
> > +		free(line);
> 
> No pclose(fp) ?
> 
> 
> > +
> > +exit:
> > +	free(sline);
> > +	return ret;
> > +}
> > diff --git a/tools/perf/ui/browsers/scripts.h b/tools/perf/ui/browsers/scripts.h
> > new file mode 100644
> > index 0000000..011baa8
> > --- /dev/null
> > +++ b/tools/perf/ui/browsers/scripts.h
> > @@ -0,0 +1,5 @@
> > +#ifndef _PERF_UI_BROWSER_BROWSER_H_
> > +#define _PERF_UI_BROWSER_BROWSER_H_ 1
> 
> I guess you want _PERF_UI_BROWSER_SCRIPT_H_ ?

Exactly. 

I'll address the comments in this email and those in other emails. thanks!

- Feng

