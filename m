Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1ATUpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:45:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753Ab1ATUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:45:17 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimsf+nCtZrO8f9E0b3=_Y2FikbAHioeZk-Vp=Lm@mail.gmail.com>
References: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com>
 <AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
 <AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com>
 <849307$b7q280@azsmga001.ch.intel.com> <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com>
 <0d30dc$kqf9gp@orsmga001.jf.intel.com> <AANLkTimsf+nCtZrO8f9E0b3=_Y2FikbAHioeZk-Vp=Lm@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 12:44:24 -0800
Message-ID: <AANLkTi=Xb7rXqgns4vUXuaZF2jFEw1B8P+kDfha3d=nX@mail.gmail.com>
Subject: Re: more intel drm issues (was Re: [git pull] drm intel only fixes)
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=000e0cd3107a2bbef6049a4d34b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd3107a2bbef6049a4d34b4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 20, 2011 at 9:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So how about just doing this in the loop? It will mean that the
> _first_ read uses the fast cached one (the common case, hopefully),
> but then if we loop, we'll use the slow exact one.
>
> (cut-and-paste, so whitespace isn't good):
>
> =A0diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c
> b/drivers/gpu/drm/i915/intel_ringbuffer.c
> =A0index 03e3370..11bbfb5 100644
> =A0--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> =A0+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> =A0@@ -961,6 +961,8 @@ int intel_wait_ring_buffer(struct
> intel_ring_buffer *ring, int n)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msleep(1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (atomic_read(&dev_priv->mm.wedged))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EAGAIN;
> =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Force a re-read. FIXME: what if read_=
status_page
> says 0 too */
> =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ring->actual_head =3D 0;
> =A0 =A0 =A0 =A0 =A0} while (!time_after(jiffies, end));
> =A0 =A0 =A0 =A0 =A0trace_i915_ring_wait_end (dev);
> =A0 =A0 =A0 =A0 =A0return -EBUSY;

This makes no difference. And the reason is exactly that we get the
zero case that I had in the comment.

But THIS attached patch actually seems to fix the slow suspend for me.
I removed the accesses to "actual_head", because that whole field
seems to not be used.

So it seems like the intel_read_status_page() thing returns zero
forever when suspending. Maybe you can explain why.

                     Linus

--000e0cd3107a2bbef6049a4d34b4
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gj64qnj40

IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuYyB8ICAgIDUgKysrLS0KIGRy
aXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuaCB8ICAgIDEgLQogMiBmaWxlcyBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5jIGIvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfcmluZ2J1ZmZlci5jCmluZGV4IDAzZTMzNzAuLmY2YjliYWEgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuYworKysgYi9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9yaW5nYnVmZmVyLmMKQEAgLTkyOCw2ICs5MjgsNyBAQCBzdGF0aWMg
aW50IGludGVsX3dyYXBfcmluZ19idWZmZXIoc3RydWN0IGludGVsX3JpbmdfYnVmZmVyICpyaW5n
KQogCiBpbnQgaW50ZWxfd2FpdF9yaW5nX2J1ZmZlcihzdHJ1Y3QgaW50ZWxfcmluZ19idWZmZXIg
KnJpbmcsIGludCBuKQogeworCWludCByZXJlYWQgPSAwOwogCXN0cnVjdCBkcm1fZGV2aWNlICpk
ZXYgPSByaW5nLT5kZXY7CiAJc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRldl9wcml2ID0gZGV2
LT5kZXZfcHJpdmF0ZTsKIAl1bnNpZ25lZCBsb25nIGVuZDsKQEAgLTk0MCw5ICs5NDEsOCBAQCBp
bnQgaW50ZWxfd2FpdF9yaW5nX2J1ZmZlcihzdHJ1Y3QgaW50ZWxfcmluZ19idWZmZXIgKnJpbmcs
IGludCBuKQogCQkgKiBmYWxsYmFjayB0byB0aGUgc2xvdyBhbmQgYWNjdXJhdGUgcGF0aC4KIAkJ
ICovCiAJCWhlYWQgPSBpbnRlbF9yZWFkX3N0YXR1c19wYWdlKHJpbmcsIDQpOwotCQlpZiAoaGVh
ZCA8IHJpbmctPmFjdHVhbF9oZWFkKQorCQlpZiAocmVyZWFkKQogCQkJaGVhZCA9IEk5MTVfUkVB
RF9IRUFEKHJpbmcpOwotCQlyaW5nLT5hY3R1YWxfaGVhZCA9IGhlYWQ7CiAJCXJpbmctPmhlYWQg
PSBoZWFkICYgSEVBRF9BRERSOwogCQlyaW5nLT5zcGFjZSA9IHJpbmctPmhlYWQgLSAocmluZy0+
dGFpbCArIDgpOwogCQlpZiAocmluZy0+c3BhY2UgPCAwKQpAQCAtOTYxLDYgKzk2MSw3IEBAIGlu
dCBpbnRlbF93YWl0X3JpbmdfYnVmZmVyKHN0cnVjdCBpbnRlbF9yaW5nX2J1ZmZlciAqcmluZywg
aW50IG4pCiAJCW1zbGVlcCgxKTsKIAkJaWYgKGF0b21pY19yZWFkKCZkZXZfcHJpdi0+bW0ud2Vk
Z2VkKSkKIAkJCXJldHVybiAtRUFHQUlOOworCQlyZXJlYWQgPSAxOwogCX0gd2hpbGUgKCF0aW1l
X2FmdGVyKGppZmZpZXMsIGVuZCkpOwogCXRyYWNlX2k5MTVfcmluZ193YWl0X2VuZCAoZGV2KTsK
IAlyZXR1cm4gLUVCVVNZOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxf
cmluZ2J1ZmZlci5oIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5oCmlu
ZGV4IGJlOTA4N2UuLjViMGFiZmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2lu
dGVsX3JpbmdidWZmZXIuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9yaW5nYnVm
ZmVyLmgKQEAgLTQ3LDcgKzQ3LDYgQEAgc3RydWN0ICBpbnRlbF9yaW5nX2J1ZmZlciB7CiAJc3Ry
dWN0CQlkcm1fZGV2aWNlICpkZXY7CiAJc3RydWN0CQlkcm1faTkxNV9nZW1fb2JqZWN0ICpvYmo7
CiAKLQl1MzIJCWFjdHVhbF9oZWFkOwogCXUzMgkJaGVhZDsKIAl1MzIJCXRhaWw7CiAJaW50CQlz
cGFjZTsK
--000e0cd3107a2bbef6049a4d34b4--
