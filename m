Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0IZRMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 13:12:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35625 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab0IZRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 13:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Fh52omEOXH+deN/5H4ugbe3UGg8z7/JdCYS4a7XMP6PGyHMQ9u3uvlVNyIohBtwBg0
         +fdjkYUvbGYN38QYAygA2Rp591iBho3AGdNetuhspz+gOHzlyKYQkUe8mYp1pY1BWPCF
         aWmTlvVJ2HFskriEcvH4beCcNwvSBiV+oMPbE=
MIME-Version: 1.0
In-Reply-To: <1285519830-6826-1-git-send-email-rahul.ruikar@gmail.com>
References: <1285519830-6826-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sun, 26 Sep 2010 22:41:43 +0530
Message-ID: <AANLkTinLPw+2QqPzLZ7X0BfRsfvqz1eh2Ay7P4t_Na+2@mail.gmail.com>
Subject: Re: [RESEND] pcmcia: vrc4173_cardu: Fix error path for
 pci_release_regions and pci_disable_device
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>
Content-Type: multipart/mixed; boundary=00163646da6ce7d0b904912cb595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163646da6ce7d0b904912cb595
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

patchwork link not showing latest changes of RESEND patch. hence
attaching in mail
https://patchwork.kernel.org/patch/210152/

- Rahul Ruikar





