Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017Ab1EJSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:25:57 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:45415 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1EJSZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=message-id
	:date:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type; q=dns; s=2007072601; b=ZQlhflSF/yCVYX8HffA0oD7/Aa
	72jvPgSDDD/+L82OKwW5Nw4ASTXLntRRfcL0Yjke3YfmtGYPJkjQyY9s92IdnYtP
	NXxR/560iY9bR5iJshVp4tk0j0+YeyoM1K/tmdWo/n+4UoAeD0LUQHbLkngz8uhS
	r26apr3pZZFYDHC94=
Message-ID: <4DC9832E.3040909@slagter.name>
Date: Tue, 10 May 2011 20:25:50 +0200
From: Erik Slagter <erik@slagter.name>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Mnenhy/0.8.3 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Maxin John <maxin.john@gmail.com>
Subject: Re: OOPS after connection Droids MuIn USB display
References: <4DC3B0E3.7010008@slagter.name> <4DC3D296.9060707@slagter.name> <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com> <4DC42897.3000300@slagter.name> <BANLkTinGydyuG58zwVG43VnDz845BOw1Tg@mail.gmail.com> <4DC4EE99.1090205@slagter.name> <20110507200252.GA19753@kroah.com>
In-Reply-To: <20110507200252.GA19753@kroah.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050202010406060607000005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050202010406060607000005
Content-Type: multipart/mixed;
 boundary="------------040404070404060608030006"

This is a multi-part message in MIME format.
--------------040404070404060608030006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 07-05-11 22:02, Greg KH wrote:
> On Sat, May 07, 2011 at 09:02:49AM +0200, Erik Slagter wrote:
>>> Congratulations and thanks for explaining the details.
>> And now my big question is, can this be fixed upstream? ;-)
> Yes, if someone sends us a patch :)

Hi Greg,

Maxin John has been so kind as to make a patch which I tested and=20
tweaked a tiny bit. The attached patch set should do the trick. Does=20
this suffice this way?

Thanks,
Erik Slagter.

--------------040404070404060608030006
Content-Type: text/x-csrc;
 name="diff-cdc-acm.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="diff-cdc-acm.c"

--- cdc-acm.c-dist	2011-05-10 19:42:37.000000000 +0200
+++ cdc-acm.c	2011-05-10 19:50:07.000000000 +0200
@@ -946,7 +946,7 @@
 	u8 ac_management_function =3D 0;
 	u8 call_management_function =3D 0;
 	int call_interface_num =3D -1;
-	int data_interface_num;
+	int data_interface_num =3D -1;
 	unsigned long quirks;
 	int num_rx_buf;
 	int i;
