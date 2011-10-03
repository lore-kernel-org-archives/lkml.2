Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1JCLrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:47:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64431 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1JCLrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:47:08 -0400
MIME-Version: 1.0
Date: Mon, 3 Oct 2011 17:16:15 +0530
Message-ID: <CADDb1s3Ab18ppaDKeRYMnX9TSb_kHaj4T1wUA=FeNUjpxF2cRw@mail.gmail.com>
Subject: UDF: alternate anchor block detection
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While mounting UDF media, when the primary AVDP is not found at block
256, UDF code tries to read-in the alternate AVDP.
In the function udf_find_anchor, udf_scan_anchors is called 3 times,
where each call to udf_scan_anchors read 12 blocks.
In case there is no alternate AVDP stored, a total of 36 blocks are
read before mount fails - causing time delay for Mount Failure.

1) After first call to udf_scan_anchors and before the second call
there is varconv conversion, for the older drivers, which skips 7
blocks after every 32 blocks. What are these older drivers? Do we
still require this code?

2) After varconv conversion, why is there a third call to
udf_scan_anchors? In the 1st call and 3rd call to udf_scan_anchors,
exactly same blocks are read, so this 3rd call seems to be redundant.

I suggest this modified code for udf_find_anchor :-
lastblock = udf_scan_anchors(sb,udf_variable_to_fixed(sbi->s_last_block),fileset);
        if (lastblock)
                goto out;
         else {
                /* VARCONV didn't help. Clear it. */
                UDF_CLEAR_FLAG(sb, UDF_FLAG_VARCONV);
                return 0;
        }

Please share your opinion to the above '2' points.


Thanks & Regards,
Amit Sahrawat
