Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1JRUmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:42:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42444 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1JRUmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111010125445.3a1248e4@bike.lwn.net>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-24-git-send-email-jim.cromie@gmail.com> <20111010125445.3a1248e4@bike.lwn.net>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 18 Oct 2011 14:41:32 -0600
Message-ID: <CAJfuBxxz_6MOtxrGr60Y7rO+AfDQe4d+TgTpPNEV6L20vmxELg@mail.gmail.com>
Subject: Re: [PATCH 23/26] dynamic_debug: document pending queries,
 flags-filter, multiple queries
To: Jonathan Corbet <corbet@lwn.net>
Cc: jbaron@redhat.com, joe@perches.com, bart.vanassche@gmail.com,
        greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Jon,

thanks for the review, and sorry for the delayed response -
I had it in sitting in drafts, but got distracted by some build-box issues..

To summarize, I agree that your suggestion, and with Thomas Renninger's patches,
they are a simpler approach (much less code), which does substantially
everything
I was looking for with pending-list.  Im in the process of reworking
the patchset on top of Thomas's patches.

The one issue with new approach is that it adds $module.ddebug parameters
that is not known to modinfo.  Whether to expose it, and how, are open
questions,
which Im deferring.  My hope is they can be added later.
Perhaps this is a good way to add $module.debug_level and
$module.debug_flags too

Below are point-by-point responses, which arent really relevant any more,
but which Im sending anyway - maybe theres something worth a followup.

Jim Cromie

On Mon, Oct 10, 2011 at 12:54 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> Some of these comments are about the patch set as a whole, but done in the
> context of the doc file changes.
>
>>  Dynamic debug has even more useful features:
>>
>> - * Simple query language allows turning on and off debugging statements by
>> -   matching any combination of:
>> + * Simple query language allows turning on and off debugging statements
>> +   by matching any combination of 0 or 1 of:
>>
>>     - source filename
>>     - function name
>>     - line number (including ranges of line numbers)
>>     - module name
>>     - format string
>> +   - current debugging flags
>
> This is totally confusing; you've replaced all the things that can be
> matched with a single-entry itemized list of "current debugging flags"?

I've not replaced the 5 lines, Ive added a single line.
the '-' here is a bullet-point, not a line removal.
Does that clarify ?
If not, I guess you dislike the ambiguity of "current debugging flags"
I think thats covered later..

>
>> + * Provides a debugfs control file: <debugfs>/dynamic_debug/control
>> +   which can be read to display the complete list of known debug
>> +   statements, to help guide you.
>>
>>  Controlling dynamic debug Behaviour
>>  ===================================
>>
>> -The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
>> -control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
>> -filesystem, in order to make use of this feature. Subsequently, we refer to the
>> -control file as: <debugfs>/dynamic_debug/control. For example, if you want to
>> -enable printing from source file 'svcsock.c', line 1603 you simply do:
>> +The behaviour of pr_debug()/dev_dbg()/net_dbg()s are controlled via
>> +writing to a control file in the 'debugfs' filesystem. Thus, you must
>> +first mount the debugfs filesystem, in order to make use of this
>> +feature.  Subsequently, we refer to mount point as $DBGFS, and the
>> +control file as $CONTROL.  So if you want to enable printing from
>
> Why the $CONTROL stuff?  I can see parameterizing teh debugfs location,
> even though that discussion seems to have settled down.  But, if you miss
> the line at the top of this section, you'll never know where $CONTROL is.
> It doesn't change, why obfuscate it?

The reason was to shorten the ~20 commandline examples using it,
avoiding long lines and \ line continuations


>> +source file 'svcsock.c', line 1603 you simply do:
>>
>> -nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
>> -                             <debugfs>/dynamic_debug/control
>> +nullarbor:~ # echo file svcsock.c line 1603 +p > $CONTROL
>>
>>  If you make a mistake with the syntax, the write will fail thus:
>>
>> -nullarbor:~ # echo 'file svcsock.c wtf 1 +p' >
>> -                             <debugfs>/dynamic_debug/control
>> +nullarbor:~ # 'echo file svcsock.c wtf 1 +p' > $CONTROL
>>  -bash: echo: write error: Invalid argument
>
> I don't think you tested that last one :)  The bash error output will be
> other than shown here.

