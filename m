Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab1CaVjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:39:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758995Ab1CaVjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimbjYuCT0VNDM5Rk_+20LocZHYaWKU37ROv3i+G@mail.gmail.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <20110331033432.GA434@redhat.com>
 <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
 <20110331040818.GB1255@redhat.com> <AANLkTi=uef63-mHHgHFU14H_Rhytcyc2p34Av6Ms6n3D@mail.gmail.com>
 <AANLkTimbjYuCT0VNDM5Rk_+20LocZHYaWKU37ROv3i+G@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 14:38:45 -0700
Message-ID: <AANLkTikk7=XBmMCskyh1zq3z_3+kZCaOyDjY5hFyiKjx@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Content-Type: multipart/mixed; boundary=001485e7c94a63ee21049fce1fa1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485e7c94a63ee21049fce1fa1
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Mar 31, 2011 at 9:21 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 31, 2011 at 8:53 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Regardless, I'll put my money where my mouth is, and try to remove the
>> crazy re-flush thing.
>
> Yeah, that doesn't work. The tty does actually lock up when it fills
> up. So clearly we actually depended on that reflushing happening.
>
> That said, I do still think it's the right thing to do to remove that
> line, it just means that I need to figure out where the missing flush
> is.

Ok, that was unexpected.

So the reason for the need to do that crazy "try to flush from the
flush routine" is that in the case of "receive_room" going down to
zero (which only happens for n_tty and for the case of switching
ldisc's around), if we hit that during flushing, nothing will
apparently ever re-start the flushing when receive_room then opens up
again.

So instead of having that case re-start the flush, we end up saying
"ok, we'll just retry the flush over and over again", and essentially
poll for receive_room opening up. No wonder you've seen high CPU use
and thousands of calls a second.

The "seen_tail" case doesn't have that issue, because anything that
adds a new buffer to the tty list should always be flipping anyway. So
this attached patch would seem to work.

Not heavily tested, but the case that I could trivially trigger before
doesn't trigger for me any more. And I can't seem to get kworker to
waste lots of CPU time any more, but it was kind of hit-and-miss
before too, so I don't know how much that's worth..

The locking here is kind of iffy, but otherwise? Comments?

                     Linus

--001485e7c94a63ee21049fce1fa1
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gly7gw080

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
--001485e7c94a63ee21049fce1fa1--
