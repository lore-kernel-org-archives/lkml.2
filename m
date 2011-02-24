Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1BXIZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:25:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46465 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1BXIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CkvdV0RQFIKxRdnP8If+WFwjKkOeyu34Pg3/1j7XwKOs0/nP7h23fDpl1oUVF+jPul
         ZTaguONXAACMYaihJi3Re1Bn06Yjc+4VUdn2yQY6/LvA8+1O8s2BMk0VMiABUhyq3Q9U
         LAbetvl4VgGQUqLTyrm+TBkgL6EEhD9U5olec=
MIME-Version: 1.0
In-Reply-To: <1298494135-16751-2-git-send-email-konrad.wilk@oracle.com>
References: <1298494135-16751-1-git-send-email-konrad.wilk@oracle.com>
	<1298494135-16751-2-git-send-email-konrad.wilk@oracle.com>
Date: Thu, 24 Feb 2011 03:25:43 -0500
Message-ID: <AANLkTi==tDG6wMVNTSYjucZH+g-G3P6OiqSmHXWm8LP9@mail.gmail.com>
Subject: Re: [PATCH] radeon: DMA unmap dummy page during unload/unbind.
From: Alex Deucher <alexdeucher@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016368e29f7aaa102049d02f5bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016368e29f7aaa102049d02f5bc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2011 at 3:48 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> git commit 82568565683b4991964a5fc89a9ca0c7122818e8 adds a dummy page
> so that if something goes wrong it will at least fetch/write data
> _only_ to this location.
>
> The radeon_gart_init sets it up.. but there is no corresponding
> free-ing of this dummy page. There is one invocation to free-ing
> the dummy page in r600.c but nothing in the radeon_gart_fini path.
>
> This patch adds in the unloading/unbind path the free-ing of said
> dummy page.

This patch looks good, but we might as go one step further and just
remove the dummy page stuff from r600.c, rv770.c and evergreen.c and
just consolidate it in gart_init() and gart_fini().  See the attached
patch.

Alex

>
> Without this patch and if we have CONFIG_DMA_API_DEBUG=3Dy set we
> get this:
>
> [ =A0 22.113420] drm: unregistered panic notifier
> [ =A0 22.126500] [drm] radeon: finishing device.
> [ =A0 22.130868] [drm] radeon: cp finalized
> [ =A0 22.135384] [TTM] Finalizing pool allocator.
> [ =A0 22.139669] [TTM] Zone =A0kernel: Used memory at exit: 0 kiB.
> [ =A0 22.145229] [drm] radeon: ttm finalized
> [ =A0 22.149055] vga_switcheroo: disabled
> [ =A0 22.153393] ------------[ cut here ]------------
> [ =A0 22.158021] WARNING: at /home/konrad/ssd/linux/lib/dma-debug.c:689 d=
ma_debug_device_change+0x12e/0x161()
> [ =A0 22.167475] Hardware name: PowerEdge T105
> [ =A0 22.171562] pci 0000:01:08.0: DMA-API: device driver has pending DMA=
 allocations while released from device [count=3D1]
>
> With this patch we don't see this anymore.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> =A0drivers/gpu/drm/radeon/radeon_gart.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeo=
n/radeon_gart.c
> index 6501611..dc04c7b 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -269,4 +269,6 @@ void radeon_gart_fini(struct radeon_device *rdev)
> =A0 =A0 =A0 =A0kfree(rdev->gart.pages_addr);
> =A0 =A0 =A0 =A0rdev->gart.pages =3D NULL;
> =A0 =A0 =A0 =A0rdev->gart.pages_addr =3D NULL;
> +
> + =A0 =A0 =A0 radeon_dummy_page_fini(rdev);
> =A0}
> --
> 1.7.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

--0016368e29f7aaa102049d02f5bc
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-clean-up-gart-dummy-page-handling.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-clean-up-gart-dummy-page-handling.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkjerg1a0

