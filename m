Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab0GJWZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:25:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0GJWZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <20100710063459.GA14596@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	<20100709203301.GA13839@merkur.ravnborg.org>
	<AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
	<1278721339.1537.166.camel@gandalf.stny.rr.com>
	<20100710063459.GA14596@merkur.ravnborg.org>
Date: Sat, 10 Jul 2010 15:25:02 -0700
Message-ID: <AANLkTindHPEQHhmrB562ZlFZMtAIN-S6yMmT7zubS2D_@mail.gmail.com>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/mixed; boundary=000e0cd598cc9cd122048b0ffd91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd598cc9cd122048b0ffd91
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 9, 2010 at 11:35 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> We define a number of symbols in the linker scipt like this:
>
> =A0 =A0__start_syscalls_metadata =3D .;
> =A0 =A0*(__syscalls_metadata)
>
> But we do not know the alignment of "." when we assign
> the __start_syscalls_metadata symbol.
> gcc started to uses bigger alignment for structs (32 bytes),
> so we saw situations where the linker due to alignment
> constraints increased the value of "." after the symbol assignment.

Ok, why not clean this up a bit more, and use a helper macro for this
pattern. There's a fair number of users of that kind of pattern, so
that actually removes a few lines.

Here's an example patch. Untested. Whatever. But just this part

 1 files changed, 21 insertions(+), 31 deletions(-)

says to me that it's a good idea, and there are other cases that could
use the new SYMBOL_SECTION() helper.

What do people think?

                       Linus
