Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0IQKcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:32:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56948 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0IQKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:32:40 -0400
X-AuditID: b753bd60-a60ccba000005dcc-9f-4c9343c5184f
Message-ID: <4C9343C2.1010909@hitachi.com>
Date: Fri, 17 Sep 2010 19:32:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: perf scripting
References: <1280497020-22816-1-git-send-email-mel@csn.ul.ie> <1280497020-22816-2-git-send-email-mel@csn.ul.ie> <20100730140441.GB5269@nowhere> <20100814200415.GA24704@infradead.org> <20100916120846.GA5400@nowhere>
In-Reply-To: <20100916120846.GA5400@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/16 21:08), Frederic Weisbecker wrote:
> (Sorry to answer that so late)
> 
> 
> On Sat, Aug 14, 2010 at 04:04:15PM -0400, Christoph Hellwig wrote:
>> On Fri, Jul 30, 2010 at 04:04:42PM +0200, Frederic Weisbecker wrote:
>>> I have the feeling you've made an ad-hoc post processing script that seems
>>> to rewrite all the format parsing, debugfs, stream handling, etc... we
>>> have that in perf tools already.
>>>
>>> May be you weren't aware of what we have in perf in terms of scripting support.
>>
>> Frederic, any chance you could help me getting a bit more familar with
>> the perf perl scripting.  I currently have a hacky little sequence that
>> I use to profile what callers generate XFS log traffic, and it like to
>> turn it into a script so that I can do a direct perf call to use it
>> to profile things without manual work, and generate nicer output.
>>
>> Currently it looks like this:
>>
>> perf probe --add xlog_sync
>>
>> perf record -g -e probe:xlog_sync -a -- <insert actualy workload here>
>>
>> then do
>>
>> perf report -n -g flat
>>
>> to get me the callchain in a readable format.
>>
>> Now what I'd really like is a perl script that can read a file like
>> latencytop.trans (or just has the information embedded) which contains
>> functions in the backtrace that we're interested in.
>>
>> E.g. one simple from the report command above may look like:
>>
>>                 xlog_sync
>> 		xlog_write
>> 		xlog_cil_push
>> 		_xfs_log_force
>> 		xfs_log_force
>> 		xfs_sync_data
>> 		xfs_quiesce_data
>> 		xfs_fs_sync_fs
>>
>> In which case I'm interested in xfs_log_force and xfs_fs_sync_fs.  So
>> the output of the perl script should looks something like:
>>
>>
>>   Samples	Caller
>> 	2	xfs_fs_sync_fs
>> 	1	xfs_file_fsync
>> 	1	xfs_commit_dummy_trans

BTW, if you want the caller for each call, you can do with perf probe

# perf probe --add 'xlog_sync caller=+0($stack)'

then, you can see the caller address in caller argument of
xlog_sync event record.


> Somehow, that's a kind of overview you can get with
> perf report, using the default fractal mode or the graph mode.
> Callers are sorted by hits in these modes (actually in raw mode too).
> 
> But it could be interesting to add the callchains as arguments to the
> perl/python scripting handlers for precise usecases.
> 
>  
>> Or if I have a way to parse the argument of the probe (in the worst case
>> I can replace it with a trace event if that makes it easier):
>>
>>   Samples	Flags		Callers
>> 	1	sync		xfs_fs_sync_fs
>> 	1			xfs_fs_sync_fs
>> 	1	sync		xfs_file_fsync
>> 	1	sync		xfs_commit_dummy_trans
> 
> 
> So for example that becomes an even more precise usecase.
> Currently the perf scripting engine doesn't give you access
> to the callchains of a trace sample. That would be a nice feature
> and would solve your problem.

AFAIK, perf perl script already supports getting arguments of
events. e.g.

sub probe::xlog_sync
{
    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
        $common_pid, $common_comm,
        $caller) = @_;

    if (!defined($caller_list{$caller})) {
         	$caller_list{$caller} = 0;
    }	
    $caller_list{$caller}++;
}

for count up caller address.
(However, perf perl currently doesn't have address-symbol translation
 function. )

If perf scripting supports calling perf internally for defining
new events for the script, it will be useful (from the viewpoint
of script packaging).

Thank you,

> 
> Tom, what do you think about that? This could be a special mode
> requested by the user, or something made automatically if callchains
> are present in samples. We could add a specific callchain extra
> argument to the generated scripting handlers, or this could
> be a generic extra dict argument that can contain whatever we want
> (perf sample headers, etc...), whatever extra data the user might
> request.
> 
> What do you think?
> 
> Thanks.