thats the error I get, on 32 and 64bit x86.
what are you seeing ?


>> +  # comments and blank lines ok, but cannot contain semicolon
>> +  # multiple cmds per line, 1st must be terminated by semicolon
>> +  func foo p=_       ; func buzz p=_
>> +  func bar p=_       ; func bum  p=_
>> +  func yak p=_       ; # trailing comment, requires semicolon to terminate cmd
>
> That seems like a slightly strange set of rules.  By Least Surprise, I
> would expect # to start a comment anywhere and to go the end of the line,
> semicolons or not.

yes, slightly strange.
I did it this way so that I could just loop over existing ddebug_exec_query
ie simpler code, smaller changeset.


>> +voyage:~# cat dyndbg-cmdfile > $CONTROL
>> +dynamic_debug:ddebug_exec_queries: processed 7 queries, with 0 errs
>
> Who produces the "processed 7 queries" message?  It's not that "cat"
> command...
>

thats the log-message, on console because I turned up /sys/proc/kernel/printk.
I thought it would be clear, esp with the ~# prompt and command preceding it.
If thats the sticking point, Im happy to remove it.


>> +Multiple commands are processed independently, this allows you to send
>> +commands which may fail, for example if a module is not present.  The
>> +last failing command returns its error.
>> +
>> +Or you can do an "echo" for each, like:
>> +
>> +nullarbor:~ # echo 'file svcsock.c line 1603 +p' > $CONTROL; \
>> +> echo 'file svcsock.c line 1563 +p' > $CONTROL

Mostly because it was in the file originally.

>
> Is there some reason for the backslash-escaped newline here?
>
>>  A match specification comprises a keyword, which controls the attribute
>>  of the callsite to be compared, and a value to compare against.  Possible
>> @@ -125,12 +142,13 @@ match-spec ::= 'func' string |
>>              'module' string |
>>              'format' string |
>>              'line' line-range
>> +// Note: no wildcards, regexs are accepted
>
> Why the // notation?  And what does that line mean?  There's a full regular
> expression interpreter in this code now?  I note that there are no
> regex-based examples in this file.
>

that comment syntax is the same as is used in the lineno explanation
and elsewhere.
As for deeper meaning, it just means literal string matches only.
Perhaps I should just say that.


>> +flags specification
>> +===================
>>
>> -=
>> -    set the flags to the given flags
>> +The flags specification matches the regexp: ^[flmpta_]*[-+=][flmpta_]*$
>> +and has 3 parts:
>>
>> -The flags are:
>> +flags filter (optional):
>> +    The filter precedes the operation [-+=], and constrains matching
>> +    to thoses callsite with given flags set.  This allows altering
>> +    flags on callsites with filtered flag values

ie matches against callsites' current debug-flags

>>
>> -f
>> -    Include the function name in the printed message
>> -l
>> -    Include line number in the printed message
>> -m
>> -    Include module name in the printed message
>> -p
>> -    Causes a printk() message to be emitted to dmesg
>> -t
>> -    Include thread ID in messages not generated from interrupt context
>> +      pm+t   # add t to enabled sites which have m
>
> How about "add the thread ID to sites that already have module-name
> printing enabled?  Same with the rest.

OK. I can improve the wording, something like:

p - enable callsite, printk message to ..
f - add function name to output of enabled callsite
...

>> +Pending queries
>> +===============
>> +
>> +Queries submitted with 'a' are applied to current callsites as above,
>> +but are also added to a pending list.  When a module is loaded later,
>> +pending queries are applied to the module in the order given.
>> +
>> +This is done before the module_init() routine is run, so pr_debug()s
>> +can be active during initialization.  To better support module
>> +debugging, pending queries remain on the list through modprobe-rmmod
>> +cycles.
>
> So this functionality seems to be the whole point of much of this patch
> set.  That's a lot of stuff to turn on printks during module_init().  I
> can't help but wonder: wouldn't it be easier and better to just recognize
> the ddebug_query= parameter at module load time?  Then you could drop this
> whole pending queries mechanism, the expanded syntax, new control file, and
> so on...?  What am I missing?

