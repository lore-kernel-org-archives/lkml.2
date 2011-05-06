Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1EFQ6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:58:05 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:34100 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab1EFQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=message-id
	:date:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type; q=dns; s=2007072601; b=Wt9Xbt2/DBI6BLlSU8LoP1oxnU
	qRvCbImARA/tF2nG3tx1OY9QaL+k70WkgZnG5GVODsMidcxUkM2gHcSnUOhVBY8a
	S6o8g7bf5naFV7NZwhGlASW9BIKltO3vevvw6PWv1zr1wAjMOGVlTrE7sBj2487X
	BQ7hDSUIx7fXsoGqE=
Message-ID: <4DC42897.3000300@slagter.name>
Date: Fri, 06 May 2011 18:57:59 +0200
From: Erik Slagter <erik@slagter.name>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Mnenhy/0.8.3 Thunderbird/3.1.10 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Maxin John <maxin.john@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOPS after connection Droids MuIn USB display
References: <4DC3B0E3.7010008@slagter.name>	<4DC3D296.9060707@slagter.name> <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
In-Reply-To: <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050405010104020003050801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050405010104020003050801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Yeah, I've found it!

As I mentioned earlier, the device appears to have a control interface=20
and no data interface. The current usb cdc-acm code doesn't account for=20
this and so yields a oops because data_interface is null.

I've "fixed" it very dirtily by changing these lines:

if (call_interface_num > 0) {
     dev_dbg(&intf->dev, "No union descriptor, using call management=20
descriptor\n");
data_interface =3D usb_ifnum_to_if(usb_dev, (data_interface_num =3D=20
call_interface_num));

into:

if (call_interface_num > 0) {
     dev_dbg(&intf->dev, "No union descriptor, using call management=20
descriptor\n");
data_interface =3D usb_ifnum_to_if(usb_dev, 0);

I can't give an exact patch because the source is full of added debug=20
printk's now ;-)

As far as I understand it, this change results in data_interface to be=20
set equal to control_interface and later on this gets dealed with properl=
y.

And now it not only no longer oopses, it actually works!

If you're planning to make a quirk of it, the USB ID is 04d8:000b=20
"Microchip Technology, Inc. PIC18F2550 (32K Flashable 10 Channel, 10 Bit =

A/D USB Microcontroller"

lsusb says:

Bus 002 Device 018: ID 04d8:000b Microchip Technology, Inc. PIC18F2550=20
(32K Flashable 10 Channel, 10 Bit A/D USB Microcontroller)
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            2 Communications
   bDeviceSubClass         2 Abstract (modem)
   bDeviceProtocol         1 AT-commands (v.25ter)
   bMaxPacketSize0        64
   idVendor           0x04d8 Microchip Technology, Inc.
   idProduct          0x000b PIC18F2550 (32K Flashable 10 Channel, 10=20
Bit A/D USB Microcontroller)
   bcdDevice            0.00
   iManufacturer           1 DROIDS
   iProduct                2 VCOM
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           53
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass         2 Communications
       bInterfaceSubClass      2 Abstract (modem)
       bInterfaceProtocol      1 AT-commands (v.25ter)
       iInterface              0
       CDC Header:
         bcdCDC               1.10
       CDC Call Management:
         bmCapabilities       0x01
           call management
         bDataInterface          1
       CDC ACM:
         bmCapabilities       0x06
           sends break
           line coding and serial state
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes        bInterval=20
       10
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval              10
Device Status:     0x0001
   Self Powered

Thanks.


--------------ms050405010104020003050801
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwNTA2MTY1NzU5WjAjBgkq
hkiG9w0BCQQxFgQUC2xfpzOMSfkOx9E6pWHMB699Kp8wXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIHVBgkrBgEEAYI3EAQxgccwgcQwga4xCzAJBgNVBAYT
AlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRo
ZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29t
MTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1h
aWwCEQCINeMohsQSwTXd5xIYntlXMIHXBgsqhkiG9w0BCRACCzGBx6CBxDCBrjELMAkGA1UE
BhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMV
VGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5j
b20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBF
bWFpbAIRAIg14yiGxBLBNd3nEhie2VcwDQYJKoZIhvcNAQEBBQAEggEAsae1qVjc+wYkwRyE
vcMZ/JQzI3knMy7DZilGMwzkvRNYqGTQ2pX7aMKBjFxsI5BzU6ZyQ7nGX+0+7S+8dkd4TzXn
yGAMurDo9CmGT5QxSbQ6suXVAGLKZnXCqgGiwkURqYuWM9m7qdbguAz40jxdrYAXdtrD3bKf
Xkn2XdDOTV/xT0LC+jQ8Gokl9FcstiPXfDucNkqWD+d99lMaV2B0GrEe93TpWnrEfLdYvbKN
zmS5OoRWkQKkFvSRYckwgKlPqoGckvbEJB+W+7EDHkRSEBsvsKiO46uV4C/S9u1R267UsMvS
wbriju0KoHETrjlUdNJveW3htkTcOQGzCbzr2AAAAAAAAA==
--------------ms050405010104020003050801--
