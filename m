Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1GKHrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab1GKHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:13 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Subject: 
Date: Mon, 11 Jul 2011 01:46:35 -0600
Message-Id: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
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

New Stuff, Bigger items:

- lock around all list-work, pending-ct

In response to Bart's locking-bug observation, I hoisted locks up to
callers, so theyd protect all list, pending-ct manipulation.  This
means longer hold-times, but less locking/unlocking.  Left as separate
patch for now, partly cuz having pr_info's under lock gave me some
heartburn.  That said, lockdep didnt complain.

- 'a' pending query modification, removal

Ive extended flags spec to have <match-flags>* <op> <new-flags>*
IE, matching /[pmflta]*[+-=][pmflta]*/

match-flags (optional) allows a query/rule to be more selective, which
increases the utility of otherwise unconstrained rules.  So the
following query matches all call-sites that are already enabled,
adding the TID flag.

$> echo " p+t " > <dbgfs>/dynamic_debug/control

Further, it allows modification or deletion of currently pending
queries:

$> echo "module foo +ap" > <debugfs>/dynamic_debug/control
$> echo "module foo +apt" > <debugfs>/dynamic_debug/control
$> echo "module foo ap=" > <debugfs>/dynamic_debug/control
    
1st command adds a pending query on module foo
2nd command modifies it by adding a TID flag
3rd command deletes the pending query by setting flags to 0

Note that 2,3 have exact match on the query-spec, the match-flags in 3
specify flags required to match against the pending query; the 't'
flag added in 2 is not required, but allowed.

TODO:

1. when pending-queries is not empty, theres a hang during shutdown.
If I delete all pending queries, shutdown works cleanly.  Ive added
code to clear the pending-list into ddebug_remove_all_tables(), but
its apparently not executed.  Please advise how to invoke
ddebug_remove_all_tables() at shutdown, and whether to do it
separately.

2. $> cat <dbfs>/dynamic_debug/pending
This would display currently pending queries, simplifying their deletion.

3. Decide whether to keep pending on list after they apply.
Given that user added 'a' flag, and can now delete them, its
reasonable to leave them on pending list.  Bart's point, TBD.

Notes:

1. There is a subtle asymmetry in the 'a' flag, example 1 doesnt care
that 'p' is still enabled for the query, once 'a' is turned off, we'd
remove it from the pending list, and same holds for any unconstrained
flags, like t.  However ISTM this is what the user would/should expect.

2. echo " +p " > /dbg/dynamic_debug/control 

The above felt a little radical, but it isnt really; it works on
mainline.  Therefore one part of the Doc is slightly misleading (last
sentence):

 The match-spec's are used to choose a subset of the known dprintk()
 callsites to which to apply the flags-spec.  Think of them as a query
 with implicit ANDs between each pair.  Note that an empty list of
 match-specs is possible, but is not very useful because it will not
 match any debug statement callsites.

3. this runs 2 separate writes.

printf "module nsc_gpio +p\n module pc8736x_gpio +p\npc8736x_gpio +p\n" \
       > /dbg/dynamic_debug/control

This form of command is seen by kernel as 2 separate writes, so the
form is not usable in boot-line in mainline; it breaks the debug
facility (see patch 6).  Patch 3 allows multiple commands, separated
by ';', and does work on boot-line.

thanks
Jim Cromie

[PATCH 01/21] dynamic_debug: add pending flag 'a' to make pending queries explicit
[PATCH 02/21] dynamic_debug: allow changing of dynamic_debug verbosity any time
[PATCH 03/21] dynamic_debug: process multiple commands on a line
[PATCH 04/21] dynamic_debug: warn when >1 of each type of match-spec is given
[PATCH 05/21] dynamic_debug: pr_err() call should not depend upon verbosity
[PATCH 06/21] dynamic_debug: dont kill entire facility on error parsing ddebug_query
[PATCH 07/21] dynamic_debug: return int from ddebug_change
[PATCH 08/21] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
[PATCH 09/21] dynamic_debug: save_pending() saves non-matching queries for later.
[PATCH 10/21] dynamic_debug: call apply_pending_queries from ddebug_add_module
[PATCH 11/21] dynamic_debug: refactor query_matches_callsite out of ddebug_change
[PATCH 12/21] dynamic_debug: document use of pending queries at boot-time
[PATCH 13/21] dynamic_debug: require 'a' flag to explicitly mark pending queries
[PATCH 14/21] dynamic_debug: hoist locking in ddebug_change to callers
[PATCH 15/21] dynamic_debug: describe_flags with '=[ptmfl]*'
[PATCH 16/21] dynamic_debug: define several levels of verbosity
[PATCH 17/21] dynamic_debug: non-optimization - remove != NULL
[PATCH 18/21] dynamic_debug: trim source-path prefix from dynamic_debug/control
[PATCH 19/21] dynamic_debug: add flags filtering to flags spec handling
[PATCH 20/21] dynamic_debug: clear pending_queries list in remove_all_tables
[PATCH 21/21] dynamic_debug: delete pending queries
