Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0GUNU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:20:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41198 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab0GUNU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:20:56 -0400
Date: Wed, 21 Jul 2010 18:49:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 0/13]  Uprobes Patches:
Message-ID: <20100721131953.GA4290@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100720041938.GA28533@infradead.org>
 <20100720063805.GA19375@linux.vnet.ibm.com>
 <20100720210358.GA17631@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100720210358.GA17631@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo <acme@infradead.org> [2010-07-20 18:03:59]:

> Em Tue, Jul 20, 2010 at 12:08:05PM +0530, Srikar Dronamraju escreveu:
> > > A minor note on perf probe -S output:  This seems to include a lot of
> > > T.456 or similar labels, which from my recollection are gcc internal
> > > things.  It would be good to filter those out as they aren't quite
> > > useful and just fill up the list.
> > 
> > Okay .. will take a look. Offhand I dont know about the T.456
> > labels, so I will google and see if its possible for us to identify if
> > its a t.456 label. However if you know how to identify a t456 label
> > from normal functions, then it would be great.
> 
> We may have some hint on the symtab, having access to one of those files
> to look at its symtab will help.

Based on inputs from Christoph and Arnaldo and Steven, I was trying to see
what could be filtered out from the current listing.

For example current listing of libc would list labels like these
(I think Christoph is refering to these as t.456 labels).
(Thankfully Steven Rostedt also confirms this).

.L2
.L3
.L4
.L5
.L6
.L7
.L8
.L9

(Think we should exclude these labels from listing.)

However I now see more classifications and I am not sure if all of these
classifications should be included. I am giving 8 listings  each for each
classification.
 
stty                                          GLOBAL binding DEFAULT visibility
swab                                          GLOBAL binding DEFAULT visibility
sync                                          GLOBAL binding DEFAULT visibility
time                                          GLOBAL binding DEFAULT visibility
verr                                          GLOBAL binding DEFAULT visibility
warn                                          GLOBAL binding DEFAULT visibility
abort                                         GLOBAL binding DEFAULT visibility
alarm                                         GLOBAL binding DEFAULT visibility

(Think we should include the above in listing.)


fini                                          LOCAL binding DEFAULT visibility
init                                          LOCAL binding DEFAULT visibility
pcmp                                          LOCAL binding DEFAULT visibility
__brk                                         LOCAL binding DEFAULT visibility
comma                                         LOCAL binding DEFAULT visibility
do_in                                         LOCAL binding DEFAULT visibility
__dup                                         LOCAL binding DEFAULT visibility
_help                                         LOCAL binding DEFAULT visibility
_itoa                                         LOCAL binding DEFAULT visibility
token                                         LOCAL binding DEFAULT visibility

(I am not sure if the above should be included in listing. This type of
classification seem to be present in libc only. However I might be wrong
here.)

_init                                         LOCAL binding HIDDEN visibility
_fitoa                                        LOCAL binding HIDDEN visibility
__GI_ffs                                      LOCAL binding HIDDEN visibility
__utimes                                      LOCAL binding HIDDEN visibility
__futimes                                     LOCAL binding HIDDEN visibility
__GI_exit                                     LOCAL binding HIDDEN visibility
__GI_glob                                     LOCAL binding HIDDEN visibility
__GI_time                                     LOCAL binding HIDDEN visibility
__GI_verr                                     LOCAL binding HIDDEN visibility
__GI_warn                                     LOCAL binding HIDDEN visibility
__readall                                     LOCAL binding HIDDEN visibility


(Guess functions listed under this classification shouldnt be listed. 
Again I have seen this classification only in libc.)


brk                                           WEAK binding DEFAULT visibility
dup                                           WEAK binding DEFAULT visibility
bcmp                                          WEAK binding DEFAULT visibility
dup2                                          WEAK binding DEFAULT visibility
feof                                          WEAK binding DEFAULT visibility
ffsl                                          WEAK binding DEFAULT visibility
fork                                          WEAK binding DEFAULT visibility
getc                                          WEAK binding DEFAULT visibility
gets                                          WEAK binding DEFAULT visibility
kill                                          WEAK binding DEFAULT visibility

(I see this classification in both libraries and executables. Generally
these are plt enteries. Again I am not sure if these enteries need to be
part of listing. In some of the DSO, these enteries have a symbol value of
0. i.e if somebody requests to probe a weak symbol in a particular dso, then
chances are we fail to probe because we dont get the right address.)

The other way to look at it is seeing how fork and malloc are categorized.

__fork                                        GLOBAL binding DEFAULT visibility
__vfork                                       GLOBAL binding DEFAULT visibility
__libc_fork                                   GLOBAL binding DEFAULT visibility
__register_atfork                             GLOBAL binding DEFAULT visibility
free_atfork                                   LOCAL binding DEFAULT visibility
__GI___vfork                                  LOCAL binding DEFAULT visibility
malloc_atfork                                 LOCAL binding DEFAULT visibility
__GI___fork                                   LOCAL binding HIDDEN visibility
__unregister_atfork                           LOCAL binding HIDDEN visibility
__GI___register_atfork                        LOCAL binding HIDDEN visibility
fork                                          WEAK binding DEFAULT visibility
vfork                                         WEAK binding DEFAULT visibility

malloc                                        GLOBAL binding DEFAULT visibility
__libc_malloc                                 GLOBAL binding DEFAULT visibility
__malloc                                      LOCAL binding DEFAULT visibility
mallochook                                    LOCAL binding DEFAULT visibility
_int_malloc                                   LOCAL binding DEFAULT visibility
malloc_check                                  LOCAL binding DEFAULT visibility
malloc_atfork                                 LOCAL binding DEFAULT visibility
__malloc_trim                                 LOCAL binding DEFAULT visibility
ptmalloc_init                                 LOCAL binding DEFAULT visibility
tr_mallochook                                 LOCAL binding DEFAULT visibility
__malloc_stats                                LOCAL binding DEFAULT visibility
malloc_hook_ini                               LOCAL binding DEFAULT visibility
ptmalloc_lock_all                             LOCAL binding DEFAULT visibility
malloc_consolidate                            LOCAL binding DEFAULT visibility
__malloc_get_state                            LOCAL binding DEFAULT visibility
__malloc_set_state                            LOCAL binding DEFAULT visibility
__malloc_check_init                           LOCAL binding DEFAULT visibility
ptmalloc_unlock_all                           LOCAL binding DEFAULT visibility
__malloc_usable_size                          LOCAL binding DEFAULT visibility
ptmalloc_unlock_all2                          LOCAL binding DEFAULT visibility
__GI___libc_malloc                            LOCAL binding HIDDEN visibility
malloc_trim                                   WEAK binding DEFAULT visibility
malloc_stats                                  WEAK binding DEFAULT visibility
malloc_get_state                              WEAK binding DEFAULT visibility
malloc_set_state                              WEAK binding DEFAULT visibility
malloc_usable_size                            WEAK binding DEFAULT visibility


I think we should just list the symbols under classification GLOBAL binding,
default visibility. 

--
Thanks and Regards
Srikar