1 - filtering callsites based upon current-flags is useful,
either by itself, or with other selection constraints

     echo l+p > $CONTROL   # enable callsites with line-numbers selected
     echo p+mf > $CONTROL

2 - with addition of user-flags, say x,y,z, user could define
arbitrary sets of callsites,
then modify and enable them in 1 operation

     echo module foo +x > $CONTROL
     echo module bar  lineno 2-200 +x > $CONTROL
     echo x+mfp > $CONTROL

3 - all modules get working pr_debug during module_init, without changes.
Perhaps no existing mods need this bad enough to have added it, but maybe
they just used printks during development, and removed them before submitting.

4 - the $module.ddebug=+p approach implements a hidden option to all modules,
which is unreported by modinfo $module, and can be used

On the whole, theres no significant advantage vs Thomas Renninger's
$module.ddebug approach.  With his way, you'd add foo.ddebug into
/etc/modprobe.d/*
for each module you want to debug at initialization time.

Given that complexity is the argument against this patchset, its primarily these
that add the pending list; most of the others (modulo the # vs ;
issue) are useful
whether or not pending-query maked the cut.

0016-dynamic_debug-save-a-queries-to-pending-list-for-lat.patch:
lib/dynamic_debug.c           |  154
+++++++++++++++++++++++++++++++++++++++--
0021-dynamic_debug-add-DBGFS-dynamic_debug-pending-file.patch:
lib/dynamic_debug.c |  191
++++++++++++++++++++++++++++++++++++++++++++++++++-


>
>> +You can review currently pending queries by catting or grepping
>> +$DEBUFS/dynamic_debug/pending.  To simplify removal via
>> +cut-paste-edit, its format is similar to the query syntax:
>> +
>> +  root@voyage:~# cat /dbg/dynamic_debug/pending
>> +  # func file module format line flags mask
>> +  ...
>> +   func a299 line 0-0 =pa
>> +   func a300 line 0-0 =pa
>
> I don't get the "line 0-0" stuff either.  Why does it exist?  Its meaning
> is far from intuitive.

It gets printed cuz its part of the query/rule syntax,
and the intent was to make it simple to copy-paste to
add/delete/modify pending rules.
Its trivial to suppress when 0-0, and this would be consistent with
module, file, format etc,
which are not shown when not specified.

I dunno why this didnt outweigh the copy-paste "feature" when I wrote the code,
eliminating it, except when its something like 100-200,
would have simplified the explanation.

>
>> +Deleting or altering a pending query requires an exact match on most
>> +of the match-spec; the same string specs must be given, but 'line 0-0'
>> +matches with '' and vice-versa.  The filter-spec is ignored for
>
> ...and that doesn't really clarify things for me.  Sorry for being so
> dense.

yeah.  Clarity and brevity are *hard*.  Thats why I put in all the examples.
I guess they werent enough.

Let me hazard one more try.
lineno differs from other match-specs in that
echo lineno 0-0 +p > $CONTROL  # is legal, but
echo func "" module ""  +p > $CONTROL   # are not legal
If module, file, func, format is to be unconstrained, just leave it out..
You can add "lineno 0-0" to the query, or leave it out, they are equivalent.


>
>> +  # removes PQ-1 (exact match with PQ-1), disables active callsites (if any)
>> +  voyage:~# dbg_query module foo line 0-0 ap=
>
> And again...how is "line 0-0" an "exact match"?
>
>> +Altering a pending query ('a' in filter) will also alter the callsites
>> +that it applies to (subject to filter match), but changing the active
>> +callsites (using a query without the 'a') does not change the pending
>> +query that applied it.
>
> Why?  If you really need to keep pending queries around, why wouldn't they
> be either totally independent of active queries, or completely tied to
> them?  From this kind of inconsistency unpleasant surprises are born.
>

what does totally independent mean in this context ?
if a pending rule is applicable (ie can effect changes upon the
module) when issued,
it seemed sensible to apply it - waiting til "later" raises many questions..

My 1st version did have them 'totally tied' insofar as any query was pending
if it did not apply (ie if module wasnt loaded).
Jason suggested 'a' flag, I agreed, because it made user intention
clear, and cuz it
eliminated questions about whether any non-applicable query should be pended.

Without explicit 'a' flag, this does NOT add query to pending-list
echo module no-such-module +p > $CONTROL

Note that non-matching query is not an error as of v3.0, nor with this patchset.
Its perhaps worth considering whether more distinct error-codes should
be returned.

>>  // enable all 12 messages in the function svc_process()
>> -nullarbor:~ # echo -n 'func svc_process +p' >
>> -                             <debugfs>/dynamic_debug/control
>> +nullarbor:~ # echo -n 'func svc_process +p' > $CONTROL
>>
>>  // disable all 12 messages in the function svc_process()
>> -nullarbor:~ # echo -n 'func svc_process -p' >
>> -                             <debugfs>/dynamic_debug/control
>> +nullarbor:~ # echo -n 'func svc_process -p' > $CONTROL
>
> Unless you're going to take responsibility for updating the document
> whenever somebody patches svc_process(), I'd take out the exact count of
> the number of messages.

fair enough - again, that is unchanged from the original.

>
>> +// send query-command file to control
>> +root@voyage:~# cat dyndbg-cmdfile > $CONTROL
>> +dynamic_debug:ddebug_proc_open: called
>> +dynamic_debug:ddebug_proc_write: read 500 bytes from userspace
>> +dynamic_debug:ddebug_exec_queries: query 0: "func foo p=_    "
>> +dynamic_debug:ddebug_tokenize: split into words: "func" "foo" "p=_"
>> +dynamic_debug:ddebug_parse_query: parsed func="foo" file="" module="" format="" lineno=0-0
>
> This doesn't seem like a particularly useful example; one can probably
> assume that readers know about cat and I/O redirection.
>

Ok.
I put it there to show representative debug output..
and for folks who skip to EXAMPLES

> Thanks,
>
> jon
>

thanks, even though it doesnt feel like the outcome Id hoped for.
Do/can my responses change the outcome, or is the
module.ddebug=<...> approach fundamentally better ?
I wish my search had found Thomas' patches :-/

Jason, can you look over these patches and suggest the subset
that you could sign-off on ?   I;ll drop the troublesome ones and resubmit.

these should all be good:
0001-dynamic_debug-drop-enabled-field-from-struct-_ddebug.patch
0002-dynamic_debug-make-dynamic-debug-supersede-DEBUG-ccf.patch
0003-dynamic_debug-replace-strcpy-with-strlcpy-in-ddebug_.patch
0004-dynamic_debug-warn-when-1-of-each-type-of-match-spec.patch
0005-dynamic_debug-pr_err-call-should-not-depend-upon-ver.patch
0006-dynamic_debug-add-trim_prefix-to-provide-source-root.patch

maybe defer til pr_debug_level is done:
0007-dynamic_debug-change-verbosity-at-runtime.patch
0008-dynamic_debug-define-several-levels-of-verbosity.patch

sensible, not necessary
0011-dynamic_debug-hoist-locking-in-ddebug_change-to-call.patch

should be done:
0012-dynamic_debug-dont-kill-entire-facility-on-error-par.patch

ok, fluff
0013-dynamic_debug-factor-vpr_info_dq-out-of-ddebug_parse.patch

sensible, not needed,
0014-dynamic_debug-refactor-query_matches_callsite-out-of.patch
0015-dynamic_debug-drop-explicit-foo-NULL-checks.patch

if flags-filtering is ok, minor reworks needed (to drop 'a')
0018-dynamic_debug-describe_flags-with-pmflta_.patch
0019-dynamic_debug-add-flags-filtering-to-flags-spec.patch
0020-dynamic_debug-make-ddebug_describe_flags-more-generi.patch

sensible
0022-dynamic_debug-early-return-if-_ddebug-table-is-empty.patch
0024-dynamic_debug-reduce-lineno-field-to-a-saner-18-bits.patch
0025-dynamic_debug-add-pr_fmt_-for-each-severity.patch
0026-printk.h-drop-unused-pr_cont_once.patch


thanks
~jimc
