Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab2CWTeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:34:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887Ab2CWTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120323154446.GK28523@wantstofly.org>
References: <20120322124919.GG28523@wantstofly.org>
	<CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
	<20120323154446.GK28523@wantstofly.org>
Date: Fri, 23 Mar 2012 15:34:00 -0400
Message-ID: <CADnq5_NAOOsp6-NrnNc3cSTGM=yNXk8yddBPSxFawuONeAu-_Q@mail.gmail.com>
Subject: Re: radeon + DVI->mDP converter + mDP display blank screen issue
 since 3.0
From: Alex Deucher <alexdeucher@gmail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=e89a8f3ba9313ebd8604bbee1b28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f3ba9313ebd8604bbee1b28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 23, 2012 at 11:44 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Fri, Mar 23, 2012 at 10:59:27AM -0400, Alex Deucher wrote:
>
>> > Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
>> > to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DVI
>> > to Mini DisplayPort converter has started to stop giving screen
>> > output on switching from text mode to graphical framebuffer during
>> > system startup.
>> >
>> > I finally had some time to look at this, and it seems to have stopped
>> > working after this commit:
>> >
>> > =A0 =A0 =A0 =A0commit df271bec805b42527d864777ed035fcbb42e76c0
>> > =A0 =A0 =A0 =A0Author: Alex Deucher <alexdeucher@gmail.com>
>> > =A0 =A0 =A0 =A0Date: =A0 Fri May 20 04:34:15 2011 -0400
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0drm/radeon/kms: properly handle bpc >8 in atom =
command tables
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.=
com>
>> > =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
>> >
>> > ...and with the patch below (i.e. reverting part of the commit above)
>> > applied to 3.3 I get screen output again.
>> >
>> > Even though the monitor seems to have an 8 bit panel, it reports 10
>> > bits per channel in its EDID:
>> >
>> > =A0 =A0 =A0 =A0[...]
>> > =A0 =A0 =A0 =A0Manufacturer: APP Model 9226 Serial Number 41959462
>> > =A0 =A0 =A0 =A0Made week 38 of 2010
>> > =A0 =A0 =A0 =A0EDID version: 1.4
>> > =A0 =A0 =A0 =A0Digital display
>> > =A0 =A0 =A0 =A010 bits per primary color channel
>> > =A0 =A0 =A0 =A0DisplayPort interface
>> > =A0 =A0 =A0 =A0Maximum image size: 60 cm x 34 cm
>> > =A0 =A0 =A0 =A0[...]
>> >
>> > The (active, dual link) DVI->mDP converter spec sheet says it supports
>> > 24 bit color, and I'm guessing that it can't deal with 30. =A0Is the
>> > converter at fault here for passing through the EDID unchanged?
>> >
>> > Also, what would be the right way to handle this, a kernel command
>> > line or module option to limit color depth or something like that?
>> > ("Buy a video card with DP output." is a valid answer, I suppose.)
>> >
>> > I have no clue at all about graphics, and I have no idea whatsoever
>> > what I'm doing here, but I just wanted to post this somewhere for
>> > Google to find in case someone else runs into this!
>>
>> I've inquired with out display team on how to best handle this. =A0In
>> the meantime, it's probably best to just default to 8 bpc. =A0Does the
>> attached patch fix your issue?
>
> I've been using the patch below in a custom Fedora 17 kernel RPM, and
> that seems to fix the issue. =A0Your patch seems to be a superset of
> this patch, so logically, your patch should do the trick as well. :)

Can you try the attached patch on top of my previous one?

Alex

>
>
> thanks,
> Lennert
>
>
> diff -up linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c=
.orig linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c
> --- linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c.orig=
 =A0 =A0 =A0 2012-03-22 14:52:20.538854547 +0100
