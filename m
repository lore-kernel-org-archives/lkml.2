Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1HJHvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 03:51:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36901 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1HJHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 03:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAGxyxNCjyoiAdniT9z7af31TETuO1u1RksTCXm6wnWR8oOaYPA@mail.gmail.com>
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
	<201107071433.42081.oliver@neukum.org>
	<CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
	<CAGxyxNCjyoiAdniT9z7af31TETuO1u1RksTCXm6wnWR8oOaYPA@mail.gmail.com>
Date: Wed, 10 Aug 2011 09:51:23 +0200
Message-ID: <CACTFLAPb-ks_hwQZqp8J0A_3svG4GzYEZ2vL7VOVC5U8dkit-Q@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd32d425b245204aa21f2e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32d425b245204aa21f2e5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 7, 2011 at 5:16 PM, Florian Mickler <florian@mickler.org> wrote=
:
> [adding Robert Hancock]
> see here for the whole thread: https://lkml.org/lkml/2011/7/7/150
>
> 2011/7/7 Daniel Mack <zonque@gmail.com>:
>> On Thu, Jul 7, 2011 at 2:33 PM, Oliver Neukum <oliver@neukum.org> wrote:
>>
>>> PS: =A0Do you still see this if you enable 64bit DMA for EHCI?
>>
>> The problem is that I personally don't see that issue at all. I even
>> installed 4GB of RAM to my development machine last year to be able to
>> reproduce this, but I can't, even when the memory allocator is under
>> heavy load. The only people who see this effect are Pedro Ribeiro and
>> William Light (both in Cc:), and both have been very helpful in trying
>> patches and reporting back in detail. Which instructions could we
>> probably give to these people to finally hunt this issue down?
>>
>> Daniel
>>
>>
>
> Did someone affected already try the suggestions from Robert :
> http://lkml.org/lkml/2010/4/10/66
>
> That is checking if it really is a 64bit vs 32bit issue by booting
> with mem=3D4096M ?

So it seems we can finally close this issue. I got myself a new laptop
recently, and was actually happy to see that this machine showed the
bug as well. So I started investigating on what's going on and after
hours of debugging in the wrong area, I stumbled over a bug in my own
code. The patch attached fixes the problem for me, and William (one of
the very few people who saw it, too) also reported green light.

However, it remains a puzzle to me where the acutal root cause is for
this is, and I would much like to know. Let me briefly explain what
I'm seeing.

The driver operates in a mode so that it copies the layout of its
inbound stream to the output stream, thus guaranteeing the data rate
of outbound data is equal to that of the input stream. For that, I
walk the isochronous frames of each received urb and prepare an urb
for sending that has the same iso packet structure in terms of lengths
and offsets, jumping over and ignoring frames that are actually
invalid (status !=3D 0). So here was the problem: if there were frames
with any different status field, the driver would calculate the wrong
offset and the playback stream will have artefacts. So, a classic bug
you might think, and the fix is trivial.

However, what I really don't understand is why this wasn't observed
any earlier by any of the many users, and why iit makes a difference
which type of memory I use for this. Recall that my original patch
that allocates DMA coherent memory for the transfer buffers also fixes
the problem just fine. Or put it that way: when allocating "normal"
memory using kmalloc(), the stream appears to have "holes" in the iso
packet structure, while with DMA coherent memory, the layout is
different. And all this only happens on fairly new 64bit-enabled
machines.

Can anyone explain this?


Many thanks to everyone involved in this - and especially to William
and Pedro who spent a lot of time in trying my patches and sending me
debug information.



Daniel

--000e0cd32d425b245204aa21f2e5
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-ALSA-snd-usb-caiaq-Correct-offset-fields-of-outbound.patch"
Content-Disposition: attachment; 
	filename="0001-ALSA-snd-usb-caiaq-Correct-offset-fields-of-outbound.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gr5zxfm30

