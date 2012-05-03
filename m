Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2ECRbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:31:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41397 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab2ECRbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
 <20120503064722.GN6871@ZenIV.linux.org.uk> <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 10:30:38 -0700
X-Google-Sender-Auth: goXjzfnHXgdWzjaJ_inNh49FETA
Message-ID: <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
To: Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Piggin <npiggin@gmail.com>, Jana Saout <jana@saout.de>,
        Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d044303f4cd6c0d04bf252a35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044303f4cd6c0d04bf252a35
Content-Type: text/plain; charset=ISO-8859-1

On Thu, May 3, 2012 at 9:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I guess I need to do the exception handling that I was hoping I
> wouldn't have to. Give me a jiffy.

Ok, that took longer than a jiffy, the asm was just nasty to get right
with all the proper suffixes for 32-bit vs 64-bit, and the fact that
gas apparently really needs %cl for the shift count, and doesn't like
%rcx. Silly assembler.

Also, the asm would have been much simpler if I didn't care so much
about the regular fast-path. I wanted the fast-path for the asm to be
a single load, with no downside, and everything fixed up in the
exception case.

And it's close. It's a single load, and the only downside is that
register '%rcx' is marked as used, because *if* the exception happens,
we want to use %rcx do the alignment fixup.

Peter, in particular, can you double (and triple-) check my asm, to
see if I missed anything? It does that "lea" of the address into %rcx
twice, because that way we don't need any other register temporaries.

On 32-bit, this results in:

 - fast-path single-instruction unaligned load (with gcc free to pick
registers and addressing modes):

      movl (%edi,%edx),%eax

 - with the exception fixup code becoming:

        leal (%edi,%edx),%ecx
        andl $-4,%ecx
        movl (%ecx),%eax
        leal (%edi,%edx),%ecx
        andl $3,%ecx
        shll $3,%ecx
        shll %cl,%eax
        shrl %cl,%eax
        jmp 2b

which looks ok. I don't worry about the efficiency of the fixup code,
because if that code is ever entered we will have taken a page fault
etc, so the only thing to worry about is that the fixup doesn't
need/fix any unnecessary extra registers so that the fast-path case
doesn't get less flexible.

Does anybody see anything wrong with this?

Anyway, with this, I guess we could enable word-at-a-time even with
CONFIG_DEBUG_PAGEALLOC on x86, and that might even be a good idea for
coverage.

Jana - does the attached patch work for you?

                     Linus

--f46d044303f4cd6c0d04bf252a35
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1s389at0

