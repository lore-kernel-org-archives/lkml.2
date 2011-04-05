Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1DERWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:22:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32969 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DERWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=XkTV7F9e8fn96Xt9ECJuLtLdpnnkoaOG5r7uCQ2ad6eWJtITspxawoaO3lnDxc8Yax
         fReb6orXiRIUnMO2xk2KXydZsZOQnk+HWw/qfOEZ1HztLHjppMq4vXnebLczQEz948Y4
         S4WZdRJW0Jq7a/1A1jlWn7NlpSf8u3lM61ivI=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] Speed up the symbols' resolution process V2
Date: Tue,  5 Apr 2011 19:22:25 +0200
Message-Id: <1302024146-2608-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of this patch is to speed up the symbols' resolution process.

This objective is achieved by sorting all ksymtab* and kcrctab* symbols
(those which reside both in the kernel and in the modules) and thus add the fast
binary search side by side to the usual slow linear search.

To avoid adding lots of code for symbols sorting I rely on the linker which can
easily do the job thanks to a little trick. The trick isn't really beautiful to
see but permits minimal changes to the code and build process. Indeed the patch
is very simple and short.

In the first place I changed the code for place every symbol in a different
section (for example: "___ksymtab" sec "__" #sym) at compile time (this the
above mentioned trick!). Thus I request to the linker to sort and merge all
these sections into the appropriate ones (for example: "__ksymtab") at link
time using the linker scripts. Once all symbols are sorted we can use binary
search instead of the linear one (enabling CONFIG_SYMBOLS_BSEARCH).

I'm fairly sure that this is a good speed improvement even though I haven't
made any comprehensive benchmarking (but follow a simple one). In any case
I would be very happy to receive suggestions about how made it. Collaterally,
the boot time should be reduced also (proportionally to the number of modules
and symbols nvolved at boot stage).

I hope that you find that interesting!

This work was supported by a hardware donation from the CE Linux Forum.

Changes since V1:
*) Merge all patches into only one
*) Remove few useless things
*) Introduce CONFIG_SYMBOLS_BSEARCH kernel option 

Using ftrace on each_symbol() function I obtained these values:

Ubuntu       	Vanilla   	 Patched
 34.792 us 	 19.928 us 	9.561 us
104.418 us 	 43.831 us 	4.018 us
 23.075 us 	  9.700 us	2.667 us
 40.798 us 	 15.495 us 	2.534 us
 48.106 us 	  7.658 us	3.219 us
 10.162 us 	  4.144 us	2.895 us
 27.939 us 	 12.624 us 	2.024 us
 39.885 us 	 16.618 us 	1.952 us
 28.419 us 	 12.751 us 	1.760 us
  9.561 us	  4.108 us	1.394 us
 12.744 us 	  4.907 us	1.243 us
 10.342 us 	  4.504 us	2.408 us
 15.435 us 	  6.036 us	2.210 us
  6.456 us	 10.414 us 	1.556 us
 25.807 us 	  5.994 us	2.798 us
 14.654 us 	  6.408 us	2.438 us
 16.150 us 	  1.165 us	2.114 us
  2.534 us	  8.979 us	1.561 us
 22.017 us 	  1.322 us	1.820 us
  2.894 us	 36.035 us 	2.583 us
 95.607 us 	 13.260 us 	1.735 us
 29.657 us 	  4.571 us	1.652 us
 11.778 us 	  1.994 us	2.247 us
  4.498 us	 34.606 us 	1.400 us
 92.022 us 	 36.834 us 	1.664 us
 97.145 us 	  6.696 us	2.840 us
 16.847 us 	  9.417 us	2.486 us
 23.105 us 	 11.099 us 	1.682 us
 27.969 us 	 38.576 us 	1.375 us
100.581 us    	  4.991 us	2.594 us
 12.756 us 	 14.348 us 	1.585 us
 37.309 us 	 37.350 us 	1.717 us
 97.776 us 	  9.657 us	1.297 us
 23.634 us 	  6.612 us	2.072 us
 17.387 us 	 38.791 us 	1.892 us
100.028 us 	 10.300 us 	1.898 us
 25.098 us 	  3.994 us	2.252 us
  9.934 us	 12.048 us 	1.640 us
 28.816 us 	 11.417 us 	1.237 us
 28.407 us 	 38.395 us 	1.459 us
100.057 us 	  7.057 us	2.066 us
 16.396 us 	 38.822 us 	1.183 us
 99.787 us 	 19.153 us 	1.850 us
  7.033 us	 15.862 us 	1.484 us
 44.341 us 	  7.976 us	1.711 us
 41.495 us 	  6.480 us	1.897 us
 19.129 us 	160.435 us 	1.542 us 
 16.498 us 	141.246 us 	0.426 us 
418.032 us 	193.275 us 	10.000 us
402.255 us 	141.780 us 	10.042 us 
408.038 us 	142.243 us 	9.796 us
404.957 us 	142.278 us 	9.759 us
438.656 us 	142.261 us 	9.729 us
399.666 us 	141.978 us 	9.693 us
403.588 us 	142.255 us 	9.694 us
394.987 us 	142.255 us 	9.700 us
404.386 us 	142.242 us 	9.718 us
398.861 us 	142.237 us 	9.735 us
389.197 us 	142.237 us 	9.729 us
401.053 us 	142.273 us 	9.772 us
393.696 us 	142.267 us 	9.730 us
442.008 us 	142.255 us 	9.801 us
398.495 us 	142.254 us 	9.699 us
396.645 us 	142.249 us 	9.711 us
399.474 us 	142.243 us 	9.688 us
400.327 us 	142.399 us 	9.694 us
399.023 us 	142.267 us 	9.718 us
397.588 us 	142.249 us 	9.687 us
397.960 us 	142.254 us 	9.699 us
398.147 us 	142.237 us 	9.724 us
397.065 us 	142.297 us 	9.718 us
442.193 us 	142.248 us 	9.700 us
396.555 us 	142.249 us 	9.747 us
402.158 us 	142.261 us 	9.705 us
399.072 us 	142.254 us 	9.724 us
400.074 us 	158.050 us 	9.730 us
396.928 us 	142.567 us 	9.723 us
395.666 us 	142.260 us 	9.837 us

Ubuntu  kernel 2.6.38-7-generic 3306 modules
Vanilla kernel 2.6.38 42 modules
Patched kernel 2.6.38 42 modules

Alessio Igor Bogani (1):
  module: Use the binary search for symbols resolution

 include/asm-generic/vmlinux.lds.h |   43 +++++++++++++++++++++------
 include/linux/module.h            |   12 ++++++-
 init/Kconfig                      |    7 ++++
 kernel/module.c                   |   57 +++++++++++++++++++++++++-----------
 scripts/module-common.lds         |   11 +++++++
 5 files changed, 100 insertions(+), 30 deletions(-)

-- 
1.7.4.1

