Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0FAKZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:25:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59862 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0FAKZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:25:47 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH v2 0/3] kmemleak: Fix false positive with special scan
Date: Tue,  1 Jun 2010 13:25:08 +0300
Message-Id: <1275387911-13030-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
In-Reply-To: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 01 Jun 2010 10:25:29.0437 (UTC) FILETIME=[C217E0D0:01CB0174]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a false positive case that a pointer is calculated by other
methods than the usual container_of macro. "kmemleak_ignore" can cover
such a false positive, but it would loose the advantage of memory leak
detection. This patch allows kmemleak to work with such false
positives by introducing a new special memory block with a specified
calculation formula. A client module can register its area with a
conversion function, with which function kmemleak scan could calculate
a correct pointer.

For this version 2, to avoid client kernel module being unloaded
before unregistering special conversion, module reference count is
used. This was pointed by Phil Carmody.

A typical use case could be the IOMMU pagetable allocation which
stores pointers to the second level of page tables with some
conversion, for example, a physical address with attribution
bits. Right now I don't have other use cases but I hope that there
could be some that this special scan works with.

Test:

# echo scan > kmemleak
# modprobe kmemleak-special-test
[ 1328.260162] Stored 1024@dfc5ac00 -> 9fc5ac01
[ 1328.264984] Stored 1024@dfc5b800 -> 9fc5b801
[ 1328.269500] Stored 1024@dfc5b400 -> 9fc5b401
[ 1328.273895] Stored 1024@dfc5b000 -> 9fc5b001
[ 1328.278381] Stored 1024@deb9bc00 -> 9eb9bc01
[ 1328.282714] Stored 1024@deea6c00 -> 9eea6c01
[ 1328.287139] Stored 1024@deea7c00 -> 9eea7c01
[ 1328.291473] Stored 1024@deea7800 -> 9eea7801
# echo scan > kmemleak
[ 1344.062591] kmemleak: 8 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
# rmmod kmemleak-special-test
# echo scan > kmemleak
# modprobe kmemleak-special-test timeout=60
[   71.758850] Stored 1024@dfc5b000 -> 9fc5b001
[   71.763702] Stored 1024@dfc5b400 -> 9fc5b401
[   71.768066] Stored 1024@dfc5b800 -> 9fc5b801
[   71.772583] Stored 1024@dfc5bc00 -> 9fc5bc01
[   71.776977] Stored 1024@deea6000 -> 9eea6001
[   71.781341] Stored 1024@deea6400 -> 9eea6401
[   71.785736] Stored 1024@deea6800 -> 9eea6801
[   71.790069] Stored 1024@deea6c00 -> 9eea6c01
[   71.794433] kmemleak_special_init: Registered special scan: bf000360
# echo scan > kmemleak
[   79.588836] custom_conversion: Converted 9fc5b001 -> dfc5b000
[   79.594696] custom_conversion: Converted 9fc5b401 -> dfc5b400
[   79.600494] custom_conversion: Converted 9fc5b801 -> dfc5b800
[   79.606292] custom_conversion: Converted 9fc5bc01 -> dfc5bc00
[   79.612060] custom_conversion: Converted 9eea6001 -> deea6000
[   79.617889] custom_conversion: Converted 9eea6401 -> deea6400
[   79.623687] custom_conversion: Converted 9eea6801 -> deea6800
[   79.629486] custom_conversion: Converted 9eea6c01 -> deea6c00
# rmmod kmemleak-special-test
rmmod: cannot unload 'kmemleak_special_test': Resource temporarily unavailable
# lsmod kmemleak-special-test
Module                  Size  Used by    Not tainted
kmemleak_special_test     1467  1
# [  131.800354] no_special_func: Unregistered special scan bf000360
# lsmod kmemleak-special-test
Module                  Size  Used by    Not tainted
kmemleak_special_test     1467  0
# rmmod kmemleak-special-test


Hiroshi DOYU (3):
  kmemleak: Fix false positives with special scan
  kmemleak: Add special scan test case
  omap iommu: kmemleak: Fix false positive with special scan

 arch/arm/plat-omap/iommu.c |   19 +++++++
 include/linux/kmemleak.h   |    5 ++
 mm/Makefile                |    2 +-
 mm/kmemleak-special-test.c |   94 ++++++++++++++++++++++++++++++++++++
 mm/kmemleak.c              |  114 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 230 insertions(+), 4 deletions(-)
 create mode 100644 mm/kmemleak-special-test.c

