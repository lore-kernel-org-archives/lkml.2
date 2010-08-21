Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HUCrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 22:47:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63636 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0HUCrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 22:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dip88C7b151xZ6pYa48ZopAEYfJY5QdFUtN2kw9WeCOSHxH35lxb0Kcaijw5Dik4V7
         lZPR5a7cOedYPGE0im+Na36RQzCtDHAfPRYH5N6JuCCAsSrEzcSqyC4I/41JHyof6UTt
         toReVaPzqDparM9FPV0mLzbTee+W8qsrL7ugc=
Date: Sat, 21 Aug 2010 04:47:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100821024713.GD7959@nowhere>
References: <20100815225359.GA32152@infradead.org> <20100819005720.GB5324@nowhere> <20100819085700.GB8782@infradead.org> <20100819150422.GA325@ghostprotocols.net> <20100820091645.GA20138@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820091645.GA20138@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:16:45AM -0400, Christoph Hellwig wrote:
> On Thu, Aug 19, 2010 at 12:04:22PM -0300, Arnaldo Carvalho de Melo wrote:
> > 
> > [acme@doppio tmp]$ perf report
> > 
> > http://vger.kernel.org/~acme/perf/perf-report-tui-callchain-xlog_sync.png
> > 
> > So it seems to work (you tell me if the callchains make sense), and the problem
> 
> I've rebuilt perf with libnewt to reproduce it, but to get any of the
> callchain data I need to call perf report with a -g argument (which is
> rather expected from the documentation anyway)
> 
> I still see the same problems as with the TUI perf report with that.
> With the -g {mode},0.0 there is nothing to expand inside the GUI for
  ^^
  you meant "without", right?

> e.g. the pythong process, and with the 0.0 threshold I can only expand
> a few 0.<something> callchains, but I never see the 80% your screenshot
> shows.  What perf version are you running?



Right. So this is due to the roots of the callchains that have uninitialized
values for their children hits.

To summarize, you enter a percentage (or you keep the default 0.5%) and it gets
multiplied by a random number. The result is supposed to be the minimum hits
a branch should have to be displayed. But it often produced a huge number due
to the unintialization randomness. Hence some callchains were not displayed.

The following patch solves that particular problem, I'll push it to Ingo for .36
(and -stable):

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 624a96c..d1349d0 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -51,6 +51,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 
 	node->parent = NULL;
+	node->children_hit = 0;
 	node->hit = 0;
 }
 



> Also the flat mode is rendered incorrectly, it just adds different call
> graphs inside a single process directly after each other instead of
> separating them in the rendering.


I'm not sure what you mean. The flat format is a pure dump of every callchains
that belong to a single process (or whatever kind of histogram source...).

What do you mean by separating them in the rendering?

OTOH I see another bug:

    61.70%        python  [kernel.kallsyms]  [k] xlog_sync
             0.03%
                xlog_sync
                xlog_write
                xlog_cil_push
                _xfs_log_force
                xfs_log_force
                xfs_commit_dummy_trans
                xfs_quiesce_data
                xfs_fs_sync_fs
                __sync_filesystem
                sync_one_sb
                iterate_supers
                sync_filesystems
                sys_sync
                system_call_fastpath
                0x334f0d72e7

             0.01%
                xlog_sync
                _xfs_log_force
                xfs_log_force
                xfs_commit_dummy_trans
                xfs_quiesce_data
                xfs_fs_sync_fs
                __sync_filesystem
                sync_one_sb
                iterate_supers
                sync_filesystems
                sys_sync
                system_call_fastpath
                0x334f0d72e7

I think that's what you said previously: they sometimes don't add up correctly.
The total of hit percentages from callchains should equal the total
percentage of the process they belong to.

I'm investigating to find the reason.

Thanks a lot of your reports!

