Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953Ab2LHFE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:04:27 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50810 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2LHFE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:04:26 -0500
MIME-Version: 1.0
Date: Sat, 8 Dec 2012 18:04:25 +1300
Message-ID: <CAKaWdxaju2cgLaN5F4evAOdQZPu_6cbC8yncmuo=qqE+H13vOQ@mail.gmail.com>
Subject: ext3 journal commit while seek & write to file
From: Keith Chew <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

There is a thread in the sqlite mailing list that was started by me,
but it did not finish because it appears that my findings are more
related to the kernel instead of sqlite. I really hope someone here
can give me some guidance.

The summary of my system is:
- kernel 2.6.39.4 (also tested with 3.6.9)
- ext3 with data=ordered,commit=5
- disk has write-cache off
- sqlite does an insert to the DB every second

I have found that it takes 1ms to write to the DB each second, except
for when the kernel commits its journal (ie every 5 seconds). At those
times, the write goes up to 160ms.

You can see from the strace below that the write() after the seek does
take longer (in this case 148ms) compared to the usual 1ms:
-------------------
[pid 17913] 17:58:14.390431 _llseek(98, 4826072, [4826072], SEEK_SET)
= 0 <0.000013>
[pid 17913] 17:58:14.390667 write(98,
"\0\0\0\5\0\0\0\215\"'\201\230\305\360\331\370G\305\25\3358W\234\336",
24) = 24 <0.000137>
[pid 17913] 17:58:14.390956 _llseek(98, 4826096, [4826096], SEEK_SET)
= 0 <0.000012>
[pid 17913] 17:58:14.391134 write(98,
"\r\0\0\0\1\3<\0\3<\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024 <0.148882>
-------------------

I have also tried to write a small program which appends 1KB to the
end of a file every second, and I do not see this latency on that app.
Profiling mysql when doing a write every second also do not suffer
from this problem. I have looked into the sqlite code, but cannot find
anything unusual.

Is there anything I can do to improve this situation?

PS: When I set commit=1, strace shows it takes 160ms every second to
write to disk.

Regards
Keith