>
> This resulted in boot fails.
>
> Fix this by forcing a 32 byte alignment of "." before the
> assignment.
>
> This patch introduces the forced alignment for
> ftrace_events and syscalls_metadata.
> It may be required in more places.
>
> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> =A0include/asm-generic/vmlinux.lds.h | =A0 10 ++++++++++
> =A01 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmli=
nux.lds.h
> index 48c5299..4b5902a 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -63,6 +63,12 @@
> =A0/* Align . to a 8 byte boundary equals to maximum function alignment. =
*/
> =A0#define ALIGN_FUNCTION() =A0. =3D ALIGN(8)
>
> +/*
> + * Align to a 32 byte boundary equal to the
> + * alignment gcc 4.5 uses for a struct
> + */
> +#define STRUCT_ALIGN() . =3D ALIGN(32)
> +
> =A0/* The actual configuration determine if the init/exit sections
> =A0* are handled as text/data or they can be discarded (which
> =A0* often happens at runtime)
> @@ -166,7 +172,11 @@
> =A0 =A0 =A0 =A0LIKELY_PROFILE() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0BRANCH_PROFILE() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0TRACE_PRINTKS() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 STRUCT_ALIGN(); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0FTRACE_EVENTS() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 STRUCT_ALIGN(); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0TRACE_SYSCALLS()
>
> =A0/*
> --
> 1.6.0.6
>
>

--000e0cd598cc9cd122048b0ffd91
Content-Type: application/octet-stream; name=diff
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbh0wewl0

IGluY2x1ZGUvYXNtLWdlbmVyaWMvdm1saW51eC5sZHMuaCB8ICAgNTIgKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCsp
LCAzMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1nZW5lcmljL3ZtbGlu
dXgubGRzLmggYi9pbmNsdWRlL2FzbS1nZW5lcmljL3ZtbGludXgubGRzLmgKaW5kZXggNDhjNTI5
OS4uYjkxYTU1NSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20tZ2VuZXJpYy92bWxpbnV4Lmxkcy5o
CisrKyBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvdm1saW51eC5sZHMuaApAQCAtOTEsNTEgKzkxLDUw
IEBACiAjZGVmaW5lIE1FTV9ESVNDQVJEKHNlYykgKigubWVtIyNzZWMpCiAjZW5kaWYKIAorI2Rl
ZmluZSBTWU1CT0xfU0VDVElPTihuYW1lLCBzZWN0aW9uKQkJXAorCS4gPSBBTElHTigzMik7CQkJ
CVwKKwlWTUxJTlVYX1NZTUJPTChfX3N0YXJ0XyMjc2VjdGlvbikgPSAuOwlcCisJKihuYW1lKQkJ
CQkJXAorCVZNTElOVVhfU1lNQk9MKF9fc3RvcF8jI3NlY3Rpb24pID0gLjsKKwogI2lmZGVmIENP
TkZJR19GVFJBQ0VfTUNPVU5UX1JFQ09SRAotI2RlZmluZSBNQ09VTlRfUkVDKCkJLiA9IEFMSUdO
KDgpOwkJCQlcCi0JCQlWTUxJTlVYX1NZTUJPTChfX3N0YXJ0X21jb3VudF9sb2MpID0gLjsgXAot
CQkJKihfX21jb3VudF9sb2MpCQkJCVwKLQkJCVZNTElOVVhfU1lNQk9MKF9fc3RvcF9tY291bnRf
bG9jKSA9IC47CisjZGVmaW5lIE1DT1VOVF9SRUMoKSBcCisJU1lNQk9MX1NFQ1RJT04oX19tY291
bnRfbG9jaywgbWNvdW50X2xvYykKICNlbHNlCiAjZGVmaW5lIE1DT1VOVF9SRUMoKQogI2VuZGlm
CiAKICNpZmRlZiBDT05GSUdfVFJBQ0VfQlJBTkNIX1BST0ZJTElORwotI2RlZmluZSBMSUtFTFlf
UFJPRklMRSgpCVZNTElOVVhfU1lNQk9MKF9fc3RhcnRfYW5ub3RhdGVkX2JyYW5jaF9wcm9maWxl
KSA9IC47IFwKLQkJCQkqKF9mdHJhY2VfYW5ub3RhdGVkX2JyYW5jaCkJCQkgICAgICBcCi0JCQkJ
Vk1MSU5VWF9TWU1CT0woX19zdG9wX2Fubm90YXRlZF9icmFuY2hfcHJvZmlsZSkgPSAuOworI2Rl
ZmluZSBMSUtFTFlfUFJPRklMRSgpIFwKKwlTWU1CT0xfU0VDVElPTihfZnRyYWNlX2Fubm90YXRl
ZF9icmFuY2gsIGFubm90YXRlZF9icmFuY2hfcHJvZmlsZSkKICNlbHNlCiAjZGVmaW5lIExJS0VM
WV9QUk9GSUxFKCkKICNlbmRpZgogCiAjaWZkZWYgQ09ORklHX1BST0ZJTEVfQUxMX0JSQU5DSEVT
Ci0jZGVmaW5lIEJSQU5DSF9QUk9GSUxFKCkJVk1MSU5VWF9TWU1CT0woX19zdGFydF9icmFuY2hf
cHJvZmlsZSkgPSAuOyAgIFwKLQkJCQkqKF9mdHJhY2VfYnJhbmNoKQkJCSAgICAgIFwKLQkJCQlW
TUxJTlVYX1NZTUJPTChfX3N0b3BfYnJhbmNoX3Byb2ZpbGUpID0gLjsKKyNkZWZpbmUgQlJBTkNI
X1BST0ZJTEUoKSBcCisJU1lNQk9MX1NFQ1RJT04oX2Z0cmFjZV9icmFuY2gsIGJyYW5jaF9wcm9m
aWxlKQogI2Vsc2UKICNkZWZpbmUgQlJBTkNIX1BST0ZJTEUoKQogI2VuZGlmCiAKICNpZmRlZiBD
T05GSUdfRVZFTlRfVFJBQ0lORwotI2RlZmluZSBGVFJBQ0VfRVZFTlRTKCkJVk1MSU5VWF9TWU1C
T0woX19zdGFydF9mdHJhY2VfZXZlbnRzKSA9IC47CVwKLQkJCSooX2Z0cmFjZV9ldmVudHMpCQkJ
CVwKLQkJCVZNTElOVVhfU1lNQk9MKF9fc3RvcF9mdHJhY2VfZXZlbnRzKSA9IC47CisjZGVmaW5l
IEZUUkFDRV9FVkVOVFMoKQlcCisJU1lNQk9MX1NFQ1RJT04oX2Z0cmFjZV9ldmVudHMsIGZ0cmFj
ZV9ldmVudHMpCiAjZWxzZQogI2RlZmluZSBGVFJBQ0VfRVZFTlRTKCkKICNlbmRpZgogCiAjaWZk
ZWYgQ09ORklHX1RSQUNJTkcKLSNkZWZpbmUgVFJBQ0VfUFJJTlRLUygpIFZNTElOVVhfU1lNQk9M
KF9fc3RhcnRfX190cmFjZV9icHJpbnRrX2ZtdCkgPSAuOyAgICAgIFwKLQkJCSAqKF9fdHJhY2Vf
cHJpbnRrX2ZtdCkgLyogVHJhY2VfcHJpbnRrIGZtdCcgcG9pbnRlciAqLyBcCi0JCQkgVk1MSU5V
WF9TWU1CT0woX19zdG9wX19fdHJhY2VfYnByaW50a19mbXQpID0gLjsKKyNkZWZpbmUgVFJBQ0Vf
UFJJTlRLUygpIFwKKwlTWU1CT0xfU0VDVElPTihfX3RyYWNlX3ByaW50a19mbXQsIF9fdHJhY2Vf
YnByaW50a19mbXQpCiAjZWxzZQogI2RlZmluZSBUUkFDRV9QUklOVEtTKCkKICNlbmRpZgogCiAj
aWZkZWYgQ09ORklHX0ZUUkFDRV9TWVNDQUxMUwotI2RlZmluZSBUUkFDRV9TWVNDQUxMUygpIFZN
TElOVVhfU1lNQk9MKF9fc3RhcnRfc3lzY2FsbHNfbWV0YWRhdGEpID0gLjsJXAotCQkJICooX19z
eXNjYWxsc19tZXRhZGF0YSkJCQkJXAotCQkJIFZNTElOVVhfU1lNQk9MKF9fc3RvcF9zeXNjYWxs
c19tZXRhZGF0YSkgPSAuOworI2RlZmluZSBUUkFDRV9TWVNDQUxMUygpIFwKKwlTWU1CT0xfU0VD
VElPTihfX3N5c2NhbGxzX21ldGFkYXRhLCBzeXNjYWxsc19tZXRhZGF0YSkKICNlbHNlCiAjZGVm
aW5lIFRSQUNFX1NZU0NBTExTKCkKICNlbmRpZgpAQCAtMTUwLDE5ICsxNDksMTAgQEAKIAlDUFVf
S0VFUChleGl0LmRhdGEpCQkJCQkJXAogCU1FTV9LRUVQKGluaXQuZGF0YSkJCQkJCQlcCiAJTUVN
X0tFRVAoZXhpdC5kYXRhKQkJCQkJCVwKLQkuID0gQUxJR04oOCk7CQkJCQkJCVwKLQlWTUxJTlVY
X1NZTUJPTChfX3N0YXJ0X19fbWFya2VycykgPSAuOwkJCQlcCi0JKihfX21hcmtlcnMpCQkJCQkJ
CVwKLQlWTUxJTlVYX1NZTUJPTChfX3N0b3BfX19tYXJrZXJzKSA9IC47CQkJCVwKLQkuID0gQUxJ
R04oMzIpOwkJCQkJCQlcCi0JVk1MSU5VWF9TWU1CT0woX19zdGFydF9fX3RyYWNlcG9pbnRzKSA9
IC47CQkJXAotCSooX190cmFjZXBvaW50cykJCQkJCQlcCi0JVk1MSU5VWF9TWU1CT0woX19zdG9w
X19fdHJhY2Vwb2ludHMpID0gLjsJCQlcCisJU1lNQk9MX1NFQ1RJT04oX19tYXJrZXJzLCBfX21h
cmtlcnMpCQkJCVwKKwlTWU1CT0xfU0VDVElPTihfX3RyYWNlcG9pbnRzLCBfX3RyYWNlcG9pbnRz
KTsJCQlcCiAJLyogaW1wbGVtZW50IGR5bmFtaWMgcHJpbnRrIGRlYnVnICovCQkJCVwKLQkuID0g
QUxJR04oOCk7CQkJCQkJCVwKLQlWTUxJTlVYX1NZTUJPTChfX3N0YXJ0X19fdmVyYm9zZSkgPSAu
OyAgICAgICAgICAgICAgICAgICAgICAgICAgXAotCSooX192ZXJib3NlKSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCi0JVk1MSU5VWF9TWU1CT0wo
X19zdG9wX19fdmVyYm9zZSkgPSAuOwkJCQlcCisJU1lNQk9MX1NFQ1RJT04oX192ZXJib3NlLCBf
X3ZlcmJvc2UpCQkJCVwKIAlMSUtFTFlfUFJPRklMRSgpCQkgICAgICAgCQkJCVwKIAlCUkFOQ0hf
UFJPRklMRSgpCQkJCQkJXAogCVRSQUNFX1BSSU5US1MoKQkJCQkJCQlcCg==
--000e0cd598cc9cd122048b0ffd91--
