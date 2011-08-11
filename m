Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1HKVtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:49:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1HKVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:49:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=rFCS0v84aixmRvHYx4jeGg6RfOe5LeDl31Z98h6vjw0OsHYs+ELMUfUPpEcH5l3km
	IRu9laHUsqWm51H4yZh2Q==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108111657190.12436@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1108111657190.12436@boston.corp.fedex.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Aug 2011 15:49:18 -0600
Message-ID: <CAErSpo6AFk71S38O6PAjbAO3P7JP2=D3THuatBhUq76unYV+tQ@mail.gmail.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Andrey Panin <pazke@centrinvest.ru>, lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: multipart/mixed; boundary=00151750edfc0ec87a04aa41c6f3
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151750edfc0ec87a04aa41c6f3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2011 at 3:07 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrot=
e:
>
>
> On Thu, Aug 11, 2011 at 12:46 AM, Bjorn Helgaas <bhelgaas@google.com> wro=
te:
>>
>> On Fri, Aug 5, 2011 at 7:02 PM, Jeff Chua <jeff.chua.linux@gmail.com>
>
> wrote:
>>
>> Ping, just a reminder :)
>> I'm pretty sure Linux only runs _SRS when we actually *change* something=
,
>> which doesn't seem to follow the intent of the spec. =A0So if
>> we can get a little more evidence here, I think it'd be worth changing
>> Linux to call _SRS for every device when it enumerates it.
>
> I did some test and it seems "auto" didn't enable the port. With "auto",
> dmesg showed more info (io 0x3e8-0x3ef irq 6), but port still disabled.
>
> After "activate", then the port can be used.

Yep, that's what I would expect.  "auto" does some work in the kernel
to choose resources that look like they should work, but it doesn't
touch the firmware or the hardware itself.  "activate" evaluates the
ACPI _SRS method, which is how we tell the firmware what resources we
want.  The _SRS method would program those into the hardware.

> I've attached the DSDT.dat.dsl. I've reconfigured the kernel with
> CONFIG_PNP_DEBUG_MESSAGES=3Dy, booting with "pnp.debug", but there were n=
ot a
> lot of messages in dmesg.

Oops, my mistake.  You now need "pnp.debug=3D1" to turn the extra debug
on (I just posted a patch to update
Documentation/kernel-parameters.txt).

> 00:0a PNP4972 (unknown)

> # cat /sys/bus/pnp/devices/00:0a/resources
> state =3D disabled
> io 0x3e8-0x3ef
> irq 6
>
> # setserial /dev/ttyS2 uart 16550a irq 6
> ttyS2: LSR safety check engaged!
> ttyS2: LSR safety check engaged!

