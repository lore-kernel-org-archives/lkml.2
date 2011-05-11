Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1EKPjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:39:44 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:35837 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1EKPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=message-id
	:date:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type; q=dns; s=2007072601; b=m9aXZMk45Qo7XyPVq9tJi31Wut
	XvLmA4JExlYCqzVRx9kP/iK6a0mzrkF7+RK6ODE0VAHSH5bsBoUkakC4fqHqfV2/
	xoTAeYBJ0widu0shzhltmQ8jaWJ/L1jkbMWkXgAwavDK285msf5CkzKCBVEKBFzW
	lJK5l0UlyDkymVu7M=
Message-ID: <4DCA5FBF.1050009@slagter.name>
Date: Wed, 11 May 2011 12:06:55 +0200
From: Erik Slagter <erik@slagter.name>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Maxin John <maxin.john@gmail.com>, greg@kroah.com
Subject: [PATCH 001/001]: USB: cdc_acm: Fix oops when Droids MuIn LCD is connected
References: <20110510074421.GA2755@maxin>	<4DC97BD0.6040403@slagter.name>	<BANLkTi=OQ=ahXW2n=ww4ZZ8vK4=mv6Kc7A@mail.gmail.com>
In-Reply-To: <BANLkTi=OQ=ahXW2n=ww4ZZ8vK4=mv6Kc7A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020406040501040406010101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020406040501040406010101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Erik Slagter <erik@slagter.name>

The Droids MuIn LCD operates like a serial remote terminal.
Data received are displayed directly on the LCD. This patch
fixes the kernel null pointer oops when it is plugged in.

Add NO_DATA_INTERFACE quirk to tell the driver that "control"
and "data" interfaces are not separated for this device, which
prevents dereferencing a null pointer in the device probe code.

Signed-off-by: Erik Slagter <erik@slagter.name>
Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Tested-by: Erik Slagter <erik@slagter.name>
---
This patch applies to vanilla kernel 2.6.38.2, but I am quite
confident it will apply to any recent kernel. It was created by
Maxin John after I located the problem, slightly modified by me
and tested by me, so blame me if it breaks anything.

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e057e53..caa2535 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -946,7 +946,7 @@ static int acm_probe(struct usb_interface *intf,
 	u8 ac_management_function =3D 0;
 	u8 call_management_function =3D 0;
 	int call_interface_num =3D -1;
-	int data_interface_num;
+	int data_interface_num =3D -1;
 	unsigned long quirks;
 	int num_rx_buf;
 	int i;
@@ -1030,7 +1030,11 @@ next_desc:
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
@@ -1622,6 +1626,11 @@ static const struct usb_device_id acm_ids[] =3D {
 	.driver_info =3D NOT_A_MODEM,
 	},

+	/* Support for Droids MuIn LCD */
+	{ USB_DEVICE(0x04d8, 0x000b),
+	.driver_info =3D NO_DATA_INTERFACE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index b4ea54d..683104a 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -137,3 +137,4 @@ struct acm {
 #define SINGLE_RX_URB			2
 #define NO_CAP_LINE			4
 #define NOT_A_MODEM			8
+#define NO_DATA_INTERFACE		16



--------------ms020406040501040406010101
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwNTExMTAwNjU1WjAjBgkq
hkiG9w0BCQQxFgQUkRij4ys2JOVQdL9q7gzo3pOZyrwwXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQxgccwgcQwga4xCzAJBgNVBAYT
AlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRo
ZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29t
MTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1h
aWwCEQCINeMohsQSwTXd5xIYntlXMIHXBgsqhkiG9w0BCRACCzGBx6CBxDCBrjELMAkGA1UE
BhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5j
b20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBF
bWFpbAIRAIg14yiGxBLBNd3nEhie2VcwDQYJKoZIhvcNAQEBBQAEggEAqEMFKIw9Z2u33OET
8GGPIhpQznUViiRtT05Ss8dj1LYY1WK4thK+WBNRizNc79fkZN/4g3c5qXu1RmYrqWLL/z1C
YviT12peBfjST6IEg+iBYERlGchnh/Q7iwV3DwcNkU71P5fqLcAdUhYxiypmTKRuqxFE8Lvd
rOsCMH+Ot/QsHSs6MDfEqSCi942rwUGNpJnGgoIIteiMSk0xFvN7awolzDw41D4kklnUtd1q
AjZfCIv7/sPXwB/n7ObgE5WcMCaxTKCvYRETbJOgp8Kcj5pwvomVyh286Aacq5UFPMUR0ef4
B8shg6C1f0nf6uUWIVzZ43aPvYM2zsgvAKU2gAAAAAAAAA==
--------------ms020406040501040406010101--
