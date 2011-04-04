Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DDUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:05:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab1DDUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110404194230.GA8785@sucs.org>
References: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com> <20110404194230.GA8785@sucs.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Apr 2011 12:59:09 -0700
Message-ID: <BANLkTik_MNB+4vWXw2k0-B-2B1_4MO3HMg@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.39-rc1: f23eb2b breaks console output
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed; boundary=90e6ba6e8ff48842cb04a01d325d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6e8ff48842cb04a01d325d
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 4, 2011 at 12:42 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Mon, Apr 04, 2011 at 11:15:10PM +0400, Alexander Beregalov wrote:
>>
>> commit f23eb2b2b28547fc70df82dd5049eb39bec5ba12 tty: stop using
>> "delayed_work" in the tty layer
>> breaks console output for me.
>
> Same here - doing a dmesg in an xterm makes the machine hang for about
> 10 seconds and latencytop whinges that a raw SCSI command took 4000ms to
> complete (uniprocessor x86 EeePC 900).
>
> Additionally, you won't see this problem if you have CONFIG_PREEMPT set
> but as my config has CONFIG_PREEMPT_VOLUNTARY=y I do see this problem.
> Reverting f23eb2b2b28547fc70df82dd5049eb39bec5ba12 fixed the problem for
> me too.

Does this patch make a difference?

The tty ldisc flushing code had this crazy "reflush if we're full"
logic, which was apparently hiding a problem in N_TTY handling where
it wouldn't wake things up when the receive-room was opened up again.

When I made it not do timers, the "reflush" logic basically made for
an infinite loop (before, it used to instead basically poll for the
event on each timer tick instead).

The attached patch removes the reflush logic, and makes N_TTY instead
wake up the work when opening up the receive buffer again.

               Linus

--90e6ba6e8ff48842cb04a01d325d
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm3tpd410

IGRyaXZlcnMvdHR5L25fdHR5LmMgICAgICB8ICAgIDYgKysrKysrCiBkcml2ZXJzL3R0eS90dHlf
YnVmZmVyLmMgfCAgICA0ICstLS0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L25fdHR5LmMgYi9kcml2ZXJz
L3R0eS9uX3R0eS5jCmluZGV4IDQyOGY0ZmUuLjBhZDMyODggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
dHR5L25fdHR5LmMKKysrIGIvZHJpdmVycy90dHkvbl90dHkuYwpAQCAtOTUsNiArOTUsNyBAQCBz
dGF0aWMgdm9pZCBuX3R0eV9zZXRfcm9vbShzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5KQogewogCS8q
IHR0eS0+cmVhZF9jbnQgaXMgbm90IHJlYWQgbG9ja2VkID8gKi8KIAlpbnQJbGVmdCA9IE5fVFRZ
X0JVRl9TSVpFIC0gdHR5LT5yZWFkX2NudCAtIDE7CisJaW50IG9sZF9sZWZ0OwogCiAJLyoKIAkg
KiBJZiB3ZSBhcmUgZG9pbmcgaW5wdXQgY2Fub25pY2FsaXphdGlvbiwgYW5kIHRoZXJlIGFyZSBu
bwpAQCAtMTA0LDcgKzEwNSwxMiBAQCBzdGF0aWMgdm9pZCBuX3R0eV9zZXRfcm9vbShzdHJ1Y3Qg
dHR5X3N0cnVjdCAqdHR5KQogCSAqLwogCWlmIChsZWZ0IDw9IDApCiAJCWxlZnQgPSB0dHktPmlj
YW5vbiAmJiAhdHR5LT5jYW5vbl9kYXRhOworCW9sZF9sZWZ0ID0gdHR5LT5yZWNlaXZlX3Jvb207
CiAJdHR5LT5yZWNlaXZlX3Jvb20gPSBsZWZ0OworCisJLyogRGlkIHRoaXMgb3BlbiB1cCB0aGUg
cmVjZWl2ZSBidWZmZXI/IFdlIG1heSBuZWVkIHRvIGZsaXAgKi8KKwlpZiAobGVmdCAmJiAhb2xk
X2xlZnQpCisJCXNjaGVkdWxlX3dvcmsoJnR0eS0+YnVmLndvcmspOwogfQogCiBzdGF0aWMgdm9p
ZCBwdXRfdHR5X3F1ZXVlX25vbG9jayh1bnNpZ25lZCBjaGFyIGMsIHN0cnVjdCB0dHlfc3RydWN0
ICp0dHkpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS90dHlfYnVmZmVyLmMgYi9kcml2ZXJzL3R0
eS90dHlfYnVmZmVyLmMKaW5kZXggYjk0NTEyMS4uZjFhNzkxOCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy90dHkvdHR5X2J1ZmZlci5jCisrKyBiL2RyaXZlcnMvdHR5L3R0eV9idWZmZXIuYwpAQCAtNDQy
LDEwICs0NDIsOCBAQCBzdGF0aWMgdm9pZCBmbHVzaF90b19sZGlzYyhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCiAJCQkgICBsaW5lIGRpc2NpcGxpbmUgYXMgd2Ugd2FudCB0byBlbXB0eSB0aGUg
cXVldWUgKi8KIAkJCWlmICh0ZXN0X2JpdChUVFlfRkxVU0hQRU5ESU5HLCAmdHR5LT5mbGFncykp
CiAJCQkJYnJlYWs7Ci0JCQlpZiAoIXR0eS0+cmVjZWl2ZV9yb29tIHx8IHNlZW5fdGFpbCkgewot
CQkJCXNjaGVkdWxlX3dvcmsoJnR0eS0+YnVmLndvcmspOworCQkJaWYgKCF0dHktPnJlY2VpdmVf
cm9vbSB8fCBzZWVuX3RhaWwpCiAJCQkJYnJlYWs7Ci0JCQl9CiAJCQlpZiAoY291bnQgPiB0dHkt
PnJlY2VpdmVfcm9vbSkKIAkJCQljb3VudCA9IHR0eS0+cmVjZWl2ZV9yb29tOwogCQkJY2hhcl9i
dWYgPSBoZWFkLT5jaGFyX2J1Zl9wdHIgKyBoZWFkLT5yZWFkOwo=
--90e6ba6e8ff48842cb04a01d325d--
