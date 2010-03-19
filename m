Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab0CSEgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 00:36:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49718 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0CSEgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 00:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kNZ9dc1DyDyR30WfIBpIhJxfo65RzuGBVtnxefTIJ4RGosx2gp70rxf5iTeZz/vxWx
         MAkge0DNQH+CzLV+4hCSKZuRuDjJmIi0H7QfbCI/F2ctqVXGvHw5rsnl+vBTgh0buu0x
         FOGwZdRLTFs6wn+5HTmA77N4HH8EkOQPNOSys=
MIME-Version: 1.0
Date: Fri, 19 Mar 2010 13:36:50 +0900
Message-ID: <90b950fc1003182136n73d54c2di4be84f16e4c3534f@mail.gmail.com>
Subject: [PATCH] fixed sparkling issue on lcd panel when fb_blank mode is 
	changed.
From: InKi Dae <daeinki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <rpurdie@linux.intel.com>, Pavel Machek <pavel@ucw.cz>,
       Kyungmin Park <kmpark@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c597c0756dbb04821fe50c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c597c0756dbb04821fe50c
Content-Type: text/plain; charset=ISO-8859-1

Hello all,

I am sending a e-mail about fb_blank issue.

This issue is a problem that lcd panel is spakled when fb_blank mode is changed
>From FB_BLANK_UNBLANK to FB_BLANK_POWER or FB_BLANK_POWER to FB_BLANK_UNBLANK.

In case of FB_BLANK_UNBLANK, screen = on, vsync = on, hsync = on and
For FB_BLANK_POWERDOWN screen = blanked, vsync = off, hsync = off
So like this when fb_blank mode becomes FB_BLANK_POWERDOWN,
Display controller and lcd panel should become off to reduce power consumption.

Let's see fb_blank function of fbmem.c file.

fb_blank()
{
    if (info->fbops->fb_blank)
            ret = info->fbops->fb_blank(blank, info(
    if (!ret)
            fb_notifier_call_chain(FB_EVENT_BLANK, &event);
}

This problem is because this code calls fb_blank (fb_blank of device
specific framebuffer driver)
Earlier then fb_notifier_call_chain.

For example,
Device specific fb_blank function is registered to generic framebuffer
driver through register_framebuffer function
And fb_notifier_call_chain calls any callback function registered to
lcd class(lcd.c) through fb_notifier_callback function.
So if fb_blank mode is changed to FB_BLANK_POWERDOWN then display
controller would become off(clock disable)
On the other hand, lcd panel would still be on. at this time, some
situation on lcd panel occers like sparkling
Because video clock to be delivered to ldi module of lcd panel is disabled also.

This patch get fb_notifier_call_chain to be called earlier then fb_blank.
Please, review this patch.

signed-off-by : InKi Dae <inki.dae@samsung.com>

Best Regards,
InKi Dae.

--001636c597c0756dbb04821fe50c
Content-Type: application/octet-stream; name="fbmem.patch"
Content-Disposition: attachment; filename="fbmem.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6yhjn9v0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vZmJtZW0uYyBiL2RyaXZlcnMvdmlkZW8vZmJtZW0u
YwppbmRleCBhMTViNDRlLi45NjAzZjY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3ZpZGVvL2ZibWVt
LmMKKysrIGIvZHJpdmVycy92aWRlby9mYm1lbS5jCkBAIC0xMDA3LDI0ICsxMDA3LDI0IEBAIGZi
X3NldF92YXIoc3RydWN0IGZiX2luZm8gKmluZm8sIHN0cnVjdCBmYl92YXJfc2NyZWVuaW5mbyAq
dmFyKQogCiBpbnQKIGZiX2JsYW5rKHN0cnVjdCBmYl9pbmZvICppbmZvLCBpbnQgYmxhbmspCi17
CQotIAlpbnQgcmV0ID0gLUVJTlZBTDsKK3sKKwlzdHJ1Y3QgZmJfZXZlbnQgZXZlbnQ7CisJaW50
IHJldCA9IC1FSU5WQUw7CiAKLSAJaWYgKGJsYW5rID4gRkJfQkxBTktfUE9XRVJET1dOKQotIAkJ
YmxhbmsgPSBGQl9CTEFOS19QT1dFUkRPV047CisJaWYgKGJsYW5rID4gRkJfQkxBTktfUE9XRVJE
T1dOKQorCQlibGFuayA9IEZCX0JMQU5LX1BPV0VSRE9XTjsKIAotCWlmIChpbmZvLT5mYm9wcy0+
ZmJfYmxhbmspCi0gCQlyZXQgPSBpbmZvLT5mYm9wcy0+ZmJfYmxhbmsoYmxhbmssIGluZm8pOwor
CWV2ZW50LmluZm8gPSBpbmZvOworCWV2ZW50LmRhdGEgPSAmYmxhbms7CiAKLSAJaWYgKCFyZXQp
IHsKLQkJc3RydWN0IGZiX2V2ZW50IGV2ZW50OworCXJldCA9IGZiX25vdGlmaWVyX2NhbGxfY2hh
aW4oRkJfRVZFTlRfQkxBTkssICZldmVudCk7CisJaWYgKChyZXQgJiBOT1RJRllfU1RPUF9NQVNL
KSA9PSBOT1RJRllfU1RPUF9NQVNLKQorCQlwcmludGsoS0VSTl9FUlIgIm5vdGlmaWVyX2NhbGwg
ZmFpbGVkLlxuIik7CiAKLQkJZXZlbnQuaW5mbyA9IGluZm87Ci0JCWV2ZW50LmRhdGEgPSAmYmxh
bms7Ci0JCWZiX25vdGlmaWVyX2NhbGxfY2hhaW4oRkJfRVZFTlRfQkxBTkssICZldmVudCk7Ci0J
fQorCWlmIChpbmZvLT5mYm9wcy0+ZmJfYmxhbmspCisJCXJldCA9IGluZm8tPmZib3BzLT5mYl9i
bGFuayhibGFuaywgaW5mbyk7CiAKLSAJcmV0dXJuIHJldDsKKwlyZXR1cm4gcmV0OwogfQogCiBz
dGF0aWMgbG9uZyBkb19mYl9pb2N0bChzdHJ1Y3QgZmJfaW5mbyAqaW5mbywgdW5zaWduZWQgaW50
IGNtZCwK
--001636c597c0756dbb04821fe50c--
