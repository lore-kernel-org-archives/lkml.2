Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2CaUwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:52:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52540 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2CaUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:52:19 -0400
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 31 Mar 2012 22:51:56 +0200
Message-ID: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com>
Subject: [PATCH] Extend core dump note section to contain file names of mapped files
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0442811eeebb7c04bc9021a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0442811eeebb7c04bc9021a8
Content-Type: text/plain; charset=ISO-8859-1

Hi,

[forgot to CC lkml, resending]

While working with core dump analysis, it struck me how much
PITA is caused merely by the fact that names of loaded binary
and libraries are not known.

gdb retrieves loaded library names by examining dynamic loader's
data stored in the core dump's data segments. It uses intimate
knowledge how and where dynamic loader keeps the list of loaded
libraries. (Meaning that it will break if non-standard loader
is used).

And, as Jan explained to me, it depends on knowing where
the linked list of libraries starts, which requires knowing binary
which was running. IIRC there is no easy and reasonably foolproof
way to determine binary's name. (Looking at argv[0] on stack
is not reasonably foolproof).

Which is *ridiculous*. We *know* the list of mapped files
at core dump generation time.

I propose to save this information in core dump, as a new note
in note segment.

This note has the following format:

long count     // how many files are mapped
long page_size // units for file_ofs
array of [COUNT] elements of
   long start
   long end
   long file_ofs
followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

The attached patch implements this.

Since list of mapped files can be large (/proc/`pidof firefox`/maps
on my machine right now is 38k), I allocate the space for note
via vmalloc, and also have a sanity limit of 4 megabytes.
(Maybe we should make it smaller?)
Oleg suggested using a linked list of smaller structures instead of
using a potentially large contiguous block, and I tried it,
but resulting code was significantly more ugly (for my taste).

The patch is run-tested.

For testing, I sent ABRT signal to a running /usr/bin/md5sum.

"readelf -aW core" shows the new note as:

Notes at offset 0x00000274 with length 0x00000990:
 Owner                 Data size       Description
 CORE                 0x00000090       NT_PRSTATUS (prstatus structure)
 CORE                 0x0000007c       NT_PRPSINFO (prpsinfo structure)
 CORE                 0x000000a0       NT_AUXV (auxiliary vector)
 CORE                 0x00000168       Unknown note type: (0x46494c45)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^new note^^^^^^^^^^

In hex format:
                                               05 00 00 00  |................|
00000460  68 01 00 00 45 4c 49 46  46 49 4c 45 00 00 00 00  |h...ELIFCORE....|
00000470  0b 00 00 00 00 10 00 00  00 80 17 00 00 f0 31 00  |..............1.|
00000480  00 00 00 00 00 f0 31 00  00 00 32 00 a7 01 00 00  |......1...2.....|
00000490  00 00 32 00 00 20 32 00  a7 01 00 00 00 20 32 00  |..2.. 2...... 2.|
000004a0  00 30 32 00 a9 01 00 00  00 50 69 00 00 60 6b 00  |.02......Pi..`k.|
000004b0  00 00 00 00 00 60 6b 00  00 70 6b 00 20 00 00 00  |.....`k..pk. ...|
000004c0  00 70 6b 00 00 80 6b 00  21 00 00 00 00 80 04 08  |.pk...k.!.......|
000004d0  00 00 05 08 00 00 00 00  00 00 05 08 00 10 05 08  |................|
000004e0  07 00 00 00 00 10 05 08  00 20 05 08 08 00 00 00  |......... ......|
000004f0  00 20 52 b7 00 20 72 b7  00 00 00 00 2f 6c 69 62  |. R.. r...../lib|
00000500  2f 6c 69 62 63 2d 32 2e  31 34 2e 39 30 2e 73 6f  |/libc-2.14.90.so|
00000510  00 2f 6c 69 62 2f 6c 69  62 63 2d 32 2e 31 34 2e  |./lib/libc-2.14.|
00000520  39 30 2e 73 6f 00 2f 6c  69 62 2f 6c 69 62 63 2d  |90.so./lib/libc-|
00000530  32 2e 31 34 2e 39 30 2e  73 6f 00 2f 6c 69 62 2f  |2.14.90.so./lib/|
00000540  6c 69 62 63 2d 32 2e 31  34 2e 39 30 2e 73 6f 00  |libc-2.14.90.so.|
00000550  2f 6c 69 62 2f 6c 64 2d  32 2e 31 34 2e 39 30 2e  |/lib/ld-2.14.90.|
00000560  73 6f 00 2f 6c 69 62 2f  6c 64 2d 32 2e 31 34 2e  |so./lib/ld-2.14.|
00000570  39 30 2e 73 6f 00 2f 6c  69 62 2f 6c 64 2d 32 2e  |90.so./lib/ld-2.|
00000580  31 34 2e 39 30 2e 73 6f  00 2f 75 73 72 2f 62 69  |14.90.so./usr/bi|
00000590  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 62 69  |n/md5sum./usr/bi|
000005a0  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 62 69  |n/md5sum./usr/bi|
000005b0  6e 2f 6d 64 35 73 75 6d  00 2f 75 73 72 2f 6c 69  |n/md5sum./usr/li|
000005c0  62 2f 6c 6f 63 61 6c 65  2f 6c 6f 63 61 6c 65 2d  |b/locale/locale-|
000005d0  61 72 63 68 69 76 65 00                           |archive.

