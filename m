Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0DACTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:19:37 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57280 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab0DACTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pIgCbLSfM9Pb1PRImkCxtoXqw0pHrsXBRg3YISys97KH6nVxqAaHmzDy+Xhs/rWu9d
         ZXtCRQqtgqqoL4WNuyP52np3iNOjL9smFQ5IwYZc2tXsZRHDvqvN4LMMOD6nxgQJbZmn
         FeNN3uZCXM3d/Nw+jTV3MvPY+CA7KrMFLIDbo=
MIME-Version: 1.0
In-Reply-To: <201004010313.32920.rjw@sisk.pl>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
Date: Wed, 31 Mar 2010 22:19:32 -0400
Message-ID: <u2ta728f9f91003311919lef17adc1s4ee009c7d18454e9@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gamil.com>, dri-devel@lists.sourceforge.net,
       stable@kernel.org, Dave Airlie <airlied@gmail.com>
Content-Type: multipart/mixed; boundary=00151747681642c1540483237e59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747681642c1540483237e59
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 31, 2010 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 30 March 2010, Rafael J. Wysocki wrote:
>> On Tuesday 30 March 2010, Linus Torvalds wrote:
>> ...
>> > Other than that? Random fixes and updates all over. Mostly drivers and
>> > filesystems, and mostly fairly small things. If you had PCI resource
>> > conflict problems with the early -rc's due to the _CRS window thing, f=
or
>> > example, that should hopefully be fixed. See the appended shortlog for
>> > other details.
>>
>> ...
>>
>> > Clemens Ladisch (4):
>> > =A0 =A0 =A0 firewire: core: fw_iso_resource_manage: fix error handling
>> > =A0 =A0 =A0 firewire: ohci: add cycle timer quirk for the TI TSB12LV22
>> > =A0 =A0 =A0 ALSA: cmipci: work around invalid PCM pointer
>> > =A0 =A0 =A0 PCI quirk: RS780/RS880: work around missing MSI initializa=
tion
>>
>> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test b=
ox
>> which happens to have a RS780.
>>
>> The symptom is that every operation involving the GPU is _very_ slow, so=
 the
>> window manager eventually disables compositing. =A0Reverting this commit=
 makes
>> things work flawlessly again.
>>
>> So, please revert.
>>
>> BTW, I don't think it's a -stable material.
>
> OK, I've verified that partial revert (below) is sufficient.
>
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: DRM / radeon: Really do not try to enable MSI on RS780 and RS880
>
> Commit a5ee4eb75413c145334c30e43f1af9875dad6fd7
> (PCI quirk: RS780/RS880: work around missing MSI initialization)
> removed a quirk to disable MSI on RS780 and RS880, which still is
> necessary on my Acer Ferrari One, because pci_enable_msi() attempts
> to enable the MSI and apparently succeeds despite the PCI quirk
> added by that commit. =A0Add the removed radeon quirk again.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> =A0drivers/gpu/drm/radeon/radeon_irq_kms.c | =A0 =A08 +++++++-
> =A01 file changed, 7 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/gpu/drm/radeon/radeon_irq_kms.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/gpu/drm/radeon/radeon_irq_kms.c
> +++ linux-2.6/drivers/gpu/drm/radeon/radeon_irq_kms.c
> @@ -116,7 +116,13 @@ int radeon_irq_kms_init(struct radeon_de
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/* enable msi */
> =A0 =A0 =A0 =A0rdev->msi_enabled =3D 0;
> - =A0 =A0 =A0 if (rdev->family >=3D CHIP_RV380) {
> + =A0 =A0 =A0 /* MSIs don't seem to work on my rs780;
> + =A0 =A0 =A0 =A0* not sure about rs880 or other rs780s.
> + =A0 =A0 =A0 =A0* Needs more investigation.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if ((rdev->family >=3D CHIP_RV380) &&
> + =A0 =A0 =A0 =A0 =A0 (rdev->family !=3D CHIP_RS780) &&
> + =A0 =A0 =A0 =A0 =A0 (rdev->family !=3D CHIP_RS880)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ret =3D pci_enable_msi(rdev->pdev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdev->msi_enabled =3D 1;

I also have the attached patch queued in via Dave's tree to disable
MSI on all IGP chips for the time being.

Alex

--00151747681642c1540483237e59
Content-Type: application/mbox; 
	name="0001-drm-radeon-kms-disable-MSI-on-IGP-chips.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-disable-MSI-on-IGP-chips.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g7gxr73t0

RnJvbSBkYmE0MGE1NWFjNWMzM2IxNTdkZWU3YjVmYTUzMDAwZDE5ZmZjYTZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAzMCBNYXIgMjAxMCAxNzoyMjozMiAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBkaXNhYmxlIE1TSSBvbiBJR1AgY2hpcHMKCkRvZXNuJ3Qgc2VlbSB0byB3
b3JrIHJlbGlhYmx5IGFuZCB0aGUgcGNpIHF1aXJrcyBkb24ndAphbHdheXMgd29yay4KClNpZ25l
ZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGRldWNoZXJAZ21haWwuY29tPgotLS0KIGRyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2lycV9rbXMuYyB8ICAgIDggKysrLS0tLS0KIDEgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2lycV9rbXMuYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uX2lycV9rbXMuYwppbmRleCA2ODUxOWI0Li5hMjEyMDQxIDEwMDY0NAot
LS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9pcnFfa21zLmMKKysrIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yYWRlb25faXJxX2ttcy5jCkBAIC0xMTQsMTMgKzExNCwxMSBAQCBp
bnQgcmFkZW9uX2lycV9rbXNfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAl9CiAJ
LyogZW5hYmxlIG1zaSAqLwogCXJkZXYtPm1zaV9lbmFibGVkID0gMDsKLQkvKiBNU0lzIGRvbid0
IHNlZW0gdG8gd29yayBvbiBteSByczc4MDsKLQkgKiBub3Qgc3VyZSBhYm91dCByczg4MCBvciBv
dGhlciByczc4MHMuCi0JICogTmVlZHMgbW9yZSBpbnZlc3RpZ2F0aW9uLgorCS8qIE1TSXMgZG9u
J3Qgc2VlbSB0byB3b3JrIHJlbGlhYmx5IG9uIGFsbCBJR1AKKwkgKiBjaGlwcy4gIERpc2FibGUg
TVNJIG9uIHRoZW0gZm9yIG5vdy4KIAkgKi8KIAlpZiAoKHJkZXYtPmZhbWlseSA+PSBDSElQX1JW
MzgwKSAmJgotCSAgICAocmRldi0+ZmFtaWx5ICE9IENISVBfUlM3ODApICYmCi0JICAgIChyZGV2
LT5mYW1pbHkgIT0gQ0hJUF9SUzg4MCkpIHsKKwkgICAgKCEocmRldi0+ZmxhZ3MgJiBSQURFT05f
SVNfSUdQKSkpIHsKIAkJaW50IHJldCA9IHBjaV9lbmFibGVfbXNpKHJkZXYtPnBkZXYpOwogCQlp
ZiAoIXJldCkgewogCQkJcmRldi0+bXNpX2VuYWJsZWQgPSAxOwotLSAKMS41LjYuMwoK
--00151747681642c1540483237e59--
