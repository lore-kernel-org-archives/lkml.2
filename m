Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0CVEsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:48:13 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:58465 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0CVEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sJNFb10bOuX3XS76+2rgzEI+3GFGrB3EgDrDxSV2SGmrcRnHkvvE+OWh0RPPWhNbG0
         AT4R2ImM2izxUoOaNCTKf41WxhZLo7pue0zibPE8EnlQ4EBWqJIFynLVWtV8EyYoOm0z
         DMYgyWT7hq1KR3Ln/KN2D8Hlu4L2WVNEsO51Q=
MIME-Version: 1.0
In-Reply-To: <90b950fc1003212018h69bb0fa0t9dd62815b08eb7b3@mail.gmail.com>
References: <90b950fc1003182136n73d54c2di4be84f16e4c3534f@mail.gmail.com>
	 <1269004294.4292.18.camel@rex>
	 <90b950fc1003212018h69bb0fa0t9dd62815b08eb7b3@mail.gmail.com>
Date: Mon, 22 Mar 2010 13:48:10 +0900
Message-ID: <90b950fc1003212148h5fd0359ay3e21a99b0c16387a@mail.gmail.com>
Subject: Re: [PATCH] fixed sparkling issue on lcd panel when fb_blank mode is 
	changed.
From: InKi Dae <daeinki@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Kyungmin Park <kmpark@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636ed6ce36612b304825c67fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636ed6ce36612b304825c67fc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I has modified my patch.

this patch would change order only in case of FB_BLANK_POWERDOWN
with Richard's opinion.

if requested blank mode is less then FB_BLANK_POWERDOWN then
it would call device specific fb_blank and then fb_notifer_call_chan
otherwise fb_notifier_call_chain first, this case means power up
and display controller should become on earlier then other devices
like lcd panel.

Please review this path again.

signed-off-by : InKi Dae <inki.dae@samsung.com>

Best Regards,
InKi Dae.

2010/3/22 InKi Dae <daeinki@gmail.com>:
> yes, you are right.
>
> when fb_blank mode is changed to FB_BLANK_NORMAL or
> FB_BLANK_UNBLANK(power down -> power up)
> it has a possibility that we would encounter same issue.
>
> I'd try to modify my patch to be considered with your opinion and will
> send it again.
> Thank you for your answer.
>
> Best Regards,
> InKi Dae.
>
> 2010/3/19 Richard Purdie <rpurdie@rpsys.net>:
>> Hi,
>>
>> On Fri, 2010-03-19 at 13:36 +0900, InKi Dae wrote:
>>> This issue is a problem that lcd panel is spakled when fb_blank mode is=
 changed