--
vda

--f46d0442811eeebb7c04bc9021a8
Content-Type: application/octet-stream; name="file_note.patch"
Content-Disposition: attachment; filename="file_note.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0h4xh3u0

ZGlmZiAtLWdpdCBhL2ZzL2JpbmZtdF9lbGYuYyBiL2ZzL2JpbmZtdF9lbGYuYwppbmRleCA4MTg3
OGI3Li5iNTg1YmExIDEwMDY0NAotLS0gYS9mcy9iaW5mbXRfZWxmLmMKKysrIGIvZnMvYmluZm10
X2VsZi5jCkBAIC0xMzU4LDYgKzEzNTgsNzMgQEAgc3RhdGljIHZvaWQgZmlsbF9hdXh2X25vdGUo
c3RydWN0IG1lbWVsZm5vdGUgKm5vdGUsIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQogCWZpbGxfbm90
ZShub3RlLCAiQ09SRSIsIE5UX0FVWFYsIGkgKiBzaXplb2YoZWxmX2FkZHJfdCksIGF1eHYpOwog
fQogCisjZGVmaW5lIE1BWF9GSUxFX05PVEVfU0laRSAoNCoxMDI0KjEwMjQpCisKK3N0YXRpYyB2
b2lkIGZpbGxfZmlsZXNfbm90ZShzdHJ1Y3QgbWVtZWxmbm90ZSAqbm90ZSkKK3sKKwlzdHJ1Y3Qg
dm1fYXJlYV9zdHJ1Y3QgKnZtYTsKKwlzdHJ1Y3QgZmlsZSAqZmlsZTsKKwl1bnNpZ25lZCBjb3Vu
dCwgd29yZF9jb3VudCwgc2l6ZSwgcmVtYWluaW5nOworCWxvbmcgKmRhdGE7CisJbG9uZyAqc3Rh
cnRfZW5kX29mczsKKwljaGFyICpuYW1lOworCisJY291bnQgPSAwOworCWZvciAodm1hID0gY3Vy
cmVudC0+bW0tPm1tYXA7IHZtYSAhPSBOVUxMOyB2bWEgPSB2bWEtPnZtX25leHQpIHsKKwkJZmls
ZSA9IHZtYS0+dm1fZmlsZTsKKwkJaWYgKCFmaWxlKQorCQkJY29udGludWU7CisJCWNvdW50Kys7
CisJCWlmIChjb3VudCA+PSBNQVhfRklMRV9OT1RFX1NJWkUgLyA2NCkgLyogcGFyYW5vaWEgY2hl
Y2sgKi8KKwkJCWdvdG8gZXJyOworCX0KKworCXNpemUgPSBjb3VudCAqIDY0OworCXdvcmRfY291
bnQgPSAyICsgMyAqIGNvdW50OworIGFsbG9jOgorCWlmIChzaXplID49IE1BWF9GSUxFX05PVEVf
U0laRSkgLyogcGFyYW5vaWEgY2hlY2sgKi8KKwkJZ290byBlcnI7CisJc2l6ZSA9IChzaXplICsg
UEFHRV9TSVpFIC0gMSkgJiAoLVBBR0VfU0laRSk7CisJZGF0YSA9IHZtYWxsb2Moc2l6ZSk7CisJ
aWYgKCFkYXRhKQorCQlnb3RvIGVycjsKKwlzdGFydF9lbmRfb2ZzID0gZGF0YTsKKwluYW1lID0g
KHZvaWQqKSZzdGFydF9lbmRfb2ZzW3dvcmRfY291bnRdOworCXJlbWFpbmluZyA9IHNpemUgLSB3
b3JkX2NvdW50ICogc2l6ZW9mKGxvbmcpOworCisJKnN0YXJ0X2VuZF9vZnMrKyA9IGNvdW50Owor
CSpzdGFydF9lbmRfb2ZzKysgPSBQQUdFX1NJWkU7CisJZm9yICh2bWEgPSBjdXJyZW50LT5tbS0+
bW1hcDsgdm1hICE9IE5VTEw7IHZtYSA9IHZtYS0+dm1fbmV4dCkgeworCQljb25zdCBjaGFyICpm
aWxlbmFtZTsKKworCQlmaWxlID0gdm1hLT52bV9maWxlOworCQlpZiAoIWZpbGUpCisJCQljb250
aW51ZTsKKwkJaWYgKHJlbWFpbmluZyA9PSAwKSB7CisgdHJ5X25ld19zaXplOgorCQkJdmZyZWUo
ZGF0YSk7CisJCQlzaXplID0gc2l6ZSAqIDUgLyA0OworCQkJZ290byBhbGxvYzsKKwkJfQorCQlm
aWxlbmFtZSA9IGRfcGF0aCgmZmlsZS0+Zl9wYXRoLCBuYW1lLCByZW1haW5pbmcpOworCQlpZiAo
SVNfRVJSKGZpbGVuYW1lKSkgeworCQkJaWYgKFBUUl9FUlIoZmlsZW5hbWUpID09IC1FTkFNRVRP
T0xPTkcpCisJCQkJZ290byB0cnlfbmV3X3NpemU7CisJCQkvKiBjb250aW51ZTsgLS0gV1JPTkcs
IHdlIG11c3QgaGF2ZSBDT1VOVCBlbGVtZW50cyAqLworCQkJZmlsZW5hbWUgPSAiIjsKKwkJfQor
CQl3aGlsZSAoKHJlbWFpbmluZy0tLCAqbmFtZSsrID0gKmZpbGVuYW1lKyspICE9ICdcMCcpCisJ
CQljb250aW51ZTsKKwkJKnN0YXJ0X2VuZF9vZnMrKyA9IHZtYS0+dm1fc3RhcnQ7CisJCSpzdGFy
dF9lbmRfb2ZzKysgPSB2bWEtPnZtX2VuZDsKKwkJKnN0YXJ0X2VuZF9vZnMrKyA9IHZtYS0+dm1f
cGdvZmY7CisJfQorCisJc2l6ZSA9IG5hbWUgLSAoY2hhciopZGF0YTsKKwlmaWxsX25vdGUobm90
ZSwgIkNPUkUiLCBOVF9GSUxFLCBzaXplLCBkYXRhKTsKKyBlcnI6IDsKK30KKwogI2lmZGVmIENP
UkVfRFVNUF9VU0VfUkVHU0VUCiAjaW5jbHVkZSA8bGludXgvcmVnc2V0Lmg+CiAKQEAgLTEzNzIs
NiArMTQzOSw3IEBAIHN0cnVjdCBlbGZfbm90ZV9pbmZvIHsKIAlzdHJ1Y3QgZWxmX3RocmVhZF9j
b3JlX2luZm8gKnRocmVhZDsKIAlzdHJ1Y3QgbWVtZWxmbm90ZSBwc2luZm87CiAJc3RydWN0IG1l
bWVsZm5vdGUgYXV4djsKKwlzdHJ1Y3QgbWVtZWxmbm90ZSBmaWxlczsKIAlzaXplX3Qgc2l6ZTsK
IAlpbnQgdGhyZWFkX25vdGVzOwogfTsKQEAgLTE1MzIsNiArMTYwMCw5IEBAIHN0YXRpYyBpbnQg
ZmlsbF9ub3RlX2luZm8oc3RydWN0IGVsZmhkciAqZWxmLCBpbnQgcGhkcnMsCiAJZmlsbF9hdXh2
X25vdGUoJmluZm8tPmF1eHYsIGN1cnJlbnQtPm1tKTsKIAlpbmZvLT5zaXplICs9IG5vdGVzaXpl
KCZpbmZvLT5hdXh2KTsKIAorCWZpbGxfZmlsZXNfbm90ZSgmaW5mby0+ZmlsZXMpOworCWluZm8t
PnNpemUgKz0gbm90ZXNpemUoJmluZm8tPmZpbGVzKTsKKwogCXJldHVybiAxOwogfQogCkBAIC0x
NTYwLDYgKzE2MzEsOCBAQCBzdGF0aWMgaW50IHdyaXRlX25vdGVfaW5mbyhzdHJ1Y3QgZWxmX25v
dGVfaW5mbyAqaW5mbywKIAkJCXJldHVybiAwOwogCQlpZiAoZmlyc3QgJiYgIXdyaXRlbm90ZSgm
aW5mby0+YXV4diwgZmlsZSwgZm9mZnNldCkpCiAJCQlyZXR1cm4gMDsKKwkJaWYgKGZpcnN0ICYm
ICF3cml0ZW5vdGUoJmluZm8tPmZpbGVzLCBmaWxlLCBmb2Zmc2V0KSkKKwkJCXJldHVybiAwOwog
CiAJCWZvciAoaSA9IDE7IGkgPCBpbmZvLT50aHJlYWRfbm90ZXM7ICsraSkKIAkJCWlmICh0LT5u
b3Rlc1tpXS5kYXRhICYmCkBAIC0xNTg2LDYgKzE2NTksNyBAQCBzdGF0aWMgdm9pZCBmcmVlX25v
dGVfaW5mbyhzdHJ1Y3QgZWxmX25vdGVfaW5mbyAqaW5mbykKIAkJa2ZyZWUodCk7CiAJfQogCWtm
cmVlKGluZm8tPnBzaW5mby5kYXRhKTsKKwl2ZnJlZShpbmZvLT5maWxlcy5kYXRhKTsKIH0KIAog
I2Vsc2UKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZWxmLmggYi9pbmNsdWRlL2xpbnV4L2Vs
Zi5oCmluZGV4IDk5OWI0ZjUuLjVlNmMwOGYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZWxm
LmgKKysrIGIvaW5jbHVkZS9saW51eC9lbGYuaApAQCAtMzcyLDYgKzM3Miw3IEBAIHR5cGVkZWYg
c3RydWN0IGVsZjY0X3NoZHIgewogI2RlZmluZSBOVF9QUlBTSU5GTwkzCiAjZGVmaW5lIE5UX1RB
U0tTVFJVQ1QJNAogI2RlZmluZSBOVF9BVVhWCQk2CisjZGVmaW5lIE5UX0ZJTEUJCTB4NDY0OTRj
NDUKICNkZWZpbmUgTlRfUFJYRlBSRUcgICAgIDB4NDZlNjJiN2YgICAgICAvKiBjb3BpZWQgZnJv
bSBnZGI1LjEvaW5jbHVkZS9lbGYvY29tbW9uLmggKi8KICNkZWZpbmUgTlRfUFBDX1ZNWAkweDEw
MAkJLyogUG93ZXJQQyBBbHRpdmVjL1ZNWCByZWdpc3RlcnMgKi8KICNkZWZpbmUgTlRfUFBDX1NQ
RQkweDEwMQkJLyogUG93ZXJQQyBTUEUvRVZSIHJlZ2lzdGVycyAqLwo=
--f46d0442811eeebb7c04bc9021a8--
