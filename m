Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2DHWic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:38:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63241 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2DHWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:38:31 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [00/02] add BUILD_BUG_DECL assertion (for 3.4??)
Date: Sun,  8 Apr 2012 16:38:16 -0600
Message-Id: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


0001-bug.h-add-BUILD_BUG_DECL-usable-at-file-scope.patch
0002-bug.h-add-test-demo-module.patch (DONT APPLY)

this patch (0001) adds new bug.h macro, BUILD_BUG_DECL(name, cond),
which unlike other *BUG* assertions is usable at file scope.  Its
primary purpose is to enforce identical sizes of 2 separate arrays,
which but for considerations of packing/padding/section, would be
together in a struct.

const char const *names[] = { "bart", "lisa", "homer", "marge" };
int a[] = {1,2,3,4};
int b[] = {1,2,3,5};
long d[] = {1,2};

BUILD_BUG_DECL(foo, ARRAY_SIZE(a) != ARRAY_SIZE(b));
BUILD_BUG_DECL(buz, sizeof(a) != sizeof(b));	// good
BUILD_BUG_DECL(a, sizeof(a) != sizeof(d));	// ok on x32, error x64
BUILD_BUG_DECL(b, ARRAY_SIZE(a) != ARRAY_SIZE(names));	// good

macro expands as:
static __attribute__ ((__section__(".init.data"))) struct {
       int BUILD_BUG_DECL_buz[1 - 2*!!(sizeof(a) != sizeof(b))];
} BUILD_BUG_DECL_buz[0] __attribute__((unused));



I wanted to ask for this in 3.4, but see CAVEATS

= its low risk (famous last words)

= has many immediate bug-prevention applications

For example (perhaps a bad one, I only eyeballed the tables
themselves): in drivers/net/wireless/b43/tables_lpphy.c, these 2
tables are the same size.  Should that be enforced ??

  static const u16 lpphy_rev0_ofdm_cck_gain_table[] = {...}
  static const u16 lpphy_rev1_ofdm_cck_gain_table[] = {...}

Whether or not this example is appropriate, I think its tautological
that there are pairs of arrays in the code that must match on length
for proper operation; this would enforce them, with trivial patches.

= other *BUG* assertions use do{}while, so they cant work at file scope.

BUILD_BUG_DECL is declarative, so it does work at file scope.  It
declares an unused 0 length array in __initdata, so shouldnt create
storage.

I sent a similar patch previously as part of dynamic-debug patches,
Jason Baron liked it, Rusty Russell thought it was redundant and not
neccessary in that context.  I dont think I adequately explained (or
even mentioned) the file-scope aspect.  Im not cc'g them, theyre both
*busy* atm.

CAVEATS

Macro includes __attribute__((unused)), but it seems ineffective.  I
also tried deref, but compiler (cc (GCC) 4.6.3 20120306 (Red Hat
4.6.3-2)) warned about it, so I yanked it.

Macro does seem to create storage, so I put it in __initdata.
However, referencing it from a non--init function doesnt give a
compiler warning.  Further, calling that function after boot gives a
paging-request error, and traceback.  See patch 0002.

IIUC, this is expected, since __initdata has been dropped after boot
is complete.  What I dont get is why the compiler allowed the
references; I've seen __initdata/section warnings for similar problems
in the past.


thanks
Jim Cromie
