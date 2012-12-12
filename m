Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2LLP3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:29:36 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57400 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2LLP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:29:35 -0500
Date: Wed, 12 Dec 2012 12:29:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, namhyung.kim@lge.com
Subject: Re: [PATCH 1/4] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121212152926.GA2382@ghostprotocols.net>
References: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
 <1355128197-18193-2-git-send-email-namhyung@kernel.org>
 <20121210134434.GA6416@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210134434.GA6416@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 10, 2012 at 02:44:34PM +0100, Jiri Olsa escreveu:
> On Mon, Dec 10, 2012 at 05:29:54PM +0900, Namhyung Kim wrote:
> > When comparing entries for collapsing put the given entry first, and then
> > the iterated entry.  This is not the case of hist_entry__cmp() when called
> > if given sort keys don't require collapsing.  So change the order for the
> > sake of consistency.  It will be required for matching and/or linking
> > multiple hist entries.

> Acked-by: Jiri Olsa <jolsa@redhat.com>

Hey,

Before:

[root@sandy ~]# perf diff
# Event 'cycles'
#
# Baseline    Delta      Shared Object                              Symbol
# ........  .......  .................  ..................................
#
    17.41%  -17.41%  [kernel.kallsyms]  [k] memset                        
     0.38%   -0.38%  [kernel.kallsyms]  [k] strlcpy                       
            +48.19%  [kernel.kallsyms]  [k] __blocking_notifier_call_chain
            +46.96%  [kernel.kallsyms]  [k] radix_tree_lookup_slot        
             +4.66%  [kernel.kallsyms]  [k] do_close_on_exec              
    16.17%  -16.17%  [kernel.kallsyms]  [k] final_putname                 
     4.17%   -4.17%  [kernel.kallsyms]  [k] shift_arg_pages               
    30.74%  -30.74%  [kernel.kallsyms]  [k] kfree                         
    14.93%  -14.93%  [kernel.kallsyms]  [k] unlock_page                   
     0.03%   +0.15%  [kernel.kallsyms]  [k] native_write_msr_safe         
    16.17%  -16.17%  libc-2.12.so       [.] _dl_addr                      

After:

[root@sandy ~]# perf diff
# Event 'cycles'
#
# Baseline    Delta      Shared Object                              Symbol
# ........  .......  .................  ..................................
#
    16.17%  -16.17%  libc-2.12.so       [.] _dl_addr                      
            +48.19%  [kernel.kallsyms]  [k] __blocking_notifier_call_chain
    14.93%  -14.93%  [kernel.kallsyms]  [k] unlock_page                   
    30.74%  -30.74%  [kernel.kallsyms]  [k] kfree                         
     4.17%   -4.17%  [kernel.kallsyms]  [k] shift_arg_pages               
    16.17%  -16.17%  [kernel.kallsyms]  [k] final_putname                 
            +46.96%  [kernel.kallsyms]  [k] radix_tree_lookup_slot        
             +4.66%  [kernel.kallsyms]  [k] do_close_on_exec              
     0.03%   +0.15%  [kernel.kallsyms]  [k] native_write_msr_safe         
     0.38%   -0.38%  [kernel.kallsyms]  [k] strlcpy                       
    17.41%  -17.41%  [kernel.kallsyms]  [k] memset                        
[root@sandy ~]#

Got inverted.

The order was arbitrary, and was arbitrarily reversed, are you guys sure this
is the only side effect?

Jiri, IIRC you mentioned that there would be some patch with an --order switch,
would that allow sorting by the entry that had the biggest change, etc?

Holding on this for now.

- Arnaldo
