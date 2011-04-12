Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab1DLRUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:20:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168Ab1DLRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik6U21r91DYiUsz9A0P--=5QcsBrA@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
 <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
 <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
 <alpine.LSU.2.00.1103182158200.18771@sister.anvils> <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
 <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
 <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
 <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com> <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
 <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com> <BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
 <BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com> <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
 <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com> <BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com>
 <BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com> <alpine.LSU.2.00.1104070718120.28555@sister.anvils>
 <BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com> <BANLkTiniyAN40p0q+2wxWsRZ5PJFn9zE0Q@mail.gmail.com>
 <BANLkTik6U21r91DYiUsz9A0P--=5QcsBrA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 10:19:57 -0700
Message-ID: <BANLkTim6ATGxTiMcfK5-03azgcWuT4wtJA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: multipart/mixed; boundary=000e0cd6b2deecaac304a0bbe71b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd6b2deecaac304a0bbe71b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2011 at 8:48 AM, Robert =C5=9Awi=C4=99cki <robert@swiecki.n=
et> wrote:
>>
>> Hmm. Sounds like an endless loop in kernel mode.
>>
>> Use "perf record -ag" as root, it should show up very clearly in the rep=
ort.
>
> I've put some data here -
> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/4345d=
cc4f7750ce2
> - I think it's somewhat connected (sys_mlock appears on both cases).

Ok, so it's definitely sys_mlock.

And I suspect it's due to commit 53a7706d5ed8 somehow looping forever.

One possible cause would be how that commit made things care deeply
about the return value of __get_user_pages(), and in particular what
happens when that return value is zero. It ends up looping forever in
do_mlock_pages() for that case, because it does

                nend =3D nstart + ret * PAGE_SIZE;

so now the next round we'll set "nstart =3D nend" and start all over.

I see at least one way __get_user_pages() will return zero, and it's
if it is passed a npages of 0 to begin with. Which can easily happen
if you try to mlock() the first page of a stack segment: the code will
jump over that stack segment page, and then have nothing to do, and
return zero. So then do_mlock_pages() will just keep on trying again.

THIS IS A HACKY AND UNTESTED PATCH!

It's ugly as hell, because the real problem is do_mlock_pages() caring
too damn much about the return value, and us hiding the whole stack
page thing in that function. I wouldn't want to commit it as-is, but
if you can easily reproduce the problem, it's a good patch to test out
the theory. Assuming I didn't screw something up.

Again, TOTALLY UNTESTED!

                           Linus

--000e0cd6b2deecaac304a0bbe71b
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmf3j1as4

IG1tL21sb2NrLmMgfCAgIDEwICsrKysrKysrKy0KIDEgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21tL21sb2NrLmMgYi9tbS9tbG9j
ay5jCmluZGV4IDI2ODlhMDhjNzlhZi4uMDgwYzIxOTk3M2VhIDEwMDY0NAotLS0gYS9tbS9tbG9j
ay5jCisrKyBiL21tL21sb2NrLmMKQEAgLTE2Miw2ICsxNjIsNyBAQCBzdGF0aWMgbG9uZyBfX21s
b2NrX3ZtYV9wYWdlc19yYW5nZShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwKIAl1bnNpZ25l
ZCBsb25nIGFkZHIgPSBzdGFydDsKIAlpbnQgbnJfcGFnZXMgPSAoZW5kIC0gc3RhcnQpIC8gUEFH
RV9TSVpFOwogCWludCBndXBfZmxhZ3M7CisJbG9uZyByZXR2YWwsIG9mZnNldDsKIAogCVZNX0JV
R19PTihzdGFydCAmIH5QQUdFX01BU0spOwogCVZNX0JVR19PTihlbmQgICAmIH5QQUdFX01BU0sp
OwpAQCAtMTg5LDEzICsxOTAsMjAgQEAgc3RhdGljIGxvbmcgX19tbG9ja192bWFfcGFnZXNfcmFu
Z2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAJCWd1cF9mbGFncyB8PSBGT0xMX01MT0NL
OwogCiAJLyogV2UgZG9uJ3QgdHJ5IHRvIGFjY2VzcyB0aGUgZ3VhcmQgcGFnZSBvZiBhIHN0YWNr
IHZtYSAqLworCW9mZnNldCA9IDA7CiAJaWYgKHN0YWNrX2d1YXJkX3BhZ2Uodm1hLCBzdGFydCkp
IHsKIAkJYWRkciArPSBQQUdFX1NJWkU7CiAJCW5yX3BhZ2VzLS07CisJCW9mZnNldCA9IDE7CiAJ
fQogCi0JcmV0dXJuIF9fZ2V0X3VzZXJfcGFnZXMoY3VycmVudCwgbW0sIGFkZHIsIG5yX3BhZ2Vz
LCBndXBfZmxhZ3MsCisJcmV0dmFsID0gX19nZXRfdXNlcl9wYWdlcyhjdXJyZW50LCBtbSwgYWRk
ciwgbnJfcGFnZXMsIGd1cF9mbGFncywKIAkJCQlOVUxMLCBOVUxMLCBub25ibG9ja2luZyk7CisK
KwkvKiBHZXQgdGhlIHJldHVybiB2YWx1ZSBjb3JyZWN0IGV2ZW4gaW4gdGhlIGZhY2Ugb2YgdGhl
IGd1YXJkIHBhZ2UgKi8KKwlpZiAocmV0dmFsIDwgMCkKKwkJcmV0dXJuIG9mZnNldCA/IDogcmV0
dmFsOworCXJldHVybiByZXR2YWwgKyBvZmZzZXQ7CiB9CiAKIC8qCg==
--000e0cd6b2deecaac304a0bbe71b--