Hmm, the fact that you need "setserial" is telling us there's another
Linux bug here.  PNP4972 is not one of the PNP IDs the 8250_pnp driver
knows about (I would have expected ACPI to supply a "compatible device
ID" of PNP0501 so we could fall back to the generic 8250_pnp driver),
so we currently don't have a path to get the I/O port address or the
IRQ info to the serial driver automatically.  On x86, the 8250 driver
has some hardcoded addresses compiled into it (ttyS2 at 0x3e8 being
one of them), and "setserial" is the manual way of changing the
default IRQ 4 to IRQ 6.

> # echo disable > /sys/bus/pnp/devices/00:0a/resources
>
> # dmesg
> pnp 00:0a: disabled
>
> # cat /sys/bus/pnp/devices/00:0a/resources
> state =3D disabled
>
> # echo activate > /sys/bus/pnp/devices/00:0a/resources
> -bash: echo: write error: Device or resource busy

This *should* work.  My guess is that it's failing because the I/O
ports at 0x3e8 are still reserved.  The PNP core doesn't actually
reserve anything, so it would have to be the 8250 driver.  It doesn't
mention those ports in dmesg, so maybe they get reserved when you do
the "setserial."  The 8250 driver has no idea that you disabled the
PNP device, so it would never release them.  Then when you try to
activate it again, they're still in use.  You can test this idea a
little bit by looking at /proc/ioports (1) immediately after boot, (2)
before "setserial", (3) after "setserial", and (4) after you disable
the PNP device.

I attached an experimental patch that add PNP4972 to the 8250_pnp
driver and tries to automatically activate devices.  Can you give it a
try (with "pnp.debug=3D1")?

Thanks,
  Bjorn

--00151750edfc0ec87a04aa41c6f3
Content-Type: application/octet-stream; name=intermec-uart
Content-Disposition: attachment; filename=intermec-uart
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gr89bn450

Y29tbWl0IGJkNTIzODNmOGE0ZDQ2NWY4MzNmNDc5ZjRjMjFiMjIwYjM2YTg0Y2YKQXV0aG9yOiBC
am9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIFRodSBBdWcgMTEgMTM6
MDY6NDIgMjAxMSAtMDYwMAoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwX3Bu
cC5jIGIvZHJpdmVycy90dHkvc2VyaWFsLzgyNTBfcG5wLmMKaW5kZXggZmMzMDFmNi4uYTJmMjM2
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy90dHkvc2VyaWFsLzgyNTBfcG5wLmMKKysrIGIvZHJpdmVy
cy90dHkvc2VyaWFsLzgyNTBfcG5wLmMKQEAgLTEwOSw2ICsxMDksOSBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHBucF9kZXZpY2VfaWQgcG5wX2Rldl90YWJsZVtdID0gewogCS8qIElCTSAqLwogCS8q
IElCTSBUaGlua3BhZCA3MDEgSW50ZXJuYWwgTW9kZW0gVm9pY2UgKi8KIAl7CSJJQk0wMDMzIiwJ
CTAJfSwKKwkvKiBJbnRlcm1lYyAqLworCS8qIEludGVybWVjIENWNjAgdG91Y2hzY3JlZW4gcG9y
dCAqLworCXsJIlBOUDQ5NzIiLAkJMAl9LAogCS8qIEludGVydGV4ICovCiAJLyogSW50ZXJ0ZXgg
MjhrOCAzM2s2IFZvaWNlIEVYVCBQblAgKi8KIAl7CSJJWERDODAxIiwJCTAJfSwKY29tbWl0IGI1
M2FkYTk4OThlYzhhZmIxNGE1YjdmOGU2NjA2Njk3OWI5N2Y5NDYKQXV0aG9yOiBCam9ybiBIZWxn
YWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIFRodSBBdWcgMTEgMTM6MTA6MzEgMjAx
MSAtMDYwMAoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcG5wL3BucGFjcGkvY29yZS5jIGIvZHJpdmVy
cy9wbnAvcG5wYWNwaS9jb3JlLmMKaW5kZXggY2E4NGQ1MC4uNjY4NzcxMSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9wbnAvcG5wYWNwaS9jb3JlLmMKKysrIGIvZHJpdmVycy9wbnAvcG5wYWNwaS9jb3Jl
LmMKQEAgLTI4MCwxMSArMjgwLDE2IEBAIHN0YXRpYyBpbnQgX19pbml0IHBucGFjcGlfYWRkX2Rl
dmljZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAllbHNlCiAJCXN0cm5jcHkoZGV2LT5u
YW1lLCBhY3BpX2RldmljZV9iaWQoZGV2aWNlKSwgc2l6ZW9mKGRldi0+bmFtZSkpOwogCisJaWYg
KGRldi0+Y2FwYWJpbGl0aWVzICYgUE5QX0NPTkZJR1VSQUJMRSkKKwkJcG5wYWNwaV9wYXJzZV9y
ZXNvdXJjZV9vcHRpb25fZGF0YShkZXYpOworCiAJaWYgKGRldi0+YWN0aXZlKQogCQlwbnBhY3Bp
X3BhcnNlX2FsbG9jYXRlZF9yZXNvdXJjZShkZXYpOworCWVsc2UKKwkJcG5wX2F1dG9fY29uZmln
X2RldihkZXYpOwogCiAJaWYgKGRldi0+Y2FwYWJpbGl0aWVzICYgUE5QX0NPTkZJR1VSQUJMRSkK
LQkJcG5wYWNwaV9wYXJzZV9yZXNvdXJjZV9vcHRpb25fZGF0YShkZXYpOworCQlwbnBhY3BpX3Nl
dF9yZXNvdXJjZXMoZGV2KTsKIAogCWxpc3RfZm9yX2VhY2hfZW50cnkoaWQsICZkZXZpY2UtPnBu
cC5pZHMsIGxpc3QpIHsKIAkJaWYgKCFzdHJjbXAoaWQtPmlkLCBwbnBpZCkpCg==
--00151750edfc0ec87a04aa41c6f3--
