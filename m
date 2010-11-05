Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0KEXYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:24:01 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:59728 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab0KEXYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:24:00 -0400
X-Greylist: delayed 1586 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 19:24:00 EDT
Message-ID: <4CD48BDA.9020102@ispras.ru>
Date: Sat, 06 Nov 2010 01:57:30 +0300
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/range: Fix clean_sort_range for the case of full array
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean_sort_range() should return a number of nonempty elements of range 
array, but if the array is full clean_sort_range() returns 0.

The problem is that the number of nonempty elements is evaluated by 
finding the first empty element of the array. If there is no such 
element it returns an initial value of local variable nr_range that is zero.

The fix is trivial: it changes initial value of nr_range to size of the 
array.

The bug can lead to loss of information regarding all ranges, since 
typically returned value of clean_sort_range() is considered as an 
actual number of ranges in the array after a series of add/subtract 
operations.


Found by Analytical Verification project of Linux Verification Center 
(linuxtesting.org), thanks to Alexander Kolosov.


Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---

diff --git a/kernel/range.c b/kernel/range.c
index 471b66a..37fa9b9 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -119,7 +119,7 @@ static int cmp_range(const void *x1, const void *x2)

  int clean_sort_range(struct range *range, int az)
  {
-       int i, j, k = az - 1, nr_range = 0;
+       int i, j, k = az - 1, nr_range = az;

         for (i = 0; i < k; i++) {
                 if (range[i].end)