> +++ linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c =A0 =
=A02012-03-22 14:55:39.740794113 +0100
> @@ -550,8 +550,6 @@ static u32 atombios_adjust_pll(struct dr
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (encoder->crtc =3D=3D crtc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_encoder =3D to_rade=
on_encoder(encoder);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0connector =3D radeon_get_c=
onnector_for_encoder(encoder);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (connector && connector-=
>display_info.bpc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D con=
nector->display_info.bpc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0encoder_mode =3D atombios_=
get_encoder_mode(encoder);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_duallink =3D radeon_dig=
_monitor_is_duallink(encoder, mode->clock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((radeon_encoder->devic=
es & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
> @@ -922,7 +920,6 @@ static void atombios_crtc_set_pll(struct
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct radeon_connector_atom_dig *dig_conn=
ector =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_connector->con_priv=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int dp_clock;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (encoder_mode) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ATOM_ENCODER_MODE_DP_MST:
>
>
>
>> From 22ca454eb749968f266d6788a5f4778acc08cc66 Mon Sep 17 00:00:00 2001
>> From: Alex Deucher <alexander.deucher@amd.com>
>> Date: Fri, 23 Mar 2012 10:54:45 -0400
>> Subject: [PATCH] drm/radeon/kms/atom: force bpc to 8 for now
>>
>> Using the bpc (bits per color) specified by the monitor
>> can cause problems in some cases. =A0Until we get a better
>> handle on how to deal with those cases, just use a bpc of 8.
>>
>> Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Cc: stable@kernel.org
>> ---
>> =A0drivers/gpu/drm/radeon/atombios_crtc.c =A0 =A0 | =A0 =A08 +++++---
>> =A0drivers/gpu/drm/radeon/atombios_dp.c =A0 =A0 =A0 | =A0 =A03 +++
>> =A0drivers/gpu/drm/radeon/atombios_encoders.c | =A0 =A04 ++--
>> =A03 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/ra=
deon/atombios_crtc.c
>> index 083b3ea..b5ff1f7 100644
>> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
>> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
>> @@ -588,8 +588,8 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (encoder->crtc =3D=3D crtc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 radeon_encoder =3D to_radeon=
_encoder(encoder);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connector =3D radeon_get_con=
nector_for_encoder(encoder);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (connector && connector->di=
splay_info.bpc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connec=
tor->display_info.bpc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if (connector && connector-=
>display_info.bpc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connec=
tor->display_info.bpc; */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 encoder_mode =3D atombios_ge=
t_encoder_mode(encoder);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_duallink =3D radeon_dig_m=
onitor_is_duallink(encoder, mode->clock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((radeon_encoder->devices=
 & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
>> @@ -965,7 +965,9 @@ static void atombios_crtc_set_pll(struct drm_crtc *c=
rtc, struct drm_display_mode
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct radeon_connector_atom_dig *dig_connec=
tor =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 radeon_connector->con_priv;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int dp_clock;
>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* if (connector->display_info.bpc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_inf=
o.bpc; */
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (encoder_mode) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ATOM_ENCODER_MODE_DP_MST:
>> diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/rade=
on/atombios_dp.c
>> index 6c62be2..c57d856 100644
>> --- a/drivers/gpu/drm/radeon/atombios_dp.c
>> +++ b/drivers/gpu/drm/radeon/atombios_dp.c
>> @@ -405,10 +405,13 @@ static void dp_get_adjust_train(u8 link_status[DP_=
LINK_STATUS_SIZE],
>> =A0/* get bpc from the EDID */
>> =A0static int convert_bpc_to_bpp(int bpc)
>> =A0{
>> +#if 0
>> =A0 =A0 =A0 if (bpc =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 24;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return bpc * 3;
>> +#endif
>> + =A0 =A0 return 24;
>> =A0}
>>
>> =A0/* get the max pix clock supported by the link rate and lane num */
>> diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/dr=
m/radeon/atombios_encoders.c
>> index 468b874..e607c4d 100644
>> --- a/drivers/gpu/drm/radeon/atombios_encoders.c
>> +++ b/drivers/gpu/drm/radeon/atombios_encoders.c
>> @@ -541,7 +541,7 @@ atombios_dig_encoder_setup(struct drm_encoder *encod=
er, int action, int panel_mo
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_clock =3D dig_connector->dp_clock;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_lane_count =3D dig_connector->dp_lane_cou=
nt;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 hpd_id =3D radeon_connector->hpd.hpd;
>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* bpc =3D connector->display_info.bpc; */
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* no dig encoder assigned */
>> @@ -1159,7 +1159,7 @@ atombios_external_encoder_setup(struct drm_encoder=
 *encoder,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_lane_count =3D dig_connector->dp_lane_cou=
nt;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 connector_object_id =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (radeon_connector->connector=
_object_id & OBJECT_ID_MASK) >> OBJECT_ID_SHIFT;
>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* bpc =3D connector->display_info.bpc; */
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 memset(&args, 0, sizeof(args));
>> --
>> 1.7.7.5
>>

--e89a8f3ba9313ebd8604bbee1b28
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-improve-bpc-handling.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-improve-bpc-handling.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h05momkg0

RnJvbSBlYzQzODUyZmM5ZjIyN2E4ZDExZTFlYjk2YTQzMDcwZjg4MTgxNTAxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IEZyaSwgMjMgTWFyIDIwMTIgMTU6MzA6NDggLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uL2ttczogaW1wcm92ZSBicGMgaGFuZGxpbmcKCkltcHJvdmUgaGFuZGxpbmcg
b2YgYnBjIChiaXRzIHBlciBjb2xvcikgaW4gcmFkZW9uLgpJbiBtb3N0IGNhc2VzIHdlIHdhbnQg
OCBleGNlcHQgZm9yIEhETUksIExWRFMsIGFuZCBlRFAuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERl
dWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9hdG9tYmlvc19jcnRjLmMgICAgIHwgICAgNyArLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL2F0b21iaW9zX2RwLmMgICAgICAgfCAgICA3ICstLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRl
b24vYXRvbWJpb3NfZW5jb2RlcnMuYyB8ICAgIDQgKy0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cmFkZW9uX2Nvbm5lY3RvcnMuYyB8ICAgNDcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKwog
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbW9kZS5oICAgICAgIHwgICAgMSArCiA1IGZp
bGVzIGNoYW5nZWQsIDU0IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKaW5kZXggYjVmZjFmNy4uMmZhYjM4ZiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysrIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKQEAgLTU4OCw4ICs1ODgsNyBAQCBzdGF0
aWMgdTMyIGF0b21iaW9zX2FkanVzdF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLAogCQlpZiAo
ZW5jb2Rlci0+Y3J0YyA9PSBjcnRjKSB7CiAJCQlyYWRlb25fZW5jb2RlciA9IHRvX3JhZGVvbl9l
bmNvZGVyKGVuY29kZXIpOwogCQkJY29ubmVjdG9yID0gcmFkZW9uX2dldF9jb25uZWN0b3JfZm9y
X2VuY29kZXIoZW5jb2Rlcik7Ci0JCQkvKiBpZiAoY29ubmVjdG9yICYmIGNvbm5lY3Rvci0+ZGlz
cGxheV9pbmZvLmJwYykKLQkJCQlicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7ICov
CisJCQlicGMgPSByYWRlb25fZ2V0X21vbml0b3JfYnBjKGNvbm5lY3Rvcik7CiAJCQllbmNvZGVy
X21vZGUgPSBhdG9tYmlvc19nZXRfZW5jb2Rlcl9tb2RlKGVuY29kZXIpOwogCQkJaXNfZHVhbGxp
bmsgPSByYWRlb25fZGlnX21vbml0b3JfaXNfZHVhbGxpbmsoZW5jb2RlciwgbW9kZS0+Y2xvY2sp
OwogCQkJaWYgKChyYWRlb25fZW5jb2Rlci0+ZGV2aWNlcyAmIChBVE9NX0RFVklDRV9MQ0RfU1VQ
UE9SVCB8IEFUT01fREVWSUNFX0RGUF9TVVBQT1JUKSkgfHwKQEAgLTk2NSw5ICs5NjQsNyBAQCBz
dGF0aWMgdm9pZCBhdG9tYmlvc19jcnRjX3NldF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLCBz
dHJ1Y3QgZHJtX2Rpc3BsYXlfbW9kZQogCQlzdHJ1Y3QgcmFkZW9uX2Nvbm5lY3Rvcl9hdG9tX2Rp
ZyAqZGlnX2Nvbm5lY3RvciA9CiAJCQlyYWRlb25fY29ubmVjdG9yLT5jb25fcHJpdjsKIAkJaW50
IGRwX2Nsb2NrOwotCi0JCS8qIGlmIChjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGMpCi0JCQli
cGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7ICovCisJCWJwYyA9IHJhZGVvbl9nZXRf
bW9uaXRvcl9icGMoY29ubmVjdG9yKTsKIAogCQlzd2l0Y2ggKGVuY29kZXJfbW9kZSkgewogCQlj
YXNlIEFUT01fRU5DT0RFUl9NT0RFX0RQX01TVDoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vYXRvbWJpb3NfZHAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3Nf
ZHAuYwppbmRleCBjNTdkODU2Li5jYWRiYjEwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL2F0b21iaW9zX2RwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlv
c19kcC5jCkBAIC00MDUsMTMgKzQwNSwxMCBAQCBzdGF0aWMgdm9pZCBkcF9nZXRfYWRqdXN0X3Ry
YWluKHU4IGxpbmtfc3RhdHVzW0RQX0xJTktfU1RBVFVTX1NJWkVdLAogLyogZ2V0IGJwYyBmcm9t
IHRoZSBFRElEICovCiBzdGF0aWMgaW50IGNvbnZlcnRfYnBjX3RvX2JwcChpbnQgYnBjKQogewot
I2lmIDAKIAlpZiAoYnBjID09IDApCiAJCXJldHVybiAyNDsKIAllbHNlCiAJCXJldHVybiBicGMg
KiAzOwotI2VuZGlmCi0JcmV0dXJuIDI0OwogfQogCiAvKiBnZXQgdGhlIG1heCBwaXggY2xvY2sg
c3VwcG9ydGVkIGJ5IHRoZSBsaW5rIHJhdGUgYW5kIGxhbmUgbnVtICovCkBAIC00NjMsNyArNDYw
LDcgQEAgc3RhdGljIGludCByYWRlb25fZHBfZ2V0X2RwX2xhbmVfbnVtYmVyKHN0cnVjdCBkcm1f
Y29ubmVjdG9yICpjb25uZWN0b3IsCiAJCQkJCXU4IGRwY2RbRFBfRFBDRF9TSVpFXSwKIAkJCQkJ
aW50IHBpeF9jbG9jaykKIHsKLQlpbnQgYnBwID0gY29udmVydF9icGNfdG9fYnBwKGNvbm5lY3Rv
ci0+ZGlzcGxheV9pbmZvLmJwYyk7CisJaW50IGJwcCA9IGNvbnZlcnRfYnBjX3RvX2JwcChyYWRl
b25fZ2V0X21vbml0b3JfYnBjKGNvbm5lY3RvcikpOwogCWludCBtYXhfbGlua19yYXRlID0gZHBf
Z2V0X21heF9saW5rX3JhdGUoZHBjZCk7CiAJaW50IG1heF9sYW5lX251bSA9IGRwX2dldF9tYXhf
bGFuZV9udW1iZXIoZHBjZCk7CiAJaW50IGxhbmVfbnVtOwpAQCAtNDgyLDcgKzQ3OSw3IEBAIHN0
YXRpYyBpbnQgcmFkZW9uX2RwX2dldF9kcF9saW5rX2Nsb2NrKHN0cnVjdCBkcm1fY29ubmVjdG9y
ICpjb25uZWN0b3IsCiAJCQkJICAgICAgIHU4IGRwY2RbRFBfRFBDRF9TSVpFXSwKIAkJCQkgICAg
ICAgaW50IHBpeF9jbG9jaykKIHsKLQlpbnQgYnBwID0gY29udmVydF9icGNfdG9fYnBwKGNvbm5l
Y3Rvci0+ZGlzcGxheV9pbmZvLmJwYyk7CisJaW50IGJwcCA9IGNvbnZlcnRfYnBjX3RvX2JwcChy
YWRlb25fZ2V0X21vbml0b3JfYnBjKGNvbm5lY3RvcikpOwogCWludCBsYW5lX251bSwgbWF4X3Bp
eF9jbG9jazsKIAogCWlmIChyYWRlb25fY29ubmVjdG9yX2VuY29kZXJfZ2V0X2RwX2JyaWRnZV9l
bmNvZGVyX2lkKGNvbm5lY3RvcikgPT0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vYXRvbWJpb3NfZW5jb2RlcnMuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3Nf
ZW5jb2RlcnMuYwppbmRleCBlNjA3YzRkLi4wNmIyMDliIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29kZXJzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jCkBAIC01NDEsNyArNTQxLDcgQEAgYXRvbWJpb3NfZGln
X2VuY29kZXJfc2V0dXAoc3RydWN0IGRybV9lbmNvZGVyICplbmNvZGVyLCBpbnQgYWN0aW9uLCBp
bnQgcGFuZWxfbW8KIAkJZHBfY2xvY2sgPSBkaWdfY29ubmVjdG9yLT5kcF9jbG9jazsKIAkJZHBf
bGFuZV9jb3VudCA9IGRpZ19jb25uZWN0b3ItPmRwX2xhbmVfY291bnQ7CiAJCWhwZF9pZCA9IHJh
ZGVvbl9jb25uZWN0b3ItPmhwZC5ocGQ7Ci0JCS8qIGJwYyA9IGNvbm5lY3Rvci0+ZGlzcGxheV9p
bmZvLmJwYzsgKi8KKwkJYnBjID0gcmFkZW9uX2dldF9tb25pdG9yX2JwYyhjb25uZWN0b3IpOwog
CX0KIAogCS8qIG5vIGRpZyBlbmNvZGVyIGFzc2lnbmVkICovCkBAIC0xMTU5LDcgKzExNTksNyBA
QCBhdG9tYmlvc19leHRlcm5hbF9lbmNvZGVyX3NldHVwKHN0cnVjdCBkcm1fZW5jb2RlciAqZW5j
b2RlciwKIAkJZHBfbGFuZV9jb3VudCA9IGRpZ19jb25uZWN0b3ItPmRwX2xhbmVfY291bnQ7CiAJ
CWNvbm5lY3Rvcl9vYmplY3RfaWQgPQogCQkJKHJhZGVvbl9jb25uZWN0b3ItPmNvbm5lY3Rvcl9v
YmplY3RfaWQgJiBPQkpFQ1RfSURfTUFTSykgPj4gT0JKRUNUX0lEX1NISUZUOwotCQkvKiBicGMg
PSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7ICovCisJCWJwYyA9IHJhZGVvbl9nZXRfbW9u
aXRvcl9icGMoY29ubmVjdG9yKTsKIAl9CiAKIAltZW1zZXQoJmFyZ3MsIDAsIHNpemVvZihhcmdz
KSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3Jz
LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3JzLmMKaW5kZXggYmQw
NTE1Ni4uNDk0OGQxMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25f
Y29ubmVjdG9ycy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Nvbm5lY3Rv
cnMuYwpAQCAtODQsNiArODQsNTMgQEAgc3RhdGljIHZvaWQgcmFkZW9uX3Byb3BlcnR5X2NoYW5n
ZV9tb2RlKHN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlcikKIAkJCQkJIGNydGMtPngsIGNydGMt
PnksIGNydGMtPmZiKTsKIAl9CiB9CisKK2ludCByYWRlb25fZ2V0X21vbml0b3JfYnBjKHN0cnVj
dCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IpCit7CisJc3RydWN0IGRybV9kZXZpY2UgKmRldiA9
IGNvbm5lY3Rvci0+ZGV2OworCXN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2ID0gZGV2LT5kZXZf
cHJpdmF0ZTsKKwlzdHJ1Y3QgcmFkZW9uX2Nvbm5lY3RvciAqcmFkZW9uX2Nvbm5lY3RvciA9IHRv
X3JhZGVvbl9jb25uZWN0b3IoY29ubmVjdG9yKTsKKwlpbnQgYnBjID0gODsKKworCXN3aXRjaCAo
Y29ubmVjdG9yLT5jb25uZWN0b3JfdHlwZSkgeworCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0RW
SUk6CisJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfSERNSUI6CisJCWlmIChyYWRlb25fY29ubmVj
dG9yLT51c2VfZGlnaXRhbCkgeworCQkJaWYgKGRybV9kZXRlY3RfaGRtaV9tb25pdG9yKHJhZGVv
bl9jb25uZWN0b3ItPmVkaWQpKSB7CisJCQkJaWYgKGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJw
YykKKwkJCQkJYnBjID0gY29ubmVjdG9yLT5kaXNwbGF5X2luZm8uYnBjOworCQkJfQorCQl9CisJ
CWJyZWFrOworCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0RWSUQ6CisJY2FzZSBEUk1fTU9ERV9D
T05ORUNUT1JfSERNSUE6CisJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfRGlzcGxheVBvcnQ6CisJ
CWlmIChkcm1fZGV0ZWN0X2hkbWlfbW9uaXRvcihyYWRlb25fY29ubmVjdG9yLT5lZGlkKSkgewor
CQkJaWYgKGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYykKKwkJCQlicGMgPSBjb25uZWN0b3It
PmRpc3BsYXlfaW5mby5icGM7CisJCX0KKwkJYnJlYWs7CisJY2FzZSBEUk1fTU9ERV9DT05ORUNU
T1JfZURQOgorCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0xWRFM6CisJCWlmIChjb25uZWN0b3It
PmRpc3BsYXlfaW5mby5icGMpCisJCQlicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7
CisJCWVsc2UgaWYgKEFTSUNfSVNfRENFNDEocmRldikgfHwgQVNJQ19JU19EQ0U1KHJkZXYpKSB7
CisJCQlzdHJ1Y3QgZHJtX2Nvbm5lY3Rvcl9oZWxwZXJfZnVuY3MgKmNvbm5lY3Rvcl9mdW5jcyA9
CisJCQkJY29ubmVjdG9yLT5oZWxwZXJfcHJpdmF0ZTsKKwkJCXN0cnVjdCBkcm1fZW5jb2RlciAq
ZW5jb2RlciA9IGNvbm5lY3Rvcl9mdW5jcy0+YmVzdF9lbmNvZGVyKGNvbm5lY3Rvcik7CisJCQlz
dHJ1Y3QgcmFkZW9uX2VuY29kZXIgKnJhZGVvbl9lbmNvZGVyID0gdG9fcmFkZW9uX2VuY29kZXIo
ZW5jb2Rlcik7CisJCQlzdHJ1Y3QgcmFkZW9uX2VuY29kZXJfYXRvbV9kaWcgKmRpZyA9IHJhZGVv
bl9lbmNvZGVyLT5lbmNfcHJpdjsKKworCQkJaWYgKGRpZy0+bGNkX21pc2MgJiBBVE9NX1BBTkVM
X01JU0NfVjEzXzZCSVRfUEVSX0NPTE9SKQorCQkJCWJwYyA9IDY7CisJCQllbHNlIGlmIChkaWct
PmxjZF9taXNjICYgQVRPTV9QQU5FTF9NSVNDX1YxM184QklUX1BFUl9DT0xPUikKKwkJCQlicGMg
PSA4OworCQl9CisJCWJyZWFrOworCX0KKwlyZXR1cm4gYnBjOworfQorCiBzdGF0aWMgdm9pZAog
cmFkZW9uX2Nvbm5lY3Rvcl91cGRhdGVfc2NyYXRjaF9yZWdzKHN0cnVjdCBkcm1fY29ubmVjdG9y
ICpjb25uZWN0b3IsIGVudW0gZHJtX2Nvbm5lY3Rvcl9zdGF0dXMgc3RhdHVzKQogewpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbW9kZS5oIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yYWRlb25fbW9kZS5oCmluZGV4IGY3ZWI1ZDguLmIyY2NhNmEgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX21vZGUuaAorKysgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JhZGVvbl9tb2RlLmgKQEAgLTQ3Niw2ICs0NzYsNyBAQCBleHRlcm4gdTE2
IHJhZGVvbl9lbmNvZGVyX2dldF9kcF9icmlkZ2VfZW5jb2Rlcl9pZChzdHJ1Y3QgZHJtX2VuY29k
ZXIgKmVuY29kZXIpOwogZXh0ZXJuIHUxNiByYWRlb25fY29ubmVjdG9yX2VuY29kZXJfZ2V0X2Rw
X2JyaWRnZV9lbmNvZGVyX2lkKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IpOwogZXh0
ZXJuIGJvb2wgcmFkZW9uX2Nvbm5lY3Rvcl9lbmNvZGVyX2lzX2hicjIoc3RydWN0IGRybV9jb25u
ZWN0b3IgKmNvbm5lY3Rvcik7CiBleHRlcm4gYm9vbCByYWRlb25fY29ubmVjdG9yX2lzX2RwMTJf
Y2FwYWJsZShzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yKTsKK2V4dGVybiBpbnQgcmFk
ZW9uX2dldF9tb25pdG9yX2JwYyhzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVjdG9yKTsKIAog
ZXh0ZXJuIHZvaWQgcmFkZW9uX2Nvbm5lY3Rvcl9ob3RwbHVnKHN0cnVjdCBkcm1fY29ubmVjdG9y
ICpjb25uZWN0b3IpOwogZXh0ZXJuIGludCByYWRlb25fZHBfbW9kZV92YWxpZF9oZWxwZXIoc3Ry
dWN0IGRybV9jb25uZWN0b3IgKmNvbm5lY3RvciwKLS0gCjEuNy43LjUKCg==
--e89a8f3ba9313ebd8604bbee1b28--