RnJvbSAwYjk1YzhiOTQwMmFhYTM5YzAwOTZkZjAwMjA5ZWI3MzQ1MGQwOGE4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgTWFjayA8ZGFuaWVsQHRhbXRhbS4obm9uZSk+CkRh
dGU6IEZyaSwgNSBBdWcgMjAxMSAxMzo0OTo1MiArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIEFMU0E6
IHNuZC11c2ItY2FpYXE6IENvcnJlY3Qgb2Zmc2V0IGZpZWxkcyBvZiBvdXRib3VuZAogaXNvX2Zy
YW1lX2Rlc2MKClRoaXMgZml4ZXMgZmF1bHR5IG91dGJvdW50IHBhY2tldHMgaW4gY2FzZSB0aGUg
aW5ib3VuZCBwYWNrZXRzCnJlY2VpdmVkIGZyb20gdGhlIGhhcmR3YXJlIGFyZSBmcmFnbWVudGVk
IGFuZCBjb250YWluIGJvZ3VzIGlucHV0CmlzbyBmcmFtZXMuIFRoZSBidWcgaGFzIGJlZW4gdGhl
cmUgZm9yIGFnZXMsIGJ1dCBmb3Igc29tZSBzdHJhbmdlCnJlYXNvbnMsIGl0IHdhcyBvbmx5IHRy
aWdnZXJlZCBieSBuZXdlciBtYWNoaW5lcyBpbiA2NGJpdCBtb2RlLgoKU2lnbmVkLW9mZi1ieTog
RGFuaWVsIE1hY2sgPHpvbnF1ZUBnbWFpbC5jb20+ClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IFdp
bGxpYW0gTGlnaHQgPHdybEBpbGxlc3QubmV0PgpSZXBvcnRlZC1ieTogUGVkcm8gUmliZWlybyA8
cGVkcmliQGdtYWlsLmNvbT4KQ2M6IHN0YWJsZUBrZXJuZWwub3JnCi0tLQogc291bmQvdXNiL2Nh
aWFxL2F1ZGlvLmMgfCAgICA0ICsrKy0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3NvdW5kL3VzYi9jYWlhcS9hdWRpby5jIGIv
c291bmQvdXNiL2NhaWFxL2F1ZGlvLmMKaW5kZXggZDBkNDkzYy4uNGM4MjQ5ZSAxMDA2NDQKLS0t
IGEvc291bmQvdXNiL2NhaWFxL2F1ZGlvLmMKKysrIGIvc291bmQvdXNiL2NhaWFxL2F1ZGlvLmMK
QEAgLTYxNCw2ICs2MTQsNyBAQCBzdGF0aWMgdm9pZCByZWFkX2NvbXBsZXRlZChzdHJ1Y3QgdXJi
ICp1cmIpCiAJc3RydWN0IHNuZF91c2JfY2FpYXFkZXYgKmRldjsKIAlzdHJ1Y3QgdXJiICpvdXQ7
CiAJaW50IGZyYW1lLCBsZW4sIHNlbmRfaXQgPSAwLCBvdXRmcmFtZSA9IDA7CisJc2l6ZV90IG9m
ZnNldCA9IDA7CiAKIAlpZiAodXJiLT5zdGF0dXMgfHwgIWluZm8pCiAJCXJldHVybjsKQEAgLTYz
NCw3ICs2MzUsOCBAQCBzdGF0aWMgdm9pZCByZWFkX2NvbXBsZXRlZChzdHJ1Y3QgdXJiICp1cmIp
CiAJCWxlbiA9IHVyYi0+aXNvX2ZyYW1lX2Rlc2Nbb3V0ZnJhbWVdLmFjdHVhbF9sZW5ndGg7CiAJ
CW91dC0+aXNvX2ZyYW1lX2Rlc2Nbb3V0ZnJhbWVdLmxlbmd0aCA9IGxlbjsKIAkJb3V0LT5pc29f
ZnJhbWVfZGVzY1tvdXRmcmFtZV0uYWN0dWFsX2xlbmd0aCA9IDA7Ci0JCW91dC0+aXNvX2ZyYW1l
X2Rlc2Nbb3V0ZnJhbWVdLm9mZnNldCA9IEJZVEVTX1BFUl9GUkFNRSAqIGZyYW1lOworCQlvdXQt
Pmlzb19mcmFtZV9kZXNjW291dGZyYW1lXS5vZmZzZXQgPSBvZmZzZXQ7CisJCW9mZnNldCArPSBs
ZW47CiAKIAkJaWYgKGxlbiA+IDApIHsKIAkJCXNwaW5fbG9jaygmZGV2LT5zcGlubG9jayk7Ci0t
IAoxLjcuNgoK
--000e0cd32d425b245204aa21f2e5--
