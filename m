Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2I0Oyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:54:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59379 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2I0Oym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <201209271523.49437.andres@anarazel.de>
References: <201209171329.15699.andres@anarazel.de>
	<201209270846.00376.andres@anarazel.de>
	<CADnq5_ME14tfMz9ZzVqBFx7TYSyKLc=iPQVthu1n77j-yfdxVA@mail.gmail.com>
	<201209271523.49437.andres@anarazel.de>
Date: Thu, 27 Sep 2012 10:54:40 -0400
Message-ID: <CADnq5_O0Y+=29ZkKxW-DgrAsFh+kiRAJBh0oC+a_SNEPu3VguQ@mail.gmail.com>
Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
From: Alex Deucher <alexdeucher@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: multipart/mixed; boundary=f46d043892b178318f04cab01ec4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043892b178318f04cab01ec4
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 27, 2012 at 9:23 AM, Andres Freund <andres@anarazel.de> wrote:
> On Thursday, September 27, 2012 03:14:31 PM Alex Deucher wrote:
>> On Thu, Sep 27, 2012 at 2:46 AM, Andres Freund <andres@anarazel.de> wrote:
>> > On Wednesday, September 26, 2012 03:42:40 PM Deucher, Alexander wrote:
>> >> > -----Original Message-----
>> >> > From: Andres Freund [mailto:andres@anarazel.de]
>> >> > Sent: Wednesday, September 26, 2012 9:41 AM
>> >> > To: Dan Carpenter
>> >> > Cc: Deucher, Alexander; LKML; David Airlie;
>> >> > dri-devel@lists.freedesktop.org Subject: Re: radeon: Regression
>> >> > between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
>> >> >
>> >> > On Wednesday, September 26, 2012 03:00:09 PM Dan Carpenter wrote:
>> >> > > This is fixed now?
>> >> >
>> >> > Its been reverted in 2f1f4d9b60396d2df4cff829bd5376ffc8ed9a2c which is
>> >> > in rc6.
>> >> >
>> >> > On Monday, September 17, 2012 09:30:12 PM Deucher, Alexander wrote:
>> >> > Sorry, I somehow accidentally marked your  email as read and thus
>> >> > didn't notice it.
>> >> >
>> >> > > I think I see the problem.  I think it's a limitation of the current
>> >> > > current
>> >> >
>> >> > modesetting API.  The current API sets up each display independently
>> >> > which doesn't work so well if there are resource restrictions.  There
>> >> > shouldn't be any contention on your board since you are only using 2
>> >> > non-DP displays.  It looks like X is mapping different crtcs to
>> >> > displays than the kernel fb.
>> >> >
>> >> > Initially the kernel set up the follow:
>> >> > > > [    2.134901] [drm] crtc 0 using pll 0x2
>> >> > > > [    2.362257] [drm] crtc 1 using pll 0x1
>> >> > > > [    2.386709] [drm] crtc 2 using pll 0x0
>> >> > >
>> >> > > Crtc 0 -> DCPLL -> DP
>> >> > > Crtc 1 -> PPLL2 -> DVI
>> >> > > Crtc 2 -> PPLL1 -> DVI
>> >> > >
>> >> > > When X loads, it tried to set a different crtc to display mapping:
>> >> > > > [   60.679310] [drm] crtc 0 using pll 0xff
>> >> > > > [   60.789183] [drm] crtc 1 using pll 0x2
>> >> > > > [   60.819594] [drm] crtc 2 using pll 0x1
>> >> > >
>> >> > > Crtc 0 -> INVALID -> DVI 0
>> >> > > Crtc 1 -> DCPLL -> DP
>> >> > > Crtc 2 -> PPLL2 -> DVI 1
>> >> > >
>> >> > > Crtc 0 should have used PPLL1 or PPLL2, but they were already in use
>> >> > > by crtc 1 and crtc  2 from the previous modeset.  Since the modeset
>> >> > > API is not atomic, it doesn't have the whole picture.  I'm not sure
>> >> > > of a good solution right now prior to the new atomic modeset API
>> >> > > that is under discussion.  I guess we can revert the patch for 3.6.
>> >> > >  For 3.7 I guess we need to validate the actual connector to make
>> >> > > sure we aren't trying to set a different configuration relating to
>> >> > > the same connector without first tearing down the first one.  In
>> >> > > the interim, you should be able to work around it by disabling the
>> >> > > non-DP outputs and then bringing than back up.
>> >> >
>> >> > Thanks! That explanation makes sense. I can work around it just fine,
>> >> > starting X multiple times works which coincides nicely with your
>> >> > explanation.
>> >> >
>> >> > The code in the 3.7 branch doesn't do that extended validation yet,
>> >> > rigth? If you want/need you can CC for testing once thats ready.
>> >>
>> >> It should handle it now.  If you could test it that would be great.
>> >
>> > Ok, just to be sure I tested Linus' tree and everything works fine there.
>> >
>> > Unfortunately thats not the case with a straight merge of
>> > alexdeucher/drm- next-3.7-wip. When gdm started *the first time* the
>> > DVI-connected (uhm, same sink type? Thats the saphire magic allowing
>> > more monitors on that type of graphics card?) I got a "unable to
>> > allocate a PPLL" error again. Logging in/starting a new X seems to fix
>> > that.
>>
>> So you have a xorg.conf with a hardcoded configuration?  If so can you
>> send it to me?
> Yes, but just setting the xrand positions:

