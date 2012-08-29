Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2H2ALI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 20:11:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2H2ALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 20:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
 <1340736849-14875-3-git-send-email-yinghai@kernel.org> <CAE9FiQVrUbEzopKfeoQZFNdNszLN96brC+rYuGXQCfZvpi_ETQ@mail.gmail.com>
 <CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com> <CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Aug 2012 17:10:43 -0700
X-Google-Sender-Auth: BLn0OSTvrtdcfxltbgCtNglZqQ8
Message-ID: <CA+55aFyb-g77CQNoR72J0pjw76ZCy_nufP=VavT_X3xBg6=G-Q@mail.gmail.com>
Subject: Re: [PATCH -v12 02/15] resources: Add probe_resource()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d04427108fe7b4004c85c64c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04427108fe7b4004c85c64c8
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Aug 28, 2012 at 10:05 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ugh. Ok, looking closer at this,

Btw, looking at that code, I also found what looks like a potential
locking bug in allocate_resource().

The code does

    if (new->parent)
       .. reallocate ..

to check whether a resource was already allocated. HOWEVER, it does so
without actually holding the resource lock. Which means that
"new->parent" might in theory change.

I don't really know if we care. Anybody who does a
"allocate_resource()" on an existing resource that might already be in
the resource tree hopefully does *not* do that in parallel with
another user trying to change the resource allocation, so maybe the
right thing to do is to just say "whatever, if there is a race with
two threads reallocating the same resource at the same time, the bug
is a much more serious one at a higher level".