@@ -1030,7 +1030,11 @@
 	if (!union_header) {
 		if (call_interface_num > 0) {
 			dev_dbg(&intf->dev, "No union descriptor, using call management descr=
iptor\n");
-			data_interface =3D usb_ifnum_to_if(usb_dev, (data_interface_num =3D c=
all_interface_num));
+			/* quirks for Droids MuIn LCD */
+			if (quirks & NO_DATA_INTERFACE)
+				data_interface =3D usb_ifnum_to_if(usb_dev, 0);
+			else
+				data_interface =3D usb_ifnum_to_if(usb_dev, (data_interface_num =3D =
call_interface_num));
 			control_interface =3D intf;
 		} else {
 			if (intf->cur_altsetting->desc.bNumEndpoints !=3D 3) {
@@ -1622,6 +1626,11 @@
 	.driver_info =3D NOT_A_MODEM,
 	},
=20
+	/* Support for Droids MuIn LCD */
+	{ USB_DEVICE(0x04d8, 0x000b),
+	.driver_info =3D NO_DATA_INTERFACE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },

--------------040404070404060608030006
Content-Type: text/x-chdr;
 name="diff-cdc-acm.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="diff-cdc-acm.h"

--- cdc-acm.h-dist	2011-05-10 19:43:18.000000000 +0200
+++ cdc-acm.h	2011-05-10 19:43:40.000000000 +0200
@@ -137,3 +137,4 @@
 #define SINGLE_RX_URB			2
 #define NO_CAP_LINE			4
 #define NOT_A_MODEM			8
+#define NO_DATA_INTERFACE		16

--------------040404070404060608030006--

--------------ms050202010406060607000005
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPWDCC
BIowggNyoAMCAQICECf06hH0eobEbp27bqkXBwcwDQYJKoZIhvcNAQEFBQAwbzELMAkGA1UE
BhMCU0UxFDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1BZGRUcnVzdCBFeHRlcm5h
bCBUVFAgTmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3QgRXh0ZXJuYWwgQ0EgUm9vdDAeFw0w
NTA2MDcwODA5MTBaFw0yMDA1MzAxMDQ4MzhaMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMC
VVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVRO
LVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsjmFpPJ9q0E7YkY3rs3BYHW8OWX5ShpHornMSMxqmNVN
NRm5pELlzkniii8efNIxB8dOtINknS4p1aJkxIW9hVE1eaROaJB7HHqkkqgX8pgV8pPMyaQy
lbsMTzC9mKALi+VuG6JG+ni8om+rWV6lL8/K2m2qL+usobNqqrcuZzWLeeEeaYji5kbNoKXq
vgvOdjp6Dpvq/NonWz1zHyLmSGHGTPNpsaguG7bUMSAsvIKKjqQOpdeJQ/wWWq8dcdcRWdq6
hw2v+vPhwvCkxWeM1tZUOt4KpLoDd7NlyP0e03RiqhjKaJMeoYV+9Udly/hNVyh00jT/MLbu
9mIwFIws6wIDAQABo4HhMIHeMB8GA1UdIwQYMBaAFK29mHo0tCb3+sQmVO8DveAky1QaMB0G
A1UdDgQWBBSJgmd9xJ0mcABLtFBIfN49rgRufTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/
BAUwAwEB/zB7BgNVHR8EdDByMDigNqA0hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9BZGRU
cnVzdEV4dGVybmFsQ0FSb290LmNybDA2oDSgMoYwaHR0cDovL2NybC5jb21vZG8ubmV0L0Fk
ZFRydXN0RXh0ZXJuYWxDQVJvb3QuY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQAZ2IkRbyispgCi
54fBm5AD236hEv0e8+LwAamUVEJrmgnEoG3XkJIEA2Z5Q3H8+G+v23ZF4jcaPd3kWQR4rBz0
g0bzes9bhHIt5UbBuhgRKfPLSXmHPLptBZ2kbWhPrXIUNqi5sf2/z3/wpGqUNVCPz4FtVbHd
WTBK322gnGQfSXzvNrv042n0+DmPWq1LhTq3Du3Tzw1EovsEv+QvcI4l+1pUBrPQxLxtjftz
Mizpm4QkLdZ/kXpoAlAfDj9N6cz1u2fo3BwuO/xOzf4CjuOoEwqlJkRl6RDyTVKnrtw+ymsy
XEFs/vVdoOr/0fqbhlhtPZZH5f4ulQTCAMyOofK7MIIFYTCCBEmgAwIBAgIRAIg14yiGxBLB
Nd3nEhie2VcwDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEX
MBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29y
azEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNF
UkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwwHhcNMTAxMDE5MDAwMDAw
WhcNMTExMDE5MjM1OTU5WjBGMQswCQYDVQQGEwJOTDEVMBMGA1UEAxMMRXJpayBTbGFndGVy
MSAwHgYJKoZIhvcNAQkBFhFlcmlrQHNsYWd0ZXIubmFtZTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBANbriwH0w2kwn4b2BwVAtiZ0OkHIiwcscx1XIOzD/bp+Sv4tVdjc2bBF
tXTyEpDzP5cLs5V3g1hTxI5V40lgmsiKrDMp8XR6fDwqv0cdoS3ABS/gvlxhwvbJaeR7tjkM
Ni4ofKgEfSWi7hzFyijuwM/SrwJVlpTO7Xah+FKDLVh8FWUHRVxtnFuLaHcZR+4y0c0Zi2AE
gp3CLZQzXCsu/Nsi+0fclP4lbhg+XgAgTKDI2WIm7JuQgMSgoevQ6HFggreTj03tUoKjD4l4
JIoDb5tc/IutLhwXZTZsrdmW2SE29xhRWauNGs9DnJAcmpUJkXHGGL8cgmqWb1Mlh9JBaN8C
AwEAAaOCAd8wggHbMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQW
BBTK4wFgfa4mmdF0XOGvj3dgyG8ePzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAd
BgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIB
AwUwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUGA1Ud
HwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1D
bGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21v
ZG8ubmV0L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmww
bAYIKwYBBQUHAQEEYDBeMDYGCCsGAQUFBzAChipodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9V
VE5BQUFDbGllbnRDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTANBgkqhkiG9w0BAQUFAAOCAQEAALQg8UqA2KoLGSmq8SsJTddYzpglJrW3mcd55qDBKLBM
J5klHPPWoqdV2dA9X0yV4WlaS/eQHfgmQCjvJ42HDNJW6YBw1MrPFPxXFJsbpY0OlIeLY5oh
VZjuQeI3YfwOB1ZceU4QTkdF636Ljyz3D++PmSw6ww6mm8R8LX18JIYe6vhWZs93sSMQct3R
2s9kGB94lCKbapyq9lBhT/swM51wWTmnrIxrmFzm0+fFnNu9QwoazTn7hwg7G0Tiv2Zqz+Ba
x318aG+gZm1OnQQRPn1hiK5C6GiKrWu9/jTV3UaGePBGslkpopMdLrwQ43P/eHmJJGyXHBLx
87J7yN8HMzCCBWEwggRJoAMCAQICEQCINeMohsQSwTXd5xIYntlXMA0GCSqGSIb3DQEBBQUA
MIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5
MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cu
dXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIEVtYWlsMB4XDTEwMTAxOTAwMDAwMFoXDTExMTAxOTIzNTk1OVowRjELMAkG
A1UEBhMCTkwxFTATBgNVBAMTDEVyaWsgU2xhZ3RlcjEgMB4GCSqGSIb3DQEJARYRZXJpa0Bz
bGFndGVyLm5hbWUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDW64sB9MNpMJ+G
9gcFQLYmdDpByIsHLHMdVyDsw/26fkr+LVXY3NmwRbV08hKQ8z+XC7OVd4NYU8SOVeNJYJrI
iqwzKfF0enw8Kr9HHaEtwAUv4L5cYcL2yWnke7Y5DDYuKHyoBH0lou4cxcoo7sDP0q8CVZaU
zu12ofhSgy1YfBVlB0VcbZxbi2h3GUfuMtHNGYtgBIKdwi2UM1wrLvzbIvtH3JT+JW4YPl4A
IEygyNliJuybkIDEoKHr0OhxYIK3k49N7VKCow+JeCSKA2+bXPyLrS4cF2U2bK3ZltkhNvcY
UVmrjRrPQ5yQHJqVCZFxxhi/HIJqlm9TJYfSQWjfAgMBAAGjggHfMIIB2zAfBgNVHSMEGDAW
gBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUyuMBYH2uJpnRdFzhr493YMhvHj8w
DgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsG
AQUFBwMCMEYGA1UdIAQ/MD0wOwYMKwYBBAGyMQECAQMFMCswKQYIKwYBBQUHAgEWHWh0dHBz
Oi8vc2VjdXJlLmNvbW9kby5uZXQvQ1BTMIGlBgNVHR8EgZ0wgZowTKBKoEiGRmh0dHA6Ly9j
cmwuY29tb2RvY2EuY29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRF
bWFpbC5jcmwwSqBIoEaGRGh0dHA6Ly9jcmwuY29tb2RvLm5ldC9VVE4tVVNFUkZpcnN0LUNs
aWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMGwGCCsGAQUFBwEBBGAwXjA2BggrBgEF
BQcwAoYqaHR0cDovL2NydC5jb21vZG9jYS5jb20vVVROQUFBQ2xpZW50Q0EuY3J0MCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEFBQADggEBAAC0
IPFKgNiqCxkpqvErCU3XWM6YJSa1t5nHeeagwSiwTCeZJRzz1qKnVdnQPV9MleFpWkv3kB34
JkAo7yeNhwzSVumAcNTKzxT8VxSbG6WNDpSHi2OaIVWY7kHiN2H8DgdWXHlOEE5HRet+i48s
9w/vj5ksOsMOppvEfC19fCSGHur4VmbPd7EjEHLd0drPZBgfeJQim2qcqvZQYU/7MDOdcFk5
p6yMa5hc5tPnxZzbvUMKGs05+4cIOxtE4r9mas/gWsd9fGhvoGZtTp0EET59YYiuQuhoiq1r
vf401d1GhnjwRrJZKaKTHS68EONz/3h5iSRslxwS8fOye8jfBzMxggRgMIIEXAIBATCBxDCB
rjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEe
MBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVz
ZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0
aW9uIGFuZCBFbWFpbAIRAIg14yiGxBLBNd3nEhie2VcwCQYFKw4DAhoFAKCCAnAwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwNTEwMTgyNTUwWjAjBgkq
hkiG9w0BCQQxFgQU6SPcP3HP8n+4nlwJBq7rPtwLKMMwXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQxgccwgcQwga4xCzAJBgNVBAYT
AlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRo
ZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29t
MTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1h
aWwCEQCINeMohsQSwTXd5xIYntlXMIHXBgsqhkiG9w0BCRACCzGBx6CBxDCBrjELMAkGA1UE
BhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5j
b20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBF
bWFpbAIRAIg14yiGxBLBNd3nEhie2VcwDQYJKoZIhvcNAQEBBQAEggEAM8veJ4tJwtmfUO+B
BdAobd5eEDeeIj3VslhCIEJs3Gj99zB21BL/t+FDV5KiuiZ3E4E0S8meUWUbWG2mIJr1dOZx
+NLhlNzX+kGA1kaWOG878OEEIdsvq4XO6gwNMRobl6xDVfUW/OfYflaUyqV3TSZXEuQMWe69
IMTmfng2VvPy/4UyeuWxO+diEFwZoQmHYeX8qTuMmgNJNHvF4bUybd1KqnLWYDMMw80VAG8F
LlnXijzXth39Hsw2fLSn0kKG+P+aLN/wN//Owh5Pq9QoyPTcO1wwoCWxlmpJILQshSBYKyug
RdvLhkO7die1Bq65w5qpSp0Ju0e11vBNIu7QDgAAAAAAAA==
--------------ms050202010406060607000005--