RnJvbSBkMjJiYmEzMGE2NmJhOTVjYWJlZWQ3YTcxYzk4MmRmYTk2NTIxMzg0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogVGh1LCAyNCBGZWIgMjAxMSAwMzoxNjoyMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBjbGVhbiB1cCBnYXJ0IGR1bW15IHBhZ2UgaGFuZGxpbmcKCkFzIHBlciBL
b25yYWQncyBvcmlnaW5hbCBwYXRjaCwgdGhlIGR1bW15IHBhZ2UgdXNlZApieSB0aGUgZ2FydCBj
b2RlIGFuZCBhbGxvY2F0ZWQgaW4gcmFkZW9uX2dhcnRfaW5pdCgpCndhcyBub3QgZnJlZWQgcHJv
cGVybHkgaW4gcmFkZW9uX2dhcnRfZmluaSgpLgoKQXQgdGhlIHNhbWUgdGltZSByNnh4IGFuZCBu
ZXdlciBhbGxvY2F0ZWQgYW5kIGZyZWVkIHRoZQpkdW1teSBwYWdlIG9uIHRoZWlyIG93bi4gIFNv
IHRvIGRvIEtvbnJhZCdzIHBhdGNoIG9uZQpiZXR0ZXIsIGp1c3QgcmVtb3ZlIHRoZSBhbGxvY2F0
aW9uIGFuZCBmcmVlaW5nIG9mIHRoZQpkdW1teSBwYWdlIGluIHRoZSByNnh4LCA3eHgsIGV2ZXJn
cmVlbiwgYW5kIG5pIGNvZGUgYW5kCmFsbG9jYXRlIGFuZCBmcmVlIGluIHRoZSBnYXJ0X2luaXQv
ZmluaSgpIGZ1bmN0aW9ucyBmb3IKYWxsIGFzaWNzLgoKQ2M6IEtvbnJhZCBSemVzenV0ZWsgV2ls
ayA8a29ucmFkLndpbGtAb3JhY2xlLmNvbT4KQ2M6IEplcm9tZSBHbGlzc2UgPGpnbGlzc2VAcmVk
aGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hlckBnbWFpbC5j
b20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYyAgIHwgICAgNCAtLS0t
CiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyAgICAgICAgfCAgICA0IC0tLS0KIGRyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2dhcnQuYyB8ICAgIDIgKysKIGRyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcnY3NzAuYyAgICAgICB8ICAgIDQgLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vZXZlcmdyZWVuLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbi5j
CmluZGV4IDc4OTQ0MWUuLjllY2IyYjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vZXZlcmdyZWVuLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW4uYwpA
QCAtMzA0OCw5ICszMDQ4LDYgQEAgaW50IGV2ZXJncmVlbl9pbml0KHN0cnVjdCByYWRlb25fZGV2
aWNlICpyZGV2KQogewogCWludCByOwogCi0JciA9IHJhZGVvbl9kdW1teV9wYWdlX2luaXQocmRl
dik7Ci0JaWYgKHIpCi0JCXJldHVybiByOwogCS8qIFRoaXMgZG9uJ3QgZG8gbXVjaCAqLwogCXIg
PSByYWRlb25fZ2VtX2luaXQocmRldik7CiAJaWYgKHIpCkBAIC0zMTYyLDcgKzMxNTksNiBAQCB2
b2lkIGV2ZXJncmVlbl9maW5pKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQogCXJhZGVvbl9h
dG9tYmlvc19maW5pKHJkZXYpOwogCWtmcmVlKHJkZXYtPmJpb3MpOwogCXJkZXYtPmJpb3MgPSBO
VUxMOwotCXJhZGVvbl9kdW1teV9wYWdlX2ZpbmkocmRldik7CiB9CiAKIHN0YXRpYyB2b2lkIGV2
ZXJncmVlbl9wY2llX2dlbjJfZW5hYmxlKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3I2MDAuYwppbmRleCAxMjUyMTk4Li44OGVhZmZjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3I2MDAuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAu
YwpAQCAtMjUxMCw5ICsyNTEwLDYgQEAgaW50IHI2MDBfaW5pdChzdHJ1Y3QgcmFkZW9uX2Rldmlj
ZSAqcmRldikKIHsKIAlpbnQgcjsKIAotCXIgPSByYWRlb25fZHVtbXlfcGFnZV9pbml0KHJkZXYp
OwotCWlmIChyKQotCQlyZXR1cm4gcjsKIAlpZiAocjYwMF9kZWJ1Z2ZzX21jX2luZm9faW5pdChy
ZGV2KSkgewogCQlEUk1fRVJST1IoIkZhaWxlZCB0byByZWdpc3RlciBkZWJ1Z2ZzIGZpbGUgZm9y
IG1jICFcbiIpOwogCX0KQEAgLTI2MjYsNyArMjYyMyw2IEBAIHZvaWQgcjYwMF9maW5pKHN0cnVj
dCByYWRlb25fZGV2aWNlICpyZGV2KQogCXJhZGVvbl9hdG9tYmlvc19maW5pKHJkZXYpOwogCWtm
cmVlKHJkZXYtPmJpb3MpOwogCXJkZXYtPmJpb3MgPSBOVUxMOwotCXJhZGVvbl9kdW1teV9wYWdl
X2ZpbmkocmRldik7CiB9CiAKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
YWRlb25fZ2FydC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZ2FydC5jCmluZGV4
IDY1MDE2MTEuLmRjMDRjN2IgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2dhcnQuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9nYXJ0LmMKQEAg
LTI2OSw0ICsyNjksNiBAQCB2b2lkIHJhZGVvbl9nYXJ0X2Zpbmkoc3RydWN0IHJhZGVvbl9kZXZp
Y2UgKnJkZXYpCiAJa2ZyZWUocmRldi0+Z2FydC5wYWdlc19hZGRyKTsKIAlyZGV2LT5nYXJ0LnBh
Z2VzID0gTlVMTDsKIAlyZGV2LT5nYXJ0LnBhZ2VzX2FkZHIgPSBOVUxMOworCisJcmFkZW9uX2R1
bW15X3BhZ2VfZmluaShyZGV2KTsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcnY3NzAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnY3NzAuYwppbmRleCBkOGJhNjc2
Li42YTMxMmU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NzcwLmMKKysr
IGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjc3MC5jCkBAIC0xMjU2LDkgKzEyNTYsNiBAQCBp
bnQgcnY3NzBfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIHsKIAlpbnQgcjsKIAot
CXIgPSByYWRlb25fZHVtbXlfcGFnZV9pbml0KHJkZXYpOwotCWlmIChyKQotCQlyZXR1cm4gcjsK
IAkvKiBUaGlzIGRvbid0IGRvIG11Y2ggKi8KIAlyID0gcmFkZW9uX2dlbV9pbml0KHJkZXYpOwog
CWlmIChyKQpAQCAtMTM3Myw3ICsxMzcwLDYgQEAgdm9pZCBydjc3MF9maW5pKHN0cnVjdCByYWRl
b25fZGV2aWNlICpyZGV2KQogCXJhZGVvbl9hdG9tYmlvc19maW5pKHJkZXYpOwogCWtmcmVlKHJk
ZXYtPmJpb3MpOwogCXJkZXYtPmJpb3MgPSBOVUxMOwotCXJhZGVvbl9kdW1teV9wYWdlX2Zpbmko
cmRldik7CiB9CiAKIHN0YXRpYyB2b2lkIHJ2NzcwX3BjaWVfZ2VuMl9lbmFibGUoc3RydWN0IHJh
ZGVvbl9kZXZpY2UgKnJkZXYpCi0tIAoxLjcuMS4xCgo=
--0016368e29f7aaa102049d02f5bc--