On 26 September 2010 22:20, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> - pci_release_regions called during return error path.
> - pci_disable_device called for cases where earlier it was enabled.
> - code duplication avoided/reduced by adding resource release at goto sta=
tements.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
> =A0drivers/pcmcia/vrc4173_cardu.c | =A0 58 +++++++++++++++++++++++++++---=
----------
> =A01 files changed, 39 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/pcmcia/vrc4173_cardu.c b/drivers/pcmcia/vrc4173_card=
u.c
> index 9b3c158..c6d36b3 100644
> --- a/drivers/pcmcia/vrc4173_cardu.c
> +++ b/drivers/pcmcia/vrc4173_cardu.c
> @@ -461,7 +461,7 @@ static int __devinit vrc4173_cardu_probe(struct pci_d=
ev *dev,
> =A0{
> =A0 =A0 =A0 =A0vrc4173_socket_t *socket;
> =A0 =A0 =A0 =A0unsigned long start, len, flags;
> - =A0 =A0 =A0 int slot, err;
> + =A0 =A0 =A0 int slot, err, ret;
>
> =A0 =A0 =A0 =A0slot =3D vrc4173_cardu_slots++;
> =A0 =A0 =A0 =A0socket =3D &cardu_sockets[slot];
> @@ -474,43 +474,63 @@ static int __devinit vrc4173_cardu_probe(struct pci=
_dev *dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>
> =A0 =A0 =A0 =A0start =3D pci_resource_start(dev, 0);
> - =A0 =A0 =A0 if (start =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> + =A0 =A0 =A0 if (start =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENODEV;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto disable;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0len =3D pci_resource_len(dev, 0);
> - =A0 =A0 =A0 if (len =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> + =A0 =A0 =A0 if (len =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENODEV;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto disable;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (((flags =3D pci_resource_flags(dev, 0)) & IORESOURCE_ME=
M) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
> + =A0 =A0 =A0 flags =3D pci_resource_flags(dev, 0);
> + =A0 =A0 =A0 if ((flags & IORESOURCE_MEM) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBUSY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto disable;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if ((err =3D pci_request_regions(dev, socket->name)) < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 err =3D pci_request_regions(dev, socket->name);
> + =A0 =A0 =A0 if (err < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto disable;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0socket->base =3D ioremap(start, len);
> - =A0 =A0 =A0 if (socket->base =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> + =A0 =A0 =A0 if (socket->base =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENODEV;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0socket->dev =3D dev;
>
> =A0 =A0 =A0 =A0socket->pcmcia_socket =3D pcmcia_register_socket(slot, &ca=
rdu_operations, 1);
> =A0 =A0 =A0 =A0if (socket->pcmcia_socket =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iounmap(socket->base);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket->base =3D NULL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D =A0-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unmap;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (request_irq(dev->irq, cardu_interrupt, IRQF_SHARED, so=
cket->name, socket) < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pcmcia_unregister_socket(socket->pcmcia_soc=
ket);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket->pcmcia_socket =3D NULL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iounmap(socket->base);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket->base =3D NULL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EBUSY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unregister;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printk(KERN_INFO "%s at %#08lx, IRQ %d\n", socket->name, s=
tart, dev->irq);
>
> =A0 =A0 =A0 =A0return 0;
> +
> +unregister:
> + =A0 =A0 =A0 pcmcia_unregister_socket(socket->pcmcia_socket);
> + =A0 =A0 =A0 socket->pcmcia_socket =3D NULL;
> +unmap:
> + =A0 =A0 =A0 iounmap(socket->base);
> + =A0 =A0 =A0 socket->base =3D NULL;
> +release:
> + =A0 =A0 =A0 pci_release_regions(dev);
> +disable:
> + =A0 =A0 =A0 pci_disable_device(dev);
> + =A0 =A0 =A0 return ret;
> =A0}
>
> =A0static int __devinit vrc4173_cardu_setup(char *options)
> --
> 1.7.2.3
>
>

--00163646da6ce7d0b904912cb595
Content-Type: application/octet-stream; 
	name="0001-pcmcia-vrc4173_cardu-Fix-error-path-for-pci_release_.patch"
Content-Disposition: attachment; 
	filename="0001-pcmcia-vrc4173_cardu-Fix-error-path-for-pci_release_.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gek5zgfa0

RnJvbSA2MjYwYWQ2NTdiMzI1MDE5YmNlMWM5NGMxMTEyOTIxYTYxMzRjNDE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWh1bCBSdWlrYXIgPHJhaHVsLnJ1aWthckBnbWFpbC5jb20+
CkRhdGU6IFN1biwgMjYgU2VwIDIwMTAgMjE6MzI6MTMgKzA1MzAKU3ViamVjdDogW1JFU0VORF0g
cGNtY2lhOiB2cmM0MTczX2NhcmR1OiBGaXggZXJyb3IgcGF0aCBmb3IgcGNpX3JlbGVhc2VfcmVn
aW9ucyBhbmQgcGNpX2Rpc2FibGVfZGV2aWNlCgotIHBjaV9yZWxlYXNlX3JlZ2lvbnMgY2FsbGVk
IGR1cmluZyByZXR1cm4gZXJyb3IgcGF0aC4KLSBwY2lfZGlzYWJsZV9kZXZpY2UgY2FsbGVkIGZv
ciBjYXNlcyB3aGVyZSBlYXJsaWVyIGl0IHdhcyBlbmFibGVkLgotIGNvZGUgZHVwbGljYXRpb24g
YXZvaWRlZC9yZWR1Y2VkIGJ5IGFkZGluZyByZXNvdXJjZSByZWxlYXNlIGF0IGdvdG8gc3RhdGVt
ZW50cy4KClNpZ25lZC1vZmYtYnk6IFJhaHVsIFJ1aWthciA8cmFodWwucnVpa2FyQGdtYWlsLmNv
bT4KLS0tCiBkcml2ZXJzL3BjbWNpYS92cmM0MTczX2NhcmR1LmMgfCAgIDU4ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0
aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY21jaWEvdnJj
NDE3M19jYXJkdS5jIGIvZHJpdmVycy9wY21jaWEvdnJjNDE3M19jYXJkdS5jCmluZGV4IDliM2Mx
NTguLmM2ZDM2YjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNtY2lhL3ZyYzQxNzNfY2FyZHUuYwor
KysgYi9kcml2ZXJzL3BjbWNpYS92cmM0MTczX2NhcmR1LmMKQEAgLTQ2MSw3ICs0NjEsNyBAQCBz
dGF0aWMgaW50IF9fZGV2aW5pdCB2cmM0MTczX2NhcmR1X3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpk
ZXYsCiB7CiAJdnJjNDE3M19zb2NrZXRfdCAqc29ja2V0OwogCXVuc2lnbmVkIGxvbmcgc3RhcnQs
IGxlbiwgZmxhZ3M7Ci0JaW50IHNsb3QsIGVycjsKKwlpbnQgc2xvdCwgZXJyLCByZXQ7CiAKIAlz
bG90ID0gdnJjNDE3M19jYXJkdV9zbG90cysrOwogCXNvY2tldCA9ICZjYXJkdV9zb2NrZXRzW3Ns
b3RdOwpAQCAtNDc0LDQzICs0NzQsNjMgQEAgc3RhdGljIGludCBfX2RldmluaXQgdnJjNDE3M19j
YXJkdV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqZGV2LAogCQlyZXR1cm4gZXJyOwogCiAJc3RhcnQg
PSBwY2lfcmVzb3VyY2Vfc3RhcnQoZGV2LCAwKTsKLQlpZiAoc3RhcnQgPT0gMCkKLQkJcmV0dXJu
IC1FTk9ERVY7CisJaWYgKHN0YXJ0ID09IDApIHsKKwkJcmV0ID0gLUVOT0RFVjsKKwkJZ290byBk
aXNhYmxlOworCX0KIAogCWxlbiA9IHBjaV9yZXNvdXJjZV9sZW4oZGV2LCAwKTsKLQlpZiAobGVu
ID09IDApCi0JCXJldHVybiAtRU5PREVWOworCWlmIChsZW4gPT0gMCkgeworCQlyZXQgPSAtRU5P
REVWOworCQlnb3RvIGRpc2FibGU7CisJfQogCi0JaWYgKCgoZmxhZ3MgPSBwY2lfcmVzb3VyY2Vf
ZmxhZ3MoZGV2LCAwKSkgJiBJT1JFU09VUkNFX01FTSkgPT0gMCkKLQkJcmV0dXJuIC1FQlVTWTsK
KwlmbGFncyA9IHBjaV9yZXNvdXJjZV9mbGFncyhkZXYsIDApOworCWlmICgoZmxhZ3MgJiBJT1JF
U09VUkNFX01FTSkgPT0gMCkgeworCQlyZXQgPSAtRUJVU1k7CisJCWdvdG8gZGlzYWJsZTsKKwl9
CiAKLQlpZiAoKGVyciA9IHBjaV9yZXF1ZXN0X3JlZ2lvbnMoZGV2LCBzb2NrZXQtPm5hbWUpKSA8
IDApCi0JCXJldHVybiBlcnI7CisJZXJyID0gcGNpX3JlcXVlc3RfcmVnaW9ucyhkZXYsIHNvY2tl
dC0+bmFtZSk7CisJaWYgKGVyciA8IDApIHsKKwkJcmV0ID0gZXJyOworCQlnb3RvIGRpc2FibGU7
CisJfQogCiAJc29ja2V0LT5iYXNlID0gaW9yZW1hcChzdGFydCwgbGVuKTsKLQlpZiAoc29ja2V0
LT5iYXNlID09IE5VTEwpCi0JCXJldHVybiAtRU5PREVWOworCWlmIChzb2NrZXQtPmJhc2UgPT0g
TlVMTCkgeworCQlyZXQgPSAtRU5PREVWOworCQlnb3RvIHJlbGVhc2U7CisJfQogCiAJc29ja2V0
LT5kZXYgPSBkZXY7CiAKIAlzb2NrZXQtPnBjbWNpYV9zb2NrZXQgPSBwY21jaWFfcmVnaXN0ZXJf
c29ja2V0KHNsb3QsICZjYXJkdV9vcGVyYXRpb25zLCAxKTsKIAlpZiAoc29ja2V0LT5wY21jaWFf
c29ja2V0ID09IE5VTEwpIHsKLQkJaW91bm1hcChzb2NrZXQtPmJhc2UpOwotCQlzb2NrZXQtPmJh
c2UgPSBOVUxMOwotCQlyZXR1cm4gLUVOT01FTTsKKwkJcmV0ID0gIC1FTk9NRU07CisJCWdvdG8g
dW5tYXA7CiAJfQogCiAJaWYgKHJlcXVlc3RfaXJxKGRldi0+aXJxLCBjYXJkdV9pbnRlcnJ1cHQs
IElSUUZfU0hBUkVELCBzb2NrZXQtPm5hbWUsIHNvY2tldCkgPCAwKSB7Ci0JCXBjbWNpYV91bnJl
Z2lzdGVyX3NvY2tldChzb2NrZXQtPnBjbWNpYV9zb2NrZXQpOwotCQlzb2NrZXQtPnBjbWNpYV9z
b2NrZXQgPSBOVUxMOwotCQlpb3VubWFwKHNvY2tldC0+YmFzZSk7Ci0JCXNvY2tldC0+YmFzZSA9
IE5VTEw7Ci0JCXJldHVybiAtRUJVU1k7CisJCXJldCA9IC1FQlVTWTsKKwkJZ290byB1bnJlZ2lz
dGVyOwogCX0KIAogCXByaW50ayhLRVJOX0lORk8gIiVzIGF0ICUjMDhseCwgSVJRICVkXG4iLCBz
b2NrZXQtPm5hbWUsIHN0YXJ0LCBkZXYtPmlycSk7CiAKIAlyZXR1cm4gMDsKKwordW5yZWdpc3Rl
cjoKKwlwY21jaWFfdW5yZWdpc3Rlcl9zb2NrZXQoc29ja2V0LT5wY21jaWFfc29ja2V0KTsKKwlz
b2NrZXQtPnBjbWNpYV9zb2NrZXQgPSBOVUxMOwordW5tYXA6CisJaW91bm1hcChzb2NrZXQtPmJh
c2UpOworCXNvY2tldC0+YmFzZSA9IE5VTEw7CityZWxlYXNlOgorCXBjaV9yZWxlYXNlX3JlZ2lv
bnMoZGV2KTsKK2Rpc2FibGU6CisJcGNpX2Rpc2FibGVfZGV2aWNlKGRldik7CisJcmV0dXJuIHJl
dDsKIH0KIAogc3RhdGljIGludCBfX2RldmluaXQgdnJjNDE3M19jYXJkdV9zZXR1cChjaGFyICpv
cHRpb25zKQotLSAKMS43LjIuMwoK
--00163646da6ce7d0b904912cb595--
