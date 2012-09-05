Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2IEAlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:41:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56112 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2IEAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:41:14 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-65-50469fa8a5d7
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf ui/browser: Add a browser for perf script
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
	<1346660073-20279-6-git-send-email-feng.tang@intel.com>
	<87a9x6eei8.fsf@sejong.aot.lge.com> <20120904171327.0901e142@feng-i7>
Date: Wed, 05 Sep 2012 09:33:46 +0900
In-Reply-To: <20120904171327.0901e142@feng-i7> (Feng Tang's message of "Tue, 4
	Sep 2012 17:13:27 +0800")
Message-ID: <87wr09cnpx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 17:13:27 +0800, Feng Tang wrote:
> Hi Namhyung,
>
> Thanks for your kind and thorough reviews.
>
> On Tue, 4 Sep 2012 10:57:35 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> On Mon,  3 Sep 2012 16:14:31 +0800, Feng Tang wrote:
>> > Create a script browser, so that user can check all the available
>> > scripts and run them inside the main perf report or annotation
>> > browsers, for all the perf samples or samples belong to one
>> > thread/symbol.
>> >
>> > The work flow is, users can use function key to list all the available
>> > scripts in system and chose one, which will be executed with
>> > popen("perf script -s xxx.xx",) and all the output lines are put into
>> > one ui browser, pressing 'q' or left arrow key will make it return
>> > to previous browser.
>> 
>> It could be used for TUI interface of perf script itself too (at least
>> for --list option) IMHO.
>
> Do you mean make the "perf script -l" to be shown in a browser, or we
> use the same popen("perf script -l") way to cache and list the all the
> scripts so that we don't need the find_scripts()?

I meant the former.

>
>> 
>> 
>> >
>> > Please be noted, most of the in-tree scripts with name xxxtop are
>> > dynamically run and not supported by this static browser. 
>> 
>> If so, wouldn't it be better adding a filter not to show those
>> unsupported scripts somehow?
>
> Good idea, will simply filter them in next version.
>> 
>> 
[SNIP]
>> > +
>> > +	fp = popen(cmd, "r");
>> > +	if (!fp)
>> > +		goto exit;
>> > +
>> > +	while ((retlen = getline(&line, &len, fp)) != -1) {
>> > +		strcpy(sline[nr_entries].line, line);
>> 
>> What if the len is larger than sline[].line?
>
> That's a problem, how about adding a check for "retlen" and cut that
> line to fit the SCRIPT_FULLPATH_LEN? Or we just wrap the long line
> by using several struct script_line to save it?

The first option looks better for simplicity.

Thanks,
Namhyung

>
>> 
>> 
>> > +		list_add_tail(&sline[nr_entries].node, &script.entries);
>> > +
>> > +		if (script.b.width < retlen)
>> > +			script.b.width = retlen;
>> > +		nr_entries++;
>> 
>> I think you need this too:
>> 
>> 		if (nr_entries >= MAX_LINES)
>> 			break;
>> > +	}
>> > +
>> > +	script.nr_lines = nr_entries;
>> > +	script.b.nr_entries = nr_entries;
>> > +	script.b.entries = &script.entries;
>> > +
>> > +	ret = script_browser__run(&script);
>> > +
>> > +	if (line)
>> > +		free(line);
>> 
>> No pclose(fp) ?
>> 
>> 
>> > +
>> > +exit:
>> > +	free(sline);
>> > +	return ret;
>> > +}
>> > diff --git a/tools/perf/ui/browsers/scripts.h b/tools/perf/ui/browsers/scripts.h
>> > new file mode 100644
>> > index 0000000..011baa8
>> > --- /dev/null
>> > +++ b/tools/perf/ui/browsers/scripts.h
>> > @@ -0,0 +1,5 @@
>> > +#ifndef _PERF_UI_BROWSER_BROWSER_H_
>> > +#define _PERF_UI_BROWSER_BROWSER_H_ 1
>> 
>> I guess you want _PERF_UI_BROWSER_SCRIPT_H_ ?
>
> Exactly. 
>
> I'll address the comments in this email and those in other emails. thanks!
>
> - Feng