Thanks.  I can't seem to reproduce it here, but I've pushed an updated
drm-next-3.7-wip which may help.  If not, can you apply the attached
patch and send me the output?

Thanks,

Alex

--f46d043892b178318f04cab01ec4
Content-Type: application/octet-stream; name="pll_debug.diff"
Content-Disposition: attachment; filename="pll_debug.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7lzgr8o0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKaW5kZXggOTYxODRkMC4uMWY3ZTVm
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysr
IGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKQEAgLTE1NjUsNiArMTU2
NSwxMCBAQCBzdGF0aWMgaW50IHJhZGVvbl9nZXRfc2hhcmVkX25vbmRwX3BwbGwoc3RydWN0IGRy
bV9jcnRjICpjcnRjKQogCQkgICAgIUVOQ09ERVJfTU9ERV9JU19EUChhdG9tYmlvc19nZXRfZW5j
b2Rlcl9tb2RlKHRlc3RfcmFkZW9uX2NydGMtPmVuY29kZXIpKSkgewogCQkJLyogY2hlY2sgaWYg
d2UgYXJlIGFscmVhZHkgZHJpdmluZyB0aGlzIGNvbm5lY3RvciB3aXRoIGFub3RoZXIgY3J0YyAq
LwogCQkJaWYgKHRlc3RfcmFkZW9uX2NydGMtPmNvbm5lY3RvciA9PSByYWRlb25fY3J0Yy0+Y29u
bmVjdG9yKSB7CisJCQkJRFJNX0lORk8oImNydGMgJWQgYW5kIGNydGMgJWQgKDB4JXgpIGJvdGgg
ZHJpdmluZyAlc1xuIiwKKwkJCQkJIHJhZGVvbl9jcnRjLT5jcnRjX2lkLCB0ZXN0X3JhZGVvbl9j
cnRjLT5jcnRjX2lkLAorCQkJCQkgdGVzdF9yYWRlb25fY3J0Yy0+cGxsX2lkLAorCQkJCQkgZHJt
X2dldF9jb25uZWN0b3JfbmFtZShyYWRlb25fY3J0Yy0+Y29ubmVjdG9yKSk7CiAJCQkJLyogaWYg
d2UgYXJlLCByZXR1cm4gdGhhdCBwbGwgKi8KIAkJCQlpZiAodGVzdF9yYWRlb25fY3J0Yy0+cGxs
X2lkICE9IEFUT01fUFBMTF9JTlZBTElEKQogCQkJCQlyZXR1cm4gdGVzdF9yYWRlb25fY3J0Yy0+
cGxsX2lkOwpAQCAtMTU3NCw4ICsxNTc4LDEwIEBAIHN0YXRpYyBpbnQgcmFkZW9uX2dldF9zaGFy
ZWRfbm9uZHBfcHBsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMpCiAJCQlpZiAoKGNydGMtPm1vZGUu
Y2xvY2sgPT0gdGVzdF9jcnRjLT5tb2RlLmNsb2NrKSAmJgogCQkJICAgIChhZGp1c3RlZF9jbG9j
ayA9PSB0ZXN0X2FkanVzdGVkX2Nsb2NrKSAmJgogCQkJICAgIChyYWRlb25fY3J0Yy0+c3NfZW5h
YmxlZCA9PSB0ZXN0X3JhZGVvbl9jcnRjLT5zc19lbmFibGVkKSAmJgotCQkJICAgICh0ZXN0X3Jh
ZGVvbl9jcnRjLT5wbGxfaWQgIT0gQVRPTV9QUExMX0lOVkFMSUQpKQorCQkJICAgICh0ZXN0X3Jh
ZGVvbl9jcnRjLT5wbGxfaWQgIT0gQVRPTV9QUExMX0lOVkFMSUQpKSB7CisJCQkJRFJNX0lORk8o
ImZvdW5kIHBsbCAweCV4IHdpdGggbWF0Y2hlZCBjbG9ja1xuIiwgdGVzdF9yYWRlb25fY3J0Yy0+
cGxsX2lkKTsKIAkJCQlyZXR1cm4gdGVzdF9yYWRlb25fY3J0Yy0+cGxsX2lkOworCQkJfQogCQl9
CiAJfQogCXJldHVybiBBVE9NX1BQTExfSU5WQUxJRDsKQEAgLTE2MzEsNiArMTYzNyw3IEBAIHN0
YXRpYyBpbnQgcmFkZW9uX2F0b21fcGlja19wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjKQogCQkJ
LyogVU5JUEhZIEEgdXNlcyBQUExMMiAqLwogCQkJcmV0dXJuIEFUT01fUFBMTDI7CiAJCWVsc2Ug
aWYgKEVOQ09ERVJfTU9ERV9JU19EUChhdG9tYmlvc19nZXRfZW5jb2Rlcl9tb2RlKHJhZGVvbl9j
cnRjLT5lbmNvZGVyKSkpIHsKKwkJCURSTV9JTkZPKCJjcnRjICVkIGlzIERQXG4iLCByYWRlb25f
Y3J0Yy0+Y3J0Y19pZCk7CiAJCQkvKiBVTklQSFkgQi9DL0QvRS9GICovCiAJCQlpZiAocmRldi0+
Y2xvY2suZHBfZXh0Y2xrKQogCQkJCS8qIHNraXAgUFBMTCBwcm9ncmFtbWluZyBpZiB1c2luZyBl
eHQgY2xvY2sgKi8KQEAgLTE2NDIsNiArMTY0OSw3IEBAIHN0YXRpYyBpbnQgcmFkZW9uX2F0b21f
cGlja19wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjKQogCQkJCQlyZXR1cm4gcGxsOwogCQkJfQog
CQl9IGVsc2UgeworCQkJRFJNX0lORk8oImNydGMgJWQgaXMgbm90IERQXG4iLCByYWRlb25fY3J0
Yy0+Y3J0Y19pZCk7CiAJCQkvKiB1c2UgdGhlIHNhbWUgUFBMTCBmb3IgYWxsIG1vbml0b3JzIHdp
dGggdGhlIHNhbWUgY2xvY2sgKi8KIAkJCXBsbCA9IHJhZGVvbl9nZXRfc2hhcmVkX25vbmRwX3Bw
bGwoY3J0Yyk7CiAJCQlpZiAocGxsICE9IEFUT01fUFBMTF9JTlZBTElEKQpAQCAtMTY0OSw2ICsx
NjU3LDcgQEAgc3RhdGljIGludCByYWRlb25fYXRvbV9waWNrX3BsbChzdHJ1Y3QgZHJtX2NydGMg
KmNydGMpCiAJCX0KIAkJLyogVU5JUEhZIEIvQy9EL0UvRiAqLwogCQlwbGxfaW5fdXNlID0gcmFk
ZW9uX2dldF9wbGxfdXNlX21hc2soY3J0Yyk7CisJCURSTV9JTkZPKCJwbGxzIGluIHVzZSAweCV4
XG4iLCBwbGxfaW5fdXNlKTsKIAkJaWYgKCEocGxsX2luX3VzZSAmICgxIDw8IEFUT01fUFBMTDAp
KSkKIAkJCXJldHVybiBBVE9NX1BQTEwwOwogCQlpZiAoIShwbGxfaW5fdXNlICYgKDEgPDwgQVRP
TV9QUExMMSkpKQpAQCAtMTY2Nyw2ICsxNjc2LDcgQEAgc3RhdGljIGludCByYWRlb25fYXRvbV9w
aWNrX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMpCiAJCSAqIGNydGMgdmlydHVhbCBwaXhlbCBj
bG9jay4KIAkJICovCiAJCWlmIChFTkNPREVSX01PREVfSVNfRFAoYXRvbWJpb3NfZ2V0X2VuY29k
ZXJfbW9kZShyYWRlb25fY3J0Yy0+ZW5jb2RlcikpKSB7CisJCQlEUk1fSU5GTygiY3J0YyAlZCBp
cyBEUFxuIiwgcmFkZW9uX2NydGMtPmNydGNfaWQpOwogCQkJaWYgKHJkZXYtPmNsb2NrLmRwX2V4
dGNsaykKIAkJCQkvKiBza2lwIFBQTEwgcHJvZ3JhbW1pbmcgaWYgdXNpbmcgZXh0IGNsb2NrICov
CiAJCQkJcmV0dXJuIEFUT01fUFBMTF9JTlZBTElEOwpAQCAtMTY4Myw2ICsxNjkzLDcgQEAgc3Rh
dGljIGludCByYWRlb25fYXRvbV9waWNrX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMpCiAJCQkJ
CXJldHVybiBwbGw7CiAJCQl9CiAJCX0gZWxzZSB7CisJCQlEUk1fSU5GTygiY3J0YyAlZCBpcyBu
b3QgRFBcbiIsIHJhZGVvbl9jcnRjLT5jcnRjX2lkKTsKIAkJCS8qIHVzZSB0aGUgc2FtZSBQUExM
IGZvciBhbGwgbW9uaXRvcnMgd2l0aCB0aGUgc2FtZSBjbG9jayAqLwogCQkJcGxsID0gcmFkZW9u
X2dldF9zaGFyZWRfbm9uZHBfcHBsbChjcnRjKTsKIAkJCWlmIChwbGwgIT0gQVRPTV9QUExMX0lO
VkFMSUQpCkBAIC0xNjkwLDYgKzE3MDEsNyBAQCBzdGF0aWMgaW50IHJhZGVvbl9hdG9tX3BpY2tf
cGxsKHN0cnVjdCBkcm1fY3J0YyAqY3J0YykKIAkJfQogCQkvKiBhbGwgb3RoZXIgY2FzZXMgKi8K
IAkJcGxsX2luX3VzZSA9IHJhZGVvbl9nZXRfcGxsX3VzZV9tYXNrKGNydGMpOworCQlEUk1fSU5G
TygicGxscyBpbiB1c2UgMHgleFxuIiwgcGxsX2luX3VzZSk7CiAJCWlmICghKHBsbF9pbl91c2Ug
JiAoMSA8PCBBVE9NX1BQTEwyKSkpCiAJCQlyZXR1cm4gQVRPTV9QUExMMjsKIAkJaWYgKCEocGxs
X2luX3VzZSAmICgxIDw8IEFUT01fUFBMTDEpKSkKQEAgLTE3MDMsMTEgKzE3MTUsMTMgQEAgc3Rh
dGljIGludCByYWRlb25fYXRvbV9waWNrX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMpCiAJCQkg
KiBEQ0UzOiBQUExMMSBvciBQUExMMgogCQkJICovCiAJCQlpZiAoRU5DT0RFUl9NT0RFX0lTX0RQ
KGF0b21iaW9zX2dldF9lbmNvZGVyX21vZGUocmFkZW9uX2NydGMtPmVuY29kZXIpKSkgeworCQkJ
CURSTV9JTkZPKCJjcnRjICVkIGlzIERQXG4iLCByYWRlb25fY3J0Yy0+Y3J0Y19pZCk7CiAJCQkJ
LyogdXNlIHRoZSBzYW1lIFBQTEwgZm9yIGFsbCBEUCBtb25pdG9ycyAqLwogCQkJCXBsbCA9IHJh
ZGVvbl9nZXRfc2hhcmVkX2RwX3BwbGwoY3J0Yyk7CiAJCQkJaWYgKHBsbCAhPSBBVE9NX1BQTExf
SU5WQUxJRCkKIAkJCQkJcmV0dXJuIHBsbDsKIAkJCX0gZWxzZSB7CisJCQkJRFJNX0lORk8oImNy
dGMgJWQgaXMgbm90IERQXG4iLCByYWRlb25fY3J0Yy0+Y3J0Y19pZCk7CiAJCQkJLyogdXNlIHRo
ZSBzYW1lIFBQTEwgZm9yIGFsbCBtb25pdG9ycyB3aXRoIHRoZSBzYW1lIGNsb2NrICovCiAJCQkJ
cGxsID0gcmFkZW9uX2dldF9zaGFyZWRfbm9uZHBfcHBsbChjcnRjKTsKIAkJCQlpZiAocGxsICE9
IEFUT01fUFBMTF9JTlZBTElEKQpAQCAtMTcxNSw2ICsxNzI5LDcgQEAgc3RhdGljIGludCByYWRl
b25fYXRvbV9waWNrX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMpCiAJCQl9CiAJCQkvKiBhbGwg
b3RoZXIgY2FzZXMgKi8KIAkJCXBsbF9pbl91c2UgPSByYWRlb25fZ2V0X3BsbF91c2VfbWFzayhj
cnRjKTsKKwkJCURSTV9JTkZPKCJwbGxzIGluIHVzZSAweCV4XG4iLCBwbGxfaW5fdXNlKTsKIAkJ
CWlmICghKHBsbF9pbl91c2UgJiAoMSA8PCBBVE9NX1BQTEwyKSkpCiAJCQkJcmV0dXJuIEFUT01f
UFBMTDI7CiAJCQlpZiAoIShwbGxfaW5fdXNlICYgKDEgPDwgQVRPTV9QUExMMSkpKQpAQCAtMTgx
MSw3ICsxODI2LDExIEBAIHN0YXRpYyBib29sIGF0b21iaW9zX2NydGNfbW9kZV9maXh1cChzdHJ1
Y3QgZHJtX2NydGMgKmNydGMsCiAJaWYgKCFhdG9tYmlvc19jcnRjX3ByZXBhcmVfcGxsKGNydGMs
IGFkanVzdGVkX21vZGUpKQogCQlyZXR1cm4gZmFsc2U7CiAJLyogcGljayBwbGwgKi8KKwlEUk1f
SU5GTygiPT0gc3RhcnQgY3J0YyAlZCBkcml2aW5nICVzID09XG4iLCByYWRlb25fY3J0Yy0+Y3J0
Y19pZCwKKwkJIGRybV9nZXRfY29ubmVjdG9yX25hbWUocmFkZW9uX2NydGMtPmNvbm5lY3Rvcikp
OwogCXJhZGVvbl9jcnRjLT5wbGxfaWQgPSByYWRlb25fYXRvbV9waWNrX3BsbChjcnRjKTsKKwlE
Uk1fSU5GTygiY3J0YyAlZCB1c2luZyBwbGwgMHgleFxuIiwgcmFkZW9uX2NydGMtPmNydGNfaWQs
IHJhZGVvbl9jcnRjLT5wbGxfaWQpOworCURSTV9JTkZPKCI9PSBlbmQgY3J0YyAlZCA9PVxuIiwg
cmFkZW9uX2NydGMtPmNydGNfaWQpOwogCS8qIGlmIHdlIGNhbid0IGdldCBhIFBQTEwgZm9yIGEg
bm9uLURQIGVuY29kZXIsIGZhaWwgKi8KIAlpZiAoKHJhZGVvbl9jcnRjLT5wbGxfaWQgPT0gQVRP
TV9QUExMX0lOVkFMSUQpICYmCiAJICAgICFFTkNPREVSX01PREVfSVNfRFAoYXRvbWJpb3NfZ2V0
X2VuY29kZXJfbW9kZShyYWRlb25fY3J0Yy0+ZW5jb2RlcikpKQo=
--f46d043892b178318f04cab01ec4--
