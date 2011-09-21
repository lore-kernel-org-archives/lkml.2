Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1IUVzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:55:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1IUVzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:55:45 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: 
Date: Wed, 21 Sep 2011 15:54:49 -0600
Message-Id: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

this reworked* patchset enhances dynamic-debug with:

- multiple queries on bootline, via ddebug_query='"...", formerly just
  1 query was accepted.  This also allows cat foo-queries > $CONTROL
  to add numerous rules together.

- tolerance to errors in ddebug_query.  Formerly, a bad rule would
  kill the facility, now it stays up, you can correct the rule without
  rebooting.

- pending queries.  bootline can enable pr_debugs in an uninstalled
  module, by adding 'a' flag. When module is loaded later, pr_debug
  callsites are enabled, before module-init is run, so pr_debug can be
  used in module-init.  Currently pending queries are readable in
  $DBGMT/dynamic_debug/pending

- filter flags.  flags before the operator [+-=] are used to narrow
  selection of callsites.  This augments module, filename, function
  filters, allowing:

echo p+t > $CONTROL  # add TID to ALL enabled sites
echo ml+p > $CONTROL # enable sites marked earlier.

- src-dir relative paths in $CONTROL.  Formerly, filenames were
  printed with full path, and new rules had to use full path if
  basename wasnt enough.  Now theyre printed with relative paths, and
  relative paths are accepted when writing new rules.

Minor things

- added warn if >1 function, filename, module filter is used.  also
fix a pr_err() conditional on verbose.

- '_' (empty) flag added.  $CONTROL now says '=_' for disabled
  callsites, so your grep command can be more selective than '='

- printing is enabled by p flag only, formerly any flag enabled
callsite.  this fix is needed for filter-flags as described above.

- dynamic debug supercedes DEBUG - Formerly ddebug couldnt control
  callsites when module had DEBUG 1, now it can.  DEBUG 1 now enables
  callsites by default, but you can turn them off.

- shrink _ddebug.lineno:24 to 18
  lineno:24 allows 16G-lines files to be 'pr_debug'd, which is silly.
  Largest in tree is 29k-lines, future additions that large are
  *unlikely*.  Even allowing for out-of-tree machine-generated code
  (which shouldnt need ddebug, right? ;-), 256k-lines should be
  enough.

- pr_fmt_dbg() - like pr_fmt(), but used in dynamic_pr_debug().
  Allows independent control of the prefix-text added by pr_debug vs
  pr_info and others.  TBD - Joe Perches had issues with this, maybe
  addressed here.  Its also at end of set, so can be trivially
  excluded from upstream.

- internal ddebug verbosity - this modparam enables several levels of
  internal debugging.  Previous patchsets used the ddebug facilities
  within ddebug (eat your own dogfood) but that was deemed too
  aggressive.

Future additions.

- user flags: If we can free up extra bits (32bit is currently tight),
  adding user-flags (say: x,y,z) would let users mark groups of
  callsites, then enable and disable them in a single operation:

echo module foo +x > $CONTROL
echo module bar +x > $CONTROL
...
echo x+p > $CONTROL


Breakdown:
1-15    prep, cleanups, minor things
16-23   major enhancements, doc
24-26   non-essentials, worth considering, discussing.


If you like, you can also get it from github,
git://github.com/jimc/linux-2.6.git  dyndbg/on-driver-core

This is a clone of GregKH's driver-core tree, circa -rc3,
which includes 8/12 of Jason Barons dynamic-debug patches.
Ive added Jason's last 4/12, and my 26 patches.


thanks
Jim Cromie


