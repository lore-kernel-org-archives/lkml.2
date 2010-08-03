Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0HCLt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:49:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52237 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab0HCLs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:48:58 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, kernel-team@lists.ubuntu.com,
        Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Subject: [PATCH 0/2] perf: symbol offset breakage with separated debug
Date: Tue,  3 Aug 2010 12:48:34 +0100
Message-Id: <1280836116-6654-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've hit some problems in trying to get perf record/report to
work correctly on systems with separated debug images (Ubuntu,
in particular).  I worked on some patches to ensure that
separate debug images do actually get loaded, when present --
these commits have now been merged in linux-2.6-tip/master.
(See below for a list of the commits.)

Now that these are in place, I'm observing a new problem which
can mess up symbol locations -- though I think there might be a
practical workaround, I can't see a trivial solution, so I'm
keen to hear if anyone has any ideas.


The problem:

perf makes some incorrect assumptions, which mean that the
symbol locations seen by perf report and friends can be
incorrect.

My analysis:

	a) perf represents symbols as offsets from the start of
		the mmap'd code region which contains each
		symbol.

	b) For shared libs (ET_DYN objects), the desired offset
		is (usually) equal to the VMA of each given
		symbol in the image.  Perf assumes that these
		offsets are always equal, and this normally
		works.

		Atypical link configurations could cause this
		to fail, but this would probably be unusual in
		the real world.

	c) For executables (ET_EXEC objects), the desired
		offset is:

	st_addr - (mmap_start + sh_offset - mmap_offset)

		Where st_addr is the symbol VMA, sh_offset is
		the offset of the parent *section* (not
		segment) from the start of the image,
		mmap_start is the base VMA of the corresponding
		mmap'd *segment* (or part of a segment) in
		memory, and mmap_offset is the file offset at
		which the mapping starts (as in mmap(2))

		(As a minor note, the pgoff field in the perf
		mmap event data (from which mmap_offset should
		be deducible) is probably also incorrect at
		present -- see snippet from util/event.c
		below.)

	d) perf assumes that the above is equivalent to:

	st_addr - (sh_addr - sh_offset)

		Where sh_addr is the VMA of the start of the
		symbol's parent section.

		This is true only given certain assumptions,
		namely that each symbol's parent section is
		mapped in such a way that mmap_offset is zero.
		In practice, this is true for the main
		executable segment of ET_EXEC images in typical
		link configurations (i.e., using the default
		GNU ld scripts).

	e) The assumptions in (d) break down when using
		separated debug images, because although
		separated debug images contain faithful VMA
		information, the image is stripped of loadable
		sections' contents, resulting in radically
		different sh_offset values from the "real"
		image.

		Because sh_offset bears no relationship to the
		layout of the data mmap'd at runtime, this
		produces bogus symbol adjustments which results
		in the wrong symbol offsets (a) being
		calculated.


Solutions:

(e) needs to be solved in order for perf report etc. to produce
sensible output when using separated debug images.

I think that a comprehensive solution should also fix the
assumptions in (b) and (d) so that any valid ELF images will be
processed correctly.


Solving (e) doesn't appear trivial, since it requires section
layout information from the image that was mmap'd at _runtime_
to be correlated with the symbol information collected maybe
from other files at _report_ time.  Currently, runtime and
report time are treated rather separately, so this isn't
straightforward to achieve.

A simple workaround in the meantime would be to assume that
.text is mmap'd with mmap_offset=0 for ET_EXEC images, and fix
the adjustment calculation appropriately.  This is not a full
fix but is probably worth doing if (as I guess) it gets the
tools working correctly in the common case: see

[PATCH 2/2] perf symbols: work around incorrect ET_EXEC symbol adjustment

-------------------------------------------------------------------------------

My current list of patches in linux-2.6-tip/master:

commit 6da80ce8c43ddda153208cbb46b75290cf566fac
    perf symbols: Improve debug image search when loading symbols
commit 8b1389ef93b36621c6acdeb623bd85aee3c405c9
    perf tools: remove extra build-id check factored into dso__load
commit 21916c380d93ab59d6d07ee198fb31c8f1338e26
    perf tools: Factor out buildid reading and make it implicit in dso__load
commit 88ca895dd4e0e64ebd942adb7925fa60ca5b2a98
    perf tools: Remove unneeded code for tracking the cwd in perf sessions
commit 361d13462585474267a0c41e956f1a1c19a93f17
    perf report: Don't abbreviate file paths relative to the cwd


Illustrative code snippets (from v2.6.35):

util/symbol.c:

968:static int dso__load_sym(struct dso *self, struct map *map, const char *name,
969:			 int fd, symbol_filter_t filter, int kmodule,
970:			 int want_symtab)
971:{
	[...]
1055:	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
1133:		if (curr_dso->adjust_symbols) {
	[...]
1134:			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
1135:				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
1136:				  (u64)sym.st_value, (u64)shdr.sh_addr,
1137:				  (u64)shdr.sh_offset);
1138:			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
1139:		}

Probable incorrect symbol adjustment which currently gets used
for ET_EXEC images.  Explanation above.


util/event.c:

109:static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
110:					 event__handler_t process,
111:					 struct perf_session *session)
112:{
	[...]
153:		if (*pbf == 'x') { /* vm_exec */
	[...]
166:			/* pgoff is in bytes, not pages */
167:			if (n >= 0)
168:				ev.mmap.pgoff = vm_pgoff << getpagesize();
169:			else
170:				ev.mmap.pgoff = 0;

Unless I've misunderstood, getpagesize(2) returns the size in
bytes of a page; in this case using it as a shift count is
wrong.

Also, the code appears to be trying to convert a page count
into an address for storage in the profile data.  This would
mean that when interpreting the data, knowledge of the page
size is not needed.  However, since I can't see any code which
actually uses the pgoff information from the profile data, I'm
not sure whether this was the intention.

In any case, the offset field from /proc/*/maps is already a
byte count, not a page offset, so it does not look necessary to
do convert it at all.

See [PATCH 1/2] perf events: Fix mmap offset determination.

Dave Martin (2):
  perf events: Fix mmap offset determination
  perf symbols: work around incorrect ET_EXEC symbol adjustment

 tools/perf/util/event.c  |    8 +-------
 tools/perf/util/symbol.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 8 deletions(-)

