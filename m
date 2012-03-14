Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2CNXC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:02:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62306 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2CNXC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:28 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [00/11] pr_debug during module initialization
Date: Wed, 14 Mar 2012 17:01:55 -0600
Message-Id: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is 3rd revision of the dyndbg modinit patches, previously sent
Dec 11.  Patches 1-17/25 sent then were added to driver-core-next,
this set reworks the remainder.

It implements the "fake" module param approach proposed by
Thomas Renninger, back in https://lkml.org/lkml/2010/9/15/397

This set is on top of linux-next, since that includes Pawel Moll's
initcall-level params patch.  Im not using this feature, but I didnt
know that when I started.

Rusty Russell did a partial review of 2nd rev (sent off-list), here:
http://thread.gmane.org/gmane.linux.kernel/1262934
This revision incorporates my understanding of his feedback.

Core of patchset is 2 callbacks, called from parse_args:

For builtin modules, dynamic_debug_init() calls parse_args(...,
&ddebug_dyndbg_boot_param_cb) to handle dyndbg and $module.dyndbg
params.  For loadable modules, load_module() calls parse_args(...,
&ddebug_dyndbg_module_param_cb) to handle dyndbg args given by
modprobe.  Both callbacks call ddebug_exec_queries() to activate the
specified pr_debug callsites.

0001-init-trivial-tweaks-to-initcall_levels.patch
This adds pr_info for each initcall-level, yielding 7 lines in dmesg
like:
  initlevel:6=device, 172 registered initcalls

I dropped the pr_debug added in 2nd rev, which was noisy and not
useful, init_debug provides similar info and more.  This patch is
decoration only, and can be dropped.

0002-dynamic_debug-fix-leading-spaces.patch
whitespace

0003-dynamic_debug-replace-if-verbose-pr_info-with-macro-.patch
I should have done this previously.  Ive disregarded a complaint about
wrapping complex macro args in (), since theres plenty of similar code
in include/*

0004-dynamic_debug-change-ddebug_query-core-param-to-dynd.patch
Change "ddebug_query" to "dyndbg", to match new $module.dyndbg added
by this patchset.

0005-params-add-param-name-to-parse_one-s-pr_debug.patch
Current message doesnt ID the param name being handled.

0006-params-add-3rd-arg-to-option-handler-callback-signat.patch
Add "doing" to lower levels of param handling callchain, supplying it
to callback added next.

0007-dynamic_debug-make-dynamic-debug-work-during-module-.patch
main patch of set.

0008-pnp-if-CONFIG_DYNAMIC_DEBUG-use-pnp.dyndbg-instead-o.patch
Adjust pnp for CONFIG_PNP_DEBUG_MESSAGES.  Unchanged since Dec 11th

0009-dynamic_debug-add-modname-arg-to-exec_query-callchai.patch
This allows parsing $modname.dyndbg=" func foo +p ; func bar +p"
without repeating "module $modname" 2x in the value

0010-dynamic_debug-update-Documentation-Kconfig.debug.patch
This gets a checkpatch complaint because of long lines in which I
tweaked flags.  I chose to disregard this cuz the lines show real
output for ~out-of-tree code.

0011-dynamic_debug-init-with-core_initcall-not-arch_initc.patch
This works-for-me, but may be broken on some arches I dont have to
test on.  I dont know why original design used arch_initcall, perhaps
constraints have changed.  I also tested with early_initcall, that
also worked.

