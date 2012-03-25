Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2CYX0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:26:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab2CYX0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:13 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [00/16] enable pr_debug during module initialization
Date: Sun, 25 Mar 2012 17:25:38 -0600
Message-Id: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is 4th revision of the dyndbg modinit patches, implementing the
"fake" module param approach proposed by Thomas Renninger, back in
https://lkml.org/lkml/2010/9/15/397

rev1.1:
stored queries for loadable modules on pending list
http://lkml.indiana.edu/hypermail/linux/kernel/1107.3/00627.html

rev2: http://thread.gmane.org/gmane.linux.kernel/1262934

changes since rev2:

- rev2 Patches 1-17/25 sent Dec 11 were added to driver-core-next,
  subsequent revs rework 18-25, renumbered.

- reworked onto linux-next, to include Pawel Moll's initcall-level
  params patch.  Im not using this feature, but I didnt know that when
  I started.

- dropped "protect dyndbg, BUILD_BUG_DECL", which caused compile err
  if module author added his own dyndbg param declaration, Rusty said:
  "if dev added it, he probably meant it"

- dropped noisy pr_* in initcall_level stuff, per Rusty.

rev3:
https://lkml.org/lkml/2012/3/14/469
changes since:
- added comment, commit-msg explaining repeat use of parse-args.
- deprecate "ddebug_query=" rather than remove it.
- refactor 2 callbacks to use common helper.
- more aggressive early_initcall, not core_initcall  RFC
- debugfs init via fs_initcall, not module_init      RFC


Core of patchset is 2 callbacks, called from parse_args:

For builtin modules, dynamic_debug_init() calls parse_args(...,
&ddebug_dyndbg_boot_param_cb) to handle dyndbg and $module.dyndbg
params.  For loadable modules, load_module() calls parse_args(),
passing &ddebug_dyndbg_module_param_cb to handle dyndbg args given by
modprobe.  

Callbacks get extra arg, which is either modulename or "Booting
Kernel" as passed by start_kernel to parse_args().  The arg allows
foo.dyndbg="func bar +p; func buz +p" to exclude the "module foo" 2x,
saving space in the limited cmdline buffers.  Both callbacks call
ddebug_exec_queries() to activate the specified pr_debug callsites.


0001-init-trivial-tweaks-to-initcall_levels.patch
This adds pr_info for each initcall-level, yielding 7 lines in dmesg
like:
  initlevel:6=device, 172 registered initcalls

I dropped the pr_debug added in 2nd rev, which was noisy and not
useful, init_debug provides similar info and more.  This patch is
decoration only, and can be dropped.

0002-dynamic_debug-fix-leading-spaces.patch
whitespace cleanup

0003-dynamic_debug-replace-if-verbose-pr_info-with-macro-.patch
I should have done this previously.  Ive disregarded a checkpatch
complaint about wrapping complex macro args in (), since theres plenty
of similar code in include/*, and a couple attempts to add them
failed.

0004-dynamic_debug-change-ddebug_query-core-param-to-dynd.patch
Change "ddebug_query" to "dyndbg", to match new $module.dyndbg added
by this patchset.

0005-params-add-param-name-to-parse_one-s-pr_debug.patch
Current message doesnt name the param being handled.

0006-params-add-3rd-arg-to-option-handler-callback-signat.patch
Add "doing" to lower levels of param handling callchain, supplying it
to callback added next.

0007-dynamic_debug-make-dynamic-debug-work-during-module-.patch
add 2 callbacks to parse dydnbg, module.dyndbg params.
main patch of set.

0008-dynamic_debug-deprecate-ddebug_query-suggest-dyndbg-.patch
adds entry to feature-removal-schedule,
and warning when ddebug_query is used.

0009-dynamic_debug-combine-parse_args-callbacks-together.patch
refactor 2 callbacks, add single helper.

0010-dynamic_debug-simplify-dynamic_debug_init-error-exit.patch
add return 0 above goto error target, move non-err code above it.

0011-dynamic_debug-print-ram-usage-by-ddebug-tables-if-ve.patch
show ram usage due to CONFIG_DYNAMIC_DEBUG.

0012-pnp-if-CONFIG_DYNAMIC_DEBUG-use-pnp.dyndbg-instead-o.patch
Adjust pnp for CONFIG_PNP_DEBUG_MESSAGES.  Unchanged since Dec 11th

0013-dynamic_debug-add-modname-arg-to-exec_query-callchai.patch
This allows parsing $modname.dyndbg=" func foo +p ; func bar +p"
without repeating "module $modname" 2x in the value

0014-dynamic_debug-update-Documentation-Kconfig.debug.patch
This gets a checkpatch complaint because of long lines in which I
tweaked flags.  I chose to disregard this cuz the lines show real
output for ~out-of-tree code.

0015-dynamic_debug-init-with-early_initcall-not-arch_initc.patch
change arch_initcall to early_initcall, and module_init to fs_initcall.
This works-for-me, but may be broken on some arches I dont have to
test on.  I dont know why original design used arch_initcall, perhaps
constraints have changed. 

0016-dynamic_debug-drop-deprecated-ddebug_query-param-cod.patch
Dont apply til v3.6 or v3.7

thanks
Jim Cromie

