Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0FHAtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:49:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0FHAtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=A9WW0eZS2lDuft027JJTuxA6b7Hfq+Muv7PZxr1Xca+e00j2NZq764orOaupkbGdnG
         CiHoNgRohch4YT6wlElGOJ2CeCcGHNf4Z62AI8FVELS88A1Z0t8O2j3J/uaFcwLDbAtz
         8zpzaQdmozIKOGFnS4CraQ5D41qEYnCFeRGto=
MIME-Version: 1.0
Date: Tue, 8 Jun 2010 10:49:31 +1000
Message-ID: <AANLkTikEGSZUBy8VZOIUhA8iAPa5p7r9vmN47hiEwSB8@mail.gmail.com>
Subject: radeon blink during probe regression (was Re: Linux 2.6.35-rc2)
From: Dave Airlie <airlied@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636b2ae399197e004887a2929
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636b2ae399197e004887a2929
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

(changing subject

On Tue, Jun 8, 2010 at 3:28 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Mon, Jun 7, 2010 at 8:52 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Mon, Jun 7, 2010 at 4:32 PM, Alex Deucher <alexdeucher@gmail.com> wro=
te:
>>> On Mon, Jun 7, 2010 at 2:22 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>> On Mon, Jun 7, 2010 at 4:09 PM, Torsten Kaiser
>>>> <just.for.lkml@googlemail.com> wrote:
>>>>> The switchoff intervall is ~10 seconds, not 1..2 as I guessed in the =
first mail.
>>>>> Any idea if there is something in the KMS code that triggers at this =
intervall?
>>>>
>>>> The new mode probing code happens every 10 seconds, though we
>>>> shouldn't be turning anything on or off with it.
>>>>
>>>> So I suspect the DAC detection table might be doing bad things on your
>>>> hardware, we have had a problem where the dac detect table on one DAC
>>>> would turn the other one off which clearly wasn't what we wanted to
>>>> see.
>>>> ,
>>>
>>> The x300 is a non-atom card, so it uses the legacy load detection
>>> routines which do mess with some of the crtc regs.
>>>
>>
>> Okay I see it now, I'm amazed that I was seeing this issue last week
>> and blaming it on something complete different and only seeing it on
>> one card.
>>
>> I expect its the same problem I'll try and track down a proper fix for
>> it tomorrow.
>
> It really seems to be this polling code.
> After the fix to drivers/char/vt.c the 2.6.35-rc2 kernel now works for
> me without crashing.
>
> I also changed #define DRM_OUTPUT_POLL_PERIOD (10*HZ) to
> #define DRM_OUTPUT_POLL_PERIOD (3*HZ) and now the flickering before X
> starts is at a three second interval. That should prove, that the
> polling from drm_crtc_helper.c is the cause.
>
> After X starts the LCD is stable, but the secondary CRT still flickers
> every 3 seconds.
>
> My hardware is an X300-PCIe card with a VGA-, a DVI-I- and a video output=
.
> I have a 1280x1024 LCD attached to the DVI-I and an old CRT to the
> VGA. The video output is unused.
> The CRT is normally switched off, but its still detected correctly.
>
> The kernel output from 2.6.34 and 2.6.35-rc2 is here:
> http://lkml.org/lkml/2010/6/6/126
>
> xrandr says:
> Screen 0: minimum 320 x 200, current 2080 x 1024, maximum 4096 x 4096
> DVI-0 connected 1280x1024+0+0 (normal left inverted right x axis y
> axis) 338mm x 270mm
> =A0 1280x1024 =A0 =A0 =A060.0*+ =A0 75.0
> =A0 1280x960 =A0 =A0 =A0 60.0
> =A0 1152x864 =A0 =A0 =A0 75.0
> =A0 1024x768 =A0 =A0 =A0 75.1 =A0 =A0 70.1 =A0 =A0 60.0
> =A0 832x624 =A0 =A0 =A0 =A074.6
> =A0 800x600 =A0 =A0 =A0 =A072.2 =A0 =A0 75.0 =A0 =A0 60.3 =A0 =A0 56.2
> =A0 640x480 =A0 =A0 =A0 =A072.8 =A0 =A0 75.0 =A0 =A0 66.7 =A0 =A0 60.0
> =A0 720x400 =A0 =A0 =A0 =A070.1
> =A0 640x400 =A0 =A0 =A0 =A070.0
> VGA-0 connected 800x600+1280+150 (normal left inverted right x axis y
> axis) 280mm x 210mm
> =A0 800x600 =A0 =A0 =A0 =A072.2*+ =A0 75.0 =A0 =A0 60.3 =A0 =A0 56.2
> =A0 1280x1024 =A0 =A0 =A060.0
> =A0 1024x768 =A0 =A0 =A0 75.1 =A0 =A0 70.1 =A0 =A0 60.0
> =A0 640x480 =A0 =A0 =A0 =A072.8 =A0 =A0 75.0 =A0 =A0 60.0
> =A0 720x400 =A0 =A0 =A0 =A087.8 =A0 =A0 70.1
> S-video disconnected (normal left inverted right x axis y axis)
>
> If you have something for me to try, just send it. :-)
>
> Torsten
>

Okay here is a patch that seems to work on my test system, but I want
to give it a bit more playing around with before I sent it onwards.

Alex, seem sane to you?