So this may well be a non-issue. It was introduced some time ago, in
commit 23c570a67448e ("resource: ability to resize an allocated
resource"), since before that we never even allowed re-allocation of
an already allocated resource in the first place, and everything
happened under the lock.

I dunno. Here's a (UNTESTED!) patch that should fix it. Because it's
extremely doubtful whether this is a real problem, I'm certainly not
going to commit it now, much less mark it for stable. But I'm throwing
it out as an RFC. Technically, if people rely on any races being
handled by the resource subsystem, this *could* trigger. But I'm
hoping that the PCI layer has some higher-level locking for
"reallocate the resources of this PCI device". I did *not* check the
callers.

Btw, reallocate_resource() isn't actually used anywhere in the tree
that I can see, so maybe we should remove it and the export, and just
have the __reallocate_resource() that is static to resource.c and is
to be called only with the lock held.

                         Linus

--f46d04427108fe7b4004c85c64c8
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h6fnyfep0

IGtlcm5lbC9yZXNvdXJjZS5jIHwgNzUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQyIGluc2VydGlvbnMoKyks
IDMzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9yZXNvdXJjZS5jIGIva2VybmVs
L3Jlc291cmNlLmMKaW5kZXggMzRkNDU4ODZlZTg0Li44Mjk0NDM2OTA0OTcgMTAwNjQ0Ci0tLSBh
L2tlcm5lbC9yZXNvdXJjZS5jCisrKyBiL2tlcm5lbC9yZXNvdXJjZS5jCkBAIC00NjIsNTAgKzQ2
Miw1OSBAQCBzdGF0aWMgaW50IGZpbmRfcmVzb3VyY2Uoc3RydWN0IHJlc291cmNlICpyb290LCBz
dHJ1Y3QgcmVzb3VyY2UgKm5ldywKIAlyZXR1cm4gIF9fZmluZF9yZXNvdXJjZShyb290LCBOVUxM
LCBuZXcsIHNpemUsIGNvbnN0cmFpbnQpOwogfQogCi0vKioKLSAqIHJlYWxsb2NhdGVfcmVzb3Vy
Y2UgLSBhbGxvY2F0ZSBhIHNsb3QgaW4gdGhlIHJlc291cmNlIHRyZWUgZ2l2ZW4gcmFuZ2UgJiBh
bGlnbm1lbnQuCi0gKglUaGUgcmVzb3VyY2Ugd2lsbCBiZSByZWxvY2F0ZWQgaWYgdGhlIG5ldyBz
aXplIGNhbm5vdCBiZSByZWFsbG9jYXRlZCBpbiB0aGUKLSAqCWN1cnJlbnQgbG9jYXRpb24uCi0g
KgotICogQHJvb3Q6IHJvb3QgcmVzb3VyY2UgZGVzY3JpcHRvcgotICogQG9sZDogIHJlc291cmNl
IGRlc2NyaXB0b3IgZGVzaXJlZCBieSBjYWxsZXIKLSAqIEBuZXdzaXplOiBuZXcgc2l6ZSBvZiB0
aGUgcmVzb3VyY2UgZGVzY3JpcHRvcgotICogQGNvbnN0cmFpbnQ6IHRoZSBzaXplIGFuZCBhbGln
bm1lbnQgY29uc3RyYWludHMgdG8gYmUgbWV0LgotICovCi1pbnQgcmVhbGxvY2F0ZV9yZXNvdXJj
ZShzdHJ1Y3QgcmVzb3VyY2UgKnJvb3QsIHN0cnVjdCByZXNvdXJjZSAqb2xkLAorCitzdGF0aWMg
aW50IF9fcmVhbGxvY2F0ZV9yZXNvdXJjZShzdHJ1Y3QgcmVzb3VyY2UgKnJvb3QsIHN0cnVjdCBy
ZXNvdXJjZSAqb2xkLAogCQkJcmVzb3VyY2Vfc2l6ZV90IG5ld3NpemUsCiAJCQlzdHJ1Y3QgcmVz
b3VyY2VfY29uc3RyYWludCAgKmNvbnN0cmFpbnQpCiB7Ci0JaW50IGVycj0wOworCWludCBlcnI7
CiAJc3RydWN0IHJlc291cmNlIG5ldyA9ICpvbGQ7CiAJc3RydWN0IHJlc291cmNlICpjb25mbGlj
dDsKIAotCXdyaXRlX2xvY2soJnJlc291cmNlX2xvY2spOwotCi0JaWYgKChlcnIgPSBfX2ZpbmRf
cmVzb3VyY2Uocm9vdCwgb2xkLCAmbmV3LCBuZXdzaXplLCBjb25zdHJhaW50KSkpCi0JCWdvdG8g
b3V0OworCWVyciA9IF9fZmluZF9yZXNvdXJjZShyb290LCBvbGQsICZuZXcsIG5ld3NpemUsIGNv
bnN0cmFpbnQpOworCWlmIChlcnIpCisJCXJldHVybiBlcnI7CiAKIAlpZiAocmVzb3VyY2VfY29u
dGFpbnMoJm5ldywgb2xkKSkgewogCQlvbGQtPnN0YXJ0ID0gbmV3LnN0YXJ0OwogCQlvbGQtPmVu
ZCA9IG5ldy5lbmQ7Ci0JCWdvdG8gb3V0OworCQlyZXR1cm4gMDsKIAl9CiAKLQlpZiAob2xkLT5j
aGlsZCkgewotCQllcnIgPSAtRUJVU1k7Ci0JCWdvdG8gb3V0OwotCX0KKwlpZiAob2xkLT5jaGls
ZCkKKwkJcmV0dXJuIC1FQlVTWTsKIAogCWlmIChyZXNvdXJjZV9jb250YWlucyhvbGQsICZuZXcp
KSB7CiAJCW9sZC0+c3RhcnQgPSBuZXcuc3RhcnQ7CiAJCW9sZC0+ZW5kID0gbmV3LmVuZDsKLQl9
IGVsc2UgewotCQlfX3JlbGVhc2VfcmVzb3VyY2Uob2xkKTsKLQkJKm9sZCA9IG5ldzsKLQkJY29u
ZmxpY3QgPSBfX3JlcXVlc3RfcmVzb3VyY2Uocm9vdCwgb2xkKTsKLQkJQlVHX09OKGNvbmZsaWN0
KTsKKwkJcmV0dXJuIDA7CiAJfQotb3V0OgorCisJX19yZWxlYXNlX3Jlc291cmNlKG9sZCk7CisJ
Km9sZCA9IG5ldzsKKwljb25mbGljdCA9IF9fcmVxdWVzdF9yZXNvdXJjZShyb290LCBvbGQpOwor
CUJVR19PTihjb25mbGljdCk7CisJcmV0dXJuIDA7Cit9CisKKy8qKgorICogcmVhbGxvY2F0ZV9y
ZXNvdXJjZSAtIGFsbG9jYXRlIGEgc2xvdCBpbiB0aGUgcmVzb3VyY2UgdHJlZSBnaXZlbiByYW5n
ZSAmIGFsaWdubWVudC4KKyAqCVRoZSByZXNvdXJjZSB3aWxsIGJlIHJlbG9jYXRlZCBpZiB0aGUg
bmV3IHNpemUgY2Fubm90IGJlIHJlYWxsb2NhdGVkIGluIHRoZQorICoJY3VycmVudCBsb2NhdGlv
bi4KKyAqCisgKiBAcm9vdDogcm9vdCByZXNvdXJjZSBkZXNjcmlwdG9yCisgKiBAb2xkOiAgcmVz
b3VyY2UgZGVzY3JpcHRvciBkZXNpcmVkIGJ5IGNhbGxlcgorICogQG5ld3NpemU6IG5ldyBzaXpl
IG9mIHRoZSByZXNvdXJjZSBkZXNjcmlwdG9yCisgKiBAY29uc3RyYWludDogdGhlIHNpemUgYW5k
IGFsaWdubWVudCBjb25zdHJhaW50cyB0byBiZSBtZXQuCisgKi8KK2ludCByZWFsbG9jYXRlX3Jl
c291cmNlKHN0cnVjdCByZXNvdXJjZSAqcm9vdCwgc3RydWN0IHJlc291cmNlICpvbGQsCisJCQly
ZXNvdXJjZV9zaXplX3QgbmV3c2l6ZSwKKwkJCXN0cnVjdCByZXNvdXJjZV9jb25zdHJhaW50ICAq
Y29uc3RyYWludCkKK3sKKwlpbnQgZXJyOworCisJd3JpdGVfbG9jaygmcmVzb3VyY2VfbG9jayk7
CisJZXJyID0gX19yZWFsbG9jYXRlX3Jlc291cmNlKHJvb3QsIG9sZCwgbmV3c2l6ZSwgY29uc3Ry
YWludCk7CiAJd3JpdGVfdW5sb2NrKCZyZXNvdXJjZV9sb2NrKTsKIAlyZXR1cm4gZXJyOwogfQpA
QCAtNTQ0LDE2ICs1NTMsMTYgQEAgaW50IGFsbG9jYXRlX3Jlc291cmNlKHN0cnVjdCByZXNvdXJj
ZSAqcm9vdCwgc3RydWN0IHJlc291cmNlICpuZXcsCiAJY29uc3RyYWludC5hbGlnbmYgPSBhbGln
bmY7CiAJY29uc3RyYWludC5hbGlnbmZfZGF0YSA9IGFsaWduZl9kYXRhOwogCisJd3JpdGVfbG9j
aygmcmVzb3VyY2VfbG9jayk7CiAJaWYgKCBuZXctPnBhcmVudCApIHsKIAkJLyogcmVzb3VyY2Ug
aXMgYWxyZWFkeSBhbGxvY2F0ZWQsIHRyeSByZWFsbG9jYXRpbmcgd2l0aAogCQkgICB0aGUgbmV3
IGNvbnN0cmFpbnRzICovCi0JCXJldHVybiByZWFsbG9jYXRlX3Jlc291cmNlKHJvb3QsIG5ldywg
c2l6ZSwgJmNvbnN0cmFpbnQpOworCQllcnIgPSBfX3JlYWxsb2NhdGVfcmVzb3VyY2Uocm9vdCwg
bmV3LCBzaXplLCAmY29uc3RyYWludCk7CisJfSBlbHNlIHsKKwkJZXJyID0gZmluZF9yZXNvdXJj
ZShyb290LCBuZXcsIHNpemUsICZjb25zdHJhaW50KTsKKwkJaWYgKGVyciA+PSAwICYmIF9fcmVx
dWVzdF9yZXNvdXJjZShyb290LCBuZXcpKQorCQkJZXJyID0gLUVCVVNZOwogCX0KLQotCXdyaXRl
X2xvY2soJnJlc291cmNlX2xvY2spOwotCWVyciA9IGZpbmRfcmVzb3VyY2Uocm9vdCwgbmV3LCBz
aXplLCAmY29uc3RyYWludCk7Ci0JaWYgKGVyciA+PSAwICYmIF9fcmVxdWVzdF9yZXNvdXJjZShy
b290LCBuZXcpKQotCQllcnIgPSAtRUJVU1k7CiAJd3JpdGVfdW5sb2NrKCZyZXNvdXJjZV9sb2Nr
KTsKIAlyZXR1cm4gZXJyOwogfQo=
--f46d04427108fe7b4004c85c64c8--
