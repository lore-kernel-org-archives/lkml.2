Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KGSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:15:43 -0500
Received: from pilot.jhuapl.edu ([128.244.251.36]:64073 "EHLO jhuapl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277Ab2KGSPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:15:41 -0500
Message-ID: <509AA501.1090701@jhuapl.edu>
Date: Wed, 07 Nov 2012 13:14:25 -0500
From: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: "mail@srajiv.net" <mail@srajiv.net>, "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu> <20121107144625.GA14628@ennui.austin.ibm.com>
In-Reply-To: <20121107144625.GA14628@ennui.austin.ibm.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080608050803030603010205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080608050803030603010205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/07/2012 09:46 AM, Kent Yoder wrote:
> Hi Matthew,
>
> On Mon, Nov 05, 2012 at 10:09:57AM -0500, Matthew Fioravante wrote:
>> This patch ports the xen vtpm frontend driver for linux
>> from the linux-2.6.18-xen.hg tree to linux-stable.
>>
>> Signed-off-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
>> ---
>>   drivers/char/tpm/Kconfig         |    9 +
>>   drivers/char/tpm/Makefile        |    2 +
>>   drivers/char/tpm/tpm.h           |   15 +
>>   drivers/char/tpm/tpm_vtpm.c      |  543 ++++++++++++++++++++++++++++=
++
>>   drivers/char/tpm/tpm_vtpm.h      |   55 +++
>>   drivers/char/tpm/tpm_xen.c       |  690 ++++++++++++++++++++++++++++=
++++++++++
>>   include/xen/interface/io/tpmif.h |   77 +++++
>>   7 files changed, 1391 insertions(+)
>>   create mode 100644 drivers/char/tpm/tpm_vtpm.c
>>   create mode 100644 drivers/char/tpm/tpm_vtpm.h
>>   create mode 100644 drivers/char/tpm/tpm_xen.c
>>   create mode 100644 include/xen/interface/io/tpmif.h
>>
>> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>> index 915875e..08c1010 100644
>> --- a/drivers/char/tpm/Kconfig
>> +++ b/drivers/char/tpm/Kconfig
>> @@ -81,4 +81,13 @@ config TCG_IBMVTPM
>>   	  will be accessible from within Linux.  To compile this driver
>>   	  as a module, choose M here; the module will be called tpm_ibmvtpm=
=2E
>>
>> +config TCG_XEN
>> +	tristate "XEN TPM Interface"
>> +	depends on TCG_TPM && XEN
>> +	---help---
>> +	  If you want to make TPM support available to a Xen user domain,
>> +	  say Yes and it will be accessible from within Linux.
>> +	  To compile this driver as a module, choose M here; the module
>> +	  will be called tpm_xenu.
>> +
>>   endif # TCG_TPM
>> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>> index 5b3fc8b..16911c5 100644
>> --- a/drivers/char/tpm/Makefile
>> +++ b/drivers/char/tpm/Makefile
>> @@ -17,3 +17,5 @@ obj-$(CONFIG_TCG_NSC) +=3D tpm_nsc.o
>>   obj-$(CONFIG_TCG_ATMEL) +=3D tpm_atmel.o
>>   obj-$(CONFIG_TCG_INFINEON) +=3D tpm_infineon.o
>>   obj-$(CONFIG_TCG_IBMVTPM) +=3D tpm_ibmvtpm.o
>> +obj-$(CONFIG_TCG_XEN) +=3D tpm_xenu.o
>> +tpm_xenu-y =3D tpm_xen.o tpm_vtpm.o
>   Let's match the naming convention of the other drivers if we can, so =
this
> would be something like tpm_xenvtpm.c. tpm_vtpm is too generic...
Makes sense, fixed.
>
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 8ef7649..2e5a47a 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -130,6 +130,9 @@ struct tpm_chip {
>>
>>   	struct list_head list;
>>   	void (*release) (struct device *);
>> +#if CONFIG_XEN
>> +	void *priv;
>> +#endif
>   Can you use the chip->vendor.data pointer here instead? tpm_ibmvtpm i=
s
> already using that as a priv pointer. I should probably change that nam=
e
> to make it more obvious what that's used for.
That makes more sense. I'm guessing your data pointer didn't exist=20
during the 2.6.18 kernel which is why they added their own priv pointer.
>
>>   };
>>
>>   #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
>> @@ -310,6 +313,18 @@ struct tpm_cmd_t {
>>
>>   ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
>>
>> +#ifdef CONFIG_XEN
>> +static inline void *chip_get_private(const struct tpm_chip *chip)
>> +{
>> +	return chip->priv;
>> +}
>> +
>> +static inline void chip_set_private(struct tpm_chip *chip, void *priv=
)
>> +{
>> +	chip->priv =3D priv;
>> +}
>> +#endif
>   Can you put these in tpm_vtpm.c please?  One less #define. :-)
Agreed, I'd rather not have to modify your shared tpm.h interface at all.=

>
> [cut]
>> +#ifndef __XEN_PUBLIC_IO_TPMIF_H__
>> +#define __XEN_PUBLIC_IO_TPMIF_H__
>> +
>> +#include "../grant_table.h"
>> +
>> +struct tpmif_tx_request {
>> +	unsigned long addr;   /* Machine address of packet.   */
>> +	grant_ref_t ref;      /* grant table access reference */
>> +	uint16_t unused;
>> +	uint16_t size;        /* Packet size in bytes.        */
>> +};
>> +typedef struct tpmif_tx_request tpmif_tx_request_t;
>    checkpatch warned on this new typedef - please run through checkpatc=
h
> and fix up that stuff.
tpmif.h has a couple of typedefs which do trigger checkpatch warnings.=20
However it looks like the paradigm for xen is to have these=20
interface/io/<dev>if.h files and all of them have typedefs. I think in=20
this case the typedef should probably stay.

Konrad your thoughts here?
>
>> +
>> +/*
>> + * The TPMIF_TX_RING_SIZE defines the number of pages the
>> + * front-end and backend can exchange (=3D size of array).
>> + */
>> +typedef uint32_t TPMIF_RING_IDX;
>> +
>> +#define TPMIF_TX_RING_SIZE 1
>> +
>> +/* This structure must fit in a memory page. */
>> +
>> +struct tpmif_ring {
>> +	struct tpmif_tx_request req;
>> +};
>> +typedef struct tpmif_ring tpmif_ring_t;
>> +
>> +struct tpmif_tx_interface {
>> +	struct tpmif_ring ring[TPMIF_TX_RING_SIZE];
>> +};
>> +typedef struct tpmif_tx_interface tpmif_tx_interface_t;
>> +
>> +#endif
>> +
>> +/*
>> + * Local variables:
>> + * mode: C
>> + * c-set-style: "BSD"
>> + * c-basic-offset: 4
>> + * tab-width: 4
>> + * indent-tabs-mode: nil
>> + * End:
>> + */
>    Please take this comment out, see Documentation/CodingStyle.
Fixed
>
> Thanks,
> Kent
>
>> --=20
>> 1.7.10.4
>>
>>



--------------ms080608050803030603010205
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIDyjCC
A8YwggMvoAMCAQICBD/xyf0wDQYJKoZIhvcNAQEFBQAwLzELMAkGA1UEBhMCVVMxDzANBgNV
BAoTBkpIVUFQTDEPMA0GA1UECxMGQklTRENBMB4XDTEwMDYxMTE4MjIwNloXDTEzMDYxMTE4
NTIwNlowZjELMAkGA1UEBhMCVVMxDzANBgNVBAoTBkpIVUFQTDEPMA0GA1UECxMGUGVvcGxl
MTUwFgYDVQQLEw9WUE5Hcm91cC1CSVNEQ0EwGwYDVQQDExRNYXR0aGV3IEUgRmlvcmF2YW50
ZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAnpbwVSP6o1Nb5lcW7dd3yTo9iBJdi7qz
4nANOMFPK7JOy5npKN1iiousl28U/scUJES55gPwAWYJK3uVyQAsA4adgDKi5DoD1UHDQEwp
bY7iHLJeq0NPr4BqYNqnCFPbE6HC8zSJrr4qKn+gVUQT39SIFqdiIPJwZL8FYTRQ/zsCAwEA
AaOCAbYwggGyMAsGA1UdDwQEAwIHgDArBgNVHRAEJDAigA8yMDEwMDYxMTE4MjIwNlqBDzIw
MTIwNzE3MjI1MjA2WjAbBg0rBgEEAbMlCwMBAQEBBAoWCGZpb3JhbWUxMBsGDSsGAQQBsyUL
AwEBAQIEChIIMDAxMDQyNjEwWAYJYIZIAYb6ax4BBEsMSVRoZSBwcml2YXRlIGtleSBjb3Jy
ZXNwb25kaW5nIHRvIHRoaXMgY2VydGlmaWNhdGUgbWF5IGhhdmUgYmVlbiBleHBvcnRlZC4w
KAYDVR0RBCEwH4EdTWF0dGhldy5GaW9yYXZhbnRlQGpodWFwbC5lZHUwUgYDVR0fBEswSTBH
oEWgQ6RBMD8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJU0RD
QTEOMAwGA1UEAxMFQ1JMNTYwHwYDVR0jBBgwFoAUCDUpmxH52EU2CyWmF2EJMB1yqeswHQYD
VR0OBBYEFO6LYxg6r9wHZ+zdQtBHn1dZ/YTNMAkGA1UdEwQCMAAwGQYJKoZIhvZ9B0EABAww
ChsEVjcuMQMCBLAwDQYJKoZIhvcNAQEFBQADgYEAJO9HQh4YNChVLzuZqK5ARJARD8JoujGZ
fdo75quvg2jXFQe2sEjvLnxJZgm/pv8fdZakq48CWwjYHKuvIp7sDjTEsQfo+y7SpN/N2NvJ
WU5SqfK1VgYtNLRRoGJUB5Q1aZ+Dg95g3kqpyfpUMISJL8IKVLtJVfN4fggFVUYZ9wwxggGr
MIIBpwIBATA3MC8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJ
U0RDQQIEP/HJ/TAJBgUrDgMCGgUAoIHLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEyMTEwNzE4MTQyNVowIwYJKoZIhvcNAQkEMRYEFBwk6zhe4ThjAtby
xJcPImgIpUAuMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYI
KoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEgYCV7QCgPV0a6wjPTkin2QRV0fkmRegK/e7z
bG7NkhPNHIZy8Ev6rCNqrX3/Xamy2lJ2pssnjMa1+XPf9am1R9YdvDDbvp2Vkzd+rnosQirI
w0lt1L3M1ZMsGQElentQKt9VDlXpBYy+bljrqxZmVlBMa/atysXrJBKJAjtlQbsd+wAAAAAA
AA==
--------------ms080608050803030603010205--