Dave.

--001636b2ae399197e004887a2929
Content-Type: application/mbox; 
	name="0001-drm-radeon-don-t-poll-tv-dac-if-crtc2-is-in-use.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-don-t-poll-tv-dac-if-crtc2-is-in-use.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ga60duzj0

RnJvbSA3MGU4OTIzNTllZDY4NGY3OTVmNjllMmViYjg0Yjg2MWY5NzQyMWQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBUdWUsIDggSnVuIDIwMTAgMTA6NDI6MjggKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vcmFk
ZW9uOiBkb24ndCBwb2xsIHR2IGRhYyBpZiBjcnRjMiBpcyBpbiB1c2UuCgpTbyB3aGVuIHdlIGFk
ZGVkIG91dHB1dCBwb2xsaW5nLCB3ZSdkIHN1ZGRlbmx5IHVzZSB0aGlzIGNvZGUgbW9yZSBvZnRl
biwgYW5kIHRoZSBmYWN0IHRoYXQgaXQgYWx3YXlzIHRha2VzIG92ZXIgY3J0YzIgYW5kIG1lc3Nl
cyB3aXRoIGl0IGR1cmluZyBwcm9iaW5nIGlzbid0IHdoYXQgd2UgcmVhbGx5IHdhbnQgdG8gYmUg
aGFwcGVuaW5nLiBBIG1vcmUgY29tcGxldGUgZml4IHdvdWxkIHRvIGNoYW5nZSBpdCB0byB1c2Ug
d2hhdGV2ZXIgY3J0YyB3YXMgZnJlZSBhdCB0aGUgdGltZSwgYnV0IGZvciBub3cgbGV0cyBzdGF5
IHNpbXBsZSBhbmQganVzdCBkb24ndCBwb2xsIGlmIGNydGMyIGlzIGFscmVhZHkgaW4gdXNlLgoK
SW4gdGhlb3J5IGZpeGVzIGZvciByZWdyZXNzaW9uIHJlcG9ydGVkIGluOiAiTGludXggMi42LjM1
LXJjMiIgdGhyZWFkLgoKUmVwb3J0ZWQtYnk6IFRvcnN0ZW4gS2Fpc2VyIDxqdXN0LmZvci5sa21s
QGdvb2dsZW1haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRo
YXQuY29tPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2xlZ2FjeV9lbmNvZGVy
cy5jIHwgICAxMSArKysrKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCsp
LCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2xlZ2FjeV9lbmNvZGVycy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbGVn
YWN5X2VuY29kZXJzLmMKaW5kZXggNWExM2IzZS4uNWIwN2I4OCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbGVnYWN5X2VuY29kZXJzLmMKKysrIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25fbGVnYWN5X2VuY29kZXJzLmMKQEAgLTExNjgsNiArMTE2OCwx
NyBAQCBzdGF0aWMgZW51bSBkcm1fY29ubmVjdG9yX3N0YXR1cyByYWRlb25fbGVnYWN5X3R2X2Rh
Y19kZXRlY3Qoc3RydWN0IGRybV9lbmNvZGVyCiAJc3RydWN0IHJhZGVvbl9lbmNvZGVyICpyYWRl
b25fZW5jb2RlciA9IHRvX3JhZGVvbl9lbmNvZGVyKGVuY29kZXIpOwogCXN0cnVjdCByYWRlb25f
ZW5jb2Rlcl90dl9kYWMgKnR2X2RhYyA9IHJhZGVvbl9lbmNvZGVyLT5lbmNfcHJpdjsKIAlib29s
IGNvbG9yID0gdHJ1ZTsKKwlzdHJ1Y3QgZHJtX2NydGMgKmNydGM7CisKKwkvKiBmaW5kIG91dCBp
ZiBjcnRjMiBpcyBpbiB1c2Ugb3IgaWYgdGhpcyBlbmNvZGVyIGlzIHVzaW5nIGl0ICovCisJbGlz
dF9mb3JfZWFjaF9lbnRyeShjcnRjLCAmZGV2LT5tb2RlX2NvbmZpZy5jcnRjX2xpc3QsIGhlYWQp
IHsKKwkJc3RydWN0IHJhZGVvbl9jcnRjICpyYWRlb25fY3J0YyA9IHRvX3JhZGVvbl9jcnRjKGNy
dGMpOworCQlpZiAoKHJhZGVvbl9jcnRjLT5jcnRjX2lkID09IDEpICYmIGNydGMtPmVuYWJsZWQp
IHsKKwkJCWlmIChlbmNvZGVyLT5jcnRjICE9IGNydGMpIHsKKwkJCQlyZXR1cm4gY29ubmVjdG9y
X3N0YXR1c19kaXNjb25uZWN0ZWQ7CisJCQl9CisJCX0KKwl9CiAKIAlpZiAoY29ubmVjdG9yLT5j
b25uZWN0b3JfdHlwZSA9PSBEUk1fTU9ERV9DT05ORUNUT1JfU1ZJREVPIHx8CiAJICAgIGNvbm5l
Y3Rvci0+Y29ubmVjdG9yX3R5cGUgPT0gRFJNX01PREVfQ09OTkVDVE9SX0NvbXBvc2l0ZSB8fAot
LSAKMS43LjAuMQoK
--001636b2ae399197e004887a2929--
