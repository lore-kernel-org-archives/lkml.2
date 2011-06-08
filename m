Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1FHDbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:31:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab1FHDbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop> <1307003821.29297.77.camel@pasglop>
 <20110602110727.7343782b@lxorguk.ukuu.org.uk> <1307062574.29297.204.camel@pasglop>
 <1307081874.23876.14.camel@pasglop> <1307084189.23876.19.camel@pasglop>
 <BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com> <BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
 <BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com> <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Jun 2011 20:31:02 -0700
Message-ID: <BANLkTikYjD2BnJz99xc-OEntAEJ0gUPztg@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: multipart/mixed; boundary=001517503e1a6f336d04a52af880
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517503e1a6f336d04a52af880
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jun 7, 2011 at 7:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. The n_tty layer has some rather distressing locking, and doesn't
> lock "tty->receive_room" changes at all, for example (and uses
> multiple locks for some other things).
>
> It may well be that there is some SMP race there.

Actually, I think it's simpler than that.

Does this patch fix things for you? It just removes the "stop if
you've seen the tail, but somebody added a new buffer in the meantime"
logic.

We might want to keep the "re-arm the work" for just that case, but
let's see what happens if we just remove the logic entirely.

                          Linus

--001517503e1a6f336d04a52af880
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gonq0rb80

IGRyaXZlcnMvdHR5L3R0eV9idWZmZXIuYyB8ICAgMTQgKystLS0tLS0tLS0tLS0KIDEgZmlsZXMg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3R0eS90dHlfYnVmZmVyLmMgYi9kcml2ZXJzL3R0eS90dHlfYnVmZmVyLmMKaW5kZXgg
ZjFhNzkxOGQ3MWFhLi42YzliN2NkNjc3OGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdHR5L3R0eV9i
dWZmZXIuYworKysgYi9kcml2ZXJzL3R0eS90dHlfYnVmZmVyLmMKQEAgLTQxMyw4ICs0MTMsNyBA
QCBzdGF0aWMgdm9pZCBmbHVzaF90b19sZGlzYyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJ
c3Bpbl9sb2NrX2lycXNhdmUoJnR0eS0+YnVmLmxvY2ssIGZsYWdzKTsKIAogCWlmICghdGVzdF9h
bmRfc2V0X2JpdChUVFlfRkxVU0hJTkcsICZ0dHktPmZsYWdzKSkgewotCQlzdHJ1Y3QgdHR5X2J1
ZmZlciAqaGVhZCwgKnRhaWwgPSB0dHktPmJ1Zi50YWlsOwotCQlpbnQgc2Vlbl90YWlsID0gMDsK
KwkJc3RydWN0IHR0eV9idWZmZXIgKmhlYWQ7CiAJCXdoaWxlICgoaGVhZCA9IHR0eS0+YnVmLmhl
YWQpICE9IE5VTEwpIHsKIAkJCWludCBjb3VudDsKIAkJCWNoYXIgKmNoYXJfYnVmOwpAQCAtNDI0
LDE1ICs0MjMsNiBAQCBzdGF0aWMgdm9pZCBmbHVzaF90b19sZGlzYyhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCiAJCQlpZiAoIWNvdW50KSB7CiAJCQkJaWYgKGhlYWQtPm5leHQgPT0gTlVMTCkK
IAkJCQkJYnJlYWs7Ci0JCQkJLyoKLQkJCQkgIFRoZXJlJ3MgYSBwb3NzaWJpbGl0eSB0dHkgbWln
aHQgZ2V0IG5ldyBidWZmZXIKLQkJCQkgIGFkZGVkIGR1cmluZyB0aGUgdW5sb2NrIHdpbmRvdyBi
ZWxvdy4gV2UgY291bGQKLQkJCQkgIGVuZCB1cCBzcGlubmluZyBpbiBoZXJlIGZvcmV2ZXIgaG9n
Z2luZyB0aGUgQ1BVCi0JCQkJICBjb21wbGV0ZWx5LiBUbyBhdm9pZCB0aGlzIGxldCdzIGhhdmUg
YSByZXN0IGVhY2gKLQkJCQkgIHRpbWUgd2UgcHJvY2Vzc2VkIHRoZSB0YWlsIGJ1ZmZlci4KLQkJ
CQkqLwotCQkJCWlmICh0YWlsID09IGhlYWQpCi0JCQkJCXNlZW5fdGFpbCA9IDE7CiAJCQkJdHR5
LT5idWYuaGVhZCA9IGhlYWQtPm5leHQ7CiAJCQkJdHR5X2J1ZmZlcl9mcmVlKHR0eSwgaGVhZCk7
CiAJCQkJY29udGludWU7CkBAIC00NDIsNyArNDMyLDcgQEAgc3RhdGljIHZvaWQgZmx1c2hfdG9f
bGRpc2Moc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQkJICAgbGluZSBkaXNjaXBsaW5lIGFz
IHdlIHdhbnQgdG8gZW1wdHkgdGhlIHF1ZXVlICovCiAJCQlpZiAodGVzdF9iaXQoVFRZX0ZMVVNI
UEVORElORywgJnR0eS0+ZmxhZ3MpKQogCQkJCWJyZWFrOwotCQkJaWYgKCF0dHktPnJlY2VpdmVf
cm9vbSB8fCBzZWVuX3RhaWwpCisJCQlpZiAoIXR0eS0+cmVjZWl2ZV9yb29tKQogCQkJCWJyZWFr
OwogCQkJaWYgKGNvdW50ID4gdHR5LT5yZWNlaXZlX3Jvb20pCiAJCQkJY291bnQgPSB0dHktPnJl
Y2VpdmVfcm9vbTsK
--001517503e1a6f336d04a52af880--
