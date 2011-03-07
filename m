Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1CGLzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:55:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62094 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1CGLzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L5ugEN0oxNzWJp6+my0JpIinM7nX/v+AtA1B8jG2OCxnhU/NKKQxBSYmAbivjfl7ic
         8YNFv5qXLMkWsHG7/aL/7F4C1Gznh6MRi0qOfoW8fgun9cm9Cmvp113vVQGbxt9midBR
         uNoKumyMLictikwYT//K08bpqYCVczUhTyxlU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org>
	<20110306193519.49DD.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
Date: Mon, 7 Mar 2011 14:55:37 +0300
Message-ID: <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
From: Andrew Vagin <avagin@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001517573fbc8cc200049de32c9b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517573fbc8cc200049de32c9b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/3/7 David Rientjes <rientjes@google.com>:
> On Sun, 6 Mar 2011, KOSAKI Motohiro wrote:
>
>> > When we check that task has flag TIF_MEMDIE, we forgot check that
>> > it has mm. A task may be zombie and a parent may wait a memor.
>> >
>> > v2: Check that task doesn't have mm one time and skip it immediately
>> >
>> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
>>
>> This seems incorrect. Do you have a reprodusable testcasae?
>> Your patch only care thread group leader state, but current code
>> care all thread in the process. Please look at oom_badness() and
>> find_lock_task_mm().
>>
>
> That's all irrelevant, the test for TIF_MEMDIE specifically makes the oom
> killer a complete no-op when an eligible task is found to have been oom
> killed to prevent needlessly killing additional tasks. =A0oom_badness() a=
nd
> find_lock_task_mm() have nothing to do with that check to return
> ERR_PTR(-1UL) from select_bad_process().
>
> Andrey is patching the case where an eligible TIF_MEMDIE process is found
> but it has already detached its ->mm. =A0In combination with the patch
> posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics,
> which makes select_bad_process() iterate over all threads, it is an
> effective solution.

Probably you said about the first version of my patch.
This version is incorrect because of
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3Ddd8e8f405ca386c7ce7cbb996ccd985d283b0e03

but my first patch is correct and it has a simple reproducer(I
attached it). You can execute it and your kernel hangs up, because the
parent doesn't wait children, but the one child (zombie) will have
flag TIF_MEMDIE, oom_killer will kill nobody


The link on the first patch:
http://groups.google.com/group/linux.kernel/browse_thread/thread/b9c6ddf34d=
1671ab/2941e1877ca4f626?lnk=3Draot&pli=3D1
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>

--001517573fbc8cc200049de32c9b
Content-Type: application/octet-stream; name="memeater_killer.py"
Content-Disposition: attachment; filename="memeater_killer.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkzbw14n0

aW1wb3J0IHN5cywgdGltZSwgbW1hcCwgb3MKZnJvbSBzdWJwcm9jZXNzIGltcG9ydCBQb3Blbiwg
UElQRQppbXBvcnQgcmFuZG9tCgpnbG9iYWwgbWVtX3NpemUKCmRlZiBpbmZvKG1zZyk6CglwaWQg
PSBvcy5nZXRwaWQoKQoJcHJpbnQgPj4gc3lzLnN0ZGVyciwgIiVzOiAlcyIgJSAocGlkLCBtc2cp
CglzeXMuc3RkZXJyLmZsdXNoKCkKCgoKZGVmIG1lbW9yeV9sb29wKGNtZCA9ICJhIik6CgkiIiIK
CWNtZCBtYXkgYmU6CgkJYzogY2hlY2sgbWVtb3J5CgkJZWxzZTogdG91Y2ggbWVtb3J5CgkiIiIK
CWMgPSAwCglmb3IgaiBpbiB4cmFuZ2UoMCwgbWVtX3NpemUpOgoJCWlmIGNtZCA9PSAiYyI6CgkJ
CWlmIGZbajw8MTJdICE9IGNocihqICUgMjU1KToKCQkJCWluZm8oIkRhdGEgY29ycnVwdGlvbiIp
CgkJCQlzeXMuZXhpdCgxKQoJCWVsc2U6CgkJCWZbajw8MTJdID0gY2hyKGogJSAyNTUpCmZvciBp
IGluIHhyYW5nZSgyMCk6CglwaWQgPSBvcy5mb3JrKCkKCXRpbWUuc2xlZXAoMSkKCWlmIChwaWQg
PT0gMCk6CgkJc3lzLnN0ZG91dC53cml0ZSgibW1hcFxuIikKCQlzeXMuc3Rkb3V0LmZsdXNoKCkK
CQltZW1fc2l6ZSA9IDQwMCAqIDEwMjQKCQlmID0gbW1hcC5tbWFwKC0xLCBtZW1fc2l6ZSA8PCAx
MiwgbW1hcC5NQVBfQU5PTllNT1VTfG1tYXAuTUFQX1BSSVZBVEUpCgkJbWVtb3J5X2xvb3AoKQoJ
CXRpbWUuc2xlZXAoMTAwKQoJCWYuY2xvc2UoKQoJCXN5cy5zdGRvdXQud3JpdGUoInVtbWFwXG4i
KQoJCXN5cy5zdGRvdXQuZmx1c2goKQp0aW1lLnNsZWVwKDEwMCkK
--001517573fbc8cc200049de32c9b--
