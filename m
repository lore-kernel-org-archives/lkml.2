Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423103Ab2KNQsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:48:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45169 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423064Ab2KNQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:48:13 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC 0/5] perf ui/gtk: Separate out GTK codes to a shared object
Date: Thu, 15 Nov 2012 01:47:39 +0900
Message-Id: <1352911664-24620-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an RFC patchset to separate GTK GUI codes to a shared object,
called libperf-gtk.so and use it with libdl.  It's in an early-stage
so probably has some rough edges, but I'd like to get some comments.

For now, the libperf-gtk.so (I'm open to a better name suggestion)
contains whole libperf.a and libtraceevent.a for simplicity.  And
because of that, every single object in perf tools needs to be built
as a PIC like libtraceevent does.

As a result, library dependency of the perf itself reduced like this:

  $ ldd perf
	linux-vdso.so.1 =>  (0x00007fff375d5000)
	libpthread.so.0 => /lib/libpthread.so.0 (0x00007f75218ef000)
	librt.so.1 => /lib/librt.so.1 (0x00007f75216e7000)
	libelf.so.1 => /usr/lib/libelf.so.1 (0x00007f75214d2000)
	libm.so.6 => /lib/libm.so.6 (0x00007f752124f000)
	libdw.so.1 => /usr/lib/libdw.so.1 (0x00007f752101d000)
	libaudit.so.0 => /lib/libaudit.so.0 (0x00007f7520e02000)
	libnewt.so.0.52 => /usr/lib/libnewt.so.0.52 (0x00007f7520bec000)
	libslang.so.2 => /lib/libslang.so.2 (0x00007f7520888000)
	libperl.so.5.10 => /usr/lib/libperl.so.5.10 (0x00007f752051c000)
	libdl.so.2 => /lib/libdl.so.2 (0x00007f7520318000)
	libc.so.6 => /lib/libc.so.6 (0x00007f751ff92000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f7521b30000)
	libcrypt.so.1 => /lib/libcrypt.so.1 (0x00007f751fd58000)
	libutil.so.1 => /lib/libutil.so.1 (0x00007f751fb55000)
	libpython2.6.so.1.0 => /usr/lib/libpython2.6.so.1.0 (0x00007f751f6a4000)
	libbfd-2.20.1-system.20100303.so => /usr/lib/libbfd-2.20.1-system.20100303.so (0x00007f751f3bd000)
	libbz2.so.1.0 => /lib/libbz2.so.1.0 (0x00007f751f1ac000)
	libz.so.1 => /lib/libz.so.1 (0x00007f751ef95000)
	libssl.so.0.9.8 => /lib/libssl.so.0.9.8 (0x00007f751ed42000)
	libcrypto.so.0.9.8 => /lib/libcrypto.so.0.9.8 (0x00007f751e9b1000)

  $ ldd libperf-gtk.so
	linux-vdso.so.1 =>  (0x00007ffffa1e8000)
	libpthread.so.0 => /lib/libpthread.so.0 (0x00007f82dd32e000)
	librt.so.1 => /lib/librt.so.1 (0x00007f82dd126000)
	libelf.so.1 => /usr/lib/libelf.so.1 (0x00007f82dcf11000)
	libm.so.6 => /lib/libm.so.6 (0x00007f82dcc8e000)
	libdw.so.1 => /usr/lib/libdw.so.1 (0x00007f82dca5c000)
	libaudit.so.0 => /lib/libaudit.so.0 (0x00007f82dc841000)
	libnewt.so.0.52 => /usr/lib/libnewt.so.0.52 (0x00007f82dc62b000)
	libslang.so.2 => /lib/libslang.so.2 (0x00007f82dc2c7000)
	libperl.so.5.10 => /usr/lib/libperl.so.5.10 (0x00007f82dbf5b000)
	libdl.so.2 => /lib/libdl.so.2 (0x00007f82dbd57000)
	libc.so.6 => /lib/libc.so.6 (0x00007f82db9d1000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f82dd8b8000)
	libcrypt.so.1 => /lib/libcrypt.so.1 (0x00007f82db797000)
	libutil.so.1 => /lib/libutil.so.1 (0x00007f82db594000)
	libpython2.6.so.1.0 => /usr/lib/libpython2.6.so.1.0 (0x00007f82db0e3000)
	libbfd-2.20.1-system.20100303.so => /usr/lib/libbfd-2.20.1-system.20100303.so (0x00007f82dadfc000)
	libgtk-x11-2.0.so.0 => /usr/lib/libgtk-x11-2.0.so.0 (0x00007f82da7da000)
	libgdk-x11-2.0.so.0 => /usr/lib/libgdk-x11-2.0.so.0 (0x00007f82da52d000)
	libatk-1.0.so.0 => /usr/lib/libatk-1.0.so.0 (0x00007f82da30b000)
	libgio-2.0.so.0 => /usr/lib/libgio-2.0.so.0 (0x00007f82da058000)
	libpangoft2-1.0.so.0 => /usr/lib/libpangoft2-1.0.so.0 (0x00007f82d9e2e000)
	libgdk_pixbuf-2.0.so.0 => /usr/lib/libgdk_pixbuf-2.0.so.0 (0x00007f82d9c11000)
	libpangocairo-1.0.so.0 => /usr/lib/libpangocairo-1.0.so.0 (0x00007f82d9a04000)
	libcairo.so.2 => /usr/lib/libcairo.so.2 (0x00007f82d9781000)
	libpango-1.0.so.0 => /usr/lib/libpango-1.0.so.0 (0x00007f82d9536000)
	libfreetype.so.6 => /usr/lib/libfreetype.so.6 (0x00007f82d92b0000)
	libfontconfig.so.1 => /usr/lib/libfontconfig.so.1 (0x00007f82d907b000)
	libgobject-2.0.so.0 => /usr/lib/libgobject-2.0.so.0 (0x00007f82d8e32000)
	libgmodule-2.0.so.0 => /usr/lib/libgmodule-2.0.so.0 (0x00007f82d8c2e000)
	libgthread-2.0.so.0 => /usr/lib/libgthread-2.0.so.0 (0x00007f82d8a29000)
	libglib-2.0.so.0 => /lib/libglib-2.0.so.0 (0x00007f82d874a000)
	libbz2.so.1.0 => /lib/libbz2.so.1.0 (0x00007f82d8539000)
	libz.so.1 => /lib/libz.so.1 (0x00007f82d8322000)
	libssl.so.0.9.8 => /lib/libssl.so.0.9.8 (0x00007f82d80cf000)
	libcrypto.so.0.9.8 => /lib/libcrypto.so.0.9.8 (0x00007f82d7d3e000)
	libXext.so.6 => /usr/lib/libXext.so.6 (0x00007f82d7b2b000)
	libXrender.so.1 => /usr/lib/libXrender.so.1 (0x00007f82d7921000)
	libXi.so.6 => /usr/lib/libXi.so.6 (0x00007f82d750d000)
	libXrandr.so.2 => /usr/lib/libXrandr.so.2 (0x00007f82d7304000)
	libXcursor.so.1 => /usr/lib/libXcursor.so.1 (0x00007f82d70fa000)
	libX11.so.6 => /usr/lib/libX11.so.6 (0x00007f82d6dc3000)
	libXcomposite.so.1 => /usr/lib/libXcomposite.so.1 (0x00007f82d6bc0000)
	libXdamage.so.1 => /usr/lib/libXdamage.so.1 (0x00007f82d69bd000)
	libXfixes.so.3 => /usr/lib/libXfixes.so.3 (0x00007f82d67b6000)
	libpcre.so.3 => /lib/libpcre.so.3 (0x00007f82d6588000)
	libresolv.so.2 => /lib/libresolv.so.2 (0x00007f82d636e000)
	libselinux.so.1 => /lib/libselinux.so.1 (0x00007f82d6150000)
	libpixman-1.so.0 => /usr/lib/libpixman-1.so.0 (0x00007f82d5ef6000)
	libdirectfb-1.2.so.0 => /usr/lib/libdirectfb-1.2.so.0 (0x00007f82d5c73000)
	libfusion-1.2.so.0 => /usr/lib/libfusion-1.2.so.0 (0x00007f82d5a69000)
	libdirect-1.2.so.0 => /usr/lib/libdirect-1.2.so.0 (0x00007f82d584f000)
	libpng12.so.0 => /lib/libpng12.so.0 (0x00007f82d5628000)
	libxcb-render-util.so.0 => /usr/lib/libxcb-render-util.so.0 (0x00007f82d5424000)
	libxcb-render.so.0 => /usr/lib/libxcb-render.so.0 (0x00007f82d521a000)
	libxcb.so.1 => /usr/lib/libxcb.so.1 (0x00007f82d4ffe000)
	libexpat.so.1 => /lib/libexpat.so.1 (0x00007f82d4dd4000)
	libXau.so.6 => /usr/lib/libXau.so.6 (0x00007f82d4bcf000)
	libXdmcp.so.6 => /usr/lib/libXdmcp.so.6 (0x00007f82d49c9000)

To run GTK report browser, you can do it with usual --gtk option but
you might need to setup LD_LIBRARY_PATH.

  $ LD_LIBRARY_PATH=$PWD ./perf report --gtk

Missing LD_LIBRARY_PATH will lead to a fallback TUI or stdio (for 
NO_NEWT=1 build) report browser.

Patch 0001 is a resend version of my previous series, and
Patch 0002 is a preparation for smooth transition to libperf-gtk.so.
Patch 0003-0005 separate out the libperf-gtk.so and use it with libdl.

You can get this at my perf/separate branch:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/separate-v1

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (5):
  perf ui: Always compile error printing code
  perf ui/helpline: Introduce ui_helpline__vshow()
  perf tools: Separate out GTK codes to libperf-gtk.so
  perf tools: Setup GTK browser dynamically
  perf report: Run dynamic loaded GTK browser

 tools/perf/Makefile          |   49 +++++++++++++++++++++++-----------------
 tools/perf/builtin-report.c  |   16 ++++++++++---
 tools/perf/ui/gtk/gtk.h      |    8 +++++++
 tools/perf/ui/gtk/helpline.c |   23 ++++++++++---------
 tools/perf/ui/helpline.c     |   12 ++++++++++
 tools/perf/ui/helpline.h     |   22 ++----------------
 tools/perf/ui/setup.c        |   51 ++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/tui/helpline.c |   29 ++++++++++++------------
 tools/perf/ui/ui.h           |   12 +---------
 tools/perf/ui/util.c         |   10 +++++++++
 tools/perf/util/debug.c      |   28 ++---------------------
 tools/perf/util/debug.h      |   33 ++-------------------------
 tools/perf/util/hist.h       |   13 -----------
 13 files changed, 154 insertions(+), 152 deletions(-)

-- 
1.7.9.2

