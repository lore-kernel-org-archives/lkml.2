Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1GYVnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1GYVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:14 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Subject: [patch 00/25] dynamic_debug: multiple, pending queries in boot-arg 
Date: Mon, 25 Jul 2011 15:42:25 -0600
Message-Id: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patchset extends dynamic-debug facility to allow
use of pr_debug() within a loadable module's module_init()
function.  Query/rules can be given on the boot-line,
and are saved to a pending list if they cannot be applied
immediately.  Later, when the module is being loaded, the
pending list is scanned, and matching rules are applied.
Thus pr_debug() calls in the module's initialization function
are active when it is invoked.

Changes since rev1:

- rebased on top of Jasons & Joes patchset
- fixed accidental unescape removal, noted by Bart
- trim src-path patch checks for matching prefix before trimming
 should now work for out-of-tree modules.
- undid verbose newline-strip in exec-queries - Bart
- verbose param 644, not 744 - Bart, Greg
- whitespace - Bart
- added 'a' flag - Jason, Bart
- drop pending_max - Bart

Changes since rev2:

1. lock around all list-work, pending-ct

In response to Bart's locking-bug observation, I hoisted locks up to
callers, so theyd protect all list, pending-ct manipulation.  This
means longer hold-times, but less locking/unlocking.  Left as separate
patch for now, partly cuz having pr_info's under lock gave me some
heartburn.  That said, lockdep didnt complain.  I think I got the
interim patches correct too.

2. filter-flags

Ive extended flags spec to have <match-flags>* <op> <new-flags>*
IE, matching /[pmflta]*[+-=][pmflta]*/

match-flags (optional) allows a query/rule to be more selective, which
increases the utility of otherwise unconstrained rules.  So the
following query matches all call-sites that are already enabled,
adding the TID flag.

$> echo " p+t " > <dbgfs>/dynamic_debug/control

3. 'a' pending query modification, removal

Real purpose of 2 was to allow modification or deletion of currently
pending queries:

$> echo "module foo +ap" > <debugfs>/dynamic_debug/control
$> echo "module foo +apt" > <debugfs>/dynamic_debug/control
$> echo "module foo ap=_" > <debugfs>/dynamic_debug/control

1st command adds a pending query on module foo
2nd command modifies it by adding a TID flag
3rd command deletes the pending query by setting flags to 0

Note that 2,3 have exact match on the query-spec, the match-flags in 3
specify flags required to match against the pending query; the 't'
flag added in 2 is not required, but allowed.

With explicit deletion of pending rules, I removed the tacit
delete-on-apply behavior.

4. $> cat <dbfs>/dynamic_debug/pending

This displays currently pending queries, simplifying their deletion.
Its not correct right now; it iterates over set, but repeats

5.  Fuller multi-command input

writes to control-file are parsed on '\n' as well as ';',
and '#' are recognized as comments.  
With this, the following works.

root@voyage:~# cat debugfs-file

  # blank lines ok
  module dynamic_debug +p              ; # turn on self-debugging
  # these are quite noisy when grepping
  # $DEBUGFS/dynamic_debug/{control,pending}
    # silence them (also, leading spaces allowed in comments)
  func ddebug_proc_show -p
  func ddebug_proc_next -p     ; # trailing comments need cmd terminator
  func pending_proc_show -p    ;
  func pending_proc_next -p

root@voyage:~# cat debugfs-file > /dbgfs/dynamic_debug/control
split into words: "module" "dynamic_debug" "+p"
changed $srcroot/lib/dynamic_debug.c:223 [dynamic_debug]ddebug_change =p
changed $srcroot/lib/dynamic_debug.c:576 [dynamic_debug]ddebug_save_pending =p
....

Here-docs work too, but shell interferes with comments.


Notes:

1. echo " +p " > /dbg/dynamic_debug/control

The above felt a little radical, but it isnt really; it works on
mainline.  Therefore one part of the Doc is slightly misleading (last
sentence):

 The match-spec's are used to choose a subset of the known dprintk()
 callsites to which to apply the flags-spec.  Think of them as a query
 with implicit ANDs between each pair.  Note that an empty list of
 match-specs is possible, but is not very useful because it will not
 match any debug statement callsites.

2. this runs 2 separate writes.

printf "module nsc_gpio +p\n module pc8736x_gpio +p\npc8736x_gpio +p\n" \
      > /dbg/dynamic_debug/control

This form of command is seen by kernel as 2 separate writes, so the
form is not usable in boot-line in mainline; it breaks the debug
facility (see patch 6).  Using ';' to separate multiple commands does
work on boot-line.

thanks
Jim Cromie

1-11 are straightforward, I think ready to go.
12-25 are the core feature addition, and have bigger implications.  
I think theyre mostly solid, but they probably warrant more scrutiny.
25 needs some help.

0001-dynamic_debug-add-pending-flag-a-to-make-pending-que.patch
0002-dynamic_debug-change-verbosity-at-runtime.patch
0003-dynamic_debug-use-pr_debug-instead-of-pr_info.patch
0004-dynamic_debug-replace-strcpy-with-strlcpy-in-ddebug_.patch
0005-dynamic_debug-trim-source-path-prefix-from-dynamic_d.patch
0006-dynamic_debug-process-multiple-commands-on-a-line.patch
0007-dynamic_debug-enlarge-command-query-write-buffer.patch
0008-dynamic_debug-warn-when-1-of-each-type-of-match-spec.patch
0009-dynamic_debug-pr_err-call-should-not-depend-upon-ver.patch
0010-dynamic_debug-dont-kill-entire-facility-on-error-par.patch
0011-dynamic_debug-factor-show_ddebug_query-out-of-ddebug.patch
0012-dynamic_debug-save-non-matching-queries-to-pending-l.patch
0013-dynamic_debug-apply_pending_queries-from-ddebug_add_.patch
0014-dynamic_debug-refactor-query_matches_callsite-out-of.patch
0015-dynamic_debug-remove-explicit-foo-NULL-checks.patch
0016-dynamic_debug-require-a-flag-to-explicitly-mark-pend.patch
0017-dynamic_debug-hoist-locking-in-ddebug_change-to-call.patch
0018-dynamic_debug-describe_flags-with-pmflta_.patch
0019-dynamic_debug-add-flags-filtering-to-flags-spec.patch
0020-dynamic_debug-remove-pending-query-when-flags-zeroed.patch
0021-dynamic_debug-shrink-struct-pending-query-to-size-ac.patch
0022-dynamic_debug-call-ddebug_add_module-on-dynamic_debu.patch
0023-dynamic_debug-document-pending-queries-flags-filter-.patch
0024-dynamic_debug-add-Documentation-example-for-query-cm.patch
0025-dynamic_debug-drop-pr_fmt-from-dynamic_pr_debug.patch
0026-dynamic_debug-add-DBGFS-dynamic_debug-pending.patch