>>> From FB_BLANK_UNBLANK to FB_BLANK_POWER or FB_BLANK_POWER to FB_BLANK_U=
NBLANK.
>>>
>>> In case of FB_BLANK_UNBLANK, screen =3D on, vsync =3D on, hsync =3D on =
and
>>> For FB_BLANK_POWERDOWN screen =3D blanked, vsync =3D off, hsync =3D off
>>> So like this when fb_blank mode becomes FB_BLANK_POWERDOWN,
>>> Display controller and lcd panel should become off to reduce power cons=
umption.
>>>
>>> Let's see fb_blank function of fbmem.c file.
>>>
>>> fb_blank()
>>> {
>>> =A0 =A0 if (info->fbops->fb_blank)
>>> =A0 =A0 =A0 =A0 =A0 =A0 ret =3D info->fbops->fb_blank(blank, info(
>>> =A0 =A0 if (!ret)
>>> =A0 =A0 =A0 =A0 =A0 =A0 fb_notifier_call_chain(FB_EVENT_BLANK, &event);
>>> }
>>>
>>> This problem is because this code calls fb_blank (fb_blank of device
>>> specific framebuffer driver)
>>> Earlier then fb_notifier_call_chain.
>>>
>>> For example,
>>> Device specific fb_blank function is registered to generic framebuffer
>>> driver through register_framebuffer function
>>> And fb_notifier_call_chain calls any callback function registered to
>>> lcd class(lcd.c) through fb_notifier_callback function.
>>> So if fb_blank mode is changed to FB_BLANK_POWERDOWN then display
>>> controller would become off(clock disable)
>>> On the other hand, lcd panel would still be on. at this time, some
>>> situation on lcd panel occers like sparkling
>>> Because video clock to be delivered to ldi module of lcd panel is disab=
led also.
>>>
>>> This patch get fb_notifier_call_chain to be called earlier then fb_blan=
k.
>>> Please, review this patch.
>>
>> So to summarise the problem more succinctly the LCD and the display
>> controllers power off in the wrong order causing visual defects
>> (sparkling) on the display.
>>
>> I was a bit worried about event order and loops with this change so I
>> checked and there are three consumers of these events in the kernel:
>> consoles, LCD and backlight. None of them have a problem with this
>> change of order for power down so from that point of view I'm ok with
>> the change.
>>
>> However this function also covers powerup from a screen blank to an
>> active screen. When powering up it makes sense to power up the video
>> device first, then the LCD, backlight and console as per the current
>> code, otherwise I can imagine "sparkling" upon powerup.
>>
>> So it looks like we need to change order only on powerdown, not upon
>> resume, otherwise we'll get further regression reports on poweron?
>>
>> Cheers,
>>
>> Richard
>>
>>
>>
>>
>>
>

--001636ed6ce36612b304825c67fc
Content-Type: application/octet-stream; name="fbmem.patch"
Content-Disposition: attachment; filename="fbmem.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g72s636p0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vZmJtZW0uYyBiL2RyaXZlcnMvdmlkZW8vZmJtZW0u
YwppbmRleCBhMTViNDRlLi5kODBlMDk3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3ZpZGVvL2ZibWVt
LmMKKysrIGIvZHJpdmVycy92aWRlby9mYm1lbS5jCkBAIC0xMDA3LDI0ICsxMDA3LDMzIEBAIGZi
X3NldF92YXIoc3RydWN0IGZiX2luZm8gKmluZm8sIHN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAq
dmFyKQogCiBpbnQKIGZiX2JsYW5rKHN0cnVjdCBmYl9pbmZvICppbmZvLCBpbnQgYmxhbmspCi17
CQotIAlpbnQgcmV0ID0gLUVJTlZBTDsKK3sKKwlzdHJ1Y3QgZmJfZXZlbnQgZXZlbnQ7CisJaW50
IHJldCA9IC1FSU5WQUw7CiAKLSAJaWYgKGJsYW5rID4gRkJfQkxBTktfUE9XRVJET1dOKQotIAkJ
YmxhbmsgPSBGQl9CTEFOS19QT1dFUkRPV047CisJaWYgKGJsYW5rID4gRkJfQkxBTktfUE9XRVJE
T1dOKQorCQlibGFuayA9IEZCX0JMQU5LX1BPV0VSRE9XTjsKIAotCWlmIChpbmZvLT5mYm9wcy0+
ZmJfYmxhbmspCi0gCQlyZXQgPSBpbmZvLT5mYm9wcy0+ZmJfYmxhbmsoYmxhbmssIGluZm8pOwor
CWV2ZW50LmluZm8gPSBpbmZvOworCWV2ZW50LmRhdGEgPSAmYmxhbms7CiAKLSAJaWYgKCFyZXQp
IHsKLQkJc3RydWN0IGZiX2V2ZW50IGV2ZW50OworCWlmIChibGFuayA8ICBGQl9CTEFOS19QT1dF
UkRPV04pIHsKKwkJaWYgKGluZm8tPmZib3BzLT5mYl9ibGFuaykKKwkJCXJldCA9IGluZm8tPmZi
b3BzLT5mYl9ibGFuayhibGFuaywgaW5mbyk7CiAKLQkJZXZlbnQuaW5mbyA9IGluZm87Ci0JCWV2
ZW50LmRhdGEgPSAmYmxhbms7Ci0JCWZiX25vdGlmaWVyX2NhbGxfY2hhaW4oRkJfRVZFTlRfQkxB
TkssICZldmVudCk7CisJCXJldCA9IGZiX25vdGlmaWVyX2NhbGxfY2hhaW4oRkJfRVZFTlRfQkxB
TkssICZldmVudCk7CisJCWlmICgocmV0ICYgTk9USUZZX1NUT1BfTUFTSykgPT0gTk9USUZZX1NU
T1BfTUFTSykKKwkJCXByaW50ayhLRVJOX0VSUiAibm90aWZpZXJfY2FsbCBmYWlsZWQuXG4iKTsK
Kwl9IGVsc2UgeworCQlyZXQgPSBmYl9ub3RpZmllcl9jYWxsX2NoYWluKEZCX0VWRU5UX0JMQU5L
LCAmZXZlbnQpOworCQlpZiAoKHJldCAmIE5PVElGWV9TVE9QX01BU0spID09IE5PVElGWV9TVE9Q
X01BU0spCisJCQlwcmludGsoS0VSTl9FUlIgIm5vdGlmaWVyX2NhbGwgZmFpbGVkLlxuIik7CisK
KwkJaWYgKGluZm8tPmZib3BzLT5mYl9ibGFuaykKKwkJCXJldCA9IGluZm8tPmZib3BzLT5mYl9i
bGFuayhibGFuaywgaW5mbyk7CiAJfQogCi0gCXJldHVybiByZXQ7CisJcmV0dXJuIHJldDsKIH0K
IAogc3RhdGljIGxvbmcgZG9fZmJfaW9jdGwoc3RydWN0IGZiX2luZm8gKmluZm8sIHVuc2lnbmVk
IGludCBjbWQsCg==
--001636ed6ce36612b304825c67fc--
