Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1BYHzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:55:48 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62038 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1BYHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:55:47 -0500
Message-ID: <4D676067.8050200@ce.jp.nec.com>
Date: Fri, 25 Feb 2011 16:55:19 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] Fix mapping->writeback_index to point to the last written
 page
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For range-cyclic writeback (e.g. kupdate), the writeback code sets
a continuation point of the next writeback to mapping->writeback_index.

Current code sets the page next to the last written page.
I think it's intended for sequential writer.
However, in many cases, sequential writer is writing in the middle of the page
and it just redirties the last written page by continuing from that.

So the next writeback should try to continue from the last written page,
not the next one.
(If it's clean because the writer was on the page boundary,
 pagevec_lookup_tag just skips it. So no problem.)

Otherwise, the last written page was left dirty until the writeback
wraps around.

I.e. if the sequential dirtier has written on pagecache as '*'s below:

   |*******|*******|****---|-------|-------|     ( |---| is a page )

then, writeback happens:

   |-------|-------|-------|-------|-------|

and the dirtier continues:

   |-------|-------|----***|*******|*****--|
                   A       B

Next writeback should start from page A, not B.

As an exceptional case, when I/O error happens, set done_index to
the next page as the comment in the code suggests.


    Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2cb01f6..beae3ed 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -927,7 +927,7 @@ retry:
 				break;
 			}
 
-			done_index = page->index + 1;
+			done_index = page->index;
 
 			lock_page(page);
 
@@ -977,6 +977,7 @@ continue_unlock:
 					 * not be suitable for data integrity
 					 * writeout).
 					 */
+					done_index = page->index + 1;
 					done = 1;
 					break;
 				}
