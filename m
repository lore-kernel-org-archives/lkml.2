Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0KORet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:34:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35604 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab0KORer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop>
	<AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	<1289677904.16461.82.camel@Joe-Laptop>
	<AANLkTikWEZLwx4khj_jFOqP+uy-TxgJGwsbxdtaCfbJq@mail.gmail.com>
	<AANLkTik=mnFDXAyJ53_7FPfD5ETiYY8GjkE5pm0PJSBu@mail.gmail.com>
Date: Mon, 15 Nov 2010 12:34:42 -0500
Message-ID: <AANLkTimoFGqKDYe24uc_2EHk-MLqxc4GGCCe7hPRJqbJ@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf301d3db0001cef04951adb0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf301d3db0001cef04951adb0d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 15, 2010 at 12:04 PM, Eric Paris <eparis@parisplace.org> wrote:
> On Sat, Nov 13, 2010 at 3:31 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> We had this exact problem with the whole "mmap_min_addr" thing. People
>> _thought_ of it as generic, but because it was actually tested by the
>> security logic, if you ended up enabling SELinux the test actually
>> went away entirely (or maybe it was the other way around). So with
>> certain security models, the whole thing was bypassed, and the
>> security module actually became an _IN_security module.
>
> Your recollection is wrong, although your conclusions of the
> ramifications are right. =A0Either SELinux or capabilities checked
> mmap_min_addr, depending on which was 'primary.' =A0Just as they are
> different modules they checked for different things. =A0Only doing
> SELinux checks was stronger for some situations, and only doing
> capability checks was stronger in some ways (and the reverse was
> obviously true). =A0Today you get the best of both worlds since we
> really have 2 different mmap_min_addr values...
>
> In any case the result of that is that LSMs (ok 'I') need to be more
> careful making sure they interact properly with the generic
> capabilities hooks.
>
> From: James Morris
>> I want to ensure that LSMs which implement security_syslog can't end up
>> with a less secure system than the default, regardless of whether they
>> call cap_syslog or not.
>
> Which really means that this is total crap. =A0If you don't call
> cap_syslog() you broke it. =A0That's all there is to it. =A0Calling the
> capability code is always required. =A0full stop.
>
> I think this patch is broken though. =A0SELinux and SMACK don't care
> about from_file and want to check every time no matter what. =A0Your
> patch breaks that and only will call the LSM on occasion. =A0It's only
> capabilities that likes those semantics. =A0I think the entire contents
> of the cap_syslog hook should be moved up and that hook just dropped
> entirely.
>
> I'll code up what I'm thinking in a minute.....
>
> -Eric

I'm sure somebody somewhere hates it, but I was thinking something
like the attached.

 include/linux/security.h   |    9 ++++-----
 kernel/printk.c            |   11 ++++++++++-
 security/capability.c      |    5 +++++
 security/commoncap.c       |   21 ---------------------
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    6 +-----
 security/smack/smack_lsm.c |    8 ++------
 7 files changed, 24 insertions(+), 40 deletions(-)