RnJvbSAyNDAxOWUzOGQ2MmVmMzBiNjlhNTJjNGQwZTE0ZDIwY2IyZWZjN2FiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IFRodSwgMyBNYXkgMjAxMiAxMDoxNjo0MyAtMDcwMApTdWJqZWN0OiBb
UEFUQ0hdIHZmczogbWFrZSB3b3JkLWF0LWEtdGltZSBhY2Nlc3NlcyBoYW5kbGUgYSBub24tZXhp
c3RpbmcgcGFnZQoKSXQgdHVybnMgb3V0IHRoYXQgdGhlcmUgYXJlIG1vcmUgY2FzZXMgdGhhbiBD
T05GSUdfREVCVUdfUEFHRUFMTE9DIHRoYXQKY2FuIGhhdmUgaG9sZXMgaW4gdGhlIGtlcm5lbCBh
ZGRyZXNzIHNwYWNlOiBpdCBzZWVtcyB0byBoYXBwZW4gZWFzaWx5CndpdGggWGVuLCBhbmQgaXQg
bG9va3MgbGlrZSB0aGUgQU1EIGdhcnQ2NCBjb2RlIHdpbGwgYWxzbyBwdW5jaCBob2xlcwpkeW5h
bWljYWxseS4KCkFjdHVhbGx5IGhpdHRpbmcgdGhhdCBjYXNlIGlzIHN0aWxsIHZlcnkgdW5saWtl
bHksIHNvIGp1c3QgZG8gdGhlCmFjY2VzcywgYW5kIHRha2UgYW4gZXhjZXB0aW9uIGFuZCBmaXgg
aXQgdXAgZm9yIHRoZSB2ZXJ5IHVubGlrZWx5IGNhc2UKb2YgaXQgYmVpbmcgYSBwYWdlLWNyb3Nz
ZXIgd2l0aCBubyBuZXh0IHBhZ2UuCgpBbmQgaGV5LCB0aGlzIGFic3RyYWN0aW9uIG1pZ2h0IGV2
ZW4gaGVscCBvdGhlciBhcmNoaXRlY3R1cmVzIHRoYXQgaGF2ZQpvdGhlciBpc3N1ZXMgd2l0aCB1
bmFsaWduZWQgd29yZCBhY2Nlc3NlcyB0aGFuIHRoZSBwb3NzaWJsZSBtaXNzaW5nIG5leHQKcGFn
ZS4gIElPVywgdGhpcyBjb3VsZCBkbyB0aGUgYnl0ZSBvcmRlciBtYWdpYyB0b28uCgpTaWduZWQt
b2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+Ci0t
LQogYXJjaC94ODYvaW5jbHVkZS9hc20vd29yZC1hdC1hLXRpbWUuaCB8ICAgMzggKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrCiBmcy9uYW1laS5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgNCArKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vd29yZC1hdC1h
LXRpbWUuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3dvcmQtYXQtYS10aW1lLmgKaW5kZXggNmZl
Njc2N2I3MTI0Li4wOTkxOGUwZGZjNzQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3dvcmQtYXQtYS10aW1lLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vd29yZC1hdC1hLXRp
bWUuaApAQCAtMjIsNiArMjIsOCBAQCBzdGF0aWMgaW5saW5lIGxvbmcgY291bnRfbWFza2VkX2J5
dGVzKHVuc2lnbmVkIGxvbmcgbWFzaykKIAlyZXR1cm4gbWFzayoweDAwMDEwMjAzMDQwNTA2MDh1
bCA+PiA1NjsKIH0KIAorI2RlZmluZSBfX1dPUkRTVUZGSVggInEiCisKICNlbHNlCS8qIDMyLWJp
dCBjYXNlICovCiAKIC8qIENhcmwgQ2hhdGZpZWxkIC8gSmFuIEFjaHJlbml1cyBHKyB2ZXJzaW9u
IGZvciAzMi1iaXQgKi8KQEAgLTMzLDYgKzM1LDggQEAgc3RhdGljIGlubGluZSBsb25nIGNvdW50
X21hc2tlZF9ieXRlcyhsb25nIG1hc2spCiAJcmV0dXJuIGEgJiBtYXNrOwogfQogCisjZGVmaW5l
IF9fV09SRFNVRkZJWCAibCIKKwogI2VuZGlmCiAKICNkZWZpbmUgUkVQRUFUX0JZVEUoeCkJKCh+
MHVsIC8gMHhmZikgKiAoeCkpCkBAIC00Myw0ICs0NywzOCBAQCBzdGF0aWMgaW5saW5lIHVuc2ln
bmVkIGxvbmcgaGFzX3plcm8odW5zaWduZWQgbG9uZyBhKQogCXJldHVybiAoKGEgLSBSRVBFQVRf
QllURSgweDAxKSkgJiB+YSkgJiBSRVBFQVRfQllURSgweDgwKTsKIH0KIAorLyoKKyAqIExvYWQg
YW4gdW5hbGlnbmVkIHdvcmQgZnJvbSBrZXJuZWwgc3BhY2UuCisgKgorICogSW4gdGhlICh2ZXJ5
IHVubGlrZWx5KSBjYXNlIG9mIHRoZSB3b3JkIGJlaW5nIGEgcGFnZS1jcm9zc2VyCisgKiBhbmQg
dGhlIG5leHQgcGFnZSBub3QgYmVpbmcgbWFwcGVkLCB0YWtlIHRoZSBleGNlcHRpb24gYW5kCisg
KiByZXR1cm4gemVyb2VzIGluIHRoZSBub24tZXhpc3RpbmcgcGFydC4KKyAqLworc3RhdGljIGlu
bGluZSB1bnNpZ25lZCBsb25nIGxvYWRfdW5hbGlnbmVkX3plcm9wYWQoY29uc3Qgdm9pZCAqYWRk
cikKK3sKKwl1bnNpZ25lZCBsb25nIHJldCwgZHVtbXk7CisKKwlhc20oCisJCSIxOlx0bW92IiBf
X1dPUkRTVUZGSVggIiAlMiwlMFxuIgorCQkiMjpcbiIKKwkJIi5zZWN0aW9uIC5maXh1cCxcImF4
XCJcbiIKKwkJIjM6XHQiCisJCSJsZWEiIF9fV09SRFNVRkZJWCAiICUyLCUxXG5cdCIKKwkJImFu
ZCIgX19XT1JEU1VGRklYICIgJTMsJTFcblx0IgorCQkibW92IiBfX1dPUkRTVUZGSVggIiAoJTEp
LCUwXG5cdCIKKwkJImxlYSIgX19XT1JEU1VGRklYICIgJTIsJTFcblx0IgorCQkiYW5kIiBfX1dP
UkRTVUZGSVggIiAlNCwlMVxuXHQiCisJCSJzaGwiIF9fV09SRFNVRkZJWCAiICQzLCUxXG5cdCIK
KwkJInNobCIgX19XT1JEU1VGRklYICIgJWIxLCUwXG5cdCIKKwkJInNociIgX19XT1JEU1VGRklY
ICIgJWIxLCUwXG5cdCIKKwkJImptcCAyYlxuIgorCQkiLnByZXZpb3VzXG4iCisJCV9BU01fRVhU
QUJMRSgxYiwgM2IpCisJCToiPSZyIiAocmV0KSwiPSZjIiAoZHVtbXkpCisJCToibSIgKCoodW5z
aWduZWQgbG9uZyAqKWFkZHIpLAorCQkgImkiICgtc2l6ZW9mKHVuc2lnbmVkIGxvbmcpKSwKKwkJ
ICJpIiAoc2l6ZW9mKHVuc2lnbmVkIGxvbmcpLTEpKTsKKwlyZXR1cm4gcmV0OworfQorCiAjZW5k
aWYgLyogX0FTTV9XT1JEX0FUX0FfVElNRV9IICovCmRpZmYgLS1naXQgYS9mcy9uYW1laS5jIGIv
ZnMvbmFtZWkuYwppbmRleCAwMDYyZGQxN2ViNTUuLmM0Mjc5MTkxNGY4MiAxMDA2NDQKLS0tIGEv
ZnMvbmFtZWkuYworKysgYi9mcy9uYW1laS5jCkBAIC0xNDI5LDcgKzE0MjksNyBAQCB1bnNpZ25l
ZCBpbnQgZnVsbF9uYW1lX2hhc2goY29uc3QgdW5zaWduZWQgY2hhciAqbmFtZSwgdW5zaWduZWQg
aW50IGxlbikKIAl1bnNpZ25lZCBsb25nIGhhc2ggPSAwOwogCiAJZm9yICg7OykgewotCQlhID0g
Kih1bnNpZ25lZCBsb25nICopbmFtZTsKKwkJYSA9IGxvYWRfdW5hbGlnbmVkX3plcm9wYWQobmFt
ZSk7CiAJCWlmIChsZW4gPCBzaXplb2YodW5zaWduZWQgbG9uZykpCiAJCQlicmVhazsKIAkJaGFz
aCArPSBhOwpAQCAtMTQ1OSw3ICsxNDU5LDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25n
IGhhc2hfbmFtZShjb25zdCBjaGFyICpuYW1lLCB1bnNpZ25lZCBpbnQgKmhhc2hwKQogCWRvIHsK
IAkJaGFzaCA9IChoYXNoICsgYSkgKiA5OwogCQlsZW4gKz0gc2l6ZW9mKHVuc2lnbmVkIGxvbmcp
OwotCQlhID0gKih1bnNpZ25lZCBsb25nICopKG5hbWUrbGVuKTsKKwkJYSA9IGxvYWRfdW5hbGln
bmVkX3plcm9wYWQobmFtZStsZW4pOwogCQkvKiBEbyB3ZSBoYXZlIGFueSBOVUwgb3IgJy8nIGJ5
dGVzIGluIHRoaXMgd29yZD8gKi8KIAkJbWFzayA9IGhhc196ZXJvKGEpIHwgaGFzX3plcm8oYSBe
IFJFUEVBVF9CWVRFKCcvJykpOwogCX0gd2hpbGUgKCFtYXNrKTsK
--f46d044303f4cd6c0d04bf252a35--
