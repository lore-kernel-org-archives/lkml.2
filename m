Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0IPMI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:08:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49852 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0IPMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DRSHcg1a5DZWdPPeDqWS8hlK1Zis9/RdpRRhwzZg3rKekPdSK/ilo/6Gj7josw8hBk
         /4tdJPhJ8e83bXspDzQ8Ud3Dssiv5tNydMYV/LmykuXygv2EV0xngQ1yPsZchFP7CbHZ
         v4jiKuWMOPOZNYA+VJqklH/YeBzt1UnBMl/1w=
Date: Thu, 16 Sep 2010 14:08:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf scripting
Message-ID: <20100916120846.GA5400@nowhere>
References: <1280497020-22816-1-git-send-email-mel@csn.ul.ie> <1280497020-22816-2-git-send-email-mel@csn.ul.ie> <20100730140441.GB5269@nowhere> <20100814200415.GA24704@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814200415.GA24704@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry to answer that so late)


On Sat, Aug 14, 2010 at 04:04:15PM -0400, Christoph Hellwig wrote:
> On Fri, Jul 30, 2010 at 04:04:42PM +0200, Frederic Weisbecker wrote:
> > I have the feeling you've made an ad-hoc post processing script that seems
> > to rewrite all the format parsing, debugfs, stream handling, etc... we
> > have that in perf tools already.
> > 
> > May be you weren't aware of what we have in perf in terms of scripting support.
> 
> Frederic, any chance you could help me getting a bit more familar with
> the perf perl scripting.  I currently have a hacky little sequence that
> I use to profile what callers generate XFS log traffic, and it like to
> turn it into a script so that I can do a direct perf call to use it
> to profile things without manual work, and generate nicer output.
> 
> Currently it looks like this:
> 
> perf probe --add xlog_sync
> 
> perf record -g -e probe:xlog_sync -a -- <insert actualy workload here>
> 
> then do
> 
> perf report -n -g flat
> 
> to get me the callchain in a readable format.
> 
> Now what I'd really like is a perl script that can read a file like
> latencytop.trans (or just has the information embedded) which contains
> functions in the backtrace that we're interested in.
> 
> E.g. one simple from the report command above may look like:
> 
>                 xlog_sync
> 		xlog_write
> 		xlog_cil_push
> 		_xfs_log_force
> 		xfs_log_force
> 		xfs_sync_data
> 		xfs_quiesce_data
> 		xfs_fs_sync_fs
> 
> In which case I'm interested in xfs_log_force and xfs_fs_sync_fs.  So
> the output of the perl script should looks something like:
> 
> 
>   Samples	Caller
> 	2	xfs_fs_sync_fs
> 	1	xfs_file_fsync
> 	1	xfs_commit_dummy_trans


Somehow, that's a kind of overview you can get with
perf report, using the default fractal mode or the graph mode.
Callers are sorted by hits in these modes (actually in raw mode too).

But it could be interesting to add the callchains as arguments to the
perl/python scripting handlers for precise usecases.

 
> Or if I have a way to parse the argument of the probe (in the worst case
> I can replace it with a trace event if that makes it easier):
> 
>   Samples	Flags		Callers
> 	1	sync		xfs_fs_sync_fs
> 	1			xfs_fs_sync_fs
> 	1	sync		xfs_file_fsync
> 	1	sync		xfs_commit_dummy_trans


So for example that becomes an even more precise usecase.
Currently the perf scripting engine doesn't give you access
to the callchains of a trace sample. That would be a nice feature
and would solve your problem.

Tom, what do you think about that? This could be a special mode
requested by the user, or something made automatically if callchains
are present in samples. We could add a specific callchain extra
argument to the generated scripting handlers, or this could
be a generic extra dict argument that can contain whatever we want
(perf sample headers, etc...), whatever extra data the user might
request.

What do you think?

Thanks.