(Personally I think that most of the hooks in commoncap.c code should
be moved out of security/ altogether and we should completely do away
with our current ghetto inter LSM calls.  But that's just me)

-Eric

--20cf301d3db0001cef04951adb0d
Content-Type: text/x-patch; charset=US-ASCII; name="tmp.patch"
Content-Disposition: attachment; filename="tmp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggjmux1d0

Y29tbWl0IGFjZWY5OTBjZGUwZGJkYzllODhkZjJkYTU0Y2FjNGRlYmM2YTUwM2YKQXV0aG9yOiBF
cmljIFBhcmlzIDxlcGFyaXNAcmVkaGF0LmNvbT4KRGF0ZTogICBNb24gTm92IDE1IDEyOjIwOjI3
IDIwMTAgLTA1MDAKCiAgICBmaXggY2FwYWJpbGl0aWVzLXJlc3RyaWMKCmRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L3NlY3VyaXR5LmggYi9pbmNsdWRlL2xpbnV4L3NlY3VyaXR5LmgKaW5kZXgg
YWVlM2I4Zi4uZDQyNjE5ZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9zZWN1cml0eS5oCisr
KyBiL2luY2x1ZGUvbGludXgvc2VjdXJpdHkuaApAQCAtNzcsNyArNzcsNiBAQCBleHRlcm4gaW50
IGNhcF90YXNrX3ByY3RsKGludCBvcHRpb24sIHVuc2lnbmVkIGxvbmcgYXJnMiwgdW5zaWduZWQg
bG9uZyBhcmczLAogZXh0ZXJuIGludCBjYXBfdGFza19zZXRzY2hlZHVsZXIoc3RydWN0IHRhc2tf
c3RydWN0ICpwKTsKIGV4dGVybiBpbnQgY2FwX3Rhc2tfc2V0aW9wcmlvKHN0cnVjdCB0YXNrX3N0
cnVjdCAqcCwgaW50IGlvcHJpbyk7CiBleHRlcm4gaW50IGNhcF90YXNrX3NldG5pY2Uoc3RydWN0
IHRhc2tfc3RydWN0ICpwLCBpbnQgbmljZSk7Ci1leHRlcm4gaW50IGNhcF9zeXNsb2coaW50IHR5
cGUsIGJvb2wgZnJvbV9maWxlKTsKIGV4dGVybiBpbnQgY2FwX3ZtX2Vub3VnaF9tZW1vcnkoc3Ry
dWN0IG1tX3N0cnVjdCAqbW0sIGxvbmcgcGFnZXMpOwogCiBzdHJ1Y3QgbXNnaGRyOwpAQCAtMTM4
OSw3ICsxMzg4LDcgQEAgc3RydWN0IHNlY3VyaXR5X29wZXJhdGlvbnMgewogCWludCAoKnN5c2N0
bCkgKHN0cnVjdCBjdGxfdGFibGUgKnRhYmxlLCBpbnQgb3ApOwogCWludCAoKnF1b3RhY3RsKSAo
aW50IGNtZHMsIGludCB0eXBlLCBpbnQgaWQsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpOwogCWlu
dCAoKnF1b3RhX29uKSAoc3RydWN0IGRlbnRyeSAqZGVudHJ5KTsKLQlpbnQgKCpzeXNsb2cpIChp
bnQgdHlwZSwgYm9vbCBmcm9tX2ZpbGUpOworCWludCAoKnN5c2xvZykgKGludCB0eXBlKTsKIAlp
bnQgKCpzZXR0aW1lKSAoc3RydWN0IHRpbWVzcGVjICp0cywgc3RydWN0IHRpbWV6b25lICp0eik7
CiAJaW50ICgqdm1fZW5vdWdoX21lbW9yeSkgKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBsb25nIHBh
Z2VzKTsKIApAQCAtMTY3NSw3ICsxNjc0LDcgQEAgaW50IHNlY3VyaXR5X3JlYWxfY2FwYWJsZV9u
b2F1ZGl0KHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLCBpbnQgY2FwKTsKIGludCBzZWN1cml0eV9z
eXNjdGwoc3RydWN0IGN0bF90YWJsZSAqdGFibGUsIGludCBvcCk7CiBpbnQgc2VjdXJpdHlfcXVv
dGFjdGwoaW50IGNtZHMsIGludCB0eXBlLCBpbnQgaWQsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2Ip
OwogaW50IHNlY3VyaXR5X3F1b3RhX29uKHN0cnVjdCBkZW50cnkgKmRlbnRyeSk7Ci1pbnQgc2Vj
dXJpdHlfc3lzbG9nKGludCB0eXBlLCBib29sIGZyb21fZmlsZSk7CitpbnQgc2VjdXJpdHlfc3lz
bG9nKGludCB0eXBlKTsKIGludCBzZWN1cml0eV9zZXR0aW1lKHN0cnVjdCB0aW1lc3BlYyAqdHMs
IHN0cnVjdCB0aW1lem9uZSAqdHopOwogaW50IHNlY3VyaXR5X3ZtX2Vub3VnaF9tZW1vcnkobG9u
ZyBwYWdlcyk7CiBpbnQgc2VjdXJpdHlfdm1fZW5vdWdoX21lbW9yeV9tbShzdHJ1Y3QgbW1fc3Ry
dWN0ICptbSwgbG9uZyBwYWdlcyk7CkBAIC0xOTA3LDkgKzE5MDYsOSBAQCBzdGF0aWMgaW5saW5l
IGludCBzZWN1cml0eV9xdW90YV9vbihzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAJcmV0dXJuIDA7
CiB9CiAKLXN0YXRpYyBpbmxpbmUgaW50IHNlY3VyaXR5X3N5c2xvZyhpbnQgdHlwZSwgYm9vbCBm
cm9tX2ZpbGUpCitzdGF0aWMgaW5saW5lIGludCBzZWN1cml0eV9zeXNsb2coaW50IHR5cGUpCiB7
Ci0JcmV0dXJuIGNhcF9zeXNsb2codHlwZSwgZnJvbV9maWxlKTsKKwlyZXR1cm4gMDsKIH0KIAog
c3RhdGljIGlubGluZSBpbnQgc2VjdXJpdHlfc2V0dGltZShzdHJ1Y3QgdGltZXNwZWMgKnRzLCBz
dHJ1Y3QgdGltZXpvbmUgKnR6KQpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay5jIGIva2VybmVs
L3ByaW50ay5jCmluZGV4IDM4ZTdkNTguLmQwMGVmZDEgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9wcmlu
dGsuYworKysgYi9rZXJuZWwvcHJpbnRrLmMKQEAgLTI3NCw3ICsyNzQsMTYgQEAgaW50IGRvX3N5
c2xvZyhpbnQgdHlwZSwgY2hhciBfX3VzZXIgKmJ1ZiwgaW50IGxlbiwgYm9vbCBmcm9tX2ZpbGUp
CiAJY2hhciBjOwogCWludCBlcnJvciA9IDA7CiAKLQllcnJvciA9IHNlY3VyaXR5X3N5c2xvZyh0
eXBlLCBmcm9tX2ZpbGUpOworCWlmICh0eXBlID09IFNZU0xPR19BQ1RJT05fT1BFTiB8fCAhZnJv
bV9maWxlKSB7CisJCWlmIChkbWVzZ19yZXN0cmljdCAmJiAhY2FwYWJsZShDQVBfU1lTX0FETUlO
KSkKKwkJCXJldHVybiAtRVBFUk07CisJCWlmICgodHlwZSAhPSBTWVNMT0dfQUNUSU9OX1JFQURf
QUxMICYmCisJCSAgICAgdHlwZSAhPSBTWVNMT0dfQUNUSU9OX1NJWkVfQlVGRkVSKSAmJgorCQkg
ICAgIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCisJCQlyZXR1cm4gLUVQRVJNOworCX0KKworCWVy
cm9yID0gc2VjdXJpdHlfc3lzbG9nKHR5cGUpOwogCWlmIChlcnJvcikKIAkJcmV0dXJuIGVycm9y
OwogCmRpZmYgLS1naXQgYS9zZWN1cml0eS9jYXBhYmlsaXR5LmMgYi9zZWN1cml0eS9jYXBhYmls
aXR5LmMKaW5kZXggZDZkNjEzYS4uNmI1YzZlOSAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvY2FwYWJp
bGl0eS5jCisrKyBiL3NlY3VyaXR5L2NhcGFiaWxpdHkuYwpAQCAtMTcsNiArMTcsMTEgQEAgc3Rh
dGljIGludCBjYXBfc3lzY3RsKGN0bF90YWJsZSAqdGFibGUsIGludCBvcCkKIAlyZXR1cm4gMDsK
IH0KIAorc3RhdGljIGludCBjYXBfc3lzbG9nKGludCB0eXBlKQoreworICAgICAgICByZXR1cm4g
MDsKK30KKwogc3RhdGljIGludCBjYXBfcXVvdGFjdGwoaW50IGNtZHMsIGludCB0eXBlLCBpbnQg
aWQsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiB7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9z
ZWN1cml0eS9jb21tb25jYXAuYyBiL3NlY3VyaXR5L2NvbW1vbmNhcC5jCmluZGV4IDA0YjgwZjku
LjY0YzJlZDkgMTAwNjQ0Ci0tLSBhL3NlY3VyaXR5L2NvbW1vbmNhcC5jCisrKyBiL3NlY3VyaXR5
L2NvbW1vbmNhcC5jCkBAIC0yNyw3ICsyNyw2IEBACiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4K
ICNpbmNsdWRlIDxsaW51eC9wcmN0bC5oPgogI2luY2x1ZGUgPGxpbnV4L3NlY3VyZWJpdHMuaD4K
LSNpbmNsdWRlIDxsaW51eC9zeXNsb2cuaD4KIAogLyoKICAqIElmIGEgbm9uLXJvb3QgdXNlciBl
eGVjdXRlcyBhIHNldHVpZC1yb290IGJpbmFyeSBpbgpAQCAtODg0LDI2ICs4ODMsNiBAQCBlcnJv
cjoKIH0KIAogLyoqCi0gKiBjYXBfc3lzbG9nIC0gRGV0ZXJtaW5lIHdoZXRoZXIgc3lzbG9nIGZ1
bmN0aW9uIGlzIHBlcm1pdHRlZAotICogQHR5cGU6IEZ1bmN0aW9uIHJlcXVlc3RlZAotICogQGZy
b21fZmlsZTogV2hldGhlciB0aGlzIHJlcXVlc3QgY2FtZSBmcm9tIGFuIG9wZW4gZmlsZSAoaS5l
LiAvcHJvYykKLSAqCi0gKiBEZXRlcm1pbmUgd2hldGhlciB0aGUgY3VycmVudCBwcm9jZXNzIGlz
IHBlcm1pdHRlZCB0byB1c2UgYSBwYXJ0aWN1bGFyCi0gKiBzeXNsb2cgZnVuY3Rpb24sIHJldHVy
bmluZyAwIGlmIHBlcm1pc3Npb24gaXMgZ3JhbnRlZCwgLXZlIGlmIG5vdC4KLSAqLwotaW50IGNh
cF9zeXNsb2coaW50IHR5cGUsIGJvb2wgZnJvbV9maWxlKQotewotCWlmICh0eXBlICE9IFNZU0xP
R19BQ1RJT05fT1BFTiAmJiBmcm9tX2ZpbGUpCi0JCXJldHVybiAwOwotCWlmIChkbWVzZ19yZXN0
cmljdCAmJiAhY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKLQkJcmV0dXJuIC1FUEVSTTsKLQlpZiAo
KHR5cGUgIT0gU1lTTE9HX0FDVElPTl9SRUFEX0FMTCAmJgotCSAgICAgdHlwZSAhPSBTWVNMT0df
QUNUSU9OX1NJWkVfQlVGRkVSKSAmJiAhY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKLQkJcmV0dXJu
IC1FUEVSTTsKLQlyZXR1cm4gMDsKLX0KLQotLyoqCiAgKiBjYXBfdm1fZW5vdWdoX21lbW9yeSAt
IERldGVybWluZSB3aGV0aGVyIGEgbmV3IHZpcnR1YWwgbWFwcGluZyBpcyBwZXJtaXR0ZWQKICAq
IEBtbTogVGhlIFZNIHNwYWNlIGluIHdoaWNoIHRoZSBuZXcgbWFwcGluZyBpcyB0byBiZSBtYWRl
CiAgKiBAcGFnZXM6IFRoZSBzaXplIG9mIHRoZSBtYXBwaW5nCmRpZmYgLS1naXQgYS9zZWN1cml0
eS9zZWN1cml0eS5jIGIvc2VjdXJpdHkvc2VjdXJpdHkuYwppbmRleCAyNTlkM2FkLi42MzlhNzJh
IDEwMDY0NAotLS0gYS9zZWN1cml0eS9zZWN1cml0eS5jCisrKyBiL3NlY3VyaXR5L3NlY3VyaXR5
LmMKQEAgLTE5Nyw5ICsxOTcsOSBAQCBpbnQgc2VjdXJpdHlfcXVvdGFfb24oc3RydWN0IGRlbnRy
eSAqZGVudHJ5KQogCXJldHVybiBzZWN1cml0eV9vcHMtPnF1b3RhX29uKGRlbnRyeSk7CiB9CiAK
LWludCBzZWN1cml0eV9zeXNsb2coaW50IHR5cGUsIGJvb2wgZnJvbV9maWxlKQoraW50IHNlY3Vy
aXR5X3N5c2xvZyhpbnQgdHlwZSkKIHsKLQlyZXR1cm4gc2VjdXJpdHlfb3BzLT5zeXNsb2codHlw
ZSwgZnJvbV9maWxlKTsKKwlyZXR1cm4gc2VjdXJpdHlfb3BzLT5zeXNsb2codHlwZSk7CiB9CiAK
IGludCBzZWN1cml0eV9zZXR0aW1lKHN0cnVjdCB0aW1lc3BlYyAqdHMsIHN0cnVjdCB0aW1lem9u
ZSAqdHopCmRpZmYgLS1naXQgYS9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMgYi9zZWN1cml0eS9z
ZWxpbnV4L2hvb2tzLmMKaW5kZXggOGJhNTAwMS4uZTA2NmJjMiAxMDA2NDQKLS0tIGEvc2VjdXJp
dHkvc2VsaW51eC9ob29rcy5jCisrKyBiL3NlY3VyaXR5L3NlbGludXgvaG9va3MuYwpAQCAtMTk3
MSwxNCArMTk3MSwxMCBAQCBzdGF0aWMgaW50IHNlbGludXhfcXVvdGFfb24oc3RydWN0IGRlbnRy
eSAqZGVudHJ5KQogCXJldHVybiBkZW50cnlfaGFzX3Blcm0oY3JlZCwgTlVMTCwgZGVudHJ5LCBG
SUxFX19RVU9UQU9OKTsKIH0KIAotc3RhdGljIGludCBzZWxpbnV4X3N5c2xvZyhpbnQgdHlwZSwg
Ym9vbCBmcm9tX2ZpbGUpCitzdGF0aWMgaW50IHNlbGludXhfc3lzbG9nKGludCB0eXBlKQogewog
CWludCByYzsKIAotCXJjID0gY2FwX3N5c2xvZyh0eXBlLCBmcm9tX2ZpbGUpOwotCWlmIChyYykK
LQkJcmV0dXJuIHJjOwotCiAJc3dpdGNoICh0eXBlKSB7CiAJY2FzZSBTWVNMT0dfQUNUSU9OX1JF
QURfQUxMOgkvKiBSZWFkIGxhc3Qga2VybmVsIG1lc3NhZ2VzICovCiAJY2FzZSBTWVNMT0dfQUNU
SU9OX1NJWkVfQlVGRkVSOgkvKiBSZXR1cm4gc2l6ZSBvZiB0aGUgbG9nIGJ1ZmZlciAqLwpkaWZm
IC0tZ2l0IGEvc2VjdXJpdHkvc21hY2svc21hY2tfbHNtLmMgYi9zZWN1cml0eS9zbWFjay9zbWFj
a19sc20uYwppbmRleCA2Y2M0N2VmLi5mN2I4YmVlIDEwMDY0NAotLS0gYS9zZWN1cml0eS9zbWFj
ay9zbWFja19sc20uYworKysgYi9zZWN1cml0eS9zbWFjay9zbWFja19sc20uYwpAQCAtMTU3LDE1
ICsxNTcsMTEgQEAgc3RhdGljIGludCBzbWFja19wdHJhY2VfdHJhY2VtZShzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnB0cCkKICAqCiAgKiBSZXR1cm5zIDAgb24gc3VjY2VzcywgZXJyb3IgY29kZSBvdGhl
cndpc2UuCiAgKi8KLXN0YXRpYyBpbnQgc21hY2tfc3lzbG9nKGludCB0eXBlLCBib29sIGZyb21f
ZmlsZSkKK3N0YXRpYyBpbnQgc21hY2tfc3lzbG9nKGludCB0eXBlZnJvbV9maWxlKQogewotCWlu
dCByYzsKKwlpbnQgcmMgPSAwOwogCWNoYXIgKnNwID0gY3VycmVudF9zZWN1cml0eSgpOwogCi0J
cmMgPSBjYXBfc3lzbG9nKHR5cGUsIGZyb21fZmlsZSk7Ci0JaWYgKHJjICE9IDApCi0JCXJldHVy
biByYzsKLQogCWlmIChjYXBhYmxlKENBUF9NQUNfT1ZFUlJJREUpKQogCQlyZXR1cm4gMDsKIAo=
--20cf301d3db0001cef04951adb0d--
