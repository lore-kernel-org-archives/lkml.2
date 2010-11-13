Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0KMRu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:50:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab0KMRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <1289669176.16461.12.camel@Joe-Laptop>
References: <1289669176.16461.12.camel@Joe-Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Nov 2010 09:50:22 -0800
Message-ID: <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
To: Joe Perches <joe@perches.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=00032557a0fa8b39d40494f2d813
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00032557a0fa8b39d40494f2d813
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 13, 2010 at 9:26 AM, Joe Perches <joe@perches.com> wrote:
>
> dmesg_restrict is guarded by #ifdef CONFIG_PRINTK in kernel.h
> Its uses need to be guarded as well.

Fair enough, but I think this part:

> diff --git a/security/commoncap.c b/security/commoncap.c
> index 04b80f9..29f2368 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -895,8 +895,10 @@ int cap_syslog(int type, bool from_file)
> =A0{
> =A0 =A0 =A0 =A0if (type !=3D SYSLOG_ACTION_OPEN && from_file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> +#ifdef CONFIG_PRINTK
> =A0 =A0 =A0 =A0if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPERM;
> +#endif
> =A0 =A0 =A0 =A0if ((type !=3D SYSLOG_ACTION_READ_ALL &&
> =A0 =A0 =A0 =A0 =A0 =A0 type !=3D SYSLOG_ACTION_SIZE_BUFFER) && !capable(=
CAP_SYS_ADMIN))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPERM;

is incredibly ugly. If CONFIG_PRINTK isn't set, the whole function
just becomes pointless, so why guard just that one part of it?

So I would suggest guarding the whole thing, and just returning 0 if
CONFIG_PRINTK isn't set. Or preferably just move the dmesg_restrict
test into do_syslog, and stop playing stupid games with
"security_syslog()", which actually goes away if you disable the you
disable CONFIG_SECURITY.

SECURITY_DMESG_RESTRICT is totally independent of CONFIG_SECURITY, so
doing it in security_syslog() was a bug to begin with.

Or we should make SECURITY_DMESG_RESTRICT _depend_ on CONFIG_SECURITY,
and move it entirely into security/commoncap.c, and not pollute
kernel/printk.c at all with it.

Anyway, suggested replacement patch attached. Comments?

                         Linus

--00032557a0fa8b39d40494f2d813
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gggskhl70

IGtlcm5lbC9wcmludGsuYyAgICAgIHwgICAgMyArKysKIGtlcm5lbC9zeXNjdGwuYyAgICAgIHwg
ICAgMiArLQogc2VjdXJpdHkvY29tbW9uY2FwLmMgfCAgICAyIC0tCiAzIGZpbGVzIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvcHJp
bnRrLmMgYi9rZXJuZWwvcHJpbnRrLmMKaW5kZXggMzhlN2Q1OC4uMTVkZDU4NSAxMDA2NDQKLS0t
IGEva2VybmVsL3ByaW50ay5jCisrKyBiL2tlcm5lbC9wcmludGsuYwpAQCAtMjc0LDYgKzI3NCw5
IEBAIGludCBkb19zeXNsb2coaW50IHR5cGUsIGNoYXIgX191c2VyICpidWYsIGludCBsZW4sIGJv
b2wgZnJvbV9maWxlKQogCWNoYXIgYzsKIAlpbnQgZXJyb3IgPSAwOwogCisJaWYgKGRtZXNnX3Jl
c3RyaWN0ICYmICFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJNOworCiAJ
ZXJyb3IgPSBzZWN1cml0eV9zeXNsb2codHlwZSwgZnJvbV9maWxlKTsKIAlpZiAoZXJyb3IpCiAJ
CXJldHVybiBlcnJvcjsKZGlmZiAtLWdpdCBhL2tlcm5lbC9zeXNjdGwuYyBiL2tlcm5lbC9zeXNj
dGwuYwppbmRleCBiNjViZjYzLi41YWJmYTE1IDEwMDY0NAotLS0gYS9rZXJuZWwvc3lzY3RsLmMK
KysrIGIva2VybmVsL3N5c2N0bC5jCkBAIC03MDIsNyArNzAyLDYgQEAgc3RhdGljIHN0cnVjdCBj
dGxfdGFibGUga2Vybl90YWJsZVtdID0gewogCQkuZXh0cmExCQk9ICZ6ZXJvLAogCQkuZXh0cmEy
CQk9ICZ0ZW5fdGhvdXNhbmQsCiAJfSwKLSNlbmRpZgogCXsKIAkJLnByb2NuYW1lCT0gImRtZXNn
X3Jlc3RyaWN0IiwKIAkJLmRhdGEJCT0gJmRtZXNnX3Jlc3RyaWN0LApAQCAtNzEyLDYgKzcxMSw3
IEBAIHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIGtlcm5fdGFibGVbXSA9IHsKIAkJLmV4dHJhMQkJ
PSAmemVybywKIAkJLmV4dHJhMgkJPSAmb25lLAogCX0sCisjZW5kaWYKIAl7CiAJCS5wcm9jbmFt
ZQk9ICJuZ3JvdXBzX21heCIsCiAJCS5kYXRhCQk9ICZuZ3JvdXBzX21heCwKZGlmZiAtLWdpdCBh
L3NlY3VyaXR5L2NvbW1vbmNhcC5jIGIvc2VjdXJpdHkvY29tbW9uY2FwLmMKaW5kZXggMDRiODBm
OS4uNWU2MzJiNCAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvY29tbW9uY2FwLmMKKysrIGIvc2VjdXJp
dHkvY29tbW9uY2FwLmMKQEAgLTg5NSw4ICs4OTUsNiBAQCBpbnQgY2FwX3N5c2xvZyhpbnQgdHlw
ZSwgYm9vbCBmcm9tX2ZpbGUpCiB7CiAJaWYgKHR5cGUgIT0gU1lTTE9HX0FDVElPTl9PUEVOICYm
IGZyb21fZmlsZSkKIAkJcmV0dXJuIDA7Ci0JaWYgKGRtZXNnX3Jlc3RyaWN0ICYmICFjYXBhYmxl
KENBUF9TWVNfQURNSU4pKQotCQlyZXR1cm4gLUVQRVJNOwogCWlmICgodHlwZSAhPSBTWVNMT0df
QUNUSU9OX1JFQURfQUxMICYmCiAJICAgICB0eXBlICE9IFNZU0xPR19BQ1RJT05fU0laRV9CVUZG
RVIpICYmICFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQogCQlyZXR1cm4gLUVQRVJNOwo=
--00032557a0fa8b39d40494f2d813--
