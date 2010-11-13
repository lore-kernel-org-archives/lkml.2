Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0KMRpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:45:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60709 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0KMRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TosQuGfL1Zdg1Ieuy7wQKL/ELjQ//PBgWtbaFSfjh36naSNx5hpMb2kHjmqiYuL2qH
         UpYfuasTFMSlZXDE6ly90TKisqe7sbOiF1IHAnW3hPn6pODq7BzBQpvdyvUyUsYSkg++
         v+OPC2+3NN41OAHQQc4ID9hkMsg9Ft6oLDk5U=
MIME-Version: 1.0
Date: Sat, 13 Nov 2010 17:45:19 +0000
Message-ID: <AANLkTikT9ch4NfL2MBDL=qUT=Q2ierehFNp1=Ux8tNNC@mail.gmail.com>
Subject: [PATCH 2/2] uml: Disable winch irq before freeing handler data.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>
Content-Type: multipart/mixed; boundary=0016e659f49e4cc61e0494f2c5a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e659f49e4cc61e0494f2c5a9
Content-Type: text/plain; charset=ISO-8859-1

Disable the winch irq early to make sure we don't
take an interrupt part way through the freeing of
the handler data, resulting in a crash on shutdown:

winch_interrupt : read failed, errno = 9
fd 13 is losing SIGWINCH support
------------[ cut here ]------------
WARNING: at lib/list_debug.c:48 list_del+0xc6/0x100()
list_del corruption, next is LIST_POISON1 (00100100)
082578c8:  [<081fd77f>] dump_stack+0x22/0x24
082578e0:  [<0807a18a>] warn_slowpath_common+0x5a/0x80
08257908:  [<0807a23e>] warn_slowpath_fmt+0x2e/0x30
08257920:  [<08172196>] list_del+0xc6/0x100
08257940:  [<08060244>] free_winch+0x14/0x80
08257958:  [<080606fb>] winch_interrupt+0xdb/0xe0
08257978:  [<080a65b5>] handle_IRQ_event+0x35/0xe0
08257998:  [<080a8717>] handle_edge_irq+0xb7/0x170
082579bc:  [<08059bc4>] do_IRQ+0x34/0x50
082579d4:  [<08059e1b>] sigio_handler+0x5b/0x80
082579ec:  [<0806a374>] sig_handler_common+0x44/0xb0
08257a68:  [<0806a538>] sig_handler+0x38/0x50
08257a78:  [<0806a77c>] handle_signal+0x5c/0xa0
08257a9c:  [<0806be28>] hard_handler+0x18/0x20
08257aac:  [<00c14400>] 0xc14400

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 arch/um/drivers/line.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 5f12fef..050e4dd 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -727,6 +727,9 @@ struct winch {

 static void free_winch(struct winch *winch, int free_irq_ok)
 {
+	if (free_irq_ok)
+		free_irq(WINCH_IRQ, winch);
+
 	list_del(&winch->list);

 	if (winch->pid != -1)
@@ -735,8 +738,6 @@ static void free_winch(struct winch *winch, int free_irq_ok)
 		os_close_file(winch->fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
-	if (free_irq_ok)
-		free_irq(WINCH_IRQ, winch);
 	kfree(winch);
 }

-- 
1.7.0.4

--0016e659f49e4cc61e0494f2c5a9
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-uml-Disable-winch-irq-before-freeing-handler-data.patch"
Content-Disposition: attachment; 
	filename="0002-uml-Disable-winch-irq-before-freeing-handler-data.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gggse5os0

RnJvbSA0MzlkNzU0NzhmNjk4MWZmMWI4MjlkNzExYmNjZTM2MDNmNWE5Nzg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBTYXQsIDEzIE5vdiAyMDEwIDE3OjEyOjMzICswMDAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IHVtbDogRGlzYWJsZSB3aW5jaCBpcnEgYmVmb3JlIGZyZWVpbmcgaGFuZGxlciBkYXRhLgoKRGlz
YWJsZSB0aGUgd2luY2ggaXJxIGVhcmx5IHRvIG1ha2Ugc3VyZSB3ZSBkb24ndAp0YWtlIGFuIGlu
dGVycnVwdCBwYXJ0IHdheSB0aHJvdWdoIHRoZSBmcmVlaW5nIG9mCnRoZSBoYW5kbGVyIGRhdGEs
IHJlc3VsdGluZyBpbiBhIGNyYXNoIG9uIHNodXRkb3duOgoKd2luY2hfaW50ZXJydXB0IDogcmVh
ZCBmYWlsZWQsIGVycm5vID0gOQpmZCAxMyBpcyBsb3NpbmcgU0lHV0lOQ0ggc3VwcG9ydAotLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KV0FSTklORzogYXQgbGliL2xpc3RfZGVi
dWcuYzo0OCBsaXN0X2RlbCsweGM2LzB4MTAwKCkKbGlzdF9kZWwgY29ycnVwdGlvbiwgbmV4dCBp
cyBMSVNUX1BPSVNPTjEgKDAwMTAwMTAwKQowODI1NzhjODogIFs8MDgxZmQ3N2Y+XSBkdW1wX3N0
YWNrKzB4MjIvMHgyNAowODI1NzhlMDogIFs8MDgwN2ExOGE+XSB3YXJuX3Nsb3dwYXRoX2NvbW1v
bisweDVhLzB4ODAKMDgyNTc5MDg6ICBbPDA4MDdhMjNlPl0gd2Fybl9zbG93cGF0aF9mbXQrMHgy
ZS8weDMwCjA4MjU3OTIwOiAgWzwwODE3MjE5Nj5dIGxpc3RfZGVsKzB4YzYvMHgxMDAKMDgyNTc5
NDA6ICBbPDA4MDYwMjQ0Pl0gZnJlZV93aW5jaCsweDE0LzB4ODAKMDgyNTc5NTg6ICBbPDA4MDYw
NmZiPl0gd2luY2hfaW50ZXJydXB0KzB4ZGIvMHhlMAowODI1Nzk3ODogIFs8MDgwYTY1YjU+XSBo
YW5kbGVfSVJRX2V2ZW50KzB4MzUvMHhlMAowODI1Nzk5ODogIFs8MDgwYTg3MTc+XSBoYW5kbGVf
ZWRnZV9pcnErMHhiNy8weDE3MAowODI1NzliYzogIFs8MDgwNTliYzQ+XSBkb19JUlErMHgzNC8w
eDUwCjA4MjU3OWQ0OiAgWzwwODA1OWUxYj5dIHNpZ2lvX2hhbmRsZXIrMHg1Yi8weDgwCjA4MjU3
OWVjOiAgWzwwODA2YTM3ND5dIHNpZ19oYW5kbGVyX2NvbW1vbisweDQ0LzB4YjAKMDgyNTdhNjg6
ICBbPDA4MDZhNTM4Pl0gc2lnX2hhbmRsZXIrMHgzOC8weDUwCjA4MjU3YTc4OiAgWzwwODA2YTc3
Yz5dIGhhbmRsZV9zaWduYWwrMHg1Yy8weGEwCjA4MjU3YTljOiAgWzwwODA2YmUyOD5dIGhhcmRf
aGFuZGxlcisweDE4LzB4MjAKMDgyNTdhYWM6ICBbPDAwYzE0NDAwPl0gMHhjMTQ0MDAKClNpZ25l
ZC1vZmYtYnk6IFdpbGwgTmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFpbC5jb20+Ci0tLQogYXJjaC91
bS9kcml2ZXJzL2xpbmUuYyB8ICAgIDUgKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvdW0vZHJpdmVycy9saW5l
LmMgYi9hcmNoL3VtL2RyaXZlcnMvbGluZS5jCmluZGV4IDVmMTJmZWYuLjA1MGU0ZGQgMTAwNjQ0
Ci0tLSBhL2FyY2gvdW0vZHJpdmVycy9saW5lLmMKKysrIGIvYXJjaC91bS9kcml2ZXJzL2xpbmUu
YwpAQCAtNzI3LDYgKzcyNyw5IEBAIHN0cnVjdCB3aW5jaCB7CiAKIHN0YXRpYyB2b2lkIGZyZWVf
d2luY2goc3RydWN0IHdpbmNoICp3aW5jaCwgaW50IGZyZWVfaXJxX29rKQogeworCWlmIChmcmVl
X2lycV9vaykKKwkJZnJlZV9pcnEoV0lOQ0hfSVJRLCB3aW5jaCk7CisKIAlsaXN0X2RlbCgmd2lu
Y2gtPmxpc3QpOwogCiAJaWYgKHdpbmNoLT5waWQgIT0gLTEpCkBAIC03MzUsOCArNzM4LDYgQEAg
c3RhdGljIHZvaWQgZnJlZV93aW5jaChzdHJ1Y3Qgd2luY2ggKndpbmNoLCBpbnQgZnJlZV9pcnFf
b2spCiAJCW9zX2Nsb3NlX2ZpbGUod2luY2gtPmZkKTsKIAlpZiAod2luY2gtPnN0YWNrICE9IDAp
CiAJCWZyZWVfc3RhY2sod2luY2gtPnN0YWNrLCAwKTsKLQlpZiAoZnJlZV9pcnFfb2spCi0JCWZy
ZWVfaXJxKFdJTkNIX0lSUSwgd2luY2gpOwogCWtmcmVlKHdpbmNoKTsKIH0KIAotLSAKMS43LjAu
NAoK
--0016e659f49e4cc61e0494f2c5a9--
